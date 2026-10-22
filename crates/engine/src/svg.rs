//! SVG dosyalarını vektör resme çevirmek.
//!
//! Sanat rehberindeki (docs/SANAT.md) SVG alt kümesi desteklenir. Desteklenmeyen bir öğe
//! (filtre, maske, kırpma yolu, desen, gömülü resim, SVG içinde yazı, kesikli çizgi) sessizce
//! atlanmaz; açık bir hata verilir. Böylece çizimdeki bir yanlışlık hemen fark edilir.

use std::fmt;
use std::sync::Arc;

use glam::{Affine2, Vec2};
use lyon_tessellation::math::point;
use lyon_tessellation::path::Path;
use usvg::tiny_skia_path::PathSegment;

use crate::color::Color;
use crate::image::RgbaImage;
use crate::paint::{Gradient, GradientKind, GradientStop, ImagePaint, Paint, Spread};
use crate::shape::{
    Fill, FillRule, LineCap, LineJoin, Shape, Stroke, VectorImage, transform_scale,
};

#[derive(Debug)]
pub enum SvgError {
    Parse(String),
    Unsupported { what: &'static str, id: String },
}

impl fmt::Display for SvgError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            SvgError::Parse(e) => write!(f, "SVG okunamadı: {e}"),
            SvgError::Unsupported { what, id } if id.is_empty() => {
                write!(f, "SVG'de desteklenmeyen öğe: {what}")
            }
            SvgError::Unsupported { what, id } => {
                write!(f, "SVG'de desteklenmeyen öğe: {what} (kimlik: {id})")
            }
        }
    }
}

impl std::error::Error for SvgError {}

fn unsupported(what: &'static str, id: &str) -> SvgError {
    SvgError::Unsupported {
        what,
        id: id.to_string(),
    }
}

/// SVG verisini vektör resme çevirir. Bütün dönüşümler şekillere işlenir; resmin
/// koordinatları SVG'nin kullanıcı birimleridir.
pub fn load_svg(data: &[u8]) -> Result<VectorImage, SvgError> {
    let tree = usvg::Tree::from_data(data, &usvg::Options::default())
        .map_err(|e| SvgError::Parse(e.to_string()))?;
    let size = tree.size();
    let mut image = VectorImage::new(Vec2::new(size.width(), size.height()));
    convert_group(tree.root(), 1.0, &mut image)?;
    Ok(image)
}

fn affine(t: usvg::Transform) -> Affine2 {
    Affine2::from_cols_array(&[t.sx, t.ky, t.kx, t.sy, t.tx, t.ty])
}

fn convert_group(group: &usvg::Group, opacity: f32, out: &mut VectorImage) -> Result<(), SvgError> {
    if !group.filters().is_empty() {
        return Err(unsupported("filtre", group.id()));
    }
    if group.mask().is_some() {
        return Err(unsupported("maske", group.id()));
    }
    if group.clip_path().is_some() {
        return Err(unsupported("kırpma yolu", group.id()));
    }
    if group.blend_mode() != usvg::BlendMode::Normal {
        return Err(unsupported("karışım kipi", group.id()));
    }
    // Grup saydamlığı her şekle ayrı uygulanır (sanat rehberi grup saydamlığı yerine şekil
    // saydamlığı kullanılmasını ister; üst üste binen şekillerde fark olabilir).
    let opacity = opacity * group.opacity().get();
    for node in group.children() {
        match node {
            usvg::Node::Group(g) => convert_group(g, opacity, out)?,
            usvg::Node::Path(p) => convert_path(p, opacity, out)?,
            usvg::Node::Image(i) => return Err(unsupported("gömülü resim", i.id())),
            usvg::Node::Text(t) => return Err(unsupported("SVG içinde yazı", t.id())),
        }
    }
    Ok(())
}

