//! Aşama 0 deneme sahnesi: örnek çizimleri paralaks katmanlı bir manzarada gösterir.
//!
//! Sahnenin dizilimi `content/scenes/demo.ron`, yazıları `content/text/tr.ron` dosyasındadır.

use std::collections::HashMap;
use std::error::Error;

use engine::app::{Control, FrameInfo, Game};
use engine::assets::Assets;
use engine::color::Color;
use engine::glam::{Affine2, Vec2};
use engine::input::{Input, Key};
use engine::render::{ColorTransform, DrawList, GpuMesh, Renderer};
use engine::svg::load_svg;
use engine::tessellate::tessellate;
use engine::text::{Align, Font, TextStyle};
use serde::Deserialize;

use crate::texts::Texts;

/// Sahnenin kodda kullandığı metin anahtarları (testler hepsinin dosyada olduğunu denetler).
pub const TEXT_KEYS: &[&str] = &["demo_title", "demo_subtitle", "demo_help", "demo_fps"];

/// Üçgenleme payı (çizim birimi): ekranda büyütülse de eğriler pürüzsüz kalsın.
const TOLERANCE: f32 = 0.04;
/// Kameranın en fazla ne kadar kayabileceği (mantıksal piksel).
const CAMERA_RANGE: f32 = 230.0;

#[derive(Clone, Debug, Deserialize)]
pub struct LayerDef {
    pub art: String,
    pub parallax: f32,
}

#[derive(Clone, Debug, Deserialize)]
pub struct ActorDef {
    pub art: String,
    /// Çizimdeki ayak noktası (çizim birimiyle).
    pub anchor: (f32, f32),
    /// Ayak noktasının ekrandaki yeri.
    pub position: (f32, f32),
    pub scale: f32,
}

#[derive(Clone, Debug, Deserialize)]
pub struct WindowDef {
    pub art: String,
    pub position: (f32, f32),
    pub scale: f32,
}

#[derive(Clone, Copy, Debug, Deserialize, PartialEq, Eq, Hash)]
pub enum FontKind {
    Title,
    Heading,
    Body,
    Small,
}

#[derive(Clone, Copy, Debug, Deserialize)]
pub enum AlignDef {
    Left,
    Center,
    Right,
}

#[derive(Clone, Debug, Deserialize)]
pub struct TextDef {
    pub key: String,
    pub font: FontKind,
    pub size: f32,
    pub color: String,
    /// Pencerenin sol üst köşesine göre (pencere birimiyle).
    pub position: (f32, f32),
    pub width: f32,
    pub align: AlignDef,
}

#[derive(Clone, Debug, Deserialize)]
pub struct SceneDef {
    pub layers: Vec<LayerDef>,
    pub layer_origin: (f32, f32),
    pub actors: Vec<ActorDef>,
    pub shadow: String,
    pub foreground: LayerDef,
    pub window: WindowDef,
    pub window_texts: Vec<TextDef>,
}

impl SceneDef {
    pub fn load(assets: &Assets, path: &str) -> Result<Self, Box<dyn Error>> {
        Ok(ron::from_str(&assets.read_string(path)?)?)
    }
}

struct Fonts {
    map: HashMap<FontKind, Font>,
}

impl Fonts {
    fn load(assets: &Assets) -> Result<Self, Box<dyn Error>> {
        let mut map = HashMap::new();
        for (kind, file, weight) in [
            (FontKind::Title, "fonts/AlegreyaSC-Bold.ttf", None),
            (FontKind::Heading, "fonts/AlegreyaSC-Regular.ttf", None),
            (FontKind::Body, "fonts/Alegreya-Variable.ttf", Some(420.0)),
            (FontKind::Small, "fonts/AlegreyaSans-Regular.ttf", None),
        ] {
            map.insert(
                kind,
                Font::from_bytes(assets.read(file)?.into_owned(), weight)?,
            );
        }
        Ok(Fonts { map })
    }

    fn get(&self, kind: FontKind) -> Result<&Font, Box<dyn Error>> {
        self.map
            .get(&kind)
            .ok_or_else(|| format!("yazı tipi yüklenmedi: {kind:?}").into())
    }
}

