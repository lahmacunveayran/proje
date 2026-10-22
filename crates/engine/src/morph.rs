//! Morph şekil: iki ucu (başlangıç ve bitiş) aynı yapıda olan vektör resmin ara hâli.
//!
//! Flash'taki gibi her şey doğrusal karışır: yolların noktaları, çizgi kalınlıkları, renkler (düz,
//! saydamlıkla çarpılmamış) ve degradelerin durakları ile matrisleri (bileşen bileşen).

use std::fmt;

use glam::{Affine2, Mat2, Vec2};
use lyon_tessellation::math::point;
use lyon_tessellation::path::{Event, Path};

use crate::paint::{Gradient, GradientKind, GradientStop, ImagePaint, Paint};
use crate::shape::{Fill, Shape, Stroke, VectorImage};

/// İki uç aynı yapıda değil (şekil, yol parçası, boya türü ya da durak sayısı farklı).
#[derive(Clone, Debug, PartialEq)]
pub struct MorphError(pub String);

impl fmt::Display for MorphError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "morph uçları uyuşmuyor: {}", self.0)
    }
}

impl std::error::Error for MorphError {}

fn mix(a: f32, b: f32, t: f32) -> f32 {
    a + (b - a) * t
}

fn mix_vec(a: Vec2, b: Vec2, t: f32) -> Vec2 {
    a + (b - a) * t
}

/// `t` oranında ara hâl (0 başlangıç, 1 bitiş).
pub fn lerp_image(a: &VectorImage, b: &VectorImage, t: f32) -> Result<VectorImage, MorphError> {
    if a.shapes.len() != b.shapes.len() {
        return Err(MorphError(format!(
            "şekil sayısı {} / {}",
            a.shapes.len(),
            b.shapes.len()
        )));
    }
    let shapes = a
        .shapes
        .iter()
        .zip(&b.shapes)
        .enumerate()
        .map(|(i, (x, y))| {
            lerp_shape(x, y, t).map_err(|e| MorphError(format!("şekil {}: {}", i + 1, e.0)))
        })
        .collect::<Result<Vec<_>, _>>()?;
    Ok(VectorImage {
        shapes,
        size: mix_vec(a.size, b.size, t),
    })
}

fn lerp_shape(a: &Shape, b: &Shape, t: f32) -> Result<Shape, MorphError> {
    let fill = match (&a.fill, &b.fill) {
        (Some(x), Some(y)) => Some(Fill {
            paint: lerp_paint(&x.paint, &y.paint, t)?,
            rule: x.rule,
        }),
        (None, None) => None,
        _ => return Err(MorphError("dolgu bir uçta var, öbüründe yok".into())),
    };
    let stroke = match (&a.stroke, &b.stroke) {
        (Some(x), Some(y)) => Some(Stroke {
            paint: lerp_paint(&x.paint, &y.paint, t)?,
            width: mix(x.width, y.width, t),
            ..x.clone()
        }),
        (None, None) => None,
        _ => return Err(MorphError("çizgi bir uçta var, öbüründe yok".into())),
    };
    Ok(Shape {
        path: lerp_path(&a.path, &b.path, t)?,
        fill,
        stroke,
    })
}

fn lerp_path(a: &Path, b: &Path, t: f32) -> Result<Path, MorphError> {
    let p = |x: lyon_tessellation::math::Point, y: lyon_tessellation::math::Point| {
        point(mix(x.x, y.x, t), mix(x.y, y.y, t))
    };
    let mut builder = Path::builder();
    let mut ea = a.iter();
    let mut eb = b.iter();
    loop {
        match (ea.next(), eb.next()) {
            (None, None) => break,
            (Some(Event::Begin { at: x }), Some(Event::Begin { at: y })) => {
                builder.begin(p(x, y));
            }
            (Some(Event::Line { to: x, .. }), Some(Event::Line { to: y, .. })) => {
                builder.line_to(p(x, y));
            }
            (
                Some(Event::Quadratic {
                    ctrl: c1, to: x, ..
                }),
                Some(Event::Quadratic {
                    ctrl: c2, to: y, ..
                }),
            ) => {
                builder.quadratic_bezier_to(p(c1, c2), p(x, y));
            }
            (
                Some(Event::Cubic {
                    ctrl1: a1,
                    ctrl2: a2,
                    to: x,
                    ..
                }),
                Some(Event::Cubic {
                    ctrl1: b1,
                    ctrl2: b2,
                    to: y,
                    ..
                }),
            ) => {
                builder.cubic_bezier_to(p(a1, b1), p(a2, b2), p(x, y));
            }
            (Some(Event::End { close, .. }), Some(Event::End { .. })) => {
                builder.end(close);
            }
            (x, y) => return Err(MorphError(format!("yol parçası farklı: {x:?} / {y:?}"))),
        }
    }
    Ok(builder.build())
}

fn lerp_affine(a: Affine2, b: Affine2, t: f32) -> Affine2 {
    Affine2 {
        matrix2: Mat2::from_cols(
            mix_vec(a.matrix2.x_axis, b.matrix2.x_axis, t),
            mix_vec(a.matrix2.y_axis, b.matrix2.y_axis, t),
        ),
        translation: mix_vec(a.translation, b.translation, t),
    }
}

