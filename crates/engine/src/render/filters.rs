//! Süzgeçler (Flash 8): bulanıklık ve parlama.
//!
//! Süzgeçli katmanın içindekiler ekran boyunda ayrı bir dokuya çizilir; süzgeçler sırayla bu dokuya
//! uygulanır; sonuç dıştaki çizime, dıştaki maskelerin içinde kalacak biçimde konur.
//!
//! - Bulanıklık: Flash'taki gibi kutu süzgeci; yatay ve dikey genişlik piksel olarak verilir, "geçiş"
//!   sayısı kadar tekrarlanır. Genişlik mantıksal pikseldir; ekran ölçeğiyle büyür (sahne
//!   büyütülünce süzgeç de büyür, nesnenin kendi ölçeği süzgeci etkilemez).
//! - Parlama: çizimin saydamlığı bulanıklaştırılır, gücüyle çarpılır (en çok 1), parlama rengiyle
//!   boyanır ve çizimin arkasına konur. İç parlama ve delme (çizimin kendisi görünmez) de desteklenir.

use bytemuck::{Pod, Zeroable};

use crate::color::Color;

use super::{Item, Renderer, STENCIL_FORMAT};

/// Katman ve süzgeç dokularının biçimi (bulanıklıkta kademelenme olmasın diye 16 bitlik).
pub(super) const LAYER_FORMAT: wgpu::TextureFormat = wgpu::TextureFormat::Rgba16Float;

/// Süzgeç değişkenlerinin tampondaki aralığı (uniform tamponlarının hizası).
const PARAMS_STRIDE: u64 = 256;

#[derive(Clone, Debug, PartialEq)]
pub enum Filter {
    /// Kutu bulanıklığı: genişlikler mantıksal piksel.
    Blur { x: f32, y: f32, passes: u32 },
    /// Parlama: `strength` bulanık saydamlığın çarpanı.
    Glow {
        color: Color,
        x: f32,
        y: f32,
        strength: f32,
        inner: bool,
        knockout: bool,
        passes: u32,
    },
}

impl Filter {
    /// Görüntüyü değiştirmeyen süzgeç (sıfır bulanıklık, sıfır güçte ya da saydam parlama).
    pub fn is_noop(&self) -> bool {
        match *self {
            Filter::Blur { x, y, passes } => passes == 0 || (x <= 1.0 && y <= 1.0),
            Filter::Glow {
                color,
                strength,
                knockout,
                ..
            } => !knockout && (strength <= 0.0 || color.a <= 0.0),
        }
    }

    /// Bulanıklık genişlikleri `scale` ile çarpılmış süzgeç.
    pub fn scaled(&self, scale: f32) -> Filter {
        let mut f = self.clone();
        match &mut f {
            Filter::Blur { x, y, .. } | Filter::Glow { x, y, .. } => {
                *x *= scale;
                *y *= scale;
            }
        }
        f
    }

    /// Süzgecin kullanacağı değişken aralığı sayısı (en çok).
    fn slots(&self) -> usize {
        match *self {
            Filter::Blur { passes, .. } => 2 * passes as usize,
            Filter::Glow { passes, .. } => 2 * passes as usize + 1,
        }
    }
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Default, Pod, Zeroable)]
struct Params {
    dir: [f32; 2],
    width: f32,
    strength: f32,
    color: [f32; 4],
    mode: [u32; 4],
}

/// Katman dokusu.
#[derive(Clone)]
pub(super) struct LayerTexture {
    pub(super) view: wgpu::TextureView,
}

/// Bir çizimin süzgeç durumu: değişken tamponu, boş dokular.
pub(super) struct FilterFrame {
    size: glam::UVec2,
    /// Mantıksal pikselden fiziksel piksele.
    scale: f32,
    params: Vec<Params>,
    buffer: Option<wgpu::Buffer>,
    free: Vec<LayerTexture>,
}

fn count_slots(items: &[Item]) -> usize {
    items
        .iter()
        .map(|i| match i {
            Item::Entry(_) => 0,
            Item::Layer(l) => {
                l.filters.iter().map(Filter::slots).sum::<usize>() + count_slots(&l.items)
            }
        })
        .sum()
}

