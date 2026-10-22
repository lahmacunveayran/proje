//! Boyalar: düz renk, degradeler ve resim (Flash'ın resim dolgusu).
//!
//! Degradeler GPU'da 256 öğelik bir renk şeridinden (rampa) okunur; şerit sRGB uzayında,
//! önceden çarpılmış saydamlıkla üretilir. Bu modüldeki [`Gradient::sample`] işlevi,
//! gölgelendiricinin yaptığı hesabın işlemcideki karşılığıdır; testlerde kıyas için kullanılır.

use std::sync::Arc;

use glam::{Affine2, Vec2};

use crate::color::Color;
use crate::image::RgbaImage;

/// Bir degrade rampasındaki öğe sayısı.
pub const RAMP_WIDTH: usize = 256;

#[derive(Clone, Copy, Debug, PartialEq)]
pub struct GradientStop {
    /// 0..=1 arasında konum.
    pub offset: f32,
    pub color: Color,
}

impl GradientStop {
    pub fn new(offset: f32, color: Color) -> Self {
        GradientStop { offset, color }
    }
}

/// Degradenin 0..1 aralığının dışında nasıl devam ettiği.
#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub enum Spread {
    /// Uç renkler devam eder.
    Pad,
    /// Degrade aynalanarak tekrar eder.
    Reflect,
    /// Degrade baştan tekrar eder.
    Repeat,
}

impl Spread {
    pub fn apply(self, t: f32) -> f32 {
        match self {
            Spread::Pad => t.clamp(0.0, 1.0),
            Spread::Repeat => t - t.floor(),
            Spread::Reflect => {
                let m = (t * 0.5) - (t * 0.5).floor();
                1.0 - (m * 2.0 - 1.0).abs()
            }
        }
    }
}

#[derive(Clone, Copy, Debug, PartialEq)]
pub enum GradientKind {
    /// `start` noktasında 0, `end` noktasında 1.
    Linear { start: Vec2, end: Vec2 },
    /// `center` merkezli, `radius` yarıçaplı daire; `focal` odak noktası (genellikle merkez).
    Radial {
        center: Vec2,
        radius: f32,
        focal: Vec2,
    },
}

#[derive(Clone, Debug, PartialEq)]
pub struct Gradient {
    pub kind: GradientKind,
    pub stops: Vec<GradientStop>,
    pub spread: Spread,
    /// Degrade koordinatlarından şeklin koordinatlarına dönüşüm.
    pub transform: Affine2,
}

/// Bir noktanın degradedeki konumunu bulmak için gereken hazır bilgi.
#[derive(Clone, Copy, Debug, PartialEq)]
pub struct GradientMapping {
    /// Şekil koordinatlarından birim degrade uzayına dönüşüm. Doğrusal degradede başlangıç
    /// (0,0), bitiş (1,0) olur; radyal degradede merkez (0,0), yarıçap 1 olur.
    pub to_unit: Affine2,
    /// Radyal degradede odak noktasının birim uzaydaki yeri.
    pub focal: Vec2,
    pub radial: bool,
}

impl Gradient {
    pub fn linear(start: Vec2, end: Vec2, stops: Vec<GradientStop>) -> Self {
        Gradient {
            kind: GradientKind::Linear { start, end },
            stops,
            spread: Spread::Pad,
            transform: Affine2::IDENTITY,
        }
    }

    pub fn radial(center: Vec2, radius: f32, stops: Vec<GradientStop>) -> Self {
        Gradient {
            kind: GradientKind::Radial {
                center,
                radius,
                focal: center,
            },
            stops,
            spread: Spread::Pad,
            transform: Affine2::IDENTITY,
        }
    }

