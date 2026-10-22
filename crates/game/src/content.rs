//! Oyuna gömülü içerik.

use std::path::PathBuf;

use engine::assets::Assets;

include!(concat!(env!("OUT_DIR"), "/embedded_content.rs"));

/// Oyunun içerik kaynağı: gömülü dosyalar; `override_dir` verilirse önce o klasör.
pub fn assets(override_dir: Option<PathBuf>) -> Assets {
    Assets::new(EMBEDDED, override_dir)
}

/// `.exe` dosyasının yanında bir `content` klasörü varsa onun yolu (içerik denemek için).
pub fn content_next_to_exe() -> Option<PathBuf> {
    let dir = std::env::current_exe().ok()?.parent()?.join("content");
    dir.is_dir().then_some(dir)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn fonts_and_texts_are_embedded() {
        let names: Vec<&str> = EMBEDDED.iter().map(|(n, _)| *n).collect();
        for wanted in [
            "fonts/Alegreya-Variable.ttf",
            "fonts/AlegreyaSC-Bold.ttf",
            "fonts/OFL-Alegreya.txt",
            "text/tr.ron",
        ] {
            assert!(names.contains(&wanted), "{wanted} gömülü değil: {names:?}");
        }
        assert!(names.iter().all(|n| !n.contains('\\')));
    }

    #[test]
    fn embedded_bytes_match_files() {
        let root = PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../../content");
        for (name, bytes) in EMBEDDED {
            assert_eq!(std::fs::read(root.join(name)).unwrap(), *bytes, "{name}");
        }
    }
}