fn convert_path(p: &usvg::Path, opacity: f32, out: &mut VectorImage) -> Result<(), SvgError> {
    if !p.is_visible() {
        return Ok(());
    }
    let t = affine(p.abs_transform());
    let path = convert_data(p.data(), t);
    let fill = match p.fill() {
        Some(f) => Some(Fill {
            paint: convert_paint(f.paint(), t, opacity * f.opacity().get(), p.id())?,
            rule: match f.rule() {
                usvg::FillRule::NonZero => FillRule::NonZero,
                usvg::FillRule::EvenOdd => FillRule::EvenOdd,
            },
        }),
        None => None,
    };
    let stroke = match p.stroke() {
        Some(s) => {
            if s.dasharray().is_some() {
                return Err(unsupported("kesikli çizgi", p.id()));
            }
            Some(Stroke {
                paint: convert_paint(s.paint(), t, opacity * s.opacity().get(), p.id())?,
                width: s.width().get() * transform_scale(t),
                join: match s.linejoin() {
                    usvg::LineJoin::Miter | usvg::LineJoin::MiterClip => LineJoin::Miter,
                    usvg::LineJoin::Round => LineJoin::Round,
                    usvg::LineJoin::Bevel => LineJoin::Bevel,
                },
                cap: match s.linecap() {
                    usvg::LineCap::Butt => LineCap::Butt,
                    usvg::LineCap::Round => LineCap::Round,
                    usvg::LineCap::Square => LineCap::Square,
                },
                miter_limit: s.miterlimit().get(),
            })
        }
        None => None,
    };
    match p.paint_order() {
        usvg::PaintOrder::FillAndStroke => out.push(Shape { path, fill, stroke }),
        usvg::PaintOrder::StrokeAndFill => {
            out.push(Shape {
                path: path.clone(),
                fill: None,
                stroke,
            });
            out.push(Shape {
                path,
                fill,
                stroke: None,
            });
        }
    }
    Ok(())
}

fn convert_data(data: &usvg::tiny_skia_path::Path, t: Affine2) -> Path {
    let pt = |p: usvg::tiny_skia_path::Point| {
        let q = t.transform_point2(Vec2::new(p.x, p.y));
        point(q.x, q.y)
    };
    let mut b = Path::builder();
    let mut open = false;
    for seg in data.segments() {
        match seg {
            PathSegment::MoveTo(p) => {
                if open {
                    b.end(false);
                }
                b.begin(pt(p));
                open = true;
            }
            PathSegment::LineTo(p) => {
                b.line_to(pt(p));
            }
            PathSegment::QuadTo(c, p) => {
                b.quadratic_bezier_to(pt(c), pt(p));
            }
            PathSegment::CubicTo(c1, c2, p) => {
                b.cubic_bezier_to(pt(c1), pt(c2), pt(p));
            }
            PathSegment::Close => {
                if open {
                    b.end(true);
                    open = false;
                }
            }
        }
    }
    if open {
        b.end(false);
    }
    b.build()
}

fn convert_stops(stops: &[usvg::Stop], opacity: f32) -> Vec<GradientStop> {
    stops
        .iter()
        .map(|s| {
            let c = s.color();
            GradientStop::new(
                s.offset().get(),
                Color::from_rgba8(c.red, c.green, c.blue, 255)
                    .with_alpha(s.opacity().get() * opacity),
            )
        })
        .collect()
}

fn convert_spread(s: usvg::SpreadMethod) -> Spread {
    match s {
        usvg::SpreadMethod::Pad => Spread::Pad,
        usvg::SpreadMethod::Reflect => Spread::Reflect,
        usvg::SpreadMethod::Repeat => Spread::Repeat,
    }
}

fn convert_paint(
    paint: &usvg::Paint,
    t: Affine2,
    opacity: f32,
    id: &str,
) -> Result<Paint, SvgError> {
    Ok(match paint {
        usvg::Paint::Color(c) => {
            Paint::Solid(Color::from_rgba8(c.red, c.green, c.blue, 255).with_alpha(opacity))
        }
        usvg::Paint::LinearGradient(g) => Paint::Gradient(Gradient {
            kind: GradientKind::Linear {
                start: Vec2::new(g.x1(), g.y1()),
                end: Vec2::new(g.x2(), g.y2()),
            },
            stops: convert_stops(g.stops(), opacity),
            spread: convert_spread(g.spread_method()),
            transform: t * affine(g.transform()),
        }),
        usvg::Paint::RadialGradient(g) => Paint::Gradient(Gradient {
            kind: GradientKind::Radial {
                center: Vec2::new(g.cx(), g.cy()),
                radius: g.r().get(),
                focal: Vec2::new(g.fx(), g.fy()),
            },
            stops: convert_stops(g.stops(), opacity),
            spread: convert_spread(g.spread_method()),
            transform: t * affine(g.transform()),
        }),
        usvg::Paint::Pattern(p) => Paint::Image(pattern_image(p, t, opacity, id)?),
    })
}

fn find_image(group: &usvg::Group) -> Option<&usvg::Image> {
    group.children().iter().find_map(|node| match node {
        usvg::Node::Image(i) => Some(i.as_ref()),
        usvg::Node::Group(g) => find_image(g),
        _ => None,
    })
}

