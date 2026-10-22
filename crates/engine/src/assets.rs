//! Oyun içeriğini (yazı tipleri, çizimler, veriler) okumak.
//!
//! İçerik, dağıtımda `.exe` dosyasının içine gömülüdür; oyun tek dosyadan çalışır.
//! Geliştirirken ya da içerik denerken bir klasör verilirse önce oradan okunur.

use std::borrow::Cow;
use std::fmt;
use std::path::PathBuf;

/// Gömülü dosya: (içerik klasörüne göre yol, bayt).
pub type EmbeddedFile = (&'static str, &'static [u8]);

#[derive(Debug)]
pub enum AssetError {
    NotFound(String),
    Io { path: String, error: std::io::Error },
    NotUtf8(String),
}

impl fmt::Display for AssetError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            AssetError::NotFound(p) => write!(f, "içerik bulunamadı: {p}"),
            AssetError::Io { path, error } => write!(f, "içerik okunamadı ({path}): {error}"),
            AssetError::NotUtf8(p) => write!(f, "içerik UTF-8 metin değil: {p}"),
        }
    }
}

impl std::error::Error for AssetError {}

#[derive(Clone, Debug, Default)]
pub struct Assets {
    embedded: &'static [EmbeddedFile],
    dir: Option<PathBuf>,
}

impl Assets {
    pub fn new(embedded: &'static [EmbeddedFile], dir: Option<PathBuf>) -> Self {
        Assets { embedded, dir }
    }

    /// Yalnızca klasörden okuyan içerik (testler ve araçlar için).
    pub fn from_dir(dir: PathBuf) -> Self {
        Assets {
            embedded: &[],
            dir: Some(dir),
        }
    }

    fn normalize(path: &str) -> String {
        path.replace('\\', "/").trim_start_matches('/').to_string()
    }

    pub fn read(&self, path: &str) -> Result<Cow<'static, [u8]>, AssetError> {
        let path = Self::normalize(path);
        if path.split('/').any(|part| part == "..") {
            return Err(AssetError::NotFound(path));
        }
        if let Some(dir) = &self.dir {
            let full = dir.join(&path);
            if full.is_file() {
                return std::fs::read(&full)
                    .map(Cow::Owned)
                    .map_err(|error| AssetError::Io { path, error });
            }
        }
        self.embedded
            .iter()
            .find(|(p, _)| *p == path)
            .map(|(_, bytes)| Cow::Borrowed(*bytes))
            .ok_or(AssetError::NotFound(path))
    }

    pub fn read_string(&self, path: &str) -> Result<String, AssetError> {
        let bytes = self.read(path)?;
        String::from_utf8(bytes.into_owned()).map_err(|_| AssetError::NotUtf8(path.to_string()))
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    static EMBEDDED: &[EmbeddedFile] = &[("art/a.svg", b"<svg/>"), ("data/b.txt", b"gomulu")];

    #[test]
    fn reads_embedded_files() {
        let a = Assets::new(EMBEDDED, None);
        assert_eq!(&*a.read("art/a.svg").unwrap(), b"<svg/>");
        assert_eq!(&*a.read("art\\a.svg").unwrap(), b"<svg/>");
        assert!(matches!(a.read("yok.txt"), Err(AssetError::NotFound(_))));
    }

    #[test]
    fn directory_overrides_embedded() {
        let dir = std::env::temp_dir().join(format!("assets-test-{}", std::process::id()));
        std::fs::create_dir_all(dir.join("data")).unwrap();
        std::fs::write(dir.join("data/b.txt"), "klasör").unwrap();
        let a = Assets::new(EMBEDDED, Some(dir.clone()));
        assert_eq!(a.read_string("data/b.txt").unwrap(), "klasör");
        // Klasörde olmayan dosya gömülüden gelir.
        assert_eq!(&*a.read("art/a.svg").unwrap(), b"<svg/>");
        std::fs::remove_dir_all(dir).unwrap();
    }

    #[test]
    fn parent_paths_are_rejected() {
        let a = Assets::from_dir(std::env::temp_dir());
        assert!(a.read("../etc/passwd").is_err());
    }

    #[test]
    fn invalid_utf8_is_reported() {
        static BAD: &[EmbeddedFile] = &[("x.txt", &[0xff, 0xfe])];
        assert!(matches!(
            Assets::new(BAD, None).read_string("x.txt"),
            Err(AssetError::NotUtf8(_))
        ));
    }
}
