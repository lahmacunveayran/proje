//! Yazının grafik kartında çizimi (ekransız).
#![allow(clippy::unwrap_used, clippy::expect_used, clippy::panic)]

mod common;

use common::{assert_snapshot, renderer};
use engine::color::Color;
use engine::glam::{Affine2, UVec2, Vec2};
use engine::render::DrawList;
use engine::tessellate::tessellate;
use engine::text::{Align, Font, TextStyle, to_upper_tr};
use engine::viewport::Viewport;

fn font(file: &str, weight: Option<f32>) -> Font {
    let path = format!("{}/../../content/fonts/{file}", env!("CARGO_MANIFEST_DIR"));
    Font::from_bytes(std::fs::read(path).unwrap(), weight).unwrap()
}

#[test]
fn turkish_text_snapshot() {
    let ink = Color::from_hex("#2E2116").unwrap();
    let title = font("AlegreyaSC-Bold.ttf", None);
    let body = font("Alegreya-Variable.ttf", Some(400.0));
    let small = font("AlegreyaSans-Regular.ttf", None);

    let mut r = renderer();
    let mut list = DrawList::new(Color::from_hex("#F1E3C2").unwrap());
    let mut y = 20.0;
    for (f, text, style) in [
        (
            &title,
            to_upper_tr("Çağrı ile İğdır kalesi"),
            TextStyle::new(44.0),
        ),
        (
            &body,
            "Pijamalı hasta yağız şoföre çabucak güvendi. Küçük bir sınır beyi olarak ordu topla, \
             kahramanını büyüt, şehirden şehre gez ve savaş."
                .to_string(),
            TextStyle::new(26.0).wrap(560.0),
        ),
        (
            &small,
            "ÇçĞğİıÖöŞşÜüÂâÎîÛû 0123456789 — 1.250 altın".to_string(),
            TextStyle::new(20.0).wrap(560.0).align(Align::Center),
        ),
    ] {
        let layout = f.layout(&text, &style).unwrap();
        let mesh = r.upload(&tessellate(&f.build_image(&layout, ink), 0.02).unwrap());
        list.draw(&mesh, Affine2::from_translation(Vec2::new(20.0, y)));
        y += layout.size.y + 16.0;
    }
    let img = r
        .render_to_image(
            &Viewport::fit(Vec2::new(600.0, 300.0), UVec2::new(600, 300)),
            &list,
        )
        .unwrap();
    assert_snapshot("turkce-yazi", &img);
}