pub(super) fn has_layers(items: &[Item]) -> bool {
    items.iter().any(|i| matches!(i, Item::Layer(_)))
}

impl Renderer {
    pub(super) fn filter_layout(device: &wgpu::Device) -> wgpu::BindGroupLayout {
        let texture = |binding| wgpu::BindGroupLayoutEntry {
            binding,
            visibility: wgpu::ShaderStages::FRAGMENT,
            ty: wgpu::BindingType::Texture {
                sample_type: wgpu::TextureSampleType::Float { filterable: false },
                view_dimension: wgpu::TextureViewDimension::D2,
                multisampled: false,
            },
            count: None,
        };
        device.create_bind_group_layout(&wgpu::BindGroupLayoutDescriptor {
            label: Some("süzgeç bağlama düzeni"),
            entries: &[
                texture(0),
                texture(1),
                wgpu::BindGroupLayoutEntry {
                    binding: 2,
                    visibility: wgpu::ShaderStages::FRAGMENT,
                    ty: wgpu::BindingType::Buffer {
                        ty: wgpu::BufferBindingType::Uniform,
                        has_dynamic_offset: true,
                        min_binding_size: wgpu::BufferSize::new(
                            std::mem::size_of::<Params>() as u64
                        ),
                    },
                    count: None,
                },
            ],
        })
    }

    /// Süzgeç boru hattı: `entry` gölgelendirici işlevi; `target` hedef biçimi. Katmanı dıştaki
    /// çizime koyan hat (`fs_copy`) çok örneklemeli ve maskeye uyar.
    fn filter_pipeline(&mut self, entry: &'static str, target: wgpu::TextureFormat) {
        let device = &self.device;
        let module = &self.filter_shader;
        let layout = &self.filter_pipeline_layout;
        self.filter_pipelines
            .entry((entry, target))
            .or_insert_with(|| {
                let composite = entry == "fs_copy";
                let face = wgpu::StencilFaceState {
                    compare: wgpu::CompareFunction::Equal,
                    fail_op: wgpu::StencilOperation::Keep,
                    depth_fail_op: wgpu::StencilOperation::Keep,
                    pass_op: wgpu::StencilOperation::Keep,
                };
                device.create_render_pipeline(&wgpu::RenderPipelineDescriptor {
                    label: Some(entry),
                    layout: Some(layout),
                    vertex: wgpu::VertexState {
                        module,
                        entry_point: Some("vs_full"),
                        compilation_options: Default::default(),
                        buffers: &[],
                    },
                    primitive: wgpu::PrimitiveState::default(),
                    depth_stencil: composite.then(|| wgpu::DepthStencilState {
                        format: STENCIL_FORMAT,
                        depth_write_enabled: Some(false),
                        depth_compare: Some(wgpu::CompareFunction::Always),
                        stencil: wgpu::StencilState {
                            front: face,
                            back: face,
                            read_mask: 0xff,
                            write_mask: 0,
                        },
                        bias: wgpu::DepthBiasState::default(),
                    }),
                    multisample: wgpu::MultisampleState {
                        count: if composite { super::SAMPLE_COUNT } else { 1 },
                        mask: !0,
                        alpha_to_coverage_enabled: false,
                    },
                    fragment: Some(wgpu::FragmentState {
                        module,
                        entry_point: Some(entry),
                        compilation_options: Default::default(),
                        targets: &[Some(wgpu::ColorTargetState {
                            format: target,
                            blend: composite
                                .then_some(wgpu::BlendState::PREMULTIPLIED_ALPHA_BLENDING),
                            write_mask: wgpu::ColorWrites::ALL,
                        })],
                    }),
                    multiview_mask: None,
                    cache: None,
                })
            });
    }

