//! Yazı: yazı tipleri, harf dizme, satır kaydırma ve yazıyı vektör resme çevirme.
//!
//! Harfler yazı tipinin vektör çizgilerinden çizilir; her ölçekte keskindir. Harf dizme
//! (aralık ayarı, bitişik harfler) Türkçe dil kurallarıyla yapılır.

use std::collections::HashMap;
use std::fmt;
use std::str::FromStr;
use std::sync::{Arc, Mutex};

use glam::{Affine2, Vec2};
use lyon_tessellation::math::point;
use lyon_tessellation::path::Path;
use skrifa::MetadataProvider;
use skrifa::instance::{LocationRef, NormalizedCoord, Size};
use skrifa::outline::{DrawSettings, OutlinePen};
use skrifa::raw::FontRef;

use crate::paint::Paint;
use crate::shape::{Fill, FillRule, Shape, VectorImage};

#[derive(Debug)]
pub enum FontError {
    Invalid(String),
    Shaping(String),
}

impl fmt::Display for FontError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            FontError::Invalid(e) => write!(f, "yazı tipi okunamadı: {e}"),
            FontError::Shaping(e) => write!(f, "yazı dizilemedi: {e}"),
        }
    }
}

impl std::error::Error for FontError {}

/// Diziden çıkan bir harf: yazı tipi birimleriyle.
#[derive(Clone, Copy, Debug, PartialEq)]
struct ShapedGlyph {
    id: u32,
    advance: f32,
    offset: Vec2,
}

/// Bir yazı tipi (değişken yazı tiplerinde belirli bir kalınlıkta).
pub struct Font {
    data: Arc<Vec<u8>>,
    shaper: harfrust::Font,
    coords: Vec<NormalizedCoord>,
    units_per_em: f32,
    ascent: f32,
    descent: f32,
    glyphs: Mutex<HashMap<u32, Option<Path>>>,
}

impl fmt::Debug for Font {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "Font({} bayt)", self.data.len())
    }
}

/// Satır hizası.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Align {
    Left,
    Center,
    Right,
}

#[derive(Clone, Copy, Debug, PartialEq)]
pub struct TextStyle {
    /// Yazı boyu (mantıksal piksel).
    pub size: f32,
    /// Satır aralığı, yazı boyunun katı.
    pub line_height: f32,
    pub align: Align,
    /// Verilirse satırlar bu genişlikte kaydırılır.
    pub max_width: Option<f32>,
}

impl TextStyle {
    pub fn new(size: f32) -> Self {
        TextStyle {
            size,
            line_height: 1.3,
            align: Align::Left,
            max_width: None,
        }
    }

    pub fn align(mut self, align: Align) -> Self {
        self.align = align;
        self
    }

    pub fn wrap(mut self, max_width: f32) -> Self {
        self.max_width = Some(max_width);
        self
    }
}

/// Yerleştirilmiş harf: `position`, harfin taban çizgisindeki başlangıç noktasıdır.
#[derive(Clone, Copy, Debug, PartialEq)]
pub struct PlacedGlyph {
    pub id: u32,
    pub position: Vec2,
}

/// Dizilmiş ve satırlara bölünmüş yazı.
#[derive(Clone, Debug, PartialEq)]
pub struct TextLayout {
    pub glyphs: Vec<PlacedGlyph>,
    /// Yazının kapladığı alan; sol üst köşe (0, 0).
    pub size: Vec2,
    pub line_widths: Vec<f32>,
    pub font_size: f32,
}

struct PathPen {
    builder: lyon_tessellation::path::path::Builder,
    open: bool,
}

impl OutlinePen for PathPen {
    fn move_to(&mut self, x: f32, y: f32) {
        if self.open {
            self.builder.end(true);
        }
        self.builder.begin(point(x, -y));
        self.open = true;
    }

    fn line_to(&mut self, x: f32, y: f32) {
        self.builder.line_to(point(x, -y));
    }

    fn quad_to(&mut self, cx0: f32, cy0: f32, x: f32, y: f32) {
        self.builder
            .quadratic_bezier_to(point(cx0, -cy0), point(x, -y));
    }

    fn curve_to(&mut self, cx0: f32, cy0: f32, cx1: f32, cy1: f32, x: f32, y: f32) {
        self.builder
            .cubic_bezier_to(point(cx0, -cy0), point(cx1, -cy1), point(x, -y));
    }

    fn close(&mut self) {
        if self.open {
            self.builder.end(true);
            self.open = false;
        }
    }
}

