//! Geliştirme aracı: bir SVG dosyasını motorla çizip PNG'ye yazar.
//!
//! Kullanım: `cargo run -p engine --example svg-png -- <girdi.svg> <çıktı.png> [ölçek] [#arkaplan]`

use std::error::Error;

use engine::color::Color;
use engine::glam::{Affine2, UVec2, Vec2};
use engine::render::{DrawList, Renderer};
use engine::svg::load_svg;
use engine::tessellate::tessellate;
use engine::viewport::Viewport;

/// SVG okunurken çıkan uyarıları ekrana yazan basit günlük.
struct StderrLogger;

impl log::Log for StderrLogger {
    fn enabled(&self, m: &log::Metadata) -> bool {
        m.level() <= log::Level::Warn
    }

    fn log(&self, r: &log::Record) {
        if self.enabled(r.metadata()) {
            eprintln!("[{}] {}", r.level(), r.args());
        }
    }

    fn flush(&self) {}
}

static LOGGER: StderrLogger = StderrLogger;

fn main() -> Result<(), Box<dyn Error>> {
    if log::set_logger(&LOGGER).is_ok() {
        log::set_max_level(log::LevelFilter::Warn);
    }
    let args: Vec<String> = std::env::args().skip(1).collect();
    let [input, output, rest @ ..] = args.as_slice() else {
        return Err("kullanım: svg-png <girdi.svg> <çıktı.png> [ölçek] [#arkaplan]".into());
    };
    let scale: f32 = rest.first().map(|s| s.parse()).transpose()?.unwrap_or(1.0);
    let background = match rest.get(1) {
        Some(hex) => Color::from_hex(hex)?,
        None => Color::TRANSPARENT,
    };
    let image = load_svg(&std::fs::read(input)?)?;
    let mut renderer = Renderer::headless()?;
    let mesh = renderer.upload(&tessellate(&image, 0.05 / scale)?);
    let mut list = DrawList::new(background);
    list.draw(&mesh, Affine2::IDENTITY);
    // Resim yukarı yuvarlanır ve mantıksal alan resmi tam kaplar: kenarda şerit kalmaz,
    // saydam arka plan saydam kalır (ölçüm araçları yalnızca çizimin piksellerini sayar).
    let px = (image.size * scale).ceil().as_uvec2().max(UVec2::ONE);
    let viewport = Viewport {
        logical: px.as_vec2() / scale,
        physical: px,
        scale,
        offset: Vec2::ZERO,
    };
    let png = renderer.render_to_image(&viewport, &list)?;
    png.save_png(std::path::Path::new(output))?;
    println!("{output}: {}×{}", png.width, png.height);
    Ok(())
}
