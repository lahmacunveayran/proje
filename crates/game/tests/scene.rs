//! Deneme sahnesinin ekransız görüntü testi.
#![allow(clippy::unwrap_used, clippy::expect_used, clippy::panic)]

use std::path::PathBuf;

use engine::glam::UVec2;
use engine::render::Renderer;
use engine::snapshot::{Tolerance, check};
use game::demo::{DemoScene, render_frame};

#[test]
fn demo_scene_snapshot() {
    let assets = game::content::assets(None);
    let mut renderer = Renderer::headless().unwrap();
    let mut scene = DemoScene::new(&mut renderer, &assets).unwrap();
    let image = render_frame(&mut scene, &mut renderer, UVec2::new(960, 540)).unwrap();
    let reference = PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("tests/reference");
    if let Err(e) = check("deneme-sahnesi", &reference, &image, Tolerance::RENDERER) {
        panic!("{e}");
    }
}
