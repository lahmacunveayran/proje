//! sRGB renkler.
//!
//! Renkler Flash'taki gibi sRGB uzayında tutulur ve karıştırılır: doğrusal ışık uzayına
//! çevrilmez. Esin kaynağımızın degradeleri ve kenarları bu yüzden o "sıcak" görünüştedir.

use std::fmt;

/// sRGB uzayında, düz (önceden çarpılmamış) saydamlıklı renk. Bileşenler 0..=1 arasındadır.
#[derive(Clone, Copy, Debug, PartialEq)]
pub struct Color {
    pub r: f32,
    pub g: f32,
    pub b: f32,
    pub a: f32,
}

/// Renk yazısı çözülemediğinde dönen hata.
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct ColorParseError(pub String);

impl fmt::Display for ColorParseError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(
            f,
            "geçersiz renk: {:?} (beklenen biçim #RRGGBB ya da #RRGGBBAA)",
            self.0
        )
    }
}

impl std::error::Error for ColorParseError {}

impl Color {
    pub const BLACK: Color = Color::rgba(0.0, 0.0, 0.0, 1.0);
    pub const WHITE: Color = Color::rgba(1.0, 1.0, 1.0, 1.0);
    pub const TRANSPARENT: Color = Color::rgba(0.0, 0.0, 0.0, 0.0);

    pub const fn rgba(r: f32, g: f32, b: f32, a: f32) -> Self {
        Color { r, g, b, a }
    }

    pub fn from_rgba8(r: u8, g: u8, b: u8, a: u8) -> Self {
        Color {
            r: f32::from(r) / 255.0,
            g: f32::from(g) / 255.0,
            b: f32::from(b) / 255.0,
            a: f32::from(a) / 255.0,
        }
    }

    /// `#RRGGBB` ya da `#RRGGBBAA` biçimindeki yazıdan renk üretir.
    pub fn from_hex(text: &str) -> Result<Self, ColorParseError> {
        let err = || ColorParseError(text.to_string());
        let hex = text.strip_prefix('#').ok_or_else(err)?;
        if !(hex.len() == 6 || hex.len() == 8) || !hex.is_ascii() {
            return Err(err());
        }
        let byte = |i: usize| u8::from_str_radix(&hex[i..i + 2], 16).map_err(|_| err());
        let a = if hex.len() == 8 { byte(6)? } else { 255 };
        Ok(Color::from_rgba8(byte(0)?, byte(2)?, byte(4)?, a))
    }

    pub fn with_alpha(self, a: f32) -> Self {
        Color { a, ..self }
    }

    /// Saydamlığı verilen oranla çarpar.
    pub fn fade(self, opacity: f32) -> Self {
        Color {
            a: self.a * opacity,
            ..self
        }
    }

    /// İki renk arasında sRGB uzayında, önceden çarpılmış saydamlıkla ara değer bulur.
    ///
    /// Önceden çarpılmış karıştırma, saydam bir uca doğru giden degradelerde kenarda
    /// koyu bir hale oluşmasını önler.
    pub fn lerp(self, other: Color, t: f32) -> Color {
        let t = t.clamp(0.0, 1.0);
        let a = self.premultiplied();
        let b = other.premultiplied();
        let mix = |i: usize| a[i] + (b[i] - a[i]) * t;
        Color::from_premultiplied([mix(0), mix(1), mix(2), mix(3)])
    }

    /// Rengi ve saydamlığı ayrı ayrı (önceden çarpmadan) karıştırır: Flash ve SVG degradelerinin
    /// duraklar arasındaki karışımı. Saydam bir durağın rengi de ara tonlara katılır.
    pub fn lerp_straight(self, other: Color, t: f32) -> Color {
        let t = t.clamp(0.0, 1.0);
        let mix = |a: f32, b: f32| a + (b - a) * t;
        Color::rgba(
            mix(self.r, other.r),
            mix(self.g, other.g),
            mix(self.b, other.b),
            mix(self.a, other.a),
        )
    }