struct Art {
    mesh: GpuMesh,
}

struct Layer {
    art: Art,
    parallax: f32,
}

struct Actor {
    art: Art,
    def: ActorDef,
    /// Nefes alma hareketinin evresi (her karakter ayrı).
    phase: f32,
}

struct Label {
    mesh: GpuMesh,
    at: Vec2,
    shadow: bool,
}

pub struct DemoScene {
    texts: Texts,
    fonts: Fonts,
    layers: Vec<Layer>,
    foreground: Layer,
    actors: Vec<Actor>,
    shadow: Art,
    window: Art,
    window_at: Vec2,
    window_scale: f32,
    window_labels: Vec<Label>,
    labels: Vec<Label>,
    layer_origin: Vec2,
    fps: Option<(i32, GpuMesh)>,
    /// Benzetim adımı sayacı (sahne saati).
    tick: u64,
    camera: f32,
    previous_camera: f32,
    velocity: f32,
    /// Son elle kaydırmadan bu yana geçen adım sayısı.
    idle_ticks: u64,
}

fn load_art(
    renderer: &mut Renderer,
    assets: &Assets,
    cache: &mut HashMap<String, GpuMesh>,
    path: &str,
) -> Result<Art, Box<dyn Error>> {
    if let Some(mesh) = cache.get(path) {
        return Ok(Art { mesh: mesh.clone() });
    }
    let image = load_svg(&assets.read(path)?).map_err(|e| format!("{path}: {e}"))?;
    let mesh = renderer.upload(&tessellate(&image, TOLERANCE)?);
    cache.insert(path.to_string(), mesh.clone());
    Ok(Art { mesh })
}

fn text_mesh(
    renderer: &mut Renderer,
    font: &Font,
    text: &str,
    style: TextStyle,
    color: Color,
) -> Result<GpuMesh, Box<dyn Error>> {
    let image = font.text_image(text, &style, color)?;
    Ok(renderer.upload(&tessellate(&image, TOLERANCE)?))
}

fn align(a: AlignDef) -> Align {
    match a {
        AlignDef::Left => Align::Left,
        AlignDef::Center => Align::Center,
        AlignDef::Right => Align::Right,
    }
}

impl DemoScene {
    pub fn new(renderer: &mut Renderer, assets: &Assets) -> Result<Self, Box<dyn Error>> {
        let texts = Texts::load(assets, "tr")?;
        let def = SceneDef::load(assets, "scenes/demo.ron")?;
        let fonts = Fonts::load(assets)?;
        let mut cache = HashMap::new();

        let mut layers = Vec::new();
        for l in &def.layers {
            layers.push(Layer {
                art: load_art(renderer, assets, &mut cache, &l.art)?,
                parallax: l.parallax,
            });
        }
        let foreground = Layer {
            art: load_art(renderer, assets, &mut cache, &def.foreground.art)?,
            parallax: def.foreground.parallax,
        };
        let mut actors = Vec::new();
        for (i, a) in def.actors.iter().enumerate() {
            actors.push(Actor {
                art: load_art(renderer, assets, &mut cache, &a.art)?,
                def: a.clone(),
                phase: i as f32 * 2.1,
            });
        }
        // Arkadakiler (ekranda daha yukarıda duranlar) önce çizilir.
        actors.sort_by(|a, b| a.def.position.1.total_cmp(&b.def.position.1));
        let shadow = load_art(renderer, assets, &mut cache, &def.shadow)?;
        let window = load_art(renderer, assets, &mut cache, &def.window.art)?;

        let mut window_labels = Vec::new();
        for t in &def.window_texts {
            let style = TextStyle::new(t.size).wrap(t.width).align(align(t.align));
            let color = Color::from_hex(&t.color)?;
            window_labels.push(Label {
                mesh: text_mesh(
                    renderer,
                    fonts.get(t.font)?,
                    texts.get(&t.key),
                    style,
                    color,
                )?,
                at: Vec2::new(t.position.0, t.position.1),
                shadow: false,
            });
        }

        // Paletten: badana ve parşömen-açık (bkz. tools/art/palet.txt).
        let cream = Color::from_hex("#FFFFCC")?;
        let parchment = Color::from_hex("#EBE1D8")?;
        let labels = vec![
            Label {
                mesh: text_mesh(
                    renderer,
                    fonts.get(FontKind::Title)?,
                    texts.get("demo_title"),
                    TextStyle::new(64.0),
                    cream,
                )?,
                at: Vec2::new(64.0, 36.0),
                shadow: true,
            },
            Label {
                mesh: text_mesh(
                    renderer,
                    fonts.get(FontKind::Body)?,
                    texts.get("demo_subtitle"),
                    TextStyle::new(32.0),
                    parchment,
                )?,
                at: Vec2::new(68.0, 124.0),
                shadow: true,
            },
            Label {
                mesh: text_mesh(
                    renderer,
                    fonts.get(FontKind::Small)?,
                    texts.get("demo_help"),
                    TextStyle::new(24.0).wrap(1792.0).align(Align::Center),
                    parchment,
                )?,
                at: Vec2::new(64.0, 1032.0),
                shadow: true,
            },
        ];

        Ok(DemoScene {
            texts,
            fonts,
            layers,
            foreground,
            actors,
            shadow,
            window,
            window_at: Vec2::new(def.window.position.0, def.window.position.1),
            window_scale: def.window.scale,
            window_labels,
            labels,
            layer_origin: Vec2::new(def.layer_origin.0, def.layer_origin.1),
            fps: None,
            tick: 0,
            camera: 0.0,
            previous_camera: 0.0,
            velocity: 0.0,
            idle_ticks: u64::MAX / 2,
        })
    }

