//! Geliştirme aracı: verilen SVG dosyalarının motorca okunup üçgenlenebildiğini denetler.
//!
//! Kullanım: `cargo run -p engine --example svg-check -- <dosya.svg>...`

use std::error::Error;

use engine::svg::load_svg;
use engine::tessellate::tessellate;

fn main() -> Result<(), Box<dyn Error>> {
    let mut failed = 0usize;
    let mut total = 0usize;
    for path in std::env::args().skip(1) {
        total += 1;
        let result = std::fs::read(&path)
            .map_err(|e| e.to_string())
            .and_then(|bytes| load_svg(&bytes).map_err(|e| e.to_string()))
            .and_then(|image| {
                tessellate(&image, 0.1)
                    .map(|_| ())
                    .map_err(|e| e.to_string())
            });
        if let Err(e) = result {
            failed += 1;
            println!("{path}: {e}");
        }
    }
    println!("{total} dosya, {failed} hata");
    Ok(())
}