    /// Bileşenleri saydamlıkla çarpılmış hâli: `[r·a, g·a, b·a, a]`.
    pub fn premultiplied(self) -> [f32; 4] {
        [self.r * self.a, self.g * self.a, self.b * self.a, self.a]
    }

    /// Önceden çarpılmış bileşenlerden renk üretir.
    pub fn from_premultiplied(p: [f32; 4]) -> Color {
        if p[3] <= 0.0 {
            return Color::TRANSPARENT;
        }
        Color {
            r: (p[0] / p[3]).clamp(0.0, 1.0),
            g: (p[1] / p[3]).clamp(0.0, 1.0),
            b: (p[2] / p[3]).clamp(0.0, 1.0),
            a: p[3].clamp(0.0, 1.0),
        }
    }

    pub fn to_rgba8(self) -> [u8; 4] {
        let q = |v: f32| (v.clamp(0.0, 1.0) * 255.0).round() as u8;
        [q(self.r), q(self.g), q(self.b), q(self.a)]
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parses_hex_colors() {
        assert_eq!(
            Color::from_hex("#FF8000").unwrap().to_rgba8(),
            [255, 128, 0, 255]
        );
        assert_eq!(
            Color::from_hex("#1e4fa680").unwrap().to_rgba8(),
            [30, 79, 166, 128]
        );
    }

    #[test]
    fn rejects_invalid_hex() {
        for bad in ["FF8000", "#FF80", "#GG0000", "#FF80001", "#ğğğğğğ", ""] {
            assert!(Color::from_hex(bad).is_err(), "{bad} kabul edilmemeliydi");
        }
    }

    #[test]
    fn lerp_mixes_in_srgb_space() {
        let mid = Color::BLACK.lerp(Color::WHITE, 0.5);
        // sRGB uzayında karışım: tam ortası 0,5 olur (doğrusal uzayda ~0,73 olurdu).
        assert!((mid.r - 0.5).abs() < 1e-6);
        assert_eq!(Color::BLACK.lerp(Color::WHITE, 2.0), Color::WHITE);
    }

    #[test]
    fn lerp_towards_transparent_keeps_hue() {
        let red = Color::from_hex("#C8372D").unwrap();
        let mid = red.lerp(Color::TRANSPARENT, 0.5);
        assert!((mid.a - 0.5).abs() < 1e-6);
        // Önceden çarpılmış karışım rengin tonunu korur; siyaha kaymaz.
        assert!((mid.r - red.r).abs() < 1e-5);
        assert!((mid.g - red.g).abs() < 1e-5);
    }

    #[test]
    fn lerp_straight_mixes_colour_of_transparent_end_too() {
        let clear_grey = Color::rgba(0.4, 0.4, 0.4, 0.0);
        let mid = clear_grey.lerp_straight(Color::BLACK, 0.5);
        assert!((mid.r - 0.2).abs() < 1e-6 && (mid.a - 0.5).abs() < 1e-6);
        assert_eq!(Color::BLACK.lerp_straight(Color::WHITE, 3.0), Color::WHITE);
    }

    #[test]
    fn premultiplied_round_trip() {
        let c = Color::rgba(0.2, 0.4, 0.6, 0.5);
        let back = Color::from_premultiplied(c.premultiplied());
        assert!((back.r - c.r).abs() < 1e-6 && (back.a - c.a).abs() < 1e-6);
        assert_eq!(
            Color::from_premultiplied([0.3, 0.3, 0.3, 0.0]),
            Color::TRANSPARENT
        );
    }

    #[test]
    fn fade_multiplies_alpha() {
        assert_eq!(Color::WHITE.fade(0.25).a, 0.25);
        assert_eq!(Color::WHITE.with_alpha(0.5).fade(0.5).a, 0.25);
    }
}