    /// Şekil koordinatlarından birim degrade uzayına dönüşümü hesaplar.
    ///
    /// Degrade çizilemeyecek kadar bozuksa (sıfır uzunluk, sıfır yarıçap, tersi alınamayan
    /// dönüşüm) `None` döner; bu durumda SVG kuralı gereği son durağın rengi kullanılır.
    pub fn mapping(&self) -> Option<GradientMapping> {
        let det = self.transform.matrix2.determinant();
        if !det.is_finite() || det.abs() < 1e-12 {
            return None;
        }
        let to_gradient = self.transform.inverse();
        match self.kind {
            GradientKind::Linear { start, end } => {
                let d = end - start;
                let len2 = d.length_squared();
                if len2 < 1e-12 {
                    return None;
                }
                // Başlangıcı sıfıra taşı, yönü x eksenine çevir, boyu 1 yap.
                let unit = Affine2::from_cols_array(&[
                    d.x / len2,
                    -d.y / len2,
                    d.y / len2,
                    d.x / len2,
                    0.0,
                    0.0,
                ]) * Affine2::from_translation(-start);
                Some(GradientMapping {
                    to_unit: unit * to_gradient,
                    focal: Vec2::ZERO,
                    radial: false,
                })
            }
            GradientKind::Radial {
                center,
                radius,
                focal,
            } => {
                if radius <= 1e-6 {
                    return None;
                }
                let unit = Affine2::from_scale(Vec2::splat(1.0 / radius))
                    * Affine2::from_translation(-center);
                // Odak dairenin dışına taşmasın (SVG 1.1 kuralı).
                let mut f = (focal - center) / radius;
                if f.length() > 0.99 {
                    f = f.normalize() * 0.99;
                }
                Some(GradientMapping {
                    to_unit: unit * to_gradient,
                    focal: f,
                    radial: true,
                })
            }
        }
    }

    /// Doğrusal degradenin şekil uzayındaki yönü: `t` değerinin en hızlı arttığı yön (boyu
    /// birim başına `t` artışıdır). Radyal ya da bozuk degradede `None` döner.
    pub fn linear_direction(&self) -> Option<Vec2> {
        let m = self.mapping()?;
        if m.radial {
            return None;
        }
        Some(Vec2::new(
            m.to_unit.matrix2.x_axis.x,
            m.to_unit.matrix2.y_axis.x,
        ))
    }

    /// Bir noktanın 0..1 aralığına yayılmadan önceki degrade konumu (`t`).
    pub fn raw_t(mapping: &GradientMapping, point: Vec2) -> f32 {
        let u = mapping.to_unit.transform_point2(point);
        if !mapping.radial {
            return u.x;
        }
        let f = mapping.focal;
        if f.length_squared() < 1e-12 {
            return u.length();
        }
        let d = u - f;
        let len = d.length();
        if len < 1e-9 {
            return 0.0;
        }
        let dir = d / len;
        let b = f.dot(dir);
        let c = f.length_squared() - 1.0;
        let s = -b + (b * b - c).max(0.0).sqrt();
        if s <= 1e-9 { 1.0 } else { len / s }
    }

    /// Duraklar arasında, sRGB uzayında renk bulur. Renk ve saydamlık ayrı ayrı karışır (Flash ve
    /// SVG'deki gibi); önceden çarpma, çizim sırasında renk şeridine yazılırken yapılır.
    pub fn color_at(&self, t: f32) -> Color {
        let Some(first) = self.stops.first() else {
            return Color::TRANSPARENT;
        };
        if t <= first.offset {
            return first.color;
        }
        let mut prev = *first;
        for stop in &self.stops[1..] {
            if t <= stop.offset {
                let span = stop.offset - prev.offset;
                if span <= 1e-9 {
                    return stop.color;
                }
                return prev
                    .color
                    .lerp_straight(stop.color, (t - prev.offset) / span);
            }
            prev = *stop;
        }
        prev.color
    }

    /// Son durağın rengi (bozuk degradelerde kullanılır).
    pub fn last_color(&self) -> Color {
        self.stops.last().map_or(Color::TRANSPARENT, |s| s.color)
    }

    /// Gölgelendiricinin okuduğu renk şeridi: önceden çarpılmış RGBA8.
    pub fn ramp(&self) -> Vec<[u8; 4]> {
        (0..RAMP_WIDTH)
            .map(|i| {
                let t = i as f32 / (RAMP_WIDTH - 1) as f32;
                let p = self.color_at(t).premultiplied();
                let q = |v: f32| (v.clamp(0.0, 1.0) * 255.0).round() as u8;
                [q(p[0]), q(p[1]), q(p[2]), q(p[3])]
            })
            .collect()
    }

    /// Şekil koordinatlarındaki bir noktanın rengi (işlemcide; testler için).
    pub fn sample(&self, point: Vec2) -> Color {
        match self.mapping() {
            Some(m) => self.color_at(self.spread.apply(Gradient::raw_t(&m, point))),
            None => self.last_color(),
        }
    }

