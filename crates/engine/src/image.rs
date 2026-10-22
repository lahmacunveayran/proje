//! Bellekteki resimler: PNG'ye yazma, PNG'den okuma ve iki resmi karşılaştırma.

use std::fmt;
use std::io;
use std::path::Path;

/// RGBA8 resim. Pikseller satır satır, soldan sağa durur.
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct RgbaImage {
    pub width: u32,
    pub height: u32,
    pub data: Vec<u8>,
}

#[derive(Debug)]
pub enum ImageError {
    Io(io::Error),
    Decode(String),
    Encode(String),
    UnsupportedFormat(String),
    SizeMismatch {
        expected: (u32, u32),
        actual: (u32, u32),
    },
}

impl fmt::Display for ImageError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            ImageError::Io(e) => write!(f, "dosya hatası: {e}"),
            ImageError::Decode(e) => write!(f, "PNG okunamadı: {e}"),
            ImageError::Encode(e) => write!(f, "PNG yazılamadı: {e}"),
            ImageError::UnsupportedFormat(e) => write!(f, "desteklenmeyen PNG biçimi: {e}"),
            ImageError::SizeMismatch { expected, actual } => write!(
                f,
                "resim boyları farklı: beklenen {}×{}, gelen {}×{}",
                expected.0, expected.1, actual.0, actual.1
            ),
        }
    }
}

impl std::error::Error for ImageError {}

impl From<io::Error> for ImageError {
    fn from(e: io::Error) -> Self {
        ImageError::Io(e)
    }
}

impl RgbaImage {
    pub fn new(width: u32, height: u32) -> Self {
        RgbaImage {
            width,
            height,
            data: vec![0; (width as usize) * (height as usize) * 4],
        }
    }

    pub fn filled(width: u32, height: u32, rgba: [u8; 4]) -> Self {
        let mut img = RgbaImage::new(width, height);
        for px in img.data.as_chunks_mut::<4>().0 {
            *px = rgba;
        }
        img
    }

    fn index(&self, x: u32, y: u32) -> usize {
        ((y as usize) * (self.width as usize) + (x as usize)) * 4
    }

    pub fn pixel(&self, x: u32, y: u32) -> [u8; 4] {
        let i = self.index(x, y);
        [
            self.data[i],
            self.data[i + 1],
            self.data[i + 2],
            self.data[i + 3],
        ]
    }

    pub fn set_pixel(&mut self, x: u32, y: u32, rgba: [u8; 4]) {
        let i = self.index(x, y);
        self.data[i..i + 4].copy_from_slice(&rgba);
    }

    pub fn encode_png(&self) -> Result<Vec<u8>, ImageError> {
        let mut out = Vec::new();
        {
            let mut enc = png::Encoder::new(&mut out, self.width, self.height);
            enc.set_color(png::ColorType::Rgba);
            enc.set_depth(png::BitDepth::Eight);
            let mut writer = enc
                .write_header()
                .map_err(|e| ImageError::Encode(e.to_string()))?;
            writer
                .write_image_data(&self.data)
                .map_err(|e| ImageError::Encode(e.to_string()))?;
        }
        Ok(out)
    }

    pub fn decode_png(bytes: &[u8]) -> Result<Self, ImageError> {
        let mut decoder = png::Decoder::new(io::Cursor::new(bytes));
        decoder.set_transformations(png::Transformations::EXPAND);
        let mut reader = decoder
            .read_info()
            .map_err(|e| ImageError::Decode(e.to_string()))?;
        let size = reader
            .output_buffer_size()
            .ok_or_else(|| ImageError::Decode("resim çok büyük".into()))?;
        let mut buf = vec![0; size];
        let info = reader
            .next_frame(&mut buf)
            .map_err(|e| ImageError::Decode(e.to_string()))?;
        buf.truncate(info.buffer_size());
        let (w, h) = (info.width, info.height);
        let data = match (info.color_type, info.bit_depth) {
            (png::ColorType::Rgba, png::BitDepth::Eight) => buf,
            (png::ColorType::Rgb, png::BitDepth::Eight) => buf
                .as_chunks::<3>()
                .0
                .iter()
                .flat_map(|p| [p[0], p[1], p[2], 255])
                .collect(),
            (other, depth) => {
                return Err(ImageError::UnsupportedFormat(format!(
                    "{other:?} {depth:?}"
                )));
            }
        };
        Ok(RgbaImage {
            width: w,
            height: h,
            data,
        })
    }

