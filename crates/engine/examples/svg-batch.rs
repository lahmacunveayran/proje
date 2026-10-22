//! Geliştirme aracı: çok sayıda SVG'yi tek seferde motorla çizip PNG'ye yazar (denetimler için).
//!
//! Kullanım: `cargo run -p engine --example svg-batch -- <liste.txt>`
//! Listenin her satırı: `<girdi.svg>\t<çıktı.png>\t<ölçek>`. Okunamayan dosya atlanır ve yazılır.

use std::error::Error;

use engine::color::Color;
use engine::glam::{Affine2, UVec2, Vec2};
use engine::render::{DrawList, Renderer};
use engine::svg::load_svg;
use engine::tessellate::tessellate;
use engine::viewport::Viewport;

fn main() -> Result<(), Box<dyn Error>> {
    let list = std::env::args()
        .nth(1)
        .ok_or("kullanım: svg-batch <liste.txt>")?;
    let text = std::fs::read_to_string(list)?;
    let mut renderer = Renderer::headless()?;
    let (mut done, mut failed) = (0usize, 0usize);
    for line in text.lines().filter(|l| !l.trim().is_empty()) {
        let mut parts = line.split('\t');
        let (Some(input), Some(output), Some(scale)) = (parts.next(), parts.next(), parts.next())
        else {
            return Err(format!("anlaşılamayan satır: {line:?}").into());
        };
        let scale: f32 = scale.parse()?;
        let result = (|| -> Result<(), Box<dyn Error>> {
            let image = load_svg(&std::fs::read(input)?)?;
            let mesh = renderer.upload(&tessellate(&image, 0.05 / scale)?);
            let mut draw = DrawList::new(Color::TRANSPARENT);
            draw.draw(&mesh, Affine2::IDENTITY);
            // svg-png ile aynı: yukarı yuvarlanmış boy, kenar şeridi yok
            let px = (image.size * scale).ceil().as_uvec2().max(UVec2::ONE);
            let viewport = Viewport {
                logical: px.as_vec2() / scale,
                physical: px,
                scale,
                offset: Vec2::ZERO,
            };
            renderer
                .render_to_image(&viewport, &draw)?
                .save_png(std::path::Path::new(output))?;
            Ok(())
        })();
        match result {
            Ok(()) => done += 1,
            Err(e) => {
                failed += 1;
                println!("{input}: {e}");
            }
        }
    }
    println!("{done} çizildi, {failed} hata");
    Ok(())
}