fn lerp_paint(a: &Paint, b: &Paint, t: f32) -> Result<Paint, MorphError> {
    match (a, b) {
        (Paint::Solid(x), Paint::Solid(y)) => Ok(Paint::Solid(x.lerp_straight(*y, t))),
        (Paint::Gradient(x), Paint::Gradient(y)) => {
            if x.stops.len() != y.stops.len() {
                return Err(MorphError("degrade durak sayısı farklı".into()));
            }
            let kind = match (x.kind, y.kind) {
                (
                    GradientKind::Linear { start: s1, end: e1 },
                    GradientKind::Linear { start: s2, end: e2 },
                ) => GradientKind::Linear {
                    start: mix_vec(s1, s2, t),
                    end: mix_vec(e1, e2, t),
                },
                (
                    GradientKind::Radial {
                        center: c1,
                        radius: r1,
                        focal: f1,
                    },
                    GradientKind::Radial {
                        center: c2,
                        radius: r2,
                        focal: f2,
                    },
                ) => GradientKind::Radial {
                    center: mix_vec(c1, c2, t),
                    radius: mix(r1, r2, t),
                    focal: mix_vec(f1, f2, t),
                },
                _ => return Err(MorphError("degrade türü farklı".into())),
            };
            Ok(Paint::Gradient(Gradient {
                kind,
                stops: x
                    .stops
                    .iter()
                    .zip(&y.stops)
                    .map(|(p, q)| {
                        GradientStop::new(
                            mix(p.offset, q.offset, t),
                            p.color.lerp_straight(q.color, t),
                        )
                    })
                    .collect(),
                spread: x.spread,
                transform: lerp_affine(x.transform, y.transform, t),
            }))
        }
        (Paint::Image(x), Paint::Image(y))
            if x.hash == y.hash && x.clip == y.clip && x.smooth == y.smooth =>
        {
            Ok(Paint::Image(ImagePaint {
                transform: lerp_affine(x.transform, y.transform, t),
                opacity: mix(x.opacity, y.opacity, t),
                ..x.clone()
            }))
        }
        _ => Err(MorphError(
            "boya türü farklı (düz renk / degrade / resim)".into(),
        )),
    }
}

#[cfg(test)]
mod tests {
    #![allow(clippy::unwrap_used, clippy::expect_used, clippy::panic)]

    use super::*;
    use crate::color::Color;
    use crate::shape::{polygon_path, rect_path};

    fn image(shape: Shape) -> VectorImage {
        VectorImage {
            shapes: vec![shape],
            size: Vec2::splat(10.0),
        }
    }

    #[test]
    fn points_colours_and_widths_mix_linearly() {
        let a = image(
            Shape::filled(
                rect_path(Vec2::ZERO, Vec2::splat(10.0)),
                Color::rgba(1.0, 0.0, 0.0, 1.0),
            )
            .with_stroke(Stroke::round(Color::BLACK, 2.0)),
        );
        let b = image(
            Shape::filled(
                rect_path(Vec2::splat(10.0), Vec2::splat(20.0)),
                Color::rgba(0.0, 0.0, 1.0, 0.0),
            )
            .with_stroke(Stroke::round(Color::BLACK, 4.0)),
        );
        let m = lerp_image(&a, &b, 0.5).unwrap();
        let (min, max) = m.bounds().unwrap();
        assert_eq!((min, max), (Vec2::splat(5.0), Vec2::splat(20.0)));
        let Some(Fill {
            paint: Paint::Solid(c),
            ..
        }) = &m.shapes[0].fill
        else {
            panic!()
        };
        assert_eq!((c.r, c.b, c.a), (0.5, 0.5, 0.5));
        assert_eq!(m.shapes[0].stroke.as_ref().unwrap().width, 3.0);
        assert_eq!(lerp_image(&a, &b, 0.0).unwrap().bounds(), a.bounds());
    }

    #[test]
    fn gradient_stops_and_matrix_mix() {
        let g = |dx: f32, c: Color| {
            let mut g = Gradient::linear(
                Vec2::ZERO,
                Vec2::X,
                vec![GradientStop::new(0.0, c), GradientStop::new(1.0, c)],
            );
            g.transform = Affine2::from_translation(Vec2::new(dx, 0.0));
            Paint::Gradient(g)
        };
        let a = image(Shape::filled(
            rect_path(Vec2::ZERO, Vec2::ONE),
            g(0.0, Color::BLACK),
        ));
        let b = image(Shape::filled(
            rect_path(Vec2::ZERO, Vec2::ONE),
            g(10.0, Color::WHITE),
        ));
        let m = lerp_image(&a, &b, 0.25).unwrap();
        let Some(Fill {
            paint: Paint::Gradient(g),
            ..
        }) = &m.shapes[0].fill
        else {
            panic!()
        };
        assert_eq!(g.transform.translation.x, 2.5);
        assert_eq!(g.stops[0].color.r, 0.25);
    }

    #[test]
    fn different_structure_is_an_error() {
        let a = image(Shape::filled(
            rect_path(Vec2::ZERO, Vec2::ONE),
            Color::BLACK,
        ));
        let b = image(Shape::filled(
            polygon_path(&[Vec2::ZERO, Vec2::X, Vec2::Y]),
            Color::BLACK,
        ));
        assert!(lerp_image(&a, &b, 0.5).is_err());
        let c = image(Shape::filled(
            rect_path(Vec2::ZERO, Vec2::ONE),
            Gradient::linear(Vec2::ZERO, Vec2::X, vec![]),
        ));
        assert!(lerp_image(&a, &c, 0.5).is_err());
    }
}