    pub fn save_png(&self, path: &Path) -> Result<(), ImageError> {
        if let Some(dir) = path.parent() {
            std::fs::create_dir_all(dir)?;
        }
        std::fs::write(path, self.encode_png()?)?;
        Ok(())
    }

    pub fn load_png(path: &Path) -> Result<Self, ImageError> {
        RgbaImage::decode_png(&std::fs::read(path)?)
    }
}

/// İki resmin farkı.
#[derive(Clone, Debug)]
pub struct ImageDiff {
    /// Herhangi bir kanaldaki en büyük fark (0..255).
    pub max_channel_diff: u8,
    /// Farkı eşiği aşan piksel sayısı.
    pub differing_pixels: usize,
    pub total_pixels: usize,
    /// Kanal başına ortalama mutlak fark.
    pub mean_abs_diff: f64,
    /// Farkın görüntüsü: farklı pikseller kırmızı, aynıları soluk gri.
    pub diff_image: RgbaImage,
}

impl ImageDiff {
    pub fn differing_fraction(&self) -> f64 {
        self.differing_pixels as f64 / self.total_pixels.max(1) as f64
    }
}

/// İki resmi karşılaştırır. Bir pikselin herhangi bir kanalındaki fark `threshold`'u
/// aşıyorsa o piksel "farklı" sayılır.
pub fn compare(
    expected: &RgbaImage,
    actual: &RgbaImage,
    threshold: u8,
) -> Result<ImageDiff, ImageError> {
    if (expected.width, expected.height) != (actual.width, actual.height) {
        return Err(ImageError::SizeMismatch {
            expected: (expected.width, expected.height),
            actual: (actual.width, actual.height),
        });
    }
    let mut diff_image = RgbaImage::new(expected.width, expected.height);
    let mut max = 0u8;
    let mut differing = 0usize;
    let mut sum = 0u64;
    for (i, (a, b)) in expected
        .data
        .as_chunks::<4>()
        .0
        .iter()
        .zip(actual.data.as_chunks::<4>().0)
        .enumerate()
    {
        let d = (0..4).map(|c| a[c].abs_diff(b[c])).max().unwrap_or(0);
        sum += (0..4).map(|c| u64::from(a[c].abs_diff(b[c]))).sum::<u64>();
        max = max.max(d);
        let out = if d > threshold {
            differing += 1;
            [255, 0, 0, 255]
        } else {
            let g = 128 + a[0] / 4;
            [g, g, g, 255]
        };
        diff_image.data[i * 4..i * 4 + 4].copy_from_slice(&out);
    }
    let total = (expected.width as usize) * (expected.height as usize);
    Ok(ImageDiff {
        max_channel_diff: max,
        differing_pixels: differing,
        total_pixels: total,
        mean_abs_diff: sum as f64 / (total.max(1) * 4) as f64,
        diff_image,
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn png_round_trip() {
        let mut img = RgbaImage::filled(3, 2, [10, 20, 30, 255]);
        img.set_pixel(2, 1, [200, 100, 50, 128]);
        let back = RgbaImage::decode_png(&img.encode_png().unwrap()).unwrap();
        assert_eq!(back, img);
    }

    #[test]
    fn identical_images_have_no_diff() {
        let a = RgbaImage::filled(4, 4, [1, 2, 3, 255]);
        let d = compare(&a, &a, 0).unwrap();
        assert_eq!(d.differing_pixels, 0);
        assert_eq!(d.max_channel_diff, 0);
        assert_eq!(d.mean_abs_diff, 0.0);
    }

    #[test]
    fn diff_counts_pixels_over_threshold() {
        let a = RgbaImage::filled(10, 10, [100, 100, 100, 255]);
        let mut b = a.clone();
        b.set_pixel(0, 0, [110, 100, 100, 255]);
        b.set_pixel(1, 0, [103, 100, 100, 255]);
        let d = compare(&a, &b, 5).unwrap();
        assert_eq!(d.differing_pixels, 1);
        assert_eq!(d.max_channel_diff, 10);
        assert!((d.differing_fraction() - 0.01).abs() < 1e-9);
        assert_eq!(d.diff_image.pixel(0, 0), [255, 0, 0, 255]);
    }

    #[test]
    fn size_mismatch_is_an_error() {
        let a = RgbaImage::new(2, 2);
        let b = RgbaImage::new(3, 2);
        assert!(matches!(
            compare(&a, &b, 0),
            Err(ImageError::SizeMismatch { .. })
        ));
    }
}
