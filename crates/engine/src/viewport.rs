//! Mantıksal ekranı (1920×1080) pencereye sığdırmak.
//!
//! Oyun her zaman 1920×1080 mantıksal piksellik bir alana çizilir. Pencere hangi boyutta
//! olursa olsun bu alan en-boy oranı korunarak büyütülür ya da küçültülür; artan yerler
//! kenarda koyu şerit olarak kalır.

use glam::{Affine2, UVec2, Vec2};

/// Oyunun tasarlandığı mantıksal ekran boyu.
pub const LOGICAL_SIZE: Vec2 = Vec2::new(1920.0, 1080.0);

#[derive(Clone, Copy, Debug, PartialEq)]
pub struct Viewport {
    /// Mantıksal alanın boyu.
    pub logical: Vec2,
    /// Hedefin (pencere ya da resim) fiziksel piksel boyu.
    pub physical: UVec2,
    /// Bir mantıksal pikselin kaç fiziksel piksel olduğu.
    pub scale: f32,
    /// Mantıksal alanın sol üst köşesinin fiziksel konumu.
    pub offset: Vec2,
}

impl Viewport {
    /// Mantıksal alanı en-boy oranını koruyarak hedefe ortalar.
    pub fn fit(logical: Vec2, physical: UVec2) -> Self {
        let phys = physical.max(UVec2::ONE).as_vec2();
        let scale = (phys.x / logical.x).min(phys.y / logical.y);
        let offset = ((phys - logical * scale) * 0.5).max(Vec2::ZERO);
        Viewport {
            logical,
            physical: physical.max(UVec2::ONE),
            scale,
            offset,
        }
    }

    pub fn logical_to_physical(&self, p: Vec2) -> Vec2 {
        p * self.scale + self.offset
    }

    pub fn physical_to_logical(&self, p: Vec2) -> Vec2 {
        (p - self.offset) / self.scale
    }

    /// Mantıksal koordinatları grafik kartının kırpma uzayına (-1..1, y yukarı) çevirir.
    pub fn clip_transform(&self) -> Affine2 {
        let phys = self.physical.as_vec2();
        let sx = 2.0 * self.scale / phys.x;
        let sy = -2.0 * self.scale / phys.y;
        let tx = 2.0 * self.offset.x / phys.x - 1.0;
        let ty = 1.0 - 2.0 * self.offset.y / phys.y;
        Affine2::from_cols_array(&[sx, 0.0, 0.0, sy, tx, ty])
    }

    /// Mantıksal alanın kapladığı fiziksel dikdörtgen (sol üst, boy).
    pub fn content_rect(&self) -> (Vec2, Vec2) {
        (self.offset, self.logical * self.scale)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn exact_fit_has_no_bars() {
        let v = Viewport::fit(LOGICAL_SIZE, UVec2::new(3840, 2160));
        assert_eq!(v.scale, 2.0);
        assert_eq!(v.offset, Vec2::ZERO);
    }

    #[test]
    fn wider_window_gets_side_bars() {
        let v = Viewport::fit(LOGICAL_SIZE, UVec2::new(2560, 1080));
        assert_eq!(v.scale, 1.0);
        assert_eq!(v.offset, Vec2::new(320.0, 0.0));
    }

    #[test]
    fn taller_window_gets_top_bars() {
        let v = Viewport::fit(LOGICAL_SIZE, UVec2::new(1920, 1200));
        assert_eq!(v.offset, Vec2::new(0.0, 60.0));
    }

    #[test]
    fn round_trip_between_spaces() {
        let v = Viewport::fit(LOGICAL_SIZE, UVec2::new(1280, 1024));
        let p = Vec2::new(123.0, 456.0);
        let back = v.physical_to_logical(v.logical_to_physical(p));
        assert!((back - p).length() < 1e-3);
    }

    #[test]
    fn clip_transform_maps_corners() {
        let v = Viewport::fit(LOGICAL_SIZE, UVec2::new(1920, 1080));
        let t = v.clip_transform();
        assert!((t.transform_point2(Vec2::ZERO) - Vec2::new(-1.0, 1.0)).length() < 1e-6);
        assert!((t.transform_point2(LOGICAL_SIZE) - Vec2::new(1.0, -1.0)).length() < 1e-6);
        let w = Viewport::fit(LOGICAL_SIZE, UVec2::new(2560, 1080));
        // Yan şeritli pencerede mantıksal sol kenar kırpma uzayında -1'den içeride kalır.
        assert!((w.clip_transform().transform_point2(Vec2::ZERO).x - (-0.75)).abs() < 1e-6);
    }

    #[test]
    fn zero_size_window_is_safe() {
        let v = Viewport::fit(LOGICAL_SIZE, UVec2::ZERO);
        assert!(v.scale.is_finite() && v.scale > 0.0);
    }
}