    pub(super) fn filter_frame(
        &mut self,
        items: &[Item],
        size: glam::UVec2,
        scale: f32,
    ) -> FilterFrame {
        let slots = count_slots(items);
        let buffer = (slots > 0 || has_layers(items)).then(|| {
            self.device.create_buffer(&wgpu::BufferDescriptor {
                label: Some("süzgeç değişkenleri"),
                size: PARAMS_STRIDE * slots.max(1) as u64,
                usage: wgpu::BufferUsages::UNIFORM | wgpu::BufferUsages::COPY_DST,
                mapped_at_creation: false,
            })
        });
        let free = if self.layer_size == size {
            std::mem::take(&mut self.layer_pool)
        } else {
            Vec::new()
        };
        FilterFrame {
            size,
            scale,
            params: Vec::new(),
            buffer,
            free,
        }
    }

    /// Değişkenleri grafik kartına gönderir ve boş dokuları sonraki çizimler için saklar.
    pub(super) fn finish_filter_frame(&mut self, frame: FilterFrame) {
        if let Some(buffer) = &frame.buffer {
            let mut data = vec![0u8; buffer.size() as usize];
            for (i, p) in frame.params.iter().enumerate() {
                let at = i * PARAMS_STRIDE as usize;
                data[at..at + std::mem::size_of::<Params>()].copy_from_slice(bytemuck::bytes_of(p));
            }
            self.queue.write_buffer(buffer, 0, &data);
        }
        self.layer_size = frame.size;
        self.layer_pool = frame.free;
    }

    pub(super) fn take_texture(&self, frame: &mut FilterFrame) -> LayerTexture {
        if let Some(t) = frame.free.pop() {
            return t;
        }
        let texture = self.device.create_texture(&wgpu::TextureDescriptor {
            label: Some("süzgeç katmanı"),
            size: wgpu::Extent3d {
                width: frame.size.x,
                height: frame.size.y,
                depth_or_array_layers: 1,
            },
            mip_level_count: 1,
            sample_count: 1,
            dimension: wgpu::TextureDimension::D2,
            format: LAYER_FORMAT,
            usage: wgpu::TextureUsages::RENDER_ATTACHMENT | wgpu::TextureUsages::TEXTURE_BINDING,
            view_formats: &[],
        });
        LayerTexture {
            view: texture.create_view(&wgpu::TextureViewDescriptor::default()),
        }
    }

    fn filter_bind_group(
        &self,
        frame: &FilterFrame,
        source: &LayerTexture,
        base: &LayerTexture,
    ) -> Option<wgpu::BindGroup> {
        let buffer = frame.buffer.as_ref()?;
        Some(self.device.create_bind_group(&wgpu::BindGroupDescriptor {
            label: Some("süzgeç bağlama"),
            layout: &self.filter_layout,
            entries: &[
                wgpu::BindGroupEntry {
                    binding: 0,
                    resource: wgpu::BindingResource::TextureView(&source.view),
                },
                wgpu::BindGroupEntry {
                    binding: 1,
                    resource: wgpu::BindingResource::TextureView(&base.view),
                },
                wgpu::BindGroupEntry {
                    binding: 2,
                    resource: wgpu::BindingResource::Buffer(wgpu::BufferBinding {
                        buffer,
                        offset: 0,
                        size: wgpu::BufferSize::new(std::mem::size_of::<Params>() as u64),
                    }),
                },
            ],
        }))
    }

    /// Tek bir tam ekran süzgeç geçişi: `source` (ve `base`) → yeni doku.
    fn filter_pass(
        &mut self,
        encoder: &mut wgpu::CommandEncoder,
        frame: &mut FilterFrame,
        entry: &'static str,
        source: &LayerTexture,
        base: &LayerTexture,
        params: Params,
    ) -> LayerTexture {
        self.filter_pipeline(entry, LAYER_FORMAT);
        let out = self.take_texture(frame);
        let slot = frame.params.len() as u32;
        frame.params.push(params);
        let Some(bind_group) = self.filter_bind_group(frame, source, base) else {
            return out;
        };
        let mut pass = encoder.begin_render_pass(&wgpu::RenderPassDescriptor {
            label: Some(entry),
            color_attachments: &[Some(wgpu::RenderPassColorAttachment {
                view: &out.view,
                depth_slice: None,
                resolve_target: None,
                ops: wgpu::Operations {
                    load: wgpu::LoadOp::Clear(wgpu::Color::TRANSPARENT),
                    store: wgpu::StoreOp::Store,
                },
            })],
            depth_stencil_attachment: None,
            timestamp_writes: None,
            occlusion_query_set: None,
            multiview_mask: None,
        });
        if let Some(pipeline) = self.filter_pipelines.get(&(entry, LAYER_FORMAT)) {
            pass.set_pipeline(pipeline);
            pass.set_bind_group(0, &bind_group, &[slot * PARAMS_STRIDE as u32]);
            pass.draw(0..3, 0..1);
        }
        out
    }

