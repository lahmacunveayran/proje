//! Oyunda görünen metinler: `content/text/tr.ron` dosyasından okunur.

use std::collections::HashMap;
use std::fmt;

use engine::assets::Assets;

#[derive(Debug)]
pub struct TextsError(pub String);

impl fmt::Display for TextsError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "metin dosyası okunamadı: {}", self.0)
    }
}

impl std::error::Error for TextsError {}

#[derive(Clone, Debug, Default)]
pub struct Texts {
    map: HashMap<String, String>,
}

impl Texts {
    pub fn parse(source: &str) -> Result<Self, TextsError> {
        let map = ron::from_str(source).map_err(|e| TextsError(e.to_string()))?;
        Ok(Texts { map })
    }

    pub fn load(assets: &Assets, language: &str) -> Result<Self, TextsError> {
        let source = assets
            .read_string(&format!("text/{language}.ron"))
            .map_err(|e| TextsError(e.to_string()))?;
        Self::parse(&source)
    }

    /// Anahtarın metni. Metin yoksa anahtarın kendisi döner (eksik metin ekranda görünsün).
    pub fn get<'a>(&'a self, key: &'a str) -> &'a str {
        match self.map.get(key) {
            Some(s) => s,
            None => {
                log::warn!("eksik metin: {key}");
                key
            }
        }
    }

    /// `{ad}` yer tutucularını verilen değerlerle doldurur.
    pub fn format(&self, key: &str, values: &[(&str, &str)]) -> String {
        let mut s = self.get(key).to_string();
        for (name, value) in values {
            s = s.replace(&format!("{{{name}}}"), value);
        }
        s
    }

    pub fn contains(&self, key: &str) -> bool {
        self.map.contains_key(key)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parses_and_formats() {
        let t = Texts::parse(r#"{ "a": "Merhaba", "b": "{n} altın" }"#).unwrap();
        assert_eq!(t.get("a"), "Merhaba");
        assert_eq!(t.format("b", &[("n", "250")]), "250 altın");
        assert_eq!(t.get("yok"), "yok");
    }

    #[test]
    fn invalid_source_is_an_error() {
        assert!(Texts::parse("{ bozuk").is_err());
    }

    #[test]
    fn turkish_file_has_all_keys_used_in_code() {
        let assets = crate::content::assets(None);
        let t = Texts::load(&assets, "tr").unwrap();
        for key in crate::demo::TEXT_KEYS.iter().chain(&["window_title"]) {
            assert!(t.contains(key), "tr.ron içinde '{key}' yok");
        }
    }
}
