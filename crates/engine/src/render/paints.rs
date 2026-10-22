//! Boya tablosu: bütün ağların boyaları grafik kartında tek bir tabloda durur.
//!
//! Aynı boya bir kez saklanır. Degradelerin renk şeritleri (rampaları) ayrı bir dokunun
//! satırlarındadır; tablo kaydı hangi satırı kullandığını bilir.

use std::collections::HashMap;

use bytemuck::{Pod, Zeroable};
use glam::Affine2;

use crate::paint::{Gradient, GradientMapping, ImagePaint, Paint, RAMP_WIDTH, Spread};

pub(crate) const KIND_SOLID: u32 = 0;
pub(crate) const KIND_LINEAR: u32 = 1;
pub(crate) const KIND_RADIAL: u32 = 2;
pub(crate) const KIND_IMAGE: u32 = 3;
/// Resim atlasının genişliği (piksel); yüksekliği gerektikçe büyür.
pub(crate) const ATLAS_WIDTH: u32 = 2048;

/// Gölgelendiricideki `Paint` yapısının karşılığı (80 bayt).
#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Pod, Zeroable)]
pub(crate) struct GpuPaint {
    pub kind: u32,
    pub spread: u32,
    pub ramp_row: u32,
    pub _pad: u32,
    /// Düz boyada önceden çarpılmış renk.
    pub color: [f32; 4],
    /// Şekil koordinatlarından birim degrade uzayına dönüşümün iki satırı.
    pub m0: [f32; 4],
    pub m1: [f32; 4],
    /// Radyal degradede odak noktası (birim uzayda).
    pub focal: [f32; 4],
}

pub(crate) fn affine_rows(t: Affine2) -> ([f32; 4], [f32; 4]) {
    (
        [t.matrix2.x_axis.x, t.matrix2.y_axis.x, t.translation.x, 0.0],
        [t.matrix2.x_axis.y, t.matrix2.y_axis.y, t.translation.y, 0.0],
    )
}

fn spread_code(s: Spread) -> u32 {
    match s {
        Spread::Pad => 0,
        Spread::Reflect => 1,
        Spread::Repeat => 2,
    }
}

/// Boyanın tablodaki eşsiz anahtarı (kayan noktalı sayıların bit karşılıkları).
fn paint_key(paint: &Paint) -> Vec<u32> {
    match paint {
        Paint::Solid(c) => vec![
            0,
            c.r.to_bits(),
            c.g.to_bits(),
            c.b.to_bits(),
            c.a.to_bits(),
        ],
        Paint::Gradient(g) => {
            let mut k = vec![1, spread_code(g.spread)];
            match g.kind {
                crate::paint::GradientKind::Linear { start, end } => {
                    k.extend([0.0, start.x, start.y, end.x, end.y].map(|v: f32| v.to_bits()));
                }
                crate::paint::GradientKind::Radial {
                    center,
                    radius,
                    focal,
                } => {
                    k.extend(
                        [1.0, center.x, center.y, radius, focal.x, focal.y]
                            .map(|v: f32| v.to_bits()),
                    );
                }
            }
            k.extend(g.transform.to_cols_array().map(f32::to_bits));
            for s in &g.stops {
                k.extend([s.offset, s.color.r, s.color.g, s.color.b, s.color.a].map(f32::to_bits));
            }
            k
        }
        Paint::Image(i) => {
            let mut k = vec![
                2,
                i.hash as u32,
                (i.hash >> 32) as u32,
                u32::from(i.clip),
                u32::from(i.smooth),
            ];
            k.extend(i.transform.to_cols_array().map(f32::to_bits));
            k.push(i.opacity.to_bits());
            k
        }
    }
}

#[derive(Default)]
pub(crate) struct PaintTable {
    pub records: Vec<GpuPaint>,
    lookup: HashMap<Vec<u32>, u32>,
    /// Rampa dokusunun satırları, art arda.
    pub ramps: Vec<[u8; 4]>,
    pub dirty: bool,
    /// Resim atlası: resmin özeti → yeri (x, y, genişlik, yükseklik; kenar payı hariç).
    atlas_rects: HashMap<u64, [u32; 4]>,
    /// Atlastaki resimler (önceden çarpılmış, 1 piksellik kenar payıyla): (x, y, genişlik, yükseklik, veri).
    pub atlas: Vec<(u32, u32, u32, u32, Vec<u8>)>,
    /// Grafik kartına henüz gönderilmemiş ilk atlas resmi.
    pub atlas_sent: usize,
    shelf: (u32, u32, u32),
}

impl PaintTable {
    pub fn ramp_rows(&self) -> u32 {
        (self.ramps.len() / RAMP_WIDTH) as u32
    }

    /// Boyayı tabloya ekler (aynısı varsa onu kullanır) ve sırasını döndürür.
    pub fn intern(&mut self, paint: &Paint) -> u32 {
        let key = paint_key(paint);
        if let Some(&i) = self.lookup.get(&key) {
            return i;
        }
        let record = match paint {
            Paint::Solid(c) => solid(c.premultiplied()),
            Paint::Gradient(g) => match g.mapping() {
                Some(m) => self.gradient(g, &m),
                None => solid(g.last_color().premultiplied()),
            },
            Paint::Image(i) => self.image(i),
        };
        let index = self.records.len() as u32;
        self.records.push(record);
        self.lookup.insert(key, index);
        self.dirty = true;
        index
    }

    /// Atlasın kullanılan yüksekliği.
    pub fn atlas_height(&self) -> u32 {
        self.shelf.1 + self.shelf.2
    }