impl Font {
    /// Yazı tipi dosyasını okur. `weight` verilirse ve yazı tipi değişken kalınlıklıysa
    /// o kalınlık kullanılır (400 normal, 700 kalın).
    pub fn from_bytes(data: Vec<u8>, weight: Option<f32>) -> Result<Font, FontError> {
        let data = Arc::new(data);
        let font_ref = FontRef::new(&data).map_err(|e| FontError::Invalid(e.to_string()))?;
        let (coords, variations): (Vec<NormalizedCoord>, Vec<(&str, f32)>) = match weight {
            Some(w)
                if font_ref
                    .axes()
                    .iter()
                    .any(|a| a.tag() == skrifa::Tag::new(b"wght")) =>
            {
                let loc = font_ref.axes().location([("wght", w)]);
                (loc.coords().to_vec(), vec![("wght", w)])
            }
            _ => (Vec::new(), Vec::new()),
        };
        let metrics = font_ref.metrics(Size::unscaled(), LocationRef::new(&coords));
        let blob: Arc<dyn AsRef<[u8]> + Send + Sync> = data.clone();
        let base = harfrust::Font::new(blob, 0)
            .ok_or_else(|| FontError::Invalid("biçim tanınmadı".into()))?;
        let shaper = if variations.is_empty() {
            base
        } else {
            base.instance_builder().variations(variations).build()
        };
        Ok(Font {
            units_per_em: f32::from(metrics.units_per_em.max(1)),
            ascent: metrics.ascent,
            descent: -metrics.descent,
            coords,
            shaper,
            data,
            glyphs: Mutex::new(HashMap::new()),
        })
    }