    fn fps_mesh(&mut self, renderer: &mut Renderer, fps: f32) -> Option<GpuMesh> {
        let value = fps.round() as i32;
        if let Some((v, mesh)) = &self.fps
            && *v == value
        {
            return Some(mesh.clone());
        }
        let text = self
            .texts
            .format("demo_fps", &[("fps", &value.to_string())]);
        let style = TextStyle::new(22.0).wrap(200.0).align(Align::Right);
        let mesh = text_mesh(
            renderer,
            self.fonts.get(FontKind::Small).ok()?,
            &text,
            style,
            Color::rgba(1.0, 0.96, 0.82, 0.85),
        )
        .ok()?;
        self.fps = Some((value, mesh.clone()));
        Some(mesh)
    }

    /// Kendiliğinden kayan kameranın hedefi (elle kaydırılmadığında).
    fn auto_camera(tick: u64) -> f32 {
        let t = tick as f32 / sim::TICKS_PER_SECOND as f32;
        CAMERA_RANGE * 0.85 * (t * 0.12).sin()
    }
}

impl Game for DemoScene {
    fn update(&mut self, input: &Input, control: &mut Control) {
        if input.key_pressed(Key::Escape) {
            control.quit();
        }
        self.tick += 1;
        let mut dir = 0.0;
        if input.key_down(Key::ArrowLeft) || input.key_down(Key::KeyA) {
            dir -= 1.0;
        }
        if input.key_down(Key::ArrowRight) || input.key_down(Key::KeyD) {
            dir += 1.0;
        }
        self.previous_camera = self.camera;
        if dir != 0.0 {
            self.idle_ticks = 0;
        } else {
            self.idle_ticks = self.idle_ticks.saturating_add(1);
        }
        if self.idle_ticks > 3 * u64::from(sim::TICKS_PER_SECOND) {
            // Elle kaydırılmıyorsa kamera yavaşça kendi yoluna döner.
            let target = Self::auto_camera(self.tick);
            self.velocity = 0.0;
            self.camera += (target - self.camera) * 0.02;
        } else {
            self.velocity += (dir * 7.0 - self.velocity) * 0.12;
            self.camera += self.velocity;
        }
        self.camera = self.camera.clamp(-CAMERA_RANGE, CAMERA_RANGE);
    }

