//! Vektör şekiller ve vektör resimler.
//!
//! Bir [`VectorImage`], sırayla çizilen şekillerden oluşur. Her şeklin bir yolu (path),
//! isteğe bağlı bir dolgusu ve isteğe bağlı bir çizgisi vardır. SVG dosyaları da, yazılar da
//! bu yapıya çevrilir.

use glam::{Affine2, Vec2};
use lyon_tessellation::geom::Box2D;
use lyon_tessellation::math::{Point, point};
use lyon_tessellation::path::traits::PathIterator;
use lyon_tessellation::path::{Path, Winding};

use crate::paint::Paint;

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum FillRule {
    NonZero,
    EvenOdd,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum LineJoin {
    Miter,
    Round,
    Bevel,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum LineCap {
    Butt,
    Round,
    Square,
}

#[derive(Clone, Debug, PartialEq)]
pub struct Fill {
    pub paint: Paint,
    pub rule: FillRule,
}

#[derive(Clone, Debug, PartialEq)]
pub struct Stroke {
    pub paint: Paint,
    pub width: f32,
    pub join: LineJoin,
    pub cap: LineCap,
    pub miter_limit: f32,
}

impl Stroke {
    /// Yuvarlak birleşimli ve uçlu çizgi: el çizimi görünüşe en yakın olanı.
    pub fn round(paint: impl Into<Paint>, width: f32) -> Self {
        Stroke {
            paint: paint.into(),
            width,
            join: LineJoin::Round,
            cap: LineCap::Round,
            miter_limit: 4.0,
        }
    }
}

#[derive(Clone, Debug)]
pub struct Shape {
    pub path: Path,
    pub fill: Option<Fill>,
    pub stroke: Option<Stroke>,
}

impl Shape {
    pub fn filled(path: Path, paint: impl Into<Paint>) -> Self {
        Shape {
            path,
            fill: Some(Fill {
                paint: paint.into(),
                rule: FillRule::NonZero,
            }),
            stroke: None,
        }
    }

    pub fn stroked(path: Path, stroke: Stroke) -> Self {
        Shape {
            path,
            fill: None,
            stroke: Some(stroke),
        }
    }

    pub fn with_stroke(mut self, stroke: Stroke) -> Self {
        self.stroke = Some(stroke);
        self
    }
}

/// Sırayla çizilen şekillerden oluşan resim.
#[derive(Clone, Debug, Default)]
pub struct VectorImage {
    pub shapes: Vec<Shape>,
    /// Resmin tasarlandığı alanın boyu (SVG'deki genişlik ve yükseklik).
    pub size: Vec2,
}

impl VectorImage {
    pub fn new(size: Vec2) -> Self {
        VectorImage {
            shapes: Vec::new(),
            size,
        }
    }

    pub fn push(&mut self, shape: Shape) {
        self.shapes.push(shape);
    }

    pub fn is_empty(&self) -> bool {
        self.shapes.is_empty()
    }

    /// Bütün şekillerin yollarını (çizgi kalınlığı hariç) kapsayan kutu.
    pub fn bounds(&self) -> Option<(Vec2, Vec2)> {
        use lyon_tessellation::path::Event;
        let mut min = Vec2::splat(f32::INFINITY);
        let mut max = Vec2::splat(f32::NEG_INFINITY);
        for shape in &self.shapes {
            for event in shape.path.iter().flattened(0.05) {
                let points = match event {
                    Event::Begin { at } => [at, at],
                    Event::Line { from, to } => [from, to],
                    _ => continue,
                };
                for p in points {
                    min = min.min(Vec2::new(p.x, p.y));
                    max = max.max(Vec2::new(p.x, p.y));
                }
            }
        }
        (min.x <= max.x).then_some((min, max))
    }

    /// Bütün şekilleri verilen dönüşümle taşınmış yeni bir resim.
    pub fn transformed(&self, transform: Affine2) -> VectorImage {
        let shapes = self
            .shapes
            .iter()
            .map(|s| Shape {
                path: transform_path(&s.path, transform),
                fill: s.fill.as_ref().map(|f| Fill {
                    paint: transform_paint(&f.paint, transform),
                    rule: f.rule,
                }),
                stroke: s.stroke.as_ref().map(|st| Stroke {
                    paint: transform_paint(&st.paint, transform),
                    width: st.width * transform_scale(transform),
                    ..st.clone()
                }),
            })
            .collect();
        VectorImage {
            shapes,
            size: self.size,
        }
    }
}

/// Dönüşümün ortalama ölçeği (çizgi kalınlığı için).
pub fn transform_scale(t: Affine2) -> f32 {
    t.matrix2.determinant().abs().sqrt()
}

fn transform_paint(paint: &Paint, t: Affine2) -> Paint {
    match paint {
        Paint::Solid(c) => Paint::Solid(*c),
        Paint::Gradient(g) => {
            let mut g = g.clone();
            g.transform = t * g.transform;
            Paint::Gradient(g)
        }
        Paint::Image(i) => {
            let mut i = i.clone();
            i.transform = t * i.transform;
            Paint::Image(i)
        }
    }
}

fn to_point(v: Vec2) -> Point {
    point(v.x, v.y)
}

fn apply(t: Affine2, p: Point) -> Point {
    to_point(t.transform_point2(Vec2::new(p.x, p.y)))
}

/// Bir yolun bütün noktalarını dönüştürür.
pub fn transform_path(path: &Path, t: Affine2) -> Path {
    use lyon_tessellation::path::Event;
    let mut b = Path::builder();
    for event in path.iter() {
        match event {
            Event::Begin { at } => {
                b.begin(apply(t, at));
            }
            Event::Line { to, .. } => {
                b.line_to(apply(t, to));
            }
            Event::Quadratic { ctrl, to, .. } => {
                b.quadratic_bezier_to(apply(t, ctrl), apply(t, to));
            }
            Event::Cubic {
                ctrl1, ctrl2, to, ..
            } => {
                b.cubic_bezier_to(apply(t, ctrl1), apply(t, ctrl2), apply(t, to));
            }
            Event::End { close, .. } => {
                b.end(close);
            }
        }
    }
    b.build()
}

/// Bir yoldaki düz ve eğri parçaların sayısı (sanat kurallarının denetimi için).
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct SegmentCounts {
    pub lines: usize,
    pub curves: usize,
}

impl SegmentCounts {
    /// Eğri parçaların bütün parçalara oranı; parça yoksa 0.
    pub fn curve_ratio(self) -> f32 {
        let total = self.lines + self.curves;
        if total == 0 {
            0.0
        } else {
            self.curves as f32 / total as f32
        }
    }
}

/// Yolun düz ve eğri parçalarını sayar. Açık uçtan başlangıca dönen kapanış düz parça sayılır.
pub fn segment_counts(path: &Path) -> SegmentCounts {
    use lyon_tessellation::path::Event;
    let mut counts = SegmentCounts::default();
    for event in path.iter() {
        match event {
            Event::Line { .. } => counts.lines += 1,
            Event::Quadratic { .. } | Event::Cubic { .. } => counts.curves += 1,
            Event::End { last, first, close } => {
                if close && (last - first).length() > 1e-4 {
                    counts.lines += 1;
                }
            }
            Event::Begin { .. } => {}
        }
    }
    counts
}

/// Dikdörtgen yol.
pub fn rect_path(origin: Vec2, size: Vec2) -> Path {
    let mut b = Path::builder();
    b.add_rectangle(
        &Box2D::new(to_point(origin), to_point(origin + size)),
        Winding::Positive,
    );
    b.build()
}

/// Köşeleri yuvarlatılmış dikdörtgen yol.
pub fn rounded_rect_path(origin: Vec2, size: Vec2, radius: f32) -> Path {
    let mut b = Path::builder();
    b.add_rounded_rectangle(
        &Box2D::new(to_point(origin), to_point(origin + size)),
        &lyon_tessellation::path::builder::BorderRadii::new(radius),
        Winding::Positive,
    );
    b.build()
}

/// Daire yol.
pub fn circle_path(center: Vec2, radius: f32) -> Path {
    ellipse_path(center, Vec2::splat(radius))
}

/// Elips yol.
pub fn ellipse_path(center: Vec2, radii: Vec2) -> Path {
    let mut b = Path::builder();
    b.add_ellipse(
        to_point(center),
        lyon_tessellation::math::vector(radii.x, radii.y),
        lyon_tessellation::math::Angle::radians(0.0),
        Winding::Positive,
    );
    b.build()
}

/// Kapalı çokgen yol.
pub fn polygon_path(points: &[Vec2]) -> Path {
    let mut b = Path::builder();
    if let Some((first, rest)) = points.split_first() {
        b.begin(to_point(*first));
        for p in rest {
            b.line_to(to_point(*p));
        }
        b.end(true);
    }
    b.build()
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::color::Color;

    #[test]
    fn bounds_cover_all_shapes() {
        let mut img = VectorImage::new(Vec2::new(100.0, 100.0));
        assert!(img.bounds().is_none());
        img.push(Shape::filled(
            rect_path(Vec2::new(10.0, 20.0), Vec2::new(5.0, 5.0)),
            Color::WHITE,
        ));
        img.push(Shape::filled(
            circle_path(Vec2::new(50.0, 50.0), 10.0),
            Color::BLACK,
        ));
        let (min, max) = img.bounds().unwrap();
        assert!((min - Vec2::new(10.0, 20.0)).length() < 0.01, "{min}");
        assert!((max - Vec2::new(60.0, 60.0)).length() < 0.2, "{max}");
    }

    #[test]
    fn transform_moves_paths_and_gradients() {
        let mut img = VectorImage::new(Vec2::splat(10.0));
        let g = crate::paint::Gradient::linear(Vec2::ZERO, Vec2::new(10.0, 0.0), vec![]);
        img.push(
            Shape::filled(rect_path(Vec2::ZERO, Vec2::splat(10.0)), g)
                .with_stroke(Stroke::round(Color::BLACK, 2.0)),
        );
        let t = Affine2::from_scale_angle_translation(Vec2::splat(2.0), 0.0, Vec2::new(5.0, 5.0));
        let moved = img.transformed(t);
        let (min, max) = moved.bounds().unwrap();
        assert!((min - Vec2::splat(5.0)).length() < 1e-3);
        assert!((max - Vec2::splat(25.0)).length() < 1e-3);
        let shape = &moved.shapes[0];
        assert!((shape.stroke.as_ref().unwrap().width - 4.0).abs() < 1e-5);
        let Some(Fill {
            paint: Paint::Gradient(g),
            ..
        }) = &shape.fill
        else {
            panic!("degrade bekleniyordu");
        };
        assert_eq!(g.transform, t);
    }

    #[test]
    fn segment_counts_separate_lines_and_curves() {
        let mut b = Path::builder();
        b.begin(point(0.0, 0.0));
        b.line_to(point(10.0, 0.0));
        b.quadratic_bezier_to(point(15.0, 5.0), point(10.0, 10.0));
        b.cubic_bezier_to(point(8.0, 12.0), point(2.0, 12.0), point(0.0, 10.0));
        // Kapanış açık uçtan başlangıca düz bir parça ekler.
        b.end(true);
        let counts = segment_counts(&b.build());
        assert_eq!(
            counts,
            SegmentCounts {
                lines: 2,
                curves: 2
            }
        );
        assert!((counts.curve_ratio() - 0.5).abs() < 1e-6);

        // Başlangıca zaten dönmüş yolun kapanışı parça sayılmaz.
        let closed = polygon_path(&[Vec2::ZERO, Vec2::X, Vec2::Y, Vec2::ZERO]);
        assert_eq!(segment_counts(&closed).lines, 3);
        assert_eq!(SegmentCounts::default().curve_ratio(), 0.0);
    }

    #[test]
    fn polygon_path_is_closed() {
        let p = polygon_path(&[Vec2::ZERO, Vec2::X, Vec2::Y]);
        let closes = p
            .iter()
            .any(|e| matches!(e, lyon_tessellation::path::Event::End { close: true, .. }));
        assert!(closes);
        assert_eq!(polygon_path(&[]).iter().count(), 0);
    }
}