    fn font_ref(&self) -> Option<FontRef<'_>> {
        FontRef::new(&self.data).ok()
    }

    /// Yazı tipinde bu harf var mı?
    pub fn has_char(&self, c: char) -> bool {
        self.font_ref()
            .is_some_and(|f| f.charmap().map(c).is_some())
    }

    /// Harfin yazı tipindeki numarası (yoksa `None`).
    pub fn glyph_id(&self, c: char) -> Option<u32> {
        self.font_ref()
            .and_then(|f| f.charmap().map(c))
            .map(|g| g.to_u32())
    }

    /// Verilen boydaki yükseklik ölçüleri: (taban çizgisinin üstü, altı).
    pub fn vertical_metrics(&self, size: f32) -> (f32, f32) {
        let s = size / self.units_per_em;
        (self.ascent * s, self.descent * s)
    }

    fn shape(&self, text: &str) -> Result<Vec<ShapedGlyph>, FontError> {
        let shaper = harfrust::ShaperFont::new(&self.shaper);
        let mut buffer = harfrust::Buffer::new();
        buffer.push_str(text);
        buffer.set_direction(harfrust::Direction::LeftToRight);
        buffer.set_script(Some(harfrust::Script::LATIN));
        buffer.set_language(harfrust::Language::from_str("tr").ok());
        harfrust::shape(&shaper, &mut buffer, harfrust::ShapeOptions::new())
            .map_err(|e| FontError::Shaping(format!("{e:?}")))?;
        Ok(buffer
            .glyph_infos()
            .iter()
            .zip(buffer.glyph_positions())
            .map(|(info, pos)| ShapedGlyph {
                id: info.glyph_id,
                advance: pos.x_advance as f32,
                offset: Vec2::new(pos.x_offset as f32, -(pos.y_offset as f32)),
            })
            .collect())
    }

    /// Tek satırlık yazının genişliği.
    pub fn measure(&self, text: &str, size: f32) -> Result<f32, FontError> {
        let s = size / self.units_per_em;
        Ok(self.shape(text)?.iter().map(|g| g.advance).sum::<f32>() * s)
    }

    /// Tek satırı dizer: harfler x = 0'dan başlar, taban çizgisi y = 0'dır. Satırın genişliğini de verir.
    /// Yazı tipinde olmayan harf 0 numaralı harftir.
    pub fn shape_line(&self, text: &str, size: f32) -> Result<(Vec<PlacedGlyph>, f32), FontError> {
        let s = size / self.units_per_em;
        let mut x = 0.0;
        let glyphs = self
            .shape(text)?
            .iter()
            .map(|g| {
                let placed = PlacedGlyph {
                    id: g.id,
                    position: Vec2::new(x, 0.0) + g.offset * s,
                };
                x += g.advance * s;
                placed
            })
            .collect();
        Ok((glyphs, x))
    }

    /// Yazıyı dizer, satırlara böler ve hizalar.
    pub fn layout(&self, text: &str, style: &TextStyle) -> Result<TextLayout, FontError> {
        let mut lines: Vec<String> = Vec::new();
        for paragraph in text.split('\n') {
            match style.max_width {
                Some(max) => self.wrap_paragraph(paragraph, style.size, max, &mut lines)?,
                None => lines.push(paragraph.to_string()),
            }
        }
        let s = style.size / self.units_per_em;
        let (ascent, descent) = self.vertical_metrics(style.size);
        let line_step = style.size * style.line_height;
        let mut line_widths = Vec::with_capacity(lines.len());
        let mut shaped = Vec::with_capacity(lines.len());
        for line in &lines {
            let glyphs = self.shape(line)?;
            line_widths.push(glyphs.iter().map(|g| g.advance).sum::<f32>() * s);
            shaped.push(glyphs);
        }
        let widest = line_widths.iter().copied().fold(0.0, f32::max);
        let box_width = style.max_width.unwrap_or(widest);
        let mut glyphs = Vec::new();
        for (i, line) in shaped.iter().enumerate() {
            let free = box_width - line_widths[i];
            let mut x = match style.align {
                Align::Left => 0.0,
                Align::Center => free * 0.5,
                Align::Right => free,
            };
            let baseline = ascent + i as f32 * line_step;
            for g in line {
                glyphs.push(PlacedGlyph {
                    id: g.id,
                    position: Vec2::new(x, baseline) + g.offset * s,
                });
                x += g.advance * s;
            }
        }
        let height = ascent + descent + (lines.len().max(1) - 1) as f32 * line_step;
        Ok(TextLayout {
            glyphs,
            size: Vec2::new(box_width, height),
            line_widths,
            font_size: style.size,
        })
    }

    fn wrap_paragraph(
        &self,
        paragraph: &str,
        size: f32,
        max_width: f32,
        out: &mut Vec<String>,
    ) -> Result<(), FontError> {
        let mut line = String::new();
        for word in paragraph.split(' ').filter(|w| !w.is_empty()) {
            if line.is_empty() {
                line.push_str(word);
                continue;
            }
            let candidate = format!("{line} {word}");
            if self.measure(&candidate, size)? > max_width {
                out.push(std::mem::take(&mut line));
                line.push_str(word);
            } else {
                line = candidate;
            }
        }
        out.push(line);
        Ok(())
    }

    /// Harfin çizgileri (yazı tipi birimleriyle, y aşağı doğru). Boş harflerde `None`.
    fn glyph_path(&self, id: u32) -> Option<Path> {
        let mut cache = self.glyphs.lock().unwrap_or_else(|e| e.into_inner());
        if let Some(p) = cache.get(&id) {
            return p.clone();
        }
        let path = self.font_ref().and_then(|f| {
            let glyph = f.outline_glyphs().get(skrifa::GlyphId::new(id))?;
            let mut pen = PathPen {
                builder: Path::builder(),
                open: false,
            };
            glyph
                .draw(
                    DrawSettings::unhinted(Size::unscaled(), LocationRef::new(&self.coords)),
                    &mut pen,
                )
                .ok()?;
            if pen.open {
                pen.builder.end(true);
            }
            let p = pen.builder.build();
            (p.iter().next().is_some()).then_some(p)
        });
        cache.insert(id, path.clone());
        path
    }

    /// Harflerin çizgilerini yola ekler: `size` boyunda, `transform` ile taşınmış.
    pub fn append_glyphs(
        &self,
        builder: &mut lyon_tessellation::path::path::Builder,
        glyphs: &[PlacedGlyph],
        size: f32,
        transform: Affine2,
    ) {
        let scale = Affine2::from_scale(Vec2::splat(size / self.units_per_em));
        for g in glyphs {
            if let Some(path) = self.glyph_path(g.id) {
                let t = transform * Affine2::from_translation(g.position) * scale;
                append_path(builder, &path, t);
            }
        }
    }

    /// Dizilmiş yazıyı tek bir vektör şekle çevirir.
    pub fn build_image(&self, layout: &TextLayout, paint: impl Into<Paint>) -> VectorImage {
        let mut builder = Path::builder();
        self.append_glyphs(
            &mut builder,
            &layout.glyphs,
            layout.font_size,
            Affine2::IDENTITY,
        );
        let mut image = VectorImage::new(layout.size);
        image.push(Shape {
            path: builder.build(),
            fill: Some(Fill {
                paint: paint.into(),
                rule: FillRule::NonZero,
            }),
            stroke: None,
        });
        image
    }

    /// Kısayol: yazıyı dizip vektör resme çevirir.
    pub fn text_image(
        &self,
        text: &str,
        style: &TextStyle,
        paint: impl Into<Paint>,
    ) -> Result<VectorImage, FontError> {
        Ok(self.build_image(&self.layout(text, style)?, paint))
    }
}

