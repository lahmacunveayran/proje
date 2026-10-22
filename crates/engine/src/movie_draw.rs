//! Oynatıcının ([`crate::movie`]) çizim komutlarını çizim listesine çevirmek.
//!
//! Sembollerin SVG dosyaları içerikten okunur, bir kez üçgenlenip grafik kartına yüklenir ve
//! önbellekte tutulur. Morph'ların ara hâlleri orana göre kurulur (oran başına bir kez). Flash'ın ince
//! çizgi kuralı uygulanır: 1 pikselden ince çizgi ekranda 1 piksel çizilir (ölçeğe göre ayrı ağ).
//!
//! Resim dolgulu şekiller resim boyasıyla çizilir. Sabit yazılar ve yazı alanları, yazı bankası
//! verildiyse ([`MovieMeshes::with_texts`]) açık lisanslı yazı tipleriyle dizilip çizilir
//! ([`crate::movie_text`]); verilmediyse çizilmeyip sayılır ([`DrawStats`]).

use std::collections::HashMap;

use glam::Affine2;

use crate::assets::Assets;
use crate::morph::lerp_image;
use crate::movie::{CharId, DrawCommand, DrawItem, DrawKind, Library};
use crate::movie_text::{Fonts, TextBank};
use crate::render::{DrawList, GpuMesh, Renderer};
use crate::shape::{VectorImage, transform_scale};
use crate::svg::load_svg;
use crate::tessellate::tessellate;

/// Üçgenleme payı (sembolün kendi biriminde, sahne pikseli).
const TOLERANCE: f32 = 0.05;
/// Morph oranının önbellek adımı (1/4096).
const RATIO_STEPS: f32 = 4096.0;
/// İnce çizgi ağlarının ölçek adımı (2'nin 1/4 kuvvetleri).
const SCALE_STEPS: f32 = 4.0;

/// Bir çizimde neyin çizildiği, neyin çizilmediği.
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct DrawStats {
    pub drawn: usize,
    /// Çizilen resim dolgulu şekiller.
    pub bitmap_shapes: usize,
    /// Çizilen sabit yazılar ve yazı alanları.
    pub texts: usize,
    /// Yazı bankası verilmediği için çizilmeyen yazılar.
    pub skipped_texts: usize,
    /// Dosyası okunamayan, dizilemeyen ya da üçgenlenemeyen semboller.
    pub failed: usize,
}

#[derive(Default)]
pub struct MovieMeshes {
    assets: Assets,
    /// İçerikteki klasör (ör. "feudalism/f1/").
    prefix: String,
    images: HashMap<String, Option<VectorImage>>,
    meshes: HashMap<(CharId, i32), Option<GpuMesh>>,
    morphs: HashMap<(CharId, u32), Option<GpuMesh>>,
    texts: Option<TextBank>,
    fonts: Fonts,
    text_meshes: HashMap<CharId, Option<GpuMesh>>,
}

impl MovieMeshes {
    pub fn new(assets: Assets, prefix: &str) -> Self {
        MovieMeshes {
            fonts: Fonts::new(assets.clone()),
            assets,
            prefix: prefix.to_string(),
            ..Default::default()
        }
    }

    /// Yazılar bu bankadan (özgün ya da çevrilmiş) dizilip çizilir.
    pub fn with_texts(mut self, bank: TextBank) -> Self {
        self.texts = Some(bank);
        self.text_meshes.clear();
        self
    }

    /// Yazının ağı (başlangıç yazısıyla). Bankası yoksa `None`.
    fn text(&mut self, renderer: &mut Renderer, kind: &DrawKind) -> Option<Option<GpuMesh>> {
        let bank = self.texts.as_ref()?;
        let (id, image) = match *kind {
            DrawKind::Text(id) => {
                if let Some(m) = self.text_meshes.get(&id) {
                    return Some(m.clone());
                }
                (id, bank.static_image(id, &mut self.fonts))
            }
            DrawKind::EditText(id) => {
                if let Some(m) = self.text_meshes.get(&id) {
                    return Some(m.clone());
                }
                (id, bank.edit_image(id, None, &mut self.fonts))
            }
            _ => return None,
        };
        let mesh = match image {
            Ok(image) => upload(renderer, &image, id),
            Err(e) => {
                log::warn!("yazı {id}: {e}");
                None
            }
        };
        self.text_meshes.insert(id, mesh.clone());
        Some(mesh)
    }

    fn image(&mut self, file: String) -> Option<VectorImage> {
        if let Some(i) = self.images.get(&file) {
            return i.clone();
        }
        let loaded = self
            .assets
            .read(&file)
            .ok()
            .and_then(|data| match load_svg(&data) {
                Ok(i) => Some(i),
                Err(e) => {
                    log::warn!("{file}: {e}");
                    None
                }
            });
        self.images.insert(file, loaded.clone());
        loaded
    }

