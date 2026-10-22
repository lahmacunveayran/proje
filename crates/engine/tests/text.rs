//! Yazının grafik kartında çizimi (ekransız).
#![allow(clippy::unwrap_used, clippy::expect_used, clippy::panic)]

mod common;

use common::renderer;
use engine::color::Color;
use engine::glam::{Affine2, UVec2, Vec2};
use engine::render::DrawList;
use engine::tessellate::tessellate;
use engine::text::{Font, TextStyle, to_upper_tr};
use engine::viewport::Viewport;

fn font(file: &str) -> Font {
    let path = format!("{}/../../content/fonts/{file}", env!("CARGO_MANIFEST_DIR"));
    Font::from_bytes(std::fs::read(path).unwrap(), None).unwrap()
}

#[test]
fn turkish_text_is_drawn_inside_its_layout() {
    let f = font("LiberationSans-Bold.ttf");
    let layout = f
        .layout(&to_upper_tr("Çağrı ile İğdır"), &TextStyle::new(40.0))
        .unwrap();
    let mut r = renderer();
    let mesh = r.upload(&tessellate(&f.build_image(&layout, Color::BLACK), 0.02).unwrap());
    let mut list = DrawList::new(Color::WHITE);
    list.draw(&mesh, Affine2::from_translation(Vec2::splat(10.0)));
    let img = r
        .render_to_image(
            &Viewport::fit(Vec2::new(400.0, 80.0), UVec2::new(400, 80)),
            &list,
        )
        .unwrap();
    // Mürekkep yalnız yazının alanında; alanın içinde de yeterince var
    let (mut ink, mut outside) = (0, 0);
    for y in 0..80 {
        for x in 0..400 {
            if img.pixel(x, y)[0] < 128 {
                let inside = (x as f32) >= 9.0
                    && (x as f32) <= 11.0 + layout.size.x
                    && (y as f32) >= 9.0
                    && (y as f32) <= 11.0 + layout.size.y;
                if inside {
                    ink += 1;
                } else {
                    outside += 1;
                }
            }
        }
    }
    assert!(ink > 1500, "{ink}");
    assert_eq!(outside, 0);
}
