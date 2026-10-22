//! SVG okuyucunun ve çizicinin, bağımsız bir SVG çiziciyle (resvg) karşılaştırılması.
#![allow(clippy::unwrap_used, clippy::expect_used, clippy::panic)]

mod common;

use common::{assert_snapshot, renderer};
use engine::color::Color;
use engine::glam::{Affine2, UVec2};
use engine::image::{RgbaImage, compare};
use engine::render::DrawList;
use engine::svg::load_svg;
use engine::tessellate::tessellate;
use engine::viewport::Viewport;

const FIXTURE: &[u8] = include_bytes!("fixtures/karsilastirma.svg");

/// resvg ile işlemcide çizer (önceden çarpılmış saydamlığı geri çevirerek).
fn render_with_resvg(data: &[u8], scale: f32) -> RgbaImage {
    let tree = resvg::usvg::Tree::from_data(data, &resvg::usvg::Options::default()).unwrap();
    let size = tree.size();
    let (w, h) = (
        (size.width() * scale) as u32,
        (size.height() * scale) as u32,
    );
    let mut pixmap = resvg::tiny_skia::Pixmap::new(w, h).unwrap();
    resvg::render(
        &tree,
        resvg::tiny_skia::Transform::from_scale(scale, scale),
        &mut pixmap.as_mut(),
    );
    let mut img = RgbaImage::new(w, h);
    for (i, p) in pixmap.pixels().iter().enumerate() {
        let c = p.demultiply();
        img.data[i * 4..i * 4 + 4].copy_from_slice(&[c.red(), c.green(), c.blue(), c.alpha()]);
    }
    img
}

fn render_with_engine(data: &[u8], scale: f32) -> RgbaImage {
    let image = load_svg(data).unwrap();
    let mut r = renderer();
    let mesh = r.upload(&tessellate(&image, 0.02).unwrap());
    let mut list = DrawList::new(Color::TRANSPARENT);
    list.draw(&mesh, Affine2::IDENTITY);
    let px = (image.size * scale).as_uvec2();
    r.render_to_image(&Viewport::fit(image.size, UVec2::new(px.x, px.y)), &list)
        .unwrap()
}

#[test]
fn engine_matches_reference_renderer() {
    for scale in [1.0, 3.0] {
        let ours = render_with_engine(FIXTURE, scale);
        let reference = render_with_resvg(FIXTURE, scale);
        let diff = compare(&reference, &ours, 24).unwrap();
        let name = format!("svg-karsilastirma-{scale}x");
        let out = engine::snapshot::output_dir();
        ours.save_png(&out.join(format!("{name}-motor.png")))
            .unwrap();
        reference
            .save_png(&out.join(format!("{name}-resvg.png")))
            .unwrap();
        diff.diff_image
            .save_png(&out.join(format!("{name}-fark.png")))
            .unwrap();
        // Kenar yumuşatma yöntemleri farklı (resvg analitik, motor MSAA); farklar kenarlarda kalmalı.
        assert!(
            diff.differing_fraction() < 0.02 && diff.mean_abs_diff < 1.5,
            "{name}: piksellerin %{:.2}'si farklı, ortalama fark {:.2}",
            diff.differing_fraction() * 100.0,
            diff.mean_abs_diff
        );
    }
}

#[test]
fn fixture_snapshot() {
    assert_snapshot("svg-deneme", &render_with_engine(FIXTURE, 2.0));
}