    pub fn fade(&self, opacity: f32) -> Gradient {
        let mut g = self.clone();
        for s in &mut g.stops {
            s.color = s.color.fade(opacity);
        }
        g
    }
}

/// Resim boyası (Flash'ın resim dolgusu).
#[derive(Clone, Debug, PartialEq)]
pub struct ImagePaint {
    /// Düz (saydamlıkla çarpılmamış) RGBA resim.
    pub image: Arc<RgbaImage>,
    /// Resmin içeriğinin özeti (aynı resim grafik kartında bir kez durur).
    pub hash: u64,
    /// Resmin piksel koordinatlarından şeklin koordinatlarına dönüşüm.
    pub transform: Affine2,
    /// Kırpılmış: resmin dışında kenar pikselleri uzar. Değilse resim tekrar eder.
    pub clip: bool,
    /// Yumuşatmalı (çift doğrusal) okuma; değilse en yakın piksel.
    pub smooth: bool,
    pub opacity: f32,
}

impl ImagePaint {
    pub fn new(image: Arc<RgbaImage>, transform: Affine2, clip: bool, smooth: bool) -> Self {
        // FNV-1a
        let mut hash: u64 = 0xcbf2_9ce4_8422_2325;
        for b in image
            .width
            .to_le_bytes()
            .iter()
            .chain(&image.height.to_le_bytes())
            .chain(&image.data)
        {
            hash = (hash ^ u64::from(*b)).wrapping_mul(0x0100_0000_01b3);
        }
        ImagePaint {
            image,
            hash,
            transform,
            clip,
            smooth,
            opacity: 1.0,
        }
    }

    /// Şekil koordinatlarındaki bir noktanın resimdeki yeri (piksel; kırpma ya da tekrar uygulanmış).
    pub fn texel(&self, point: Vec2) -> Option<Vec2> {
        let det = self.transform.matrix2.determinant();
        if !det.is_finite() || det.abs() < 1e-12 || self.image.width == 0 || self.image.height == 0
        {
            return None;
        }
        let u = self.transform.inverse().transform_point2(point);
        let size = Vec2::new(self.image.width as f32, self.image.height as f32);
        Some(if self.clip {
            u.clamp(Vec2::ZERO, size - Vec2::splat(1e-3))
        } else {
            u - (u / size).floor() * size
        })
    }

    /// Bir noktadaki renk (işlemcide; testler için). Yumuşatmalıda da en yakın piksel okunur.
    pub fn sample(&self, point: Vec2) -> Color {
        let Some(u) = self.texel(point) else {
            return Color::TRANSPARENT;
        };
        let [r, g, b, a] = self.image.pixel(u.x as u32, u.y as u32);
        Color::from_rgba8(r, g, b, a).fade(self.opacity)
    }
}

/// Bir şeklin içini ya da çizgisini boyayan şey.
#[derive(Clone, Debug, PartialEq)]
pub enum Paint {
    Solid(Color),
    Gradient(Gradient),
    Image(ImagePaint),
}

impl Paint {
    /// Saydamlığı verilen oranla çarpılmış boya.
    pub fn fade(&self, opacity: f32) -> Paint {
        if (opacity - 1.0).abs() < f32::EPSILON {
            return self.clone();
        }
        match self {
            Paint::Solid(c) => Paint::Solid(c.fade(opacity)),
            Paint::Gradient(g) => Paint::Gradient(g.fade(opacity)),
            Paint::Image(i) => Paint::Image(ImagePaint {
                opacity: i.opacity * opacity,
                ..i.clone()
            }),
        }
    }

    /// Boyanın bir noktadaki rengi (işlemcide; testler için).
    pub fn sample(&self, point: Vec2) -> Color {
        match self {
            Paint::Solid(c) => *c,
            Paint::Gradient(g) => g.sample(point),
            Paint::Image(i) => i.sample(point),
        }
    }
}

impl From<Color> for Paint {
    fn from(c: Color) -> Self {
        Paint::Solid(c)
    }
}

