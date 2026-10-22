//! Vektör resimleri üçgenlere bölmek.
//!
//! Her resim bir kez üçgenlere bölünür ve grafik kartına yüklenir; sonraki karelerde yalnızca
//! konumu, dönüşü ve ölçeği değişir. Böylece yüzlerce asker her karede yeniden hesaplanmadan
//! çizilir ve vektör oldukları için her ölçekte keskin kalır.

use std::fmt;

use bytemuck::{Pod, Zeroable};
use glam::{Affine2, Vec2};
use lyon_tessellation::{
    BuffersBuilder, FillOptions, FillTessellator, FillVertex, StrokeOptions, StrokeTessellator,
    StrokeVertex, VertexBuffers,
};

use crate::paint::Paint;
use crate::shape::{FillRule, LineCap, LineJoin, VectorImage};

/// Grafik kartına gönderilen köşe noktası.
#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Pod, Zeroable)]
pub struct MeshVertex {
    pub position: [f32; 2],
    /// Ağın boya listesindeki sıra.
    pub paint: u32,
}

/// Üçgenlere bölünmüş resim.
#[derive(Clone, Debug, Default, PartialEq)]
pub struct Mesh {
    pub vertices: Vec<MeshVertex>,
    pub indices: Vec<u32>,
    pub paints: Vec<Paint>,
}

#[derive(Debug)]
pub struct TessellateError(pub String);

impl fmt::Display for TessellateError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "şekil üçgenlere bölünemedi: {}", self.0)
    }
}

impl std::error::Error for TessellateError {}

impl Mesh {
    pub fn is_empty(&self) -> bool {
        self.indices.is_empty()
    }

    pub fn triangle_count(&self) -> usize {
        self.indices.len() / 3
    }

    /// Boyayı listeye ekler (aynısı varsa onu kullanır) ve sırasını döndürür.
    pub fn paint_index(&mut self, paint: &Paint) -> u32 {
        if let Some(i) = self.paints.iter().position(|p| p == paint) {
            return i as u32;
        }
        self.paints.push(paint.clone());
        (self.paints.len() - 1) as u32
    }

    /// Başka bir ağı verilen dönüşümle bu ağın sonuna ekler.
    pub fn append(&mut self, other: &Mesh, transform: Affine2) {
        let base = self.vertices.len() as u32;
        let remap: Vec<u32> = other.paints.iter().map(|p| self.paint_index(p)).collect();
        self.vertices.extend(other.vertices.iter().map(|v| {
            let p = transform.transform_point2(Vec2::from(v.position));
            MeshVertex {
                position: p.into(),
                paint: remap[v.paint as usize],
            }
        }));
        self.indices.extend(other.indices.iter().map(|i| i + base));
    }

    /// Üçgenlerin toplam alanı (testler için).
    pub fn area(&self) -> f32 {
        self.indices
            .as_chunks::<3>()
            .0
            .iter()
            .map(|t| {
                let [a, b, c] =
                    [t[0], t[1], t[2]].map(|i| Vec2::from(self.vertices[i as usize].position));
                ((b - a).perp_dot(c - a) * 0.5).abs()
            })
            .sum()
    }
}

/// Resmi üçgenlere böler. `tolerance`, eğrilerin düz parçalarla en fazla ne kadar
/// sapabileceğidir (resim birimiyle). Ekranda büyük çizilecek resimler için küçük tutulur.
pub fn tessellate(image: &VectorImage, tolerance: f32) -> Result<Mesh, TessellateError> {
    let mut mesh = Mesh::default();
    let mut fill_tess = FillTessellator::new();
    let mut stroke_tess = StrokeTessellator::new();

    for shape in &image.shapes {
        if let Some(fill) = &shape.fill {
            let paint = mesh.paint_index(&fill.paint);
            let rule = match fill.rule {
                FillRule::NonZero => lyon_tessellation::FillRule::NonZero,
                FillRule::EvenOdd => lyon_tessellation::FillRule::EvenOdd,
            };
            let options = FillOptions::tolerance(tolerance).with_fill_rule(rule);
            let mut buffers: VertexBuffers<MeshVertex, u32> = VertexBuffers::new();
            fill_tess
                .tessellate_path(
                    &shape.path,
                    &options,
                    &mut BuffersBuilder::new(&mut buffers, |v: FillVertex| MeshVertex {
                        position: v.position().to_array(),
                        paint,
                    }),
                )
                .map_err(|e| TessellateError(format!("{e:?}")))?;
            push_buffers(&mut mesh, buffers);
        }
        if let Some(stroke) = &shape.stroke {
            if stroke.width <= 0.0 {
                continue;
            }
            let paint = mesh.paint_index(&stroke.paint);
            let join = match stroke.join {
                LineJoin::Miter => lyon_tessellation::LineJoin::Miter,
                LineJoin::Round => lyon_tessellation::LineJoin::Round,
                LineJoin::Bevel => lyon_tessellation::LineJoin::Bevel,
            };
            let cap = match stroke.cap {
                LineCap::Butt => lyon_tessellation::LineCap::Butt,
                LineCap::Round => lyon_tessellation::LineCap::Round,
                LineCap::Square => lyon_tessellation::LineCap::Square,
            };
            let options = StrokeOptions::tolerance(tolerance)
                .with_line_width(stroke.width)
                .with_line_join(join)
                .with_line_cap(cap)
                .with_miter_limit(stroke.miter_limit.max(1.0));
            let mut buffers: VertexBuffers<MeshVertex, u32> = VertexBuffers::new();
            stroke_tess
                .tessellate_path(
                    &shape.path,
                    &options,
                    &mut BuffersBuilder::new(&mut buffers, |v: StrokeVertex| MeshVertex {
                        position: v.position().to_array(),
                        paint,
                    }),
                )
                .map_err(|e| TessellateError(format!("{e:?}")))?;
            push_buffers(&mut mesh, buffers);
        }
    }
    Ok(mesh)
}

