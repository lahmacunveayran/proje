//! Testlerde ortak yardımcılar.
#![allow(dead_code, clippy::unwrap_used, clippy::expect_used, clippy::panic)]

use std::path::PathBuf;
use std::sync::{Mutex, MutexGuard, OnceLock};

use engine::image::RgbaImage;
use engine::render::Renderer;
use engine::snapshot::{self, Tolerance};

/// Bütün testlerin paylaştığı tek grafik cihazı (her test için yeniden açmak yavaş).
pub fn renderer() -> MutexGuard<'static, Renderer> {
    static R: OnceLock<Mutex<Renderer>> = OnceLock::new();
    R.get_or_init(|| {
        let r = Renderer::headless().expect("grafik kartı açılamadı");
        eprintln!("grafik kartı: {:?}", r.adapter_info());
        Mutex::new(r)
    })
    .lock()
    .unwrap_or_else(|e| e.into_inner())
}

pub fn reference_dir() -> PathBuf {
    PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("tests/reference")
}

pub fn assert_snapshot(name: &str, image: &RgbaImage) {
    if let Err(e) = snapshot::check(name, &reference_dir(), image, Tolerance::RENDERER) {
        panic!("{e}");
    }
}

/// İki rengin her kanalda en fazla `tol` farklı olduğunu denetler.
pub fn assert_close(actual: [u8; 4], expected: [u8; 4], tol: u8, what: &str) {
    let ok = (0..4).all(|i| actual[i].abs_diff(expected[i]) <= tol);
    assert!(ok, "{what}: beklenen {expected:?}, gelen {actual:?}");
}