impl From<Gradient> for Paint {
    fn from(g: Gradient) -> Self {
        Paint::Gradient(g)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn linear_direction_follows_transform() {
        let mut g = Gradient::linear(Vec2::ZERO, Vec2::new(10.0, 0.0), vec![]);
        let d = g.linear_direction().unwrap();
        assert!(d.normalize().abs_diff_eq(Vec2::X, 1e-5), "{d}");

        // Degrade 90° döndürülünce şekil uzayında aşağı doğru artar.
        g.transform = Affine2::from_angle(std::f32::consts::FRAC_PI_2);
        let d = g.linear_direction().unwrap();
        assert!(d.normalize().abs_diff_eq(Vec2::Y, 1e-5), "{d}");

        // Eğik ölçek yönü de değiştirir: degrade boyunca t'nin en hızlı arttığı yön.
        g.transform = Affine2::from_cols_array(&[1.0, 0.0, 1.0, 1.0, 0.0, 0.0]);
        let d = g.linear_direction().unwrap().normalize();
        let expected = Vec2::new(1.0, -1.0).normalize();
        assert!(d.abs_diff_eq(expected, 1e-5), "{d}");

        let r = Gradient::radial(Vec2::ZERO, 5.0, vec![]);
        assert!(r.linear_direction().is_none());
    }

    fn bw() -> Vec<GradientStop> {
        vec![
            GradientStop::new(0.0, Color::BLACK),
            GradientStop::new(1.0, Color::WHITE),
        ]
    }

    #[test]
    fn linear_gradient_maps_start_and_end() {
        let g = Gradient::linear(Vec2::new(10.0, 0.0), Vec2::new(110.0, 0.0), bw());
        let m = g.mapping().unwrap();
        assert!((Gradient::raw_t(&m, Vec2::new(10.0, 50.0))).abs() < 1e-5);
        assert!((Gradient::raw_t(&m, Vec2::new(60.0, -7.0)) - 0.5).abs() < 1e-5);
        assert!((Gradient::raw_t(&m, Vec2::new(110.0, 3.0)) - 1.0).abs() < 1e-5);
    }

    #[test]
    fn diagonal_linear_gradient() {
        let g = Gradient::linear(Vec2::ZERO, Vec2::new(10.0, 10.0), bw());
        let m = g.mapping().unwrap();
        assert!((Gradient::raw_t(&m, Vec2::new(10.0, 0.0)) - 0.5).abs() < 1e-5);
        assert!((Gradient::raw_t(&m, Vec2::new(10.0, 10.0)) - 1.0).abs() < 1e-5);
    }

    #[test]
    fn gradient_transform_is_applied() {
        let mut g = Gradient::linear(Vec2::ZERO, Vec2::new(1.0, 0.0), bw());
        // Degrade uzayı 100 kat büyütülüp 50 birim sağa kaydırılmış.
        g.transform = Affine2::from_translation(Vec2::new(50.0, 0.0))
            * Affine2::from_scale(Vec2::splat(100.0));
        let m = g.mapping().unwrap();
        assert!((Gradient::raw_t(&m, Vec2::new(100.0, 0.0)) - 0.5).abs() < 1e-5);
    }

    #[test]
    fn radial_gradient_distance() {
        let g = Gradient::radial(Vec2::new(50.0, 50.0), 20.0, bw());
        let m = g.mapping().unwrap();
        assert!(Gradient::raw_t(&m, Vec2::new(50.0, 50.0)).abs() < 1e-5);
        assert!((Gradient::raw_t(&m, Vec2::new(60.0, 50.0)) - 0.5).abs() < 1e-5);
        assert!((Gradient::raw_t(&m, Vec2::new(50.0, 70.0)) - 1.0).abs() < 1e-5);
    }

    #[test]
    fn focal_radial_gradient_reaches_one_on_circle() {
        let mut g = Gradient::radial(Vec2::ZERO, 10.0, bw());
        g.kind = GradientKind::Radial {
            center: Vec2::ZERO,
            radius: 10.0,
            focal: Vec2::new(5.0, 0.0),
        };
        let m = g.mapping().unwrap();
        assert!(Gradient::raw_t(&m, Vec2::new(5.0, 0.0)).abs() < 1e-5);
        for p in [
            Vec2::new(10.0, 0.0),
            Vec2::new(-10.0, 0.0),
            Vec2::new(0.0, 10.0),
        ] {
            assert!((Gradient::raw_t(&m, p) - 1.0).abs() < 1e-4, "{p}");
        }
        // Odak ile kenar arasının ortası.
        assert!((Gradient::raw_t(&m, Vec2::new(-2.5, 0.0)) - 0.5).abs() < 1e-4);
    }

    #[test]
    fn degenerate_gradients_have_no_mapping() {
        assert!(
            Gradient::linear(Vec2::ONE, Vec2::ONE, bw())
                .mapping()
                .is_none()
        );
        assert!(Gradient::radial(Vec2::ONE, 0.0, bw()).mapping().is_none());
        let g = Gradient::linear(Vec2::ZERO, Vec2::X, bw());
        assert_eq!(g.clone().sample(Vec2::new(-5.0, 0.0)), Color::BLACK);
        let broken = Gradient::linear(Vec2::ONE, Vec2::ONE, bw());
        assert_eq!(broken.sample(Vec2::ZERO), Color::WHITE);
    }

    #[test]
    fn stops_mix_colour_and_opacity_separately_like_flash() {
        // Flash (ve SVG) duraklar arasında rengi ve saydamlığı ayrı ayrı karıştırır; önceden çarpılmış
        // karışım saydam durağın rengini yok sayıp ara tonları koyulaştırırdı.
        let clear_grey = Color::rgba(0.4, 0.4, 0.4, 0.0);
        let g = Gradient::linear(
            Vec2::ZERO,
            Vec2::X,
            vec![
                GradientStop::new(0.0, clear_grey),
                GradientStop::new(1.0, Color::BLACK),
            ],
        );
        let mid = g.color_at(0.5);
        assert!((mid.a - 0.5).abs() < 1e-5, "{mid:?}");
        assert!((mid.r - 0.2).abs() < 1e-5, "{mid:?}");
    }

    #[test]
    fn color_at_respects_stops() {
        let red = Color::from_hex("#FF0000").unwrap();
        let g = Gradient::linear(
            Vec2::ZERO,
            Vec2::X,
            vec![
                GradientStop::new(0.25, Color::BLACK),
                GradientStop::new(0.5, red),
                GradientStop::new(0.75, Color::WHITE),
            ],
        );
        assert_eq!(g.color_at(0.0), Color::BLACK);
        assert_eq!(g.color_at(0.5), red);
        assert_eq!(g.color_at(1.0), Color::WHITE);
        let q = g.color_at(0.375);
        assert!((q.r - 0.5).abs() < 1e-5 && q.g.abs() < 1e-5);
    }

    #[test]
    fn spread_modes() {
        assert_eq!(Spread::Pad.apply(-0.5), 0.0);
        assert_eq!(Spread::Pad.apply(1.5), 1.0);
        assert!((Spread::Repeat.apply(1.25) - 0.25).abs() < 1e-6);
        assert!((Spread::Reflect.apply(1.25) - 0.75).abs() < 1e-6);
        assert!((Spread::Reflect.apply(0.25) - 0.25).abs() < 1e-6);
    }

    #[test]
    fn ramp_is_premultiplied_and_monotonic() {
        let g = Gradient::linear(
            Vec2::ZERO,
            Vec2::X,
            vec![
                GradientStop::new(0.0, Color::WHITE.with_alpha(0.0)),
                GradientStop::new(1.0, Color::WHITE),
            ],
        );
        let ramp = g.ramp();
        assert_eq!(ramp.len(), RAMP_WIDTH);
        assert_eq!(ramp[0], [0, 0, 0, 0]);
        assert_eq!(ramp[RAMP_WIDTH - 1], [255, 255, 255, 255]);
        assert!(ramp.windows(2).all(|w| w[0][3] <= w[1][3]));
        // Önceden çarpılmış: renk bileşeni saydamlıktan büyük olamaz.
        assert!(ramp.iter().all(|p| p[0] <= p[3]));
    }

    #[test]
    fn fade_scales_alpha() {
        let p = Paint::from(Color::WHITE).fade(0.5);
        assert_eq!(p, Paint::Solid(Color::WHITE.with_alpha(0.5)));
        let g = Gradient::linear(Vec2::ZERO, Vec2::X, bw()).fade(0.5);
        assert!(g.stops.iter().all(|s| (s.color.a - 0.5).abs() < 1e-6));
    }
}