/// FFDec'in resim dolgusu deseni: içinde tek bir PNG resmi olan desen. Desen kimliğindeki "-kirp"
/// kırpılmış dolgu (kenar uzar), "-yumusak" yumuşatmalı okuma demektir (aktarım aracı yazar).
fn pattern_image(
    p: &usvg::Pattern,
    t: Affine2,
    opacity: f32,
    id: &str,
) -> Result<ImagePaint, SvgError> {
    let image = find_image(p.root()).ok_or_else(|| unsupported("resimsiz desen", id))?;
    let usvg::ImageKind::PNG(data) = image.kind() else {
        return Err(unsupported("PNG olmayan desen resmi", id));
    };
    let decoded = RgbaImage::decode_png(data).map_err(|e| SvgError::Parse(e.to_string()))?;
    if decoded.width == 0 || decoded.height == 0 {
        return Err(unsupported("boş desen resmi", id));
    }
    let size = image.size();
    let pixel = Affine2::from_scale(Vec2::new(
        size.width() / decoded.width as f32,
        size.height() / decoded.height as f32,
    ));
    let mut paint = ImagePaint::new(
        Arc::new(decoded),
        t * affine(p.transform()) * affine(image.abs_transform()) * pixel,
        p.id().contains("-kirp"),
        p.id().contains("-yumusak"),
    );
    paint.opacity = opacity;
    Ok(paint)
}

#[cfg(test)]
mod tests {
    use super::*;

    fn svg(body: &str) -> String {
        format!(
            r#"<svg xmlns="http://www.w3.org/2000/svg" width="100" height="50" viewBox="0 0 100 50">{body}</svg>"#
        )
    }