    fn draw(&mut self, renderer: &mut Renderer, frame: &FrameInfo) -> DrawList {
        let camera = self.previous_camera + (self.camera - self.previous_camera) * frame.alpha;
        let time = (self.tick as f32 + frame.alpha) / sim::TICKS_PER_SECOND as f32;
        // Paletten: gök-tepe.
        let mut list = DrawList::new(Color::from_hex("#00359B").unwrap_or(Color::BLACK));
        let layer_at = |parallax: f32| {
            Affine2::from_translation(self.layer_origin - Vec2::new(camera * parallax, 0.0))
        };
        for layer in &self.layers {
            list.draw(&layer.art.mesh, layer_at(layer.parallax));
        }
        for actor in &self.actors {
            let d = &actor.def;
            let feet = Vec2::new(d.position.0 - camera, d.position.1);
            list.draw(
                &self.shadow.mesh,
                Affine2::from_translation(feet)
                    * Affine2::from_scale(Vec2::new(0.75, 0.9) * d.scale)
                    * Affine2::from_translation(Vec2::new(-100.0, -20.0)),
            );
            // Hafif nefes alma: ayak noktasından dikey ölçek.
            let breath = 1.0 + 0.007 * (time * 1.9 + actor.phase).sin();
            list.draw(
                &actor.art.mesh,
                Affine2::from_translation(feet)
                    * Affine2::from_scale(Vec2::new(d.scale, d.scale * breath))
                    * Affine2::from_translation(-Vec2::new(d.anchor.0, d.anchor.1)),
            );
        }
        list.draw(
            &self.foreground.art.mesh,
            layer_at(self.foreground.parallax),
        );

        let window = Affine2::from_translation(self.window_at)
            * Affine2::from_scale(Vec2::splat(self.window_scale));
        list.draw(&self.window.mesh, window);
        for label in &self.window_labels {
            list.draw(&label.mesh, window * Affine2::from_translation(label.at));
        }
        let shadow = ColorTransform::multiply(Color::rgba(0.0, 0.0, 0.0, 0.45));
        for label in &self.labels {
            if label.shadow {
                list.draw_with(
                    &label.mesh,
                    Affine2::from_translation(label.at + Vec2::new(2.0, 3.0)),
                    shadow,
                );
            }
            list.draw(&label.mesh, Affine2::from_translation(label.at));
        }
        if let Some(mesh) = self.fps_mesh(renderer, frame.fps) {
            list.draw(&mesh, Affine2::from_translation(Vec2::new(1690.0, 24.0)));
        }
        list
    }
}

/// Sahnenin bir karesini ekransız çizer (komut satırı ve testler için).
pub fn render_frame(
    scene: &mut DemoScene,
    renderer: &mut Renderer,
    size: engine::glam::UVec2,
) -> Result<engine::image::RgbaImage, Box<dyn Error>> {
    let viewport = engine::viewport::Viewport::fit(engine::viewport::LOGICAL_SIZE, size);
    let frame = FrameInfo {
        alpha: 0.0,
        viewport,
        fps: 60.0,
    };
    let list = scene.draw(renderer, &frame);
    Ok(renderer.render_to_image(&viewport, &list)?)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn scene_file_parses_and_references_existing_art() {
        let assets = crate::content::assets(None);
        let def = SceneDef::load(&assets, "scenes/demo.ron").unwrap();
        let mut arts: Vec<&str> = def.layers.iter().map(|l| l.art.as_str()).collect();
        arts.extend(def.actors.iter().map(|a| a.art.as_str()));
        arts.extend([
            def.shadow.as_str(),
            def.foreground.art.as_str(),
            def.window.art.as_str(),
        ]);
        for art in arts {
            let data = assets.read(art).unwrap();
            load_svg(&data).unwrap_or_else(|e| panic!("{art}: {e}"));
        }
        let texts = Texts::load(&assets, "tr").unwrap();
        for t in &def.window_texts {
            assert!(texts.contains(&t.key), "tr.ron içinde '{}' yok", t.key);
        }
    }

    #[test]
    fn auto_camera_stays_in_range() {
        for tick in (0..100_000).step_by(37) {
            assert!(DemoScene::auto_camera(tick).abs() <= CAMERA_RANGE);
        }
    }
}