fn push_buffers(mesh: &mut Mesh, buffers: VertexBuffers<MeshVertex, u32>) {
    let base = mesh.vertices.len() as u32;
    mesh.vertices.extend(buffers.vertices);
    mesh.indices
        .extend(buffers.indices.into_iter().map(|i| i + base));
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::color::Color;
    use crate::shape::{Shape, Stroke, circle_path, polygon_path, rect_path};
    use std::f32::consts::PI;

    fn image(shapes: Vec<Shape>) -> VectorImage {
        VectorImage {
            shapes,
            size: Vec2::splat(100.0),
        }
    }

    #[test]
    fn rectangle_area() {
        let img = image(vec![Shape::filled(
            rect_path(Vec2::new(5.0, 5.0), Vec2::new(10.0, 20.0)),
            Color::WHITE,
        )]);
        let mesh = tessellate(&img, 0.1).unwrap();
        assert!((mesh.area() - 200.0).abs() < 1e-3);
        assert_eq!(mesh.paints, vec![Paint::Solid(Color::WHITE)]);
    }

    #[test]
    fn circle_area_within_tolerance() {
        let img = image(vec![Shape::filled(
            circle_path(Vec2::ZERO, 10.0),
            Color::BLACK,
        )]);
        let mesh = tessellate(&img, 0.01).unwrap();
        let expected = PI * 100.0;
        assert!(
            (mesh.area() - expected).abs() / expected < 0.005,
            "{}",
            mesh.area()
        );
    }

    #[test]
    fn stroke_area() {
        let mut stroke = Stroke::round(Color::BLACK, 2.0);
        stroke.cap = LineCap::Butt;
        // Açık yol: 10 birim uzunluğunda, 2 birim kalınlığında düz çizgi.
        let mut b = lyon_tessellation::path::Path::builder();
        b.begin(lyon_tessellation::math::point(0.0, 0.0));
        b.line_to(lyon_tessellation::math::point(10.0, 0.0));
        b.end(false);
        let img = image(vec![Shape::stroked(b.build(), stroke)]);
        let mesh = tessellate(&img, 0.01).unwrap();
        assert!((mesh.area() - 20.0).abs() < 1e-3, "{}", mesh.area());
    }

    #[test]
    fn closed_polygon_fills() {
        let img = image(vec![Shape::filled(
            polygon_path(&[Vec2::ZERO, Vec2::new(4.0, 0.0), Vec2::new(0.0, 3.0)]),
            Color::WHITE,
        )]);
        assert!((tessellate(&img, 0.1).unwrap().area() - 6.0).abs() < 1e-4);
    }

    #[test]
    fn even_odd_makes_a_hole() {
        let mut b = lyon_tessellation::path::Path::builder();
        b.add_rectangle(
            &lyon_tessellation::geom::Box2D::new(
                lyon_tessellation::math::point(0.0, 0.0),
                lyon_tessellation::math::point(10.0, 10.0),
            ),
            lyon_tessellation::path::Winding::Positive,
        );
        b.add_rectangle(
            &lyon_tessellation::geom::Box2D::new(
                lyon_tessellation::math::point(2.0, 2.0),
                lyon_tessellation::math::point(8.0, 8.0),
            ),
            lyon_tessellation::path::Winding::Positive,
        );
        let path = b.build();
        let mut shape = Shape::filled(path, Color::WHITE);
        shape.fill.as_mut().unwrap().rule = FillRule::EvenOdd;
        let mesh = tessellate(&image(vec![shape]), 0.1).unwrap();
        assert!((mesh.area() - 64.0).abs() < 1e-3);
    }

    #[test]
    fn paints_are_shared_and_indexed() {
        let red = Color::from_hex("#A3241A").unwrap();
        let img = image(vec![
            Shape::filled(rect_path(Vec2::ZERO, Vec2::ONE), red),
            Shape::filled(rect_path(Vec2::ONE, Vec2::ONE), Color::WHITE)
                .with_stroke(Stroke::round(red, 0.5)),
        ]);
        let mesh = tessellate(&img, 0.1).unwrap();
        assert_eq!(mesh.paints.len(), 2);
        assert!(
            mesh.vertices
                .iter()
                .all(|v| (v.paint as usize) < mesh.paints.len())
        );
        assert!(mesh.vertices.iter().any(|v| v.paint == 1));
    }

    #[test]
    fn empty_image_gives_empty_mesh() {
        let mesh = tessellate(&VectorImage::default(), 0.1).unwrap();
        assert!(mesh.is_empty());
        assert_eq!(mesh.triangle_count(), 0);
    }

    #[test]
    fn append_transforms_and_remaps_paints() {
        let a = tessellate(
            &image(vec![Shape::filled(
                rect_path(Vec2::ZERO, Vec2::ONE),
                Color::WHITE,
            )]),
            0.1,
        )
        .unwrap();
        let b = tessellate(
            &image(vec![Shape::filled(
                rect_path(Vec2::ZERO, Vec2::ONE),
                Color::BLACK,
            )]),
            0.1,
        )
        .unwrap();
        let mut merged = a.clone();
        merged.append(&b, Affine2::from_translation(Vec2::new(5.0, 0.0)));
        merged.append(&a, Affine2::from_scale(Vec2::splat(2.0)));
        assert_eq!(merged.paints.len(), 2);
        assert!((merged.area() - 6.0).abs() < 1e-4);
        let max_x = merged
            .vertices
            .iter()
            .map(|v| v.position[0])
            .fold(f32::MIN, f32::max);
        assert!((max_x - 6.0).abs() < 1e-5);
    }
}