fn append_path(b: &mut lyon_tessellation::path::path::Builder, path: &Path, t: Affine2) {
    use lyon_tessellation::path::Event;
    let tp = |p: lyon_tessellation::math::Point| {
        let q = t.transform_point2(Vec2::new(p.x, p.y));
        point(q.x, q.y)
    };
    for event in path.iter() {
        match event {
            Event::Begin { at } => {
                b.begin(tp(at));
            }
            Event::Line { to, .. } => {
                b.line_to(tp(to));
            }
            Event::Quadratic { ctrl, to, .. } => {
                b.quadratic_bezier_to(tp(ctrl), tp(to));
            }
            Event::Cubic {
                ctrl1, ctrl2, to, ..
            } => {
                b.cubic_bezier_to(tp(ctrl1), tp(ctrl2), tp(to));
            }
            Event::End { close, .. } => {
                b.end(close);
            }
        }
    }
}

/// Türkçe kurallarla büyük harfe çevirir (i → İ, ı → I).
pub fn to_upper_tr(text: &str) -> String {
    text.chars()
        .flat_map(|c| match c {
            'i' => vec!['İ'],
            'ı' => vec!['I'],
            _ => c.to_uppercase().collect(),
        })
        .collect()
}

/// Türkçe kurallarla küçük harfe çevirir (I → ı, İ → i).
pub fn to_lower_tr(text: &str) -> String {
    text.chars()
        .flat_map(|c| match c {
            'I' => vec!['ı'],
            'İ' => vec!['i'],
            _ => c.to_lowercase().collect(),
        })
        .collect()
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::color::Color;
    use crate::tessellate::tessellate;

    /// Feudalism yazılarının açık lisanslı karşılıkları.
    const FONTS: [(&str, &[u8]); 12] = [
        (
            "Liberation Sans",
            include_bytes!("../../../content/fonts/LiberationSans-Regular.ttf"),
        ),
        (
            "Liberation Sans Bold",
            include_bytes!("../../../content/fonts/LiberationSans-Bold.ttf"),
        ),
        (
            "Liberation Sans Bold Italic",
            include_bytes!("../../../content/fonts/LiberationSans-BoldItalic.ttf"),
        ),
        (
            "Liberation Serif",
            include_bytes!("../../../content/fonts/LiberationSerif-Regular.ttf"),
        ),
        (
            "Liberation Serif Bold",
            include_bytes!("../../../content/fonts/LiberationSerif-Bold.ttf"),
        ),
        (
            "Liberation Serif Bold Italic",
            include_bytes!("../../../content/fonts/LiberationSerif-BoldItalic.ttf"),
        ),
        (
            "TeX Gyre Adventor Bold",
            include_bytes!("../../../content/fonts/texgyreadventor-bold.otf"),
        ),
        (
            "TeX Gyre Bonum Bold",
            include_bytes!("../../../content/fonts/texgyrebonum-bold.otf"),
        ),
        (
            "TeX Gyre Bonum Italic",
            include_bytes!("../../../content/fonts/texgyrebonum-italic.otf"),
        ),
        (
            "TeX Gyre Chorus",
            include_bytes!("../../../content/fonts/texgyrechorus-mediumitalic.otf"),
        ),
        (
            "TeX Gyre Pagella Bold",
            include_bytes!("../../../content/fonts/texgyrepagella-bold.otf"),
        ),
        (
            "TeX Gyre Pagella Bold Italic",
            include_bytes!("../../../content/fonts/texgyrepagella-bolditalic.otf"),
        ),
    ];

    const TURKISH: &str = "ÇçĞğİıÖöŞşÜüÂâÎîÛû";

    fn regular() -> Font {
        Font::from_bytes(FONTS[0].1.to_vec(), None).unwrap()
    }

    #[test]
    fn every_font_has_all_turkish_letters() {
        for (name, data) in FONTS {
            let font = Font::from_bytes(data.to_vec(), None).unwrap();
            for c in TURKISH.chars() {
                assert!(font.has_char(c), "{name} yazı tipinde '{c}' yok");
            }
        }
    }

    #[test]
    fn invalid_data_is_an_error() {
        assert!(Font::from_bytes(vec![1, 2, 3], None).is_err());
    }

    #[test]
    fn measure_grows_with_size_and_text() {
        let f = regular();
        let a = f.measure("Savaş", 20.0).unwrap();
        let b = f.measure("Savaş", 40.0).unwrap();
        assert!((b - 2.0 * a).abs() < 1e-3);
        assert!(f.measure("Savaşa hazır ol", 20.0).unwrap() > a);
        assert_eq!(f.measure("", 20.0).unwrap(), 0.0);
    }

    #[test]
    fn kerning_is_applied() {
        let f = regular();
        let pair = f.measure("AV", 100.0).unwrap();
        let apart = f.measure("A", 100.0).unwrap() + f.measure("V", 100.0).unwrap();
        assert!(pair < apart, "AV aralığı daraltılmadı: {pair} >= {apart}");
    }

    #[test]
    fn bold_font_is_heavier() {
        let thin = regular();
        let bold = Font::from_bytes(FONTS[1].1.to_vec(), None).unwrap();
        let style = TextStyle::new(50.0);
        let area = |f: &Font| {
            tessellate(&f.text_image("Kale", &style, Color::BLACK).unwrap(), 0.05)
                .unwrap()
                .area()
        };
        assert!(area(&bold) > area(&thin) * 1.15);
    }

    #[test]
    fn wrapping_keeps_lines_within_width() {
        let f = regular();
        let text = "Küçük bir sınır beyi olarak ordu topla, kahramanını büyüt, şehirden şehre gez ve savaş.";
        let style = TextStyle::new(26.0).wrap(300.0);
        let layout = f.layout(text, &style).unwrap();
        assert!(layout.line_widths.len() >= 3);
        assert!(layout.line_widths.iter().all(|w| *w <= 300.0 + 1e-3));
        assert_eq!(layout.size.x, 300.0);
        // Satırlar alt alta: yükseklik satır sayısıyla büyür.
        let lines = layout.line_widths.len() as f32;
        assert!(layout.size.y > (lines - 1.0) * 26.0 * 1.3);
    }

    #[test]
    fn long_words_overflow_on_their_own_line() {
        let f = regular();
        let layout = f
            .layout(
                "a çokçokçokuzunbirsözcük b",
                &TextStyle::new(20.0).wrap(50.0),
            )
            .unwrap();
        assert_eq!(layout.line_widths.len(), 3);
        assert!(layout.line_widths[1] > 50.0);
    }

    #[test]
    fn newlines_start_new_lines() {
        let f = regular();
        let layout = f.layout("bir\niki\n\ndört", &TextStyle::new(20.0)).unwrap();
        assert_eq!(layout.line_widths.len(), 4);
        assert_eq!(layout.line_widths[2], 0.0);
    }

    #[test]
    fn alignment_offsets_lines() {
        let f = regular();
        let style = TextStyle::new(20.0).wrap(400.0);
        let x0 = |layout: &TextLayout| layout.glyphs[0].position.x;
        let left = f.layout("Kale", &style).unwrap();
        let center = f.layout("Kale", &style.align(Align::Center)).unwrap();
        let right = f.layout("Kale", &style.align(Align::Right)).unwrap();
        let w = left.line_widths[0];
        assert!((x0(&center) - x0(&left) - (400.0 - w) / 2.0).abs() < 1e-3);
        assert!((x0(&right) - x0(&left) - (400.0 - w)).abs() < 1e-3);
    }

    #[test]
    fn text_image_covers_layout() {
        let f = regular();
        let style = TextStyle::new(40.0);
        let layout = f.layout("Ğİ", &style).unwrap();
        let img = f.build_image(&layout, Color::BLACK);
        let (min, max) = img.bounds().unwrap();
        // Ğ ve İ'nin üstündeki işaretler taban çizgisinin epey üstüne çıkar ama alanın içinde kalır.
        assert!(min.y >= -1.0 && min.y < layout.size.y * 0.3, "{min}");
        assert!(
            max.x <= layout.size.x + 1.0 && max.y <= layout.size.y + 1.0,
            "{max}"
        );
        assert!(!tessellate(&img, 0.05).unwrap().is_empty());
    }

    #[test]
    fn space_only_text_draws_nothing() {
        let f = regular();
        let img = f
            .text_image("   ", &TextStyle::new(20.0), Color::BLACK)
            .unwrap();
        assert!(tessellate(&img, 0.05).unwrap().is_empty());
    }

    #[test]
    fn turkish_case_conversion() {
        assert_eq!(to_upper_tr("istanbul ılık çağrı"), "İSTANBUL ILIK ÇAĞRI");
        assert_eq!(to_lower_tr("IĞDIR İZMİR ŞÜKRÜ"), "ığdır izmir şükrü");
        assert_eq!(to_upper_tr("ß"), "SS");
    }
}
