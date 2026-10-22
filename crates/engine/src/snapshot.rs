//! Görüntü testleri: çizilen sahneyi kayıtlı bir "beklenen" resimle karşılaştırmak.
//!
//! Kullanım: test sahneyi ekransız çizer ve [`check`] ile karşılaştırır.
//!
//! - Beklenen resimler testin yanındaki `reference/` klasöründe PNG olarak durur.
//! - `UPDATE_SNAPSHOTS=1` ortam değişkeniyle çalıştırılırsa beklenen resimler yeniden yazılır.
//! - Fark çıkarsa çizilen resim ve fark resmi `target/goruntu-testleri/` altına yazılır.

use std::fmt;
use std::path::{Path, PathBuf};

use crate::image::{ImageError, RgbaImage, compare};

/// Görüntü testinde kabul edilen fark.
#[derive(Clone, Copy, Debug)]
pub struct Tolerance {
    /// Bir pikselin "farklı" sayılması için gereken en küçük kanal farkı.
    pub pixel_threshold: u8,
    /// Farklı piksellerin en fazla oranı (0..1).
    pub max_differing_fraction: f64,
    /// Kanal başına en fazla ortalama fark.
    pub max_mean_diff: f64,
}

impl Tolerance {
    /// Aynı motorla, farklı grafik kartlarında çizilen resimler için: kenar yumuşatmadaki
    /// küçük farklara izin verir, görünür değişiklikleri yakalar.
    pub const RENDERER: Tolerance = Tolerance {
        pixel_threshold: 24,
        max_differing_fraction: 0.004,
        max_mean_diff: 0.8,
    };
}

#[derive(Debug)]
pub enum SnapshotError {
    MissingReference(PathBuf),
    Mismatch {
        name: String,
        differing_fraction: f64,
        mean_abs_diff: f64,
        max_channel_diff: u8,
        actual: PathBuf,
        diff: PathBuf,
    },
    Image(ImageError),
}

impl fmt::Display for SnapshotError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            SnapshotError::MissingReference(p) => write!(
                f,
                "beklenen resim yok: {}\nOluşturmak için testi UPDATE_SNAPSHOTS=1 ile çalıştırın.",
                p.display()
            ),
            SnapshotError::Mismatch {
                name,
                differing_fraction,
                mean_abs_diff,
                max_channel_diff,
                actual,
                diff,
            } => write!(
                f,
                "\"{name}\" beklenen resimden farklı: piksellerin %{:.3}'ü farklı, ortalama fark {mean_abs_diff:.3}, \
                 en büyük fark {max_channel_diff}.\nÇizilen: {}\nFark: {}",
                differing_fraction * 100.0,
                actual.display(),
                diff.display()
            ),
            SnapshotError::Image(e) => write!(f, "{e}"),
        }
    }
}

impl std::error::Error for SnapshotError {}

impl From<ImageError> for SnapshotError {
    fn from(e: ImageError) -> Self {
        SnapshotError::Image(e)
    }
}

/// Testlerin çıktı klasörü: `<depo>/target/goruntu-testleri`.
pub fn output_dir() -> PathBuf {
    let target = std::env::var_os("CARGO_TARGET_DIR")
        .map(PathBuf::from)
        .unwrap_or_else(|| workspace_root().join("target"));
    target.join("goruntu-testleri")
}

fn workspace_root() -> PathBuf {
    // engine paketinin klasörü: <depo>/crates/engine
    Path::new(env!("CARGO_MANIFEST_DIR")).join("../..")
}

fn update_requested() -> bool {
    std::env::var("UPDATE_SNAPSHOTS").is_ok_and(|v| v == "1")
}

/// Çizilen resmi `reference_dir/<name>.png` ile karşılaştırır.
pub fn check(
    name: &str,
    reference_dir: &Path,
    actual: &RgbaImage,
    tolerance: Tolerance,
) -> Result<(), SnapshotError> {
    let reference = reference_dir.join(format!("{name}.png"));
    let out = output_dir();
    actual.save_png(&out.join(format!("{name}.png")))?;
    if update_requested() {
        actual.save_png(&reference)?;
        return Ok(());
    }
    if !reference.exists() {
        return Err(SnapshotError::MissingReference(reference));
    }
    let expected = RgbaImage::load_png(&reference)?;
    let diff = compare(&expected, actual, tolerance.pixel_threshold)?;
    if diff.differing_fraction() > tolerance.max_differing_fraction
        || diff.mean_abs_diff > tolerance.max_mean_diff
    {
        let diff_path = out.join(format!("{name}-fark.png"));
        diff.diff_image.save_png(&diff_path)?;
        return Err(SnapshotError::Mismatch {
            name: name.to_string(),
            differing_fraction: diff.differing_fraction(),
            mean_abs_diff: diff.mean_abs_diff,
            max_channel_diff: diff.max_channel_diff,
            actual: out.join(format!("{name}.png")),
            diff: diff_path,
        });
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    fn temp_dir(tag: &str) -> PathBuf {
        let dir = std::env::temp_dir().join(format!("snapshot-test-{tag}-{}", std::process::id()));
        let _ = std::fs::remove_dir_all(&dir);
        std::fs::create_dir_all(&dir).unwrap();
        dir
    }

    #[test]
    fn missing_reference_is_reported() {
        if update_requested() {
            return;
        }
        let dir = temp_dir("missing");
        let img = RgbaImage::filled(2, 2, [0, 0, 0, 255]);
        let err = check("yok", &dir, &img, Tolerance::RENDERER).unwrap_err();
        assert!(matches!(err, SnapshotError::MissingReference(_)));
    }

    #[test]
    fn matching_and_mismatching_images() {
        if update_requested() {
            return;
        }
        let dir = temp_dir("match");
        let img = RgbaImage::filled(10, 10, [50, 60, 70, 255]);
        img.save_png(&dir.join("kare.png")).unwrap();
        check("kare", &dir, &img, Tolerance::RENDERER).unwrap();

        let other = RgbaImage::filled(10, 10, [250, 60, 70, 255]);
        let err = check("kare", &dir, &other, Tolerance::RENDERER).unwrap_err();
        let SnapshotError::Mismatch { diff, .. } = err else {
            panic!("fark bekleniyordu: {err}");
        };
        assert!(diff.exists());
    }
}
