//! Feudalism ekranlarının motorun oynatıcısıyla ekransız görüntü testi: kök filmin karesi oynatılıp
//! çizilir ve beklenen resimle karşılaştırılır (ana menüler; resim dolgulu zeminli şehir ekranı).
//! Beklenen resimler FFDec'in kare çizimiyle karşılaştırılarak gözden geçirildi (yazılar Türkçe SWF'nin
//! çizimiyle; süzgeçler henüz çizilmiyor).
#![allow(clippy::unwrap_used, clippy::expect_used, clippy::panic)]

use std::path::PathBuf;

use engine::color::Color;
use engine::glam::{Affine2, UVec2, Vec2};
use engine::movie::{Clip, Library};
use engine::movie_draw::MovieMeshes;
use engine::movie_text::TextBank;
use engine::render::{ColorTransform, DrawList, Renderer};
use engine::snapshot::{Tolerance, check};
use engine::viewport::Viewport;

/// Karenin resmi ve çizilen yazı sayısı.
fn render_root_frame(game: &str, frame: usize, size: UVec2) -> (engine::image::RgbaImage, usize) {
    let assets = game::content::assets(None);
    let prefix = format!("feudalism/{game}/");
    let lib = Library::from_json(
        &assets.read(&format!("{prefix}library.json")).unwrap(),
        Some(&assets.read(&format!("{prefix}texts.json")).unwrap()),
    )
    .unwrap();
    let mut events = Vec::new();
    let mut root = Clip::root(&lib, &mut events);
    root.goto(&lib, frame - 1, false, &mut events);
    let viewport = Viewport::fit(Vec2::new(lib.stage.width, lib.stage.height), size);
    let mut renderer = Renderer::headless().unwrap();
    let texts = TextBank::load(&assets, &prefix, true).unwrap();
    let mut meshes = MovieMeshes::new(assets, &prefix).with_texts(texts);
    let commands = root.draw_commands(&lib, Affine2::IDENTITY, ColorTransform::IDENTITY);
    let mut list = DrawList::new(Color::from_hex(&lib.stage.background).unwrap());
    let stats = meshes.draw(&mut renderer, &lib, &commands, viewport.scale, &mut list);
    assert_eq!(
        stats.failed, 0,
        "{game} kare {frame}: çizilemeyen sembol var"
    );
    assert!(stats.drawn > 50, "{game} kare {frame}: çok az çizim");
    assert_eq!(stats.skipped_texts, 0);
    (
        renderer.render_to_image(&viewport, &list).unwrap(),
        stats.texts,
    )
}

#[test]
fn main_menus_snapshot() {
    let reference = PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("tests/reference");
    for game in ["f1", "f2"] {
        let (image, texts) = render_root_frame(game, 4, UVec2::new(400, 300));
        // Düğme yazıları ve sürüm numarası Türkçe çizilir
        assert!(texts >= 9, "{game}: {texts} yazı");
        // Sahnenin arka plan rengi (gökyüzünün üst köşesi)
        assert_eq!(image.pixel(2, 2), [0x35, 0x56, 0x7B, 255], "{game}");
        if let Err(e) = check(
            &format!("feudalism-{game}-ana-menu"),
            &reference,
            &image,
            Tolerance::RENDERER,
        ) {
            panic!("{e}");
        }
    }
}

#[test]
fn town_screen_with_bitmap_filled_ground_snapshot() {
    // F1 kök filmin 5. karesi: parke taşı zemin resim dolgusudur (kırpılmış, yumuşatmasız)
    let reference = PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("tests/reference");
    let (image, _) = render_root_frame("f1", 5, UVec2::new(400, 300));
    if let Err(e) = check(
        "feudalism-f1-sehir",
        &reference,
        &image,
        Tolerance::RENDERER,
    ) {
        panic!("{e}");
    }
}

#[test]
fn town_screen_with_objects_moved_back_to_identity_snapshot() {
    // D3-1: F1 kök filmin 13. karesinde binalar "taşı" işlemiyle başlangıç konumlarına (birim matris)
    // döner; bu bilgi kaybolursa yarısı yanlış yerde çizilir
    let reference = PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("tests/reference");
    let (image, _) = render_root_frame("f1", 13, UVec2::new(400, 300));
    if let Err(e) = check(
        "feudalism-f1-sehir-13",
        &reference,
        &image,
        Tolerance::RENDERER,
    ) {
        panic!("{e}");
    }
}