    /// Resmi atlasa koyar (yoksa) ve atlastaki yerini verir. Raflara soldan sağa dizilir; her resmin
    /// çevresinde kenar piksellerinin kopyasından 1 piksellik pay vardır (yumuşatmalı okumada sınır).
    fn place_image(&mut self, i: &ImagePaint) -> [u32; 4] {
        if let Some(r) = self.atlas_rects.get(&i.hash) {
            return *r;
        }
        let (w, h) = (i.image.width.min(ATLAS_WIDTH - 2), i.image.height);
        let (pw, ph) = (w + 2, h + 2);
        let (mut x, mut y, mut row) = self.shelf;
        if x + pw > ATLAS_WIDTH {
            y += row;
            x = 0;
            row = 0;
        }
        let mut data = Vec::with_capacity((pw * ph * 4) as usize);
        for py in 0..ph {
            for px in 0..pw {
                let sx = px.saturating_sub(1).min(w.saturating_sub(1));
                let sy = py.saturating_sub(1).min(h.saturating_sub(1));
                let [r, g, b, a] = i.image.pixel(sx, sy);
                let f = f32::from(a) / 255.0;
                let pre = |c: u8| (f32::from(c) * f).round() as u8;
                data.extend([pre(r), pre(g), pre(b), a]);
            }
        }
        self.atlas.push((x, y, pw, ph, data));
        self.shelf = (x + pw, y, row.max(ph));
        let rect = [x + 1, y + 1, w, h];
        self.atlas_rects.insert(i.hash, rect);
        rect
    }

    fn image(&mut self, i: &ImagePaint) -> GpuPaint {
        let det = i.transform.matrix2.determinant();
        if !det.is_finite() || det.abs() < 1e-12 || i.image.width == 0 || i.image.height == 0 {
            return solid([0.0; 4]);
        }
        let rect = self.place_image(i);
        let (m0, m1) = affine_rows(i.transform.inverse());
        GpuPaint {
            kind: KIND_IMAGE,
            spread: u32::from(i.clip),
            ramp_row: u32::from(i.smooth),
            _pad: 0,
            color: [i.opacity, 0.0, 0.0, 0.0],
            m0,
            m1,
            focal: rect.map(|v| v as f32),
        }
    }

    fn gradient(&mut self, g: &Gradient, m: &GradientMapping) -> GpuPaint {
        let row = self.ramp_rows();
        self.ramps.extend(g.ramp());
        let (m0, m1) = affine_rows(m.to_unit);
        GpuPaint {
            kind: if m.radial { KIND_RADIAL } else { KIND_LINEAR },
            spread: spread_code(g.spread),
            ramp_row: row,
            _pad: 0,
            color: [0.0; 4],
            m0,
            m1,
            focal: [m.focal.x, m.focal.y, 0.0, 0.0],
        }
    }
}

fn solid(color: [f32; 4]) -> GpuPaint {
    GpuPaint {
        kind: KIND_SOLID,
        spread: 0,
        ramp_row: 0,
        _pad: 0,
        color,
        m0: [0.0; 4],
        m1: [0.0; 4],
        focal: [0.0; 4],
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::color::Color;
    use crate::paint::GradientStop;
    use glam::Vec2;

    fn gradient() -> Paint {
        Paint::Gradient(Gradient::linear(
            Vec2::ZERO,
            Vec2::new(10.0, 0.0),
            vec![
                GradientStop::new(0.0, Color::BLACK),
                GradientStop::new(1.0, Color::WHITE),
            ],
        ))
    }

    #[test]
    fn identical_paints_are_shared() {
        let mut t = PaintTable::default();
        let a = t.intern(&Paint::Solid(Color::WHITE));
        let b = t.intern(&gradient());
        assert_eq!(t.intern(&Paint::Solid(Color::WHITE)), a);
        assert_eq!(t.intern(&gradient()), b);
        assert_eq!(t.records.len(), 2);
        assert_eq!(t.ramp_rows(), 1);
    }

    #[test]
    fn gradient_record_points_to_its_ramp() {
        let mut t = PaintTable::default();
        t.intern(&gradient());
        let mut other = gradient();
        if let Paint::Gradient(g) = &mut other {
            g.spread = Spread::Reflect;
        }
        let i = t.intern(&other) as usize;
        assert_eq!(t.records[i].ramp_row, 1);
        assert_eq!(t.records[i].spread, 1);
        assert_eq!(t.records[i].kind, KIND_LINEAR);
        assert_eq!(t.ramps.len(), 2 * RAMP_WIDTH);
    }

    #[test]
    fn degenerate_gradient_becomes_solid() {
        let mut t = PaintTable::default();
        let g = Paint::Gradient(Gradient::radial(
            Vec2::ZERO,
            0.0,
            vec![GradientStop::new(1.0, Color::WHITE)],
        ));
        let i = t.intern(&g) as usize;
        assert_eq!(t.records[i].kind, KIND_SOLID);
        assert_eq!(t.records[i].color, [1.0, 1.0, 1.0, 1.0]);
        assert_eq!(t.ramp_rows(), 0);
    }

    #[test]
    fn affine_rows_match_transform() {
        let t = Affine2::from_cols_array(&[1.0, 2.0, 3.0, 4.0, 5.0, 6.0]);
        let (r0, r1) = affine_rows(t);
        let p = Vec2::new(7.0, 8.0);
        let q = t.transform_point2(p);
        assert_eq!(r0[0] * p.x + r0[1] * p.y + r0[2], q.x);
        assert_eq!(r1[0] * p.x + r1[1] * p.y + r1[2], q.y);
    }
}