    #[test]
    fn reads_size_and_solid_fill() {
        let img = load_svg(
            svg(r##"<rect x="10" y="5" width="20" height="10" fill="#A3241A"/>"##).as_bytes(),
        )
        .unwrap();
        assert_eq!(img.size, Vec2::new(100.0, 50.0));
        assert_eq!(img.shapes.len(), 1);
        let fill = img.shapes[0].fill.as_ref().unwrap();
        assert_eq!(
            fill.paint,
            Paint::Solid(Color::from_hex("#A3241A").unwrap())
        );
        let (min, max) = img.bounds().unwrap();
        assert!((min - Vec2::new(10.0, 5.0)).length() < 1e-4);
        assert!((max - Vec2::new(30.0, 15.0)).length() < 1e-4);
    }

    #[test]
    fn transforms_are_baked_into_paths() {
        let img = load_svg(
            svg(r##"<g transform="translate(50 0) scale(2)"><rect x="0" y="0" width="10" height="5" fill="#000"/></g>"##)
                .as_bytes(),
        )
        .unwrap();
        let (min, max) = img.bounds().unwrap();
        assert!((min - Vec2::new(50.0, 0.0)).length() < 1e-4);
        assert!((max - Vec2::new(70.0, 10.0)).length() < 1e-4);
    }

    #[test]
    fn viewbox_scales_content() {
        let data = r##"<svg xmlns="http://www.w3.org/2000/svg" width="200" height="100" viewBox="0 0 100 50"><rect width="100" height="50" fill="#fff"/></svg>"##;
        let img = load_svg(data.as_bytes()).unwrap();
        let (_, max) = img.bounds().unwrap();
        assert!((max - Vec2::new(200.0, 100.0)).length() < 1e-3);
    }

    #[test]
    fn bounding_box_gradient_becomes_user_space() {
        let img = load_svg(
            svg(r##"<defs><linearGradient id="g"><stop offset="0" stop-color="#000"/><stop offset="1" stop-color="#fff"/></linearGradient></defs>
            <rect x="20" y="0" width="40" height="50" fill="url(#g)"/>"##)
            .as_bytes(),
        )
        .unwrap();
        let paint = &img.shapes[0].fill.as_ref().unwrap().paint;
        // Nesne kutusuna göre tanımlı degrade: dikdörtgenin solunda siyah, ortasında gri, sağında beyaz.
        assert!(paint.sample(Vec2::new(20.0, 25.0)).r < 0.01);
        assert!((paint.sample(Vec2::new(40.0, 25.0)).r - 0.5).abs() < 0.01);
        assert!(paint.sample(Vec2::new(60.0, 25.0)).r > 0.99);
    }

    #[test]
    fn opacities_multiply() {
        let img = load_svg(
            svg(r##"<g opacity="0.5"><rect width="10" height="10" fill="#fff" fill-opacity="0.5"/></g>"##).as_bytes(),
        )
        .unwrap();
        let Paint::Solid(c) = img.shapes[0].fill.as_ref().unwrap().paint else {
            panic!("düz boya bekleniyordu");
        };
        assert!((c.a - 0.25).abs() < 1e-6);
    }

    #[test]
    fn stroke_width_scales_with_transform() {
        let img = load_svg(
            svg(r##"<g transform="scale(3)"><path d="M0 0 L10 0" stroke="#000" stroke-width="2" fill="none"/></g>"##)
                .as_bytes(),
        )
        .unwrap();
        let s = img.shapes[0].stroke.as_ref().unwrap();
        assert!((s.width - 6.0).abs() < 1e-5);
        assert!(img.shapes[0].fill.is_none());
    }

    #[test]
    fn unsupported_elements_are_errors() {
        let cases = [
            (
                r#"<defs><filter id="f"><feGaussianBlur stdDeviation="2"/></filter></defs><rect width="10" height="10" filter="url(#f)"/>"#,
                "filtre",
            ),
            (
                r#"<defs><clipPath id="c"><rect width="5" height="5"/></clipPath></defs><rect width="10" height="10" clip-path="url(#c)"/>"#,
                "kırpma yolu",
            ),
            (
                r##"<path d="M0 0 L10 0" stroke="#000" stroke-dasharray="2 2"/>"##,
                "kesikli çizgi",
            ),
            (
                r#"<defs><pattern id="p" width="4" height="4" patternUnits="userSpaceOnUse"><rect width="2" height="2"/></pattern></defs><rect width="10" height="10" fill="url(#p)"/>"#,
                "resimsiz desen",
            ),
        ];
        for (body, what) in cases {
            match load_svg(svg(body).as_bytes()) {
                Err(SvgError::Unsupported { what: w, .. }) => assert_eq!(w, what),
                other => panic!("{what} için hata bekleniyordu: {other:?}"),
            }
        }
    }

    #[test]
    fn invalid_svg_is_a_parse_error() {
        assert!(matches!(load_svg(b"<svg"), Err(SvgError::Parse(_))));
    }

    fn base64(data: &[u8]) -> String {
        const T: &[u8] = b"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        let mut out = String::new();
        for c in data.chunks(3) {
            let n = (u32::from(c[0]) << 16)
                | (u32::from(*c.get(1).unwrap_or(&0)) << 8)
                | u32::from(*c.get(2).unwrap_or(&0));
            for k in 0..4 {
                if k <= c.len() {
                    out.push(T[((n >> (18 - 6 * k)) & 63) as usize] as char);
                } else {
                    out.push('=');
                }
            }
        }
        out
    }

    #[test]
    fn ffdec_pattern_becomes_image_paint_with_its_mode() {
        // FFDec'in resim dolgusu: desen kimliğindeki "-kirp" kırpılmış dolgu, "-yumusak" yumuşatmalı demektir
        let mut img = crate::image::RgbaImage::new(2, 1);
        img.set_pixel(0, 0, [255, 0, 0, 255]);
        img.set_pixel(1, 0, [0, 0, 255, 255]);
        let png = base64(&img.encode_png().unwrap());
        let doc = |id: &str| {
            svg(&format!(
                r##"<pattern id="{id}" width="2" height="1" patternUnits="userSpaceOnUse" overflow="visible" viewBox="0 0 2 1" patternTransform="matrix(10, 0, 0, 10, 5, 0)"><image width="2" height="1" xlink:href="data:image/PNG;base64,{png}"/></pattern><path d="M0 0 L100 0 L100 50 L0 50 Z" style="fill:url(#{id})"/>"##
            ))
            .replace("<svg ", r#"<svg xmlns:xlink="http://www.w3.org/1999/xlink" "#)
        };
        let shape = load_svg(doc("PatternID_5_1-kirp").as_bytes()).unwrap();
        let Paint::Image(p) = &shape.shapes[0].fill.as_ref().unwrap().paint else {
            panic!("resim boyası bekleniyordu");
        };
        assert!(p.clip && !p.smooth);
        assert_eq!(p.image.width, 2);
        assert_eq!(p.sample(Vec2::new(6.0, 5.0)).to_rgba8(), [255, 0, 0, 255]);
        assert_eq!(p.sample(Vec2::new(16.0, 5.0)).to_rgba8(), [0, 0, 255, 255]);
        // Kırpılmış: resmin sağı mavi kalır; tekrarlı: kırmızı yeniden başlar
        assert_eq!(p.sample(Vec2::new(30.0, 5.0)).to_rgba8(), [0, 0, 255, 255]);
        let repeat = load_svg(doc("PatternID_5_1").as_bytes()).unwrap();
        let Paint::Image(r) = &repeat.shapes[0].fill.as_ref().unwrap().paint else {
            panic!()
        };
        assert!(!r.clip);
        assert_eq!(r.sample(Vec2::new(30.0, 5.0)).to_rgba8(), [255, 0, 0, 255]);
        let smooth = load_svg(doc("PatternID_5_1-kirp-yumusak").as_bytes()).unwrap();
        let Paint::Image(m) = &smooth.shapes[0].fill.as_ref().unwrap().paint else {
            panic!()
        };
        assert!(m.clip && m.smooth);
    }
}
