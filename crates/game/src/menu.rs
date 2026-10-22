//! Açılış ekranı: Feudalism 2'nin ana menüsü, Türkçe yazılarıyla ve hareketleriyle.
//!
//! Kök filmin menü karesi (4. kare) oynatıcıyla kurulur; sprite'lar kendi zaman çizelgelerini
//! sahnenin kare hızıyla oynatır. Düğmeler henüz bir şey yapmaz.

use std::error::Error;

use engine::app::{Control, FrameInfo, Game};
use engine::assets::Assets;
use engine::color::Color;
use engine::glam::{Affine2, Vec2};
use engine::input::{Input, Key};
use engine::movie::{Clip, Library};
use engine::movie_draw::{DrawStats, MovieMeshes};
use engine::movie_text::TextBank;
use engine::render::{ColorTransform, DrawList, Renderer};

/// İçerikteki oyun klasörü.
const GAME: &str = "feudalism/f2/";
/// Kök filmin menü karesi (0'dan).
const MENU_FRAME: usize = 3;

pub struct MenuScreen {
    lib: Library,
    root: Clip,
    meshes: MovieMeshes,
    background: Color,
    /// Benzetim adımı başına sahne karesi (sahne kare hızı / adım hızı).
    frames_per_tick: f64,
    pending: f64,
    /// İlerletilen sahne karesi sayısı.
    frames: u64,
    last_stats: DrawStats,
}

impl MenuScreen {
    pub fn new(assets: &Assets) -> Result<Self, Box<dyn Error>> {
        let lib = Library::from_json(
            &assets.read(&format!("{GAME}library.json"))?,
            Some(&assets.read(&format!("{GAME}texts.json"))?),
        )?;
        let texts = TextBank::load(assets, GAME, true)?;
        let mut events = Vec::new();
        let mut root = Clip::root(&lib, &mut events);
        root.goto(&lib, MENU_FRAME, false, &mut events);
        Ok(MenuScreen {
            background: Color::from_hex(&lib.stage.background)?,
            frames_per_tick: f64::from(lib.stage.fps) / f64::from(sim::TICKS_PER_SECOND),
            pending: 0.0,
            frames: 0,
            meshes: MovieMeshes::new(assets.clone(), GAME).with_texts(texts),
            last_stats: DrawStats::default(),
            root,
            lib,
        })
    }

    /// Sahnenin boyu (mantıksal alan).
    pub fn stage_size(&self) -> Vec2 {
        Vec2::new(self.lib.stage.width, self.lib.stage.height)
    }

    /// Son çizimde neyin çizildiği.
    pub fn last_stats(&self) -> DrawStats {
        self.last_stats
    }

    /// Sahneyi bir kare ilerletir (sprite'ların animasyonları).
    pub fn advance_frame(&mut self) {
        self.root.tick(&self.lib, &mut Vec::new());
        self.frames += 1;
    }

    /// Açılıştan beri ilerletilen sahne karesi sayısı.
    pub fn frames(&self) -> u64 {
        self.frames
    }
}

impl Game for MenuScreen {
    fn update(&mut self, input: &Input, control: &mut Control) {
        if input.key_pressed(Key::Escape) {
            control.quit();
        }
        self.pending += self.frames_per_tick;
        while self.pending >= 1.0 {
            self.pending -= 1.0;
            self.advance_frame();
        }
    }

    fn draw(&mut self, renderer: &mut Renderer, frame: &FrameInfo) -> DrawList {
        let mut list = DrawList::new(self.background);
        let commands =
            self.root
                .draw_commands(&self.lib, Affine2::IDENTITY, ColorTransform::IDENTITY);
        self.last_stats = self.meshes.draw(
            renderer,
            &self.lib,
            &commands,
            frame.viewport.scale,
            &mut list,
        );
        list
    }
}

/// Ekranın bir karesini ekransız çizer (komut satırı ve testler için).
pub fn render_frame(
    screen: &mut MenuScreen,
    renderer: &mut Renderer,
    size: engine::glam::UVec2,
) -> Result<engine::image::RgbaImage, Box<dyn Error>> {
    let viewport = engine::viewport::Viewport::fit(screen.stage_size(), size);
    let frame = FrameInfo {
        alpha: 0.0,
        viewport,
        fps: 60.0,
    };
    let list = screen.draw(renderer, &frame);
    Ok(renderer.render_to_image(&viewport, &list)?)
}

#[cfg(test)]
mod tests {
    #![allow(clippy::unwrap_used, clippy::expect_used)]

    use super::*;
    use engine::glam::UVec2;

    #[test]
    fn menu_draws_with_turkish_texts_and_animates() {
        let assets = crate::content::assets(None);
        let mut screen = MenuScreen::new(&assets).unwrap();
        assert_eq!(screen.stage_size(), Vec2::new(800.0, 600.0));
        let mut renderer = Renderer::headless().unwrap();
        let first = render_frame(&mut screen, &mut renderer, UVec2::new(400, 300)).unwrap();
        let stats = screen.last_stats();
        assert_eq!(stats.failed, 0);
        assert_eq!(stats.skipped_texts, 0);
        assert!(stats.texts >= 9, "{stats:?}");
        // Sahnenin arka plan rengi (gökyüzünün üst köşesi)
        assert_eq!(first.pixel(2, 2), [0x35, 0x56, 0x7B, 255]);
        // Saniyede 60 adım, sahne 30 kare: 60 adım sahneyi 30 kare ilerletir; menü karesinde kalır
        let mut control = Control::default();
        for _ in 0..60 {
            screen.update(&Input::default(), &mut control);
        }
        assert_eq!(screen.frames(), 30);
        let later = render_frame(&mut screen, &mut renderer, UVec2::new(400, 300)).unwrap();
        assert_eq!(screen.last_stats().failed, 0);
        assert_eq!(later.pixel(2, 2), first.pixel(2, 2));
    }
}