    /// Şeklin ağı. İnce çizgisi olan şekil, ekrandaki ölçeğine göre ayrı ağdır.
    fn shape(
        &mut self,
        renderer: &mut Renderer,
        lib: &Library,
        id: CharId,
        screen_scale: f32,
    ) -> Option<GpuMesh> {
        let hairlines = lib.hairlines.get(&id);
        let bucket = match hairlines {
            Some(_) if screen_scale > 0.0 => (screen_scale.log2() * SCALE_STEPS).floor() as i32,
            _ => i32::MIN,
        };
        if let Some(m) = self.meshes.get(&(id, bucket)) {
            return m.clone();
        }
        let file = format!("{}shapes/{id}.svg", self.prefix);
        let mesh = self.image(file).and_then(|mut image| {
            if let Some(list) = hairlines {
                // Ölçek adımının alt sınırıyla: çizgi en az 1 ekran pikseli olur
                let min_width = 1.0 / 2f32.powf(bucket as f32 / SCALE_STEPS);
                for &(index, original) in list {
                    if let Some(stroke) =
                        image.shapes.get_mut(index).and_then(|s| s.stroke.as_mut())
                    {
                        stroke.width = original.max(min_width);
                    }
                }
            }
            upload(renderer, &image, id)
        });
        self.meshes.insert((id, bucket), mesh.clone());
        mesh
    }

    fn bitmap_shape(&mut self, renderer: &mut Renderer, id: CharId) -> Option<GpuMesh> {
        if let Some(m) = self.meshes.get(&(id, i32::MAX)) {
            return m.clone();
        }
        let mesh = self
            .image(format!("{}shapes-bitmap/{id}.svg", self.prefix))
            .and_then(|image| upload(renderer, &image, id));
        self.meshes.insert((id, i32::MAX), mesh.clone());
        mesh
    }

    fn morph(&mut self, renderer: &mut Renderer, id: CharId, ratio: f32) -> Option<GpuMesh> {
        let step = (ratio.clamp(0.0, 1.0) * RATIO_STEPS).round() as u32;
        if let Some(m) = self.morphs.get(&(id, step)) {
            return m.clone();
        }
        let start = self.image(format!("{}morphs/{id}.start.svg", self.prefix));
        let end = self.image(format!("{}morphs/{id}.end.svg", self.prefix));
        let mesh = match (start, end) {
            (Some(a), Some(b)) => match lerp_image(&a, &b, step as f32 / RATIO_STEPS) {
                Ok(image) => upload(renderer, &image, id),
                Err(e) => {
                    log::warn!("morph {id}: {e}");
                    None
                }
            },
            _ => None,
        };
        self.morphs.insert((id, step), mesh.clone());
        mesh
    }

    fn item_mesh(
        &mut self,
        renderer: &mut Renderer,
        lib: &Library,
        item: &DrawItem,
        pixel_scale: f32,
        stats: &mut DrawStats,
    ) -> Option<(GpuMesh, Affine2)> {
        let transform = item.svg_transform(lib);
        let mesh = match item.kind {
            DrawKind::Shape(id) => {
                self.shape(renderer, lib, id, transform_scale(transform) * pixel_scale)
            }
            DrawKind::Morph { id, ratio } => self.morph(renderer, id, ratio),
            DrawKind::BitmapShape(id) => {
                stats.bitmap_shapes += 1;
                self.bitmap_shape(renderer, id)
            }
            DrawKind::Text(_) | DrawKind::EditText(_) => match self.text(renderer, &item.kind) {
                Some(mesh) => {
                    stats.texts += 1;
                    mesh
                }
                None => {
                    stats.skipped_texts += 1;
                    return None;
                }
            },
        };
        if mesh.is_none() {
            stats.failed += 1;
        }
        mesh.map(|m| (m, transform))
    }

    /// Komutları çizim listesine ekler. `pixel_scale`: bir sahne biriminin ekranda kaç piksel olduğu
    /// (ince çizgi kuralı için); komutların dönüşümü sahneyi mantıksal alana yerleştirir.
    pub fn draw(
        &mut self,
        renderer: &mut Renderer,
        lib: &Library,
        commands: &[DrawCommand],
        pixel_scale: f32,
        list: &mut DrawList,
    ) -> DrawStats {
        let mut stats = DrawStats::default();
        for cmd in commands {
            match cmd {
                DrawCommand::Draw(item) => {
                    if let Some((mesh, t)) =
                        self.item_mesh(renderer, lib, item, pixel_scale, &mut stats)
                    {
                        list.draw_with(&mesh, t, item.color);
                        stats.drawn += 1;
                    }
                }
                DrawCommand::MaskStart(items) => {
                    let shapes: Vec<(GpuMesh, Affine2)> = items
                        .iter()
                        .filter_map(|i| self.item_mesh(renderer, lib, i, pixel_scale, &mut stats))
                        .collect();
                    list.push_mask(&shapes);
                }
                DrawCommand::MaskEnd => list.pop_mask(),
            }
        }
        stats
    }
}

fn upload(renderer: &mut Renderer, image: &VectorImage, id: CharId) -> Option<GpuMesh> {
    match tessellate(image, TOLERANCE) {
        Ok(mesh) => Some(renderer.upload(&mesh)),
        Err(e) => {
            log::warn!("sembol {id}: {e}");
            None
        }
    }
}
