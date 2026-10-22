//! Oyunun giriş noktası.
// Sürüm derlemesinde Windows'ta arkada konsol penceresi açılmasın.
#![cfg_attr(all(windows, not(debug_assertions)), windows_subsystem = "windows")]

use std::error::Error;
use std::process::ExitCode;

use engine::app::{AppConfig, run};
use engine::glam::UVec2;
use engine::render::Renderer;
use engine::viewport::LOGICAL_SIZE;
use game::args::{Args, HELP};
use game::demo::DemoScene;
use game::texts::Texts;

fn main() -> ExitCode {
    let log_path = game::logging::init();
    match start() {
        Ok(()) => ExitCode::SUCCESS,
        Err(e) => {
            log::error!("{e}");
            if let Some(p) = log_path {
                log::error!("ayrıntılar: {}", p.display());
            }
            ExitCode::FAILURE
        }
    }
}

fn start() -> Result<(), Box<dyn Error>> {
    let args = Args::parse(std::env::args().skip(1))?;
    if args.help {
        println!("{HELP}");
        return Ok(());
    }
    if args.version {
        println!("{}", env!("CARGO_PKG_VERSION"));
        return Ok(());
    }
    let assets = game::content::assets(
        args.content
            .clone()
            .or_else(game::content::content_next_to_exe),
    );
    log::info!("sürüm {}", env!("CARGO_PKG_VERSION"));

    if let Some(path) = &args.screenshot {
        let size = args.size.unwrap_or(UVec2::new(1920, 1080));
        let mut renderer = Renderer::headless()?;
        let mut scene = DemoScene::new(&mut renderer, &assets)?;
        let image = game::demo::render_frame(&mut scene, &mut renderer, size)?;
        image.save_png(path)?;
        log::info!("resim yazıldı: {}", path.display());
        return Ok(());
    }

    let texts = Texts::load(&assets, "tr")?;
    let config = AppConfig {
        title: texts.get("window_title").to_string(),
        logical_size: LOGICAL_SIZE,
        window_size: UVec2::new(1600, 900),
        ticks_per_second: sim::TICKS_PER_SECOND,
        fullscreen: args.fullscreen,
    };
    run(
        config,
        Box::new(move |renderer: &mut Renderer| DemoScene::new(renderer, &assets)),
    )?;
    Ok(())
}