    /// Kutu bulanıklığı (yatay, dikey; `passes` kez); hiç geçiş gerekmediyse `None`. Ara dokular
    /// boşa çıkar.
    fn blur(
        &mut self,
        encoder: &mut wgpu::CommandEncoder,
        frame: &mut FilterFrame,
        input: &LayerTexture,
        (x, y, passes): (f32, f32, u32),
    ) -> Option<LayerTexture> {
        let mut current: Option<LayerTexture> = None;
        for _ in 0..passes {
            for (dir, width) in [([1.0, 0.0], x), ([0.0, 1.0], y)] {
                let width = width * frame.scale;
                if width <= 1.0 {
                    continue;
                }
                let params = Params {
                    dir,
                    width,
                    ..Default::default()
                };
                let source = current.as_ref().unwrap_or(input).clone();
                let next = self.filter_pass(encoder, frame, "fs_blur", &source, &source, params);
                if let Some(old) = current.replace(next) {
                    frame.free.push(old);
                }
            }
        }
        current
    }

    /// Süzgeci uygular. `input` boşa çıkar ya da (süzgeç bir şey yapmadıysa) sonuç olarak döner.
    pub(super) fn apply_filter(
        &mut self,
        encoder: &mut wgpu::CommandEncoder,
        frame: &mut FilterFrame,
        filter: &Filter,
        input: LayerTexture,
    ) -> LayerTexture {
        match *filter {
            Filter::Blur { x, y, passes } => {
                match self.blur(encoder, frame, &input, (x, y, passes)) {
                    Some(out) => {
                        frame.free.push(input);
                        out
                    }
                    None => input,
                }
            }
            Filter::Glow {
                color,
                x,
                y,
                strength,
                inner,
                knockout,
                passes,
            } => {
                let blurred = self.blur(encoder, frame, &input, (x, y, passes));
                let params = Params {
                    strength,
                    color: [color.r, color.g, color.b, color.a],
                    mode: [u32::from(inner), u32::from(knockout), 0, 0],
                    ..Default::default()
                };
                let source = blurred.as_ref().unwrap_or(&input).clone();
                let out = self.filter_pass(encoder, frame, "fs_glow", &source, &input, params);
                if let Some(b) = blurred {
                    frame.free.push(b);
                }
                frame.free.push(input);
                out
            }
        }
    }

    /// Katmanı dıştaki çizime koyan hattı ve bağlamayı hazırlar.
    pub(super) fn composite_bind_group(
        &mut self,
        frame: &FilterFrame,
        layer: &LayerTexture,
        target: wgpu::TextureFormat,
    ) -> Option<wgpu::BindGroup> {
        self.filter_pipeline("fs_copy", target);
        self.filter_bind_group(frame, layer, layer)
    }

    pub(super) fn composite_pipeline(
        &self,
        target: wgpu::TextureFormat,
    ) -> Option<&wgpu::RenderPipeline> {
        self.filter_pipelines.get(&("fs_copy", target))
    }
}

pub(super) fn frame_size(frame: &FilterFrame) -> glam::UVec2 {
    frame.size
}

/// Artık kullanılmayan dokuyu boşa çıkarır.
pub(super) fn frame_release(frame: &mut FilterFrame, texture: LayerTexture) {
    frame.free.push(texture);
}
