//! Geliştirme aracı: bir sembol kütüphanesinin (library.json) kök filmini oynatıp bir karesini PNG'ye
//! çizer (oynatıcının denetimi için; FFDec'in kare çizimiyle karşılaştırılır).
//!
//! Kullanım: `cargo run --release -p engine --example movie-png -- <içerik klasörü> <alt klasör>
//! <kare (1'den)> <çıktı.png> [genişlik] [ilerleme karesi] [dil]`
//! Örnek: `... -- content feudalism/f1 4 menu.png 800 0`. "ilerleme karesi": o kareye gidildikten sonra
//! oynatıcının kaç kare daha ilerletileceği (sprite'ların animasyonu için). "dil": `tr` (Türkçe çeviri,
//! varsayılan) ya da `orijinal` (yazılar özgün hâliyle). Kare yerine `sprite:<kimlik>:<kare>` verilirse
//! kök film yerine o sprite çizilir (kendi başlangıç noktası sahnenin sol üst köşesinde).

use std::error::Error;
use std::path::PathBuf;

use engine::assets::Assets;
use engine::color::Color;
use engine::glam::{Affine2, UVec2, Vec2};
use engine::movie::{Clip, Library};
use engine::movie_draw::MovieMeshes;
use engine::movie_text::TextBank;
use engine::render::{ColorTransform, DrawList, Renderer};
use engine::viewport::Viewport;

fn main() -> Result<(), Box<dyn Error>> {
    let args: Vec<String> = std::env::args().skip(1).collect();
    let [content, prefix, frame, output, rest @ ..] = args.as_slice() else {
        return Err(
            "kullanım: movie-png <içerik> <alt klasör> <kare> <çıktı.png> [genişlik] [ilerleme] [dil]"
                .into(),
        );
    };
    let width: u32 = rest.first().map_or(Ok(800), |w| w.parse())?;
    let ticks: usize = rest.get(1).map_or(Ok(0), |t| t.parse())?;
    let turkish = match rest.get(2).map(String::as_str) {
        None | Some("tr") => true,
        Some("orijinal") => false,
        Some(other) => return Err(format!("bilinmeyen dil: {other}").into()),
    };
    let assets = Assets::from_dir(PathBuf::from(content));
    let prefix = format!("{}/", prefix.trim_end_matches('/'));
    let lib = Library::from_json(
        &assets.read(&format!("{prefix}library.json"))?,
        Some(&assets.read(&format!("{prefix}texts.json"))?),
    )?;
    let mut events = Vec::new();
    let (mut root, frame) = match frame.strip_prefix("sprite:") {
        Some(spec) => {
            let (id, frame) = spec.split_once(':').unwrap_or((spec, "1"));
            (
                Clip::sprite(&lib, id.parse()?, &mut events),
                frame.parse::<usize>()?,
            )
        }
        None => (Clip::root(&lib, &mut events), frame.parse()?),
    };
    root.goto(&lib, frame.saturating_sub(1), false, &mut events);
    for _ in 0..ticks {
        root.tick(&lib, &mut events);
    }
    let stage = Vec2::new(lib.stage.width, lib.stage.height);
    let height = (width as f32 * stage.y / stage.x).round() as u32;
    let viewport = Viewport::fit(stage, UVec2::new(width, height));
    let mut renderer = Renderer::headless()?;
    let texts = TextBank::load(&assets, &prefix, turkish)?;
    let mut meshes = MovieMeshes::new(assets, &prefix).with_texts(texts);
    let commands = root.draw_commands(&lib, Affine2::IDENTITY, ColorTransform::IDENTITY);
    let mut list = DrawList::new(Color::from_hex(&lib.stage.background)?);
    let stats = meshes.draw(&mut renderer, &lib, &commands, viewport.scale, &mut list);
    renderer
        .render_to_image(&viewport, &list)?
        .save_png(std::path::Path::new(output))?;
    println!(
        "kare {frame}: {} çizim (resim dolgulu {}, yazı {}); hata {}",
        stats.drawn, stats.bitmap_shapes, stats.texts, stats.failed
    );
    Ok(())
}
