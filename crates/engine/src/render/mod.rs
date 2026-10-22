//! Grafik kartında çizim.
//!
//! - Ağlar ([`crate::tessellate::Mesh`]) bir kez yüklenir ([`Renderer::upload`]), her karede
//!   yalnızca dönüşümleriyle çizilir.
//! - Kenar yumuşatma 4 örneklemeli MSAA ile yapılır.
//! - Renkler sRGB uzayında karışır: hedef doku "sRGB" değil, düz `Unorm` biçimindedir.
//! - Her çizime Flash'taki gibi bir renk dönüşümü ([`ColorTransform`]) verilebilir: saydamlık,
//!   renklendirme, gün saati ışığı.

mod filters;
mod paints;

use std::collections::HashMap;
use std::fmt;
use std::sync::Arc;

use bytemuck::{Pod, Zeroable};
use glam::{Affine2, UVec2, Vec2};
use wgpu::util::DeviceExt;

use crate::color::Color;
use crate::image::RgbaImage;
use crate::paint::RAMP_WIDTH;
use crate::tessellate::{Mesh, MeshVertex};
use crate::viewport::Viewport;

use filters::{FilterFrame, LAYER_FORMAT, LayerTexture, frame_release, frame_size};
use paints::{ATLAS_WIDTH, GpuPaint, PaintTable, affine_rows};

pub use filters::Filter;

/// Kenar yumuşatmadaki örnek sayısı.
pub const SAMPLE_COUNT: u32 = 4;

/// Mantıksal alanın dışında kalan şeritlerin rengi.
pub const LETTERBOX_COLOR: Color = Color::rgba(0.055, 0.047, 0.04, 1.0);

/// Ekransız çizimde kullanılan doku biçimi.
pub const IMAGE_FORMAT: wgpu::TextureFormat = wgpu::TextureFormat::Rgba8Unorm;

#[derive(Debug)]
pub enum RenderError {
    NoAdapter(String),
    Device(String),
    Readback(String),
    /// İstenen resim grafik kartının doku sınırından büyük.
    TooLarge {
        size: UVec2,
        limit: u32,
    },
}

impl fmt::Display for RenderError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            RenderError::NoAdapter(e) => write!(f, "uygun grafik kartı bulunamadı: {e}"),
            RenderError::Device(e) => write!(f, "grafik kartı açılamadı: {e}"),
            RenderError::Readback(e) => write!(f, "çizilen resim okunamadı: {e}"),
            RenderError::TooLarge { size, limit } => write!(
                f,
                "resim çok büyük: {}×{} (grafik kartının sınırı {limit})",
                size.x, size.y
            ),
        }
    }
}

impl std::error::Error for RenderError {}

/// Renk dönüşümü: `sonuç = renk × mul + add` (düz renk üzerinde, bileşen bileşen).
#[derive(Clone, Copy, Debug, PartialEq)]
pub struct ColorTransform {
    pub mul: [f32; 4],
    pub add: [f32; 4],
}

impl ColorTransform {
    pub const IDENTITY: ColorTransform = ColorTransform {
        mul: [1.0; 4],
        add: [0.0; 4],
    };

    /// Yalnızca saydamlığı değiştiren dönüşüm.
    pub fn alpha(a: f32) -> Self {
        ColorTransform {
            mul: [1.0, 1.0, 1.0, a],
            add: [0.0; 4],
        }
    }

    /// Rengi verilen renkle çarpar (gün saati ışığı, gölgede kalma).
    pub fn multiply(c: Color) -> Self {
        ColorTransform {
            mul: [c.r, c.g, c.b, c.a],
            add: [0.0; 4],
        }
    }

    /// İki dönüşümü art arda uygular: önce `self`, sonra `then`.
    pub fn then(self, then: ColorTransform) -> Self {
        let mut out = ColorTransform::IDENTITY;
        for i in 0..4 {
            out.mul[i] = self.mul[i] * then.mul[i];
            out.add[i] = self.add[i] * then.mul[i] + then.add[i];
        }
        out
    }
}

/// Gölgelendiricideki örnek (instance) bilgisi (64 bayt).
#[repr(C)]
#[derive(Clone, Copy, Debug, Pod, Zeroable)]
struct GpuInstance {
    t0: [f32; 4],
    t1: [f32; 4],
    mul: [f32; 4],
    add: [f32; 4],
}

impl GpuInstance {
    fn new(transform: Affine2, color: ColorTransform) -> Self {
        let (t0, t1) = affine_rows(transform);
        GpuInstance {
            t0,
            t1,
            mul: color.mul,
            add: color.add,
        }
    }
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Pod, Zeroable)]
struct GpuView {
    row0: [f32; 4],
    row1: [f32; 4],
    ramp: [f32; 4],
}

struct GpuMeshData {
    buffers: Option<(wgpu::Buffer, wgpu::Buffer)>,
    index_count: u32,
}

/// Grafik kartına yüklenmiş ağ. Kopyalaması ucuzdur; son kopyası düşünce bellekten silinir.
#[derive(Clone)]
pub struct GpuMesh(Arc<GpuMeshData>);

impl GpuMesh {
    pub fn triangle_count(&self) -> u32 {
        self.0.index_count / 3
    }
}

impl fmt::Debug for GpuMesh {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "GpuMesh({} üçgen)", self.triangle_count())
    }
}

/// Bir çizimin geçişi: görünen çizim ya da maske (kalıp arabelleği) işlemi.
#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
enum Pass {
    /// Kalıp değeri maske düzeyine eşit piksellere çizer.
    Draw,
    /// Renk yazmaz; şeklin altındaki piksellerin maske düzeyini bir artırır.
    MaskPush,
    /// Renk yazmaz; şeklin altındaki piksellerin maske düzeyini bir azaltır.
    MaskPop,
}

#[derive(Clone, Debug)]
struct DrawEntry {
    mesh: GpuMesh,
    /// Örnek tablosundaki sırası.
    index: u32,
    pass: Pass,
    /// Kalıp karşılaştırma değeri (maske düzeyi).
    level: u32,
}

/// Süzgeçli katman: içindekiler ayrı bir dokuya çizilir, süzgeçlerden geçer, sonra dıştaki çizime
/// konur (dıştaki maskeler katmanın sonucuna uygulanır).
#[derive(Clone, Debug)]
struct Layer {
    filters: Vec<Filter>,
    items: Vec<Item>,
    /// Dıştaki maske düzeyi.
    level: u32,
}

#[derive(Clone, Debug)]
enum Item {
    Entry(DrawEntry),
    Layer(Layer),
}

type MaskShapes = Vec<(GpuMesh, u32)>;

/// Açık süzgeçli katman: süzgeçleri ve dıştaki çizimler ile maskeler (süzgeci olmayan katman
/// yalnız yer tutar).
#[derive(Clone, Debug)]
struct OpenLayer {
    filters: Option<Vec<Filter>>,
    items: Vec<Item>,
    masks: Vec<MaskShapes>,
}

/// Bir karede çizilecekler, çizim sırasıyla.
///
/// Maskeler (Flash'taki gibi): [`DrawList::push_mask`] ile verilen şekiller görünmez; sonraki çizimler
/// [`DrawList::pop_mask`]'a kadar yalnız bu şekillerin içinde görünür. Maskeler iç içe olabilir;
/// içteki çizim bütün açık maskelerin kesişiminde görünür.
///
/// Süzgeçler: [`DrawList::push_filters`] ile [`DrawList::pop_filters`] arasındaki çizimler birlikte
/// süzgeçten geçer (bulanıklık, parlama).
#[derive(Clone, Debug)]
pub struct DrawList {
    /// Mantıksal alanın arka plan rengi.
    pub clear: Color,
    instances: Vec<GpuInstance>,
    items: Vec<Item>,
    masks: Vec<MaskShapes>,
    layers: Vec<OpenLayer>,
    entries: usize,
}

impl DrawList {
    pub fn new(clear: Color) -> Self {
        DrawList {
            clear,
            instances: Vec::new(),
            items: Vec::new(),
            masks: Vec::new(),
            layers: Vec::new(),
            entries: 0,
        }
    }

    fn push_entry(&mut self, mesh: &GpuMesh, index: u32, pass: Pass, level: u32) {
        self.entries += 1;
        self.items.push(Item::Entry(DrawEntry {
            mesh: mesh.clone(),
            index,
            pass,
            level,
        }));
    }

    fn instance(&mut self, transform: Affine2, color: ColorTransform) -> u32 {
        self.instances.push(GpuInstance::new(transform, color));
        (self.instances.len() - 1) as u32
    }

    pub fn draw(&mut self, mesh: &GpuMesh, transform: Affine2) {
        self.draw_with(mesh, transform, ColorTransform::IDENTITY);
    }

    pub fn draw_with(&mut self, mesh: &GpuMesh, transform: Affine2, color: ColorTransform) {
        if mesh.0.index_count > 0 {
            let index = self.instance(transform, color);
            self.push_entry(mesh, index, Pass::Draw, self.masks.len() as u32);
        }
    }

    /// Maske açar: şekiller görünmez, sonraki çizimler yalnız onların içinde görünür.
    pub fn push_mask(&mut self, shapes: &[(GpuMesh, Affine2)]) {
        let level = self.masks.len() as u32;
        let mut mask = Vec::new();
        for (mesh, t) in shapes.iter().filter(|(m, _)| m.0.index_count > 0) {
            let index = self.instance(*t, ColorTransform::IDENTITY);
            self.push_entry(mesh, index, Pass::MaskPush, level);
            mask.push((mesh.clone(), index));
        }
        self.masks.push(mask);
    }

    /// En son açılan maskeyi kapatır (açık maske yoksa bir şey yapmaz).
    pub fn pop_mask(&mut self) {
        let level = self.masks.len() as u32;
        if let Some(shapes) = self.masks.pop() {
            for (mesh, index) in shapes {
                self.push_entry(&mesh, index, Pass::MaskPop, level);
            }
        }
    }

    /// Süzgeçli katman açar. Etkisi olmayan süzgeçler (ör. sıfır bulanıklık) atlanır; hiç süzgeç
    /// kalmazsa çizimler doğrudan yapılır.
    pub fn push_filters(&mut self, filters: &[Filter]) {
        let filters: Vec<Filter> = filters.iter().filter(|f| !f.is_noop()).cloned().collect();
        if filters.is_empty() {
            self.layers.push(OpenLayer {
                filters: None,
                items: Vec::new(),
                masks: Vec::new(),
            });
            return;
        }
        self.layers.push(OpenLayer {
            filters: Some(filters),
            items: std::mem::take(&mut self.items),
            masks: std::mem::take(&mut self.masks),
        });
    }

    /// En son açılan süzgeçli katmanı kapatır (katmanın içinde açık kalan maskeler de kapanır).
    pub fn pop_filters(&mut self) {
        let Some(open) = self.layers.pop() else {
            return;
        };
        let Some(filters) = open.filters else {
            return;
        };
        while !self.masks.is_empty() {
            self.pop_mask();
        }
        let items = std::mem::replace(&mut self.items, open.items);
        self.masks = open.masks;
        self.items.push(Item::Layer(Layer {
            filters,
            items,
            level: self.masks.len() as u32,
        }));
    }

    /// Çizim ve maske işlemlerinin sayısı.
    pub fn len(&self) -> usize {
        self.entries
    }

    pub fn is_empty(&self) -> bool {
        self.entries == 0
    }
}

struct MsaaTarget {
    format: wgpu::TextureFormat,
    size: UVec2,
    view: wgpu::TextureView,
    /// Maskeler için kalıp arabelleği (çok örneklemeli, renk hedefiyle aynı boyda).
    stencil: wgpu::TextureView,
}

/// Maskelerin kalıp arabelleğinin biçimi.
const STENCIL_FORMAT: wgpu::TextureFormat = wgpu::TextureFormat::Stencil8;

pub struct Renderer {
    device: wgpu::Device,
    queue: wgpu::Queue,
    info: wgpu::AdapterInfo,
    shader: wgpu::ShaderModule,
    pipeline_layout: wgpu::PipelineLayout,
    bind_group_layout: wgpu::BindGroupLayout,
    pipelines: HashMap<(wgpu::TextureFormat, Pass), wgpu::RenderPipeline>,
    sampler: wgpu::Sampler,
    view_buffer: wgpu::Buffer,
    paints: PaintTable,
    paint_buffer: wgpu::Buffer,
    paint_capacity: usize,
    ramp_texture: wgpu::Texture,
    ramp_capacity: u32,
    /// Resim boyalarının atlası (genişlik ATLAS_WIDTH, yükseklik `atlas_capacity`).
    atlas_texture: wgpu::Texture,
    atlas_capacity: u32,
    bind_group: wgpu::BindGroup,
    instance_buffer: wgpu::Buffer,
    instance_capacity: usize,
    /// Çok örneklemeli hedefler (biçim başına bir tane: ekran ve süzgeç katmanları).
    msaa: Vec<MsaaTarget>,
    background: GpuMesh,
    filter_shader: wgpu::ShaderModule,
    filter_layout: wgpu::BindGroupLayout,
    filter_pipeline_layout: wgpu::PipelineLayout,
    filter_pipelines: HashMap<(&'static str, wgpu::TextureFormat), wgpu::RenderPipeline>,
    /// Önceki çizimlerden kalan boş süzgeç dokuları (`layer_size` boyunda).
    layer_pool: Vec<LayerTexture>,
    layer_size: UVec2,
}

impl Renderer {
    /// Ekransız çizim için grafik kartını kendisi açar (testler ve resim çıktısı).
    pub fn headless() -> Result<Self, RenderError> {
        let instance =
            wgpu::Instance::new(wgpu::InstanceDescriptor::new_without_display_handle_from_env());
        let adapter = request_adapter(&instance, None)?;
        Self::from_adapter(&adapter)
    }

    /// Verilen grafik kartı için cihaz açar.
    pub fn from_adapter(adapter: &wgpu::Adapter) -> Result<Self, RenderError> {
        let (device, queue) = pollster::block_on(adapter.request_device(&wgpu::DeviceDescriptor {
            label: Some("motor"),
            required_features: wgpu::Features::empty(),
            required_limits: wgpu::Limits::default(),
            memory_hints: wgpu::MemoryHints::Performance,
            ..Default::default()
        }))
        .map_err(|e| RenderError::Device(e.to_string()))?;
        Ok(Self::new(device, queue, adapter.get_info()))
    }

    fn new(device: wgpu::Device, queue: wgpu::Queue, info: wgpu::AdapterInfo) -> Self {
        let shader = device.create_shader_module(wgpu::ShaderModuleDescriptor {
            label: Some("vektör gölgelendirici"),
            source: wgpu::ShaderSource::Wgsl(include_str!("shader.wgsl").into()),
        });
        let bind_group_layout = device.create_bind_group_layout(&wgpu::BindGroupLayoutDescriptor {
            label: Some("vektör bağlama düzeni"),
            entries: &[
                wgpu::BindGroupLayoutEntry {
                    binding: 0,
                    visibility: wgpu::ShaderStages::VERTEX_FRAGMENT,
                    ty: wgpu::BindingType::Buffer {
                        ty: wgpu::BufferBindingType::Uniform,
                        has_dynamic_offset: false,
                        min_binding_size: None,
                    },
                    count: None,
                },
                wgpu::BindGroupLayoutEntry {
                    binding: 1,
                    visibility: wgpu::ShaderStages::FRAGMENT,
                    ty: wgpu::BindingType::Buffer {
                        ty: wgpu::BufferBindingType::Storage { read_only: true },
                        has_dynamic_offset: false,
                        min_binding_size: None,
                    },
                    count: None,
                },
                wgpu::BindGroupLayoutEntry {
                    binding: 2,
                    visibility: wgpu::ShaderStages::FRAGMENT,
                    ty: wgpu::BindingType::Texture {
                        sample_type: wgpu::TextureSampleType::Float { filterable: true },
                        view_dimension: wgpu::TextureViewDimension::D2,
                        multisampled: false,
                    },
                    count: None,
                },
                wgpu::BindGroupLayoutEntry {
                    binding: 3,
                    visibility: wgpu::ShaderStages::FRAGMENT,
                    ty: wgpu::BindingType::Sampler(wgpu::SamplerBindingType::Filtering),
                    count: None,
                },
                wgpu::BindGroupLayoutEntry {
                    binding: 4,
                    visibility: wgpu::ShaderStages::FRAGMENT,
                    ty: wgpu::BindingType::Texture {
                        sample_type: wgpu::TextureSampleType::Float { filterable: true },
                        view_dimension: wgpu::TextureViewDimension::D2,
                        multisampled: false,
                    },
                    count: None,
                },
            ],
        });
        let pipeline_layout = device.create_pipeline_layout(&wgpu::PipelineLayoutDescriptor {
            label: Some("vektör boru hattı düzeni"),
            bind_group_layouts: &[Some(&bind_group_layout)],
            immediate_size: 0,
        });
        let sampler = device.create_sampler(&wgpu::SamplerDescriptor {
            label: Some("rampa örnekleyici"),
            address_mode_u: wgpu::AddressMode::ClampToEdge,
            address_mode_v: wgpu::AddressMode::ClampToEdge,
            mag_filter: wgpu::FilterMode::Linear,
            min_filter: wgpu::FilterMode::Linear,
            ..Default::default()
        });
        let view_buffer = device.create_buffer(&wgpu::BufferDescriptor {
            label: Some("görünüm"),
            size: std::mem::size_of::<GpuView>() as u64,
            usage: wgpu::BufferUsages::UNIFORM | wgpu::BufferUsages::COPY_DST,
            mapped_at_creation: false,
        });
        let paint_capacity = 256;
        let paint_buffer = create_paint_buffer(&device, paint_capacity);
        let ramp_capacity = 64;
        let ramp_texture = create_ramp_texture(&device, ramp_capacity);
        let atlas_capacity = 64;
        let atlas_texture = create_atlas_texture(&device, atlas_capacity);
        let bind_group = create_bind_group(
            &device,
            &bind_group_layout,
            &view_buffer,
            &paint_buffer,
            &ramp_texture,
            &sampler,
            &atlas_texture,
        );
        let instance_capacity = 1024;
        let instance_buffer = create_instance_buffer(&device, instance_capacity);
        let filter_shader = device.create_shader_module(wgpu::ShaderModuleDescriptor {
            label: Some("süzgeç gölgelendirici"),
            source: wgpu::ShaderSource::Wgsl(include_str!("filter.wgsl").into()),
        });
        let filter_layout = Renderer::filter_layout(&device);
        let filter_pipeline_layout =
            device.create_pipeline_layout(&wgpu::PipelineLayoutDescriptor {
                label: Some("süzgeç boru hattı düzeni"),
                bind_group_layouts: &[Some(&filter_layout)],
                immediate_size: 0,
            });
        let mut renderer = Renderer {
            device,
            queue,
            info,
            shader,
            pipeline_layout,
            bind_group_layout,
            pipelines: HashMap::new(),
            sampler,
            view_buffer,
            paints: PaintTable::default(),
            paint_buffer,
            paint_capacity,
            ramp_texture,
            ramp_capacity,
            atlas_texture,
            atlas_capacity,
            bind_group,
            instance_buffer,
            instance_capacity,
            msaa: Vec::new(),
            background: GpuMesh(Arc::new(GpuMeshData {
                buffers: None,
                index_count: 0,
            })),
            filter_shader,
            filter_layout,
            filter_pipeline_layout,
            filter_pipelines: HashMap::new(),
            layer_pool: Vec::new(),
            layer_size: UVec2::ZERO,
        };
        renderer.background = renderer.upload(&unit_square());
        renderer
    }

    pub fn device(&self) -> &wgpu::Device {
        &self.device
    }

    pub fn queue(&self) -> &wgpu::Queue {
        &self.queue
    }

    pub fn adapter_info(&self) -> &wgpu::AdapterInfo {
        &self.info
    }

    /// Ağı grafik kartına yükler.
    pub fn upload(&mut self, mesh: &Mesh) -> GpuMesh {
        if mesh.is_empty() {
            return GpuMesh(Arc::new(GpuMeshData {
                buffers: None,
                index_count: 0,
            }));
        }
        let global: Vec<u32> = mesh.paints.iter().map(|p| self.paints.intern(p)).collect();
        let vertices: Vec<MeshVertex> = mesh
            .vertices
            .iter()
            .map(|v| MeshVertex {
                position: v.position,
                paint: global[v.paint as usize],
            })
            .collect();
        let vb = self
            .device
            .create_buffer_init(&wgpu::util::BufferInitDescriptor {
                label: Some("ağ köşeleri"),
                contents: bytemuck::cast_slice(&vertices),
                usage: wgpu::BufferUsages::VERTEX,
            });
        let ib = self
            .device
            .create_buffer_init(&wgpu::util::BufferInitDescriptor {
                label: Some("ağ üçgenleri"),
                contents: bytemuck::cast_slice(&mesh.indices),
                usage: wgpu::BufferUsages::INDEX,
            });
        GpuMesh(Arc::new(GpuMeshData {
            buffers: Some((vb, ib)),
            index_count: mesh.indices.len() as u32,
        }))
    }

    fn pipeline(&mut self, format: wgpu::TextureFormat, pass: Pass) {
        let device = &self.device;
        let shader = &self.shader;
        let layout = &self.pipeline_layout;
        self.pipelines.entry((format, pass)).or_insert_with(|| {
            let pass_op = match pass {
                Pass::Draw => wgpu::StencilOperation::Keep,
                Pass::MaskPush => wgpu::StencilOperation::IncrementClamp,
                Pass::MaskPop => wgpu::StencilOperation::DecrementClamp,
            };
            let face = wgpu::StencilFaceState {
                compare: wgpu::CompareFunction::Equal,
                fail_op: wgpu::StencilOperation::Keep,
                depth_fail_op: wgpu::StencilOperation::Keep,
                pass_op,
            };
            device.create_render_pipeline(&wgpu::RenderPipelineDescriptor {
                label: Some("vektör boru hattı"),
                layout: Some(layout),
                vertex: wgpu::VertexState {
                    module: shader,
                    entry_point: Some("vs_main"),
                    compilation_options: Default::default(),
                    buffers: &[
                        Some(wgpu::VertexBufferLayout {
                            array_stride: std::mem::size_of::<MeshVertex>() as u64,
                            step_mode: wgpu::VertexStepMode::Vertex,
                            attributes: &wgpu::vertex_attr_array![0 => Float32x2, 1 => Uint32],
                        }),
                        Some(wgpu::VertexBufferLayout {
                            array_stride: std::mem::size_of::<GpuInstance>() as u64,
                            step_mode: wgpu::VertexStepMode::Instance,
                            attributes: &wgpu::vertex_attr_array![
                                2 => Float32x4, 3 => Float32x4, 4 => Float32x4, 5 => Float32x4
                            ],
                        }),
                    ],
                },
                primitive: wgpu::PrimitiveState {
                    topology: wgpu::PrimitiveTopology::TriangleList,
                    cull_mode: None,
                    ..Default::default()
                },
                depth_stencil: Some(wgpu::DepthStencilState {
                    format: STENCIL_FORMAT,
                    depth_write_enabled: Some(false),
                    depth_compare: Some(wgpu::CompareFunction::Always),
                    stencil: wgpu::StencilState {
                        front: face,
                        back: face,
                        read_mask: 0xff,
                        write_mask: 0xff,
                    },
                    bias: wgpu::DepthBiasState::default(),
                }),
                multisample: wgpu::MultisampleState {
                    count: SAMPLE_COUNT,
                    mask: !0,
                    alpha_to_coverage_enabled: false,
                },
                fragment: Some(wgpu::FragmentState {
                    module: shader,
                    entry_point: Some("fs_main"),
                    compilation_options: Default::default(),
                    targets: &[Some(wgpu::ColorTargetState {
                        format,
                        blend: Some(wgpu::BlendState::PREMULTIPLIED_ALPHA_BLENDING),
                        write_mask: if pass == Pass::Draw {
                            wgpu::ColorWrites::ALL
                        } else {
                            wgpu::ColorWrites::empty()
                        },
                    })],
                }),
                multiview_mask: None,
                cache: None,
            })
        });
    }

    /// Boya tablosundaki yenilikleri grafik kartına gönderir.
    fn flush_paints(&mut self) {
        if !self.paints.dirty {
            return;
        }
        let mut rebind = false;
        if self.paints.records.len() > self.paint_capacity {
            while self.paint_capacity < self.paints.records.len() {
                self.paint_capacity *= 2;
            }
            self.paint_buffer = create_paint_buffer(&self.device, self.paint_capacity);
            rebind = true;
        }
        let rows = self.paints.ramp_rows().max(1);
        if rows > self.ramp_capacity {
            while self.ramp_capacity < rows {
                self.ramp_capacity *= 2;
            }
            self.ramp_texture = create_ramp_texture(&self.device, self.ramp_capacity);
            rebind = true;
        }
        self.queue.write_buffer(
            &self.paint_buffer,
            0,
            bytemuck::cast_slice(&self.paints.records),
        );
        if !self.paints.ramps.is_empty() {
            self.queue.write_texture(
                wgpu::TexelCopyTextureInfo {
                    texture: &self.ramp_texture,
                    mip_level: 0,
                    origin: wgpu::Origin3d::ZERO,
                    aspect: wgpu::TextureAspect::All,
                },
                bytemuck::cast_slice(&self.paints.ramps),
                wgpu::TexelCopyBufferLayout {
                    offset: 0,
                    bytes_per_row: Some((RAMP_WIDTH * 4) as u32),
                    rows_per_image: None,
                },
                wgpu::Extent3d {
                    width: RAMP_WIDTH as u32,
                    height: self.paints.ramp_rows(),
                    depth_or_array_layers: 1,
                },
            );
        }
        if self.paints.atlas_height() > self.atlas_capacity {
            while self.atlas_capacity < self.paints.atlas_height() {
                self.atlas_capacity *= 2;
            }
            self.atlas_texture = create_atlas_texture(&self.device, self.atlas_capacity);
            // Yeni doku boştur: bütün resimler yeniden gönderilir
            self.paints.atlas_sent = 0;
            rebind = true;
        }
        for (x, y, w, h, data) in &self.paints.atlas[self.paints.atlas_sent..] {
            self.queue.write_texture(
                wgpu::TexelCopyTextureInfo {
                    texture: &self.atlas_texture,
                    mip_level: 0,
                    origin: wgpu::Origin3d { x: *x, y: *y, z: 0 },
                    aspect: wgpu::TextureAspect::All,
                },
                data,
                wgpu::TexelCopyBufferLayout {
                    offset: 0,
                    bytes_per_row: Some(w * 4),
                    rows_per_image: None,
                },
                wgpu::Extent3d {
                    width: *w,
                    height: *h,
                    depth_or_array_layers: 1,
                },
            );
        }
        self.paints.atlas_sent = self.paints.atlas.len();
        if rebind {
            self.bind_group = create_bind_group(
                &self.device,
                &self.bind_group_layout,
                &self.view_buffer,
                &self.paint_buffer,
                &self.ramp_texture,
                &self.sampler,
                &self.atlas_texture,
            );
        }
        self.paints.dirty = false;
    }

    /// Çok örneklemeli renk hedefi ve kalıp arabelleği (boy ya da biçim değişince yeniden kurulur).
    fn msaa_view(
        &mut self,
        format: wgpu::TextureFormat,
        size: UVec2,
    ) -> (wgpu::TextureView, wgpu::TextureView) {
        if let Some(m) = self
            .msaa
            .iter()
            .find(|m| m.format == format && m.size == size)
        {
            return (m.view.clone(), m.stencil.clone());
        }
        let texture = self.device.create_texture(&wgpu::TextureDescriptor {
            label: Some("MSAA hedefi"),
            size: wgpu::Extent3d {
                width: size.x,
                height: size.y,
                depth_or_array_layers: 1,
            },
            mip_level_count: 1,
            sample_count: SAMPLE_COUNT,
            dimension: wgpu::TextureDimension::D2,
            format,
            usage: wgpu::TextureUsages::RENDER_ATTACHMENT,
            view_formats: &[],
        });
        let view = texture.create_view(&wgpu::TextureViewDescriptor::default());
        let stencil = self
            .device
            .create_texture(&wgpu::TextureDescriptor {
                label: Some("maske kalıbı"),
                size: wgpu::Extent3d {
                    width: size.x,
                    height: size.y,
                    depth_or_array_layers: 1,
                },
                mip_level_count: 1,
                sample_count: SAMPLE_COUNT,
                dimension: wgpu::TextureDimension::D2,
                format: STENCIL_FORMAT,
                usage: wgpu::TextureUsages::RENDER_ATTACHMENT,
                view_formats: &[],
            })
            .create_view(&wgpu::TextureViewDescriptor::default());
        self.msaa.retain(|m| m.format != format && m.size == size);
        self.msaa.push(MsaaTarget {
            format,
            size,
            view: view.clone(),
            stencil: stencil.clone(),
        });
        (view, stencil)
    }

    /// Çizim listesini hedef dokuya çizer. `format`, hedef görünümün biçimidir ve "sRGB"
    /// olmamalıdır (renkler sRGB uzayında karışsın diye).
    pub fn render(
        &mut self,
        target: &wgpu::TextureView,
        format: wgpu::TextureFormat,
        viewport: &Viewport,
        list: &DrawList,
    ) {
        let size = viewport.physical;
        if size.x == 0 || size.y == 0 {
            return;
        }
        // Şerit yoksa (içerik bütün hedefi kaplıyorsa) hedef doğrudan arka plan rengiyle temizlenir;
        // böylece saydam arka plan saydam kalır. Şerit varsa şerit rengiyle temizlenir ve arka plan,
        // mantıksal alanı kaplayan bir kare olarak listenin başına eklenir.
        let seritsiz = viewport.offset.length_squared() < 1e-6
            && (viewport.logical * viewport.scale - size.as_vec2())
                .abs()
                .max_element()
                < 0.5;
        let temiz = if seritsiz {
            let p = list.clear.premultiplied();
            Color::rgba(p[0], p[1], p[2], p[3])
        } else {
            LETTERBOX_COLOR
        };
        let mut instances = list.instances.clone();
        let mut items = Vec::with_capacity(list.items.len() + 1);
        if !seritsiz && list.clear.a > 0.0 {
            instances.push(GpuInstance::new(
                Affine2::from_scale(viewport.logical),
                ColorTransform::multiply(list.clear),
            ));
            items.push(Item::Entry(DrawEntry {
                mesh: self.background.clone(),
                index: (instances.len() - 1) as u32,
                pass: Pass::Draw,
                level: 0,
            }));
        }
        items.extend(list.items.iter().cloned());

        self.flush_paints();
        if instances.len() > self.instance_capacity {
            while self.instance_capacity < instances.len() {
                self.instance_capacity *= 2;
            }
            self.instance_buffer = create_instance_buffer(&self.device, self.instance_capacity);
        }
        self.queue
            .write_buffer(&self.instance_buffer, 0, bytemuck::cast_slice(&instances));
        let (row0, row1) = affine_rows(viewport.clip_transform());
        let view = GpuView {
            row0,
            row1,
            ramp: [
                self.ramp_capacity as f32,
                ATLAS_WIDTH as f32,
                self.atlas_capacity as f32,
                0.0,
            ],
        };
        self.queue
            .write_buffer(&self.view_buffer, 0, bytemuck::bytes_of(&view));

        // Mantıksal alanın dışına taşan çizimler (ör. paralaks katmanları) kırpılır.
        let (origin, extent) = viewport.content_rect();
        let x0 = origin.x.floor().max(0.0) as u32;
        let y0 = origin.y.floor().max(0.0) as u32;
        let x1 = ((origin.x + extent.x).ceil() as u32).min(size.x);
        let y1 = ((origin.y + extent.y).ceil() as u32).min(size.y);
        let scissor = [
            x0,
            y0,
            x1.saturating_sub(x0).max(1),
            y1.saturating_sub(y0).max(1),
        ];
        let mut frame = self.filter_frame(&items, size, viewport.scale);
        let mut encoder = self
            .device
            .create_command_encoder(&wgpu::CommandEncoderDescriptor {
                label: Some("çizim"),
            });
        let clear = wgpu::Color {
            r: f64::from(temiz.r),
            g: f64::from(temiz.g),
            b: f64::from(temiz.b),
            a: f64::from(temiz.a),
        };
        self.draw_items(
            &mut encoder,
            &mut frame,
            &items,
            (target, format),
            clear,
            scissor,
        );
        self.finish_filter_frame(frame);
        self.queue.submit([encoder.finish()]);
    }

    /// Bir katmanın (ya da en dıştaki listenin) çizimleri: önce içindeki süzgeçli katmanlar kendi
    /// dokularına çizilir, sonra bu hedefe tek geçişte çizim, maske ve katman koyma yapılır.
    fn draw_items(
        &mut self,
        encoder: &mut wgpu::CommandEncoder,
        frame: &mut FilterFrame,
        items: &[Item],
        (target, format): (&wgpu::TextureView, wgpu::TextureFormat),
        clear: wgpu::Color,
        scissor: [u32; 4],
    ) {
        let mut layers = Vec::new();
        for item in items {
            if let Item::Layer(layer) = item {
                let content = self.take_texture(frame);
                self.draw_items(
                    encoder,
                    frame,
                    &layer.items,
                    (&content.view, LAYER_FORMAT),
                    wgpu::Color::TRANSPARENT,
                    scissor,
                );
                let mut result = content;
                for filter in &layer.filters {
                    result = self.apply_filter(encoder, frame, filter, result);
                }
                let bind_group = self.composite_bind_group(frame, &result, format);
                layers.push((result, bind_group));
            }
        }
        let (msaa, stencil) = self.msaa_view(format, frame_size(frame));
        for pass in [Pass::Draw, Pass::MaskPush, Pass::MaskPop] {
            self.pipeline(format, pass);
        }
        {
            let mut pass = encoder.begin_render_pass(&wgpu::RenderPassDescriptor {
                label: Some("vektör geçişi"),
                color_attachments: &[Some(wgpu::RenderPassColorAttachment {
                    view: &msaa,
                    depth_slice: None,
                    resolve_target: Some(target),
                    ops: wgpu::Operations {
                        load: wgpu::LoadOp::Clear(clear),
                        store: wgpu::StoreOp::Discard,
                    },
                })],
                depth_stencil_attachment: Some(wgpu::RenderPassDepthStencilAttachment {
                    view: &stencil,
                    depth_ops: None,
                    stencil_ops: Some(wgpu::Operations {
                        load: wgpu::LoadOp::Clear(0),
                        store: wgpu::StoreOp::Discard,
                    }),
                }),
                timestamp_writes: None,
                occlusion_query_set: None,
                multiview_mask: None,
            });
            let [x, y, w, h] = scissor;
            pass.set_scissor_rect(x, y, w, h);
            pass.set_vertex_buffer(1, self.instance_buffer.slice(..));
            // Şu anki hat (çizim geçişi ya da katman koyma) ve kalıp değeri
            let mut current: Option<(Option<Pass>, u32)> = None;
            let mut next_layer = layers.iter();
            for item in items {
                match item {
                    Item::Entry(entry) => {
                        let Some((vb, ib)) = &entry.mesh.0.buffers else {
                            continue;
                        };
                        if current.map(|c| c.0) != Some(Some(entry.pass)) {
                            let Some(pipeline) = self.pipelines.get(&(format, entry.pass)) else {
                                continue;
                            };
                            pass.set_pipeline(pipeline);
                            pass.set_bind_group(0, &self.bind_group, &[]);
                        }
                        if current.map(|c| c.1) != Some(entry.level) {
                            pass.set_stencil_reference(entry.level);
                        }
                        current = Some((Some(entry.pass), entry.level));
                        pass.set_vertex_buffer(0, vb.slice(..));
                        pass.set_index_buffer(ib.slice(..), wgpu::IndexFormat::Uint32);
                        pass.draw_indexed(
                            0..entry.mesh.0.index_count,
                            0,
                            entry.index..entry.index + 1,
                        );
                    }
                    Item::Layer(layer) => {
                        let Some((_, Some(bind_group))) = next_layer.next() else {
                            continue;
                        };
                        let Some(pipeline) = self.composite_pipeline(format) else {
                            continue;
                        };
                        pass.set_pipeline(pipeline);
                        pass.set_bind_group(0, bind_group, &[0]);
                        pass.set_stencil_reference(layer.level);
                        current = Some((None, layer.level));
                        pass.draw(0..3, 0..1);
                    }
                }
            }
        }
        for (texture, _) in layers {
            frame_release(frame, texture);
        }
    }

    /// Çizim listesini ekransız bir resme çizer.
    pub fn render_to_image(
        &mut self,
        viewport: &Viewport,
        list: &DrawList,
    ) -> Result<RgbaImage, RenderError> {
        let size = viewport.physical;
        let limit = self.device.limits().max_texture_dimension_2d;
        if size.x > limit || size.y > limit {
            return Err(RenderError::TooLarge { size, limit });
        }
        let texture = self.device.create_texture(&wgpu::TextureDescriptor {
            label: Some("ekransız hedef"),
            size: wgpu::Extent3d {
                width: size.x,
                height: size.y,
                depth_or_array_layers: 1,
            },
            mip_level_count: 1,
            sample_count: 1,
            dimension: wgpu::TextureDimension::D2,
            format: IMAGE_FORMAT,
            usage: wgpu::TextureUsages::RENDER_ATTACHMENT | wgpu::TextureUsages::COPY_SRC,
            view_formats: &[],
        });
        let view = texture.create_view(&wgpu::TextureViewDescriptor::default());
        self.render(&view, IMAGE_FORMAT, viewport, list);

        let unpadded = size.x * 4;
        let padded = unpadded.div_ceil(wgpu::COPY_BYTES_PER_ROW_ALIGNMENT)
            * wgpu::COPY_BYTES_PER_ROW_ALIGNMENT;
        let buffer = self.device.create_buffer(&wgpu::BufferDescriptor {
            label: Some("okuma"),
            size: u64::from(padded) * u64::from(size.y),
            usage: wgpu::BufferUsages::COPY_DST | wgpu::BufferUsages::MAP_READ,
            mapped_at_creation: false,
        });
        let mut encoder = self
            .device
            .create_command_encoder(&wgpu::CommandEncoderDescriptor {
                label: Some("okuma"),
            });
        encoder.copy_texture_to_buffer(
            wgpu::TexelCopyTextureInfo {
                texture: &texture,
                mip_level: 0,
                origin: wgpu::Origin3d::ZERO,
                aspect: wgpu::TextureAspect::All,
            },
            wgpu::TexelCopyBufferInfo {
                buffer: &buffer,
                layout: wgpu::TexelCopyBufferLayout {
                    offset: 0,
                    bytes_per_row: Some(padded),
                    rows_per_image: None,
                },
            },
            wgpu::Extent3d {
                width: size.x,
                height: size.y,
                depth_or_array_layers: 1,
            },
        );
        let index = self.queue.submit([encoder.finish()]);
        let (tx, rx) = std::sync::mpsc::channel();
        buffer.map_async(wgpu::MapMode::Read, .., move |r| {
            let _ = tx.send(r);
        });
        self.device
            .poll(wgpu::PollType::Wait {
                submission_index: Some(index),
                timeout: None,
            })
            .map_err(|e| RenderError::Readback(e.to_string()))?;
        rx.recv()
            .map_err(|e| RenderError::Readback(e.to_string()))?
            .map_err(|e| RenderError::Readback(e.to_string()))?;
        let mut image = RgbaImage::new(size.x, size.y);
        {
            let mapped = buffer
                .get_mapped_range(..)
                .map_err(|e| RenderError::Readback(e.to_string()))?;
            for y in 0..size.y as usize {
                let src = &mapped[y * padded as usize..y * padded as usize + unpadded as usize];
                let dst = &mut image.data[y * unpadded as usize..(y + 1) * unpadded as usize];
                dst.copy_from_slice(src);
            }
        }
        buffer.unmap();
        unpremultiply(&mut image);
        Ok(image)
    }
}

/// Grafik kartı seçer: önce gerçek bir kart, yoksa yazılımla çalışan yedek kart.
pub fn request_adapter(
    instance: &wgpu::Instance,
    surface: Option<&wgpu::Surface<'_>>,
) -> Result<wgpu::Adapter, RenderError> {
    let first = pollster::block_on(instance.request_adapter(&wgpu::RequestAdapterOptions {
        power_preference: wgpu::PowerPreference::HighPerformance,
        force_fallback_adapter: false,
        compatible_surface: surface,
        apply_limit_buckets: false,
    }));
    match first {
        Ok(a) => Ok(a),
        Err(e) => pollster::block_on(instance.request_adapter(&wgpu::RequestAdapterOptions {
            power_preference: wgpu::PowerPreference::HighPerformance,
            force_fallback_adapter: true,
            compatible_surface: surface,
            apply_limit_buckets: false,
        }))
        .map_err(|e2| RenderError::NoAdapter(format!("{e}; yedek kart: {e2}"))),
    }
}

fn unpremultiply(image: &mut RgbaImage) {
    for px in image.data.as_chunks_mut::<4>().0 {
        let a = px[3];
        if a == 0 || a == 255 {
            continue;
        }
        for c in &mut px[..3] {
            *c = ((u32::from(*c) * 255 + u32::from(a) / 2) / u32::from(a)).min(255) as u8;
        }
    }
}

fn unit_square() -> Mesh {
    let v = |x: f32, y: f32| MeshVertex {
        position: Vec2::new(x, y).into(),
        paint: 0,
    };
    Mesh {
        vertices: vec![v(0.0, 0.0), v(1.0, 0.0), v(1.0, 1.0), v(0.0, 1.0)],
        indices: vec![0, 1, 2, 0, 2, 3],
        paints: vec![crate::paint::Paint::Solid(Color::WHITE)],
    }
}

fn create_paint_buffer(device: &wgpu::Device, capacity: usize) -> wgpu::Buffer {
    device.create_buffer(&wgpu::BufferDescriptor {
        label: Some("boya tablosu"),
        size: (capacity * std::mem::size_of::<GpuPaint>()) as u64,
        usage: wgpu::BufferUsages::STORAGE | wgpu::BufferUsages::COPY_DST,
        mapped_at_creation: false,
    })
}

fn create_ramp_texture(device: &wgpu::Device, rows: u32) -> wgpu::Texture {
    device.create_texture(&wgpu::TextureDescriptor {
        label: Some("degrade rampaları"),
        size: wgpu::Extent3d {
            width: RAMP_WIDTH as u32,
            height: rows,
            depth_or_array_layers: 1,
        },
        mip_level_count: 1,
        sample_count: 1,
        dimension: wgpu::TextureDimension::D2,
        format: wgpu::TextureFormat::Rgba8Unorm,
        usage: wgpu::TextureUsages::TEXTURE_BINDING | wgpu::TextureUsages::COPY_DST,
        view_formats: &[],
    })
}

fn create_atlas_texture(device: &wgpu::Device, rows: u32) -> wgpu::Texture {
    device.create_texture(&wgpu::TextureDescriptor {
        label: Some("resim atlası"),
        size: wgpu::Extent3d {
            width: ATLAS_WIDTH,
            height: rows,
            depth_or_array_layers: 1,
        },
        mip_level_count: 1,
        sample_count: 1,
        dimension: wgpu::TextureDimension::D2,
        format: wgpu::TextureFormat::Rgba8Unorm,
        usage: wgpu::TextureUsages::TEXTURE_BINDING | wgpu::TextureUsages::COPY_DST,
        view_formats: &[],
    })
}

fn create_instance_buffer(device: &wgpu::Device, capacity: usize) -> wgpu::Buffer {
    device.create_buffer(&wgpu::BufferDescriptor {
        label: Some("örnekler"),
        size: (capacity * std::mem::size_of::<GpuInstance>()) as u64,
        usage: wgpu::BufferUsages::VERTEX | wgpu::BufferUsages::COPY_DST,
        mapped_at_creation: false,
    })
}

fn create_bind_group(
    device: &wgpu::Device,
    layout: &wgpu::BindGroupLayout,
    view: &wgpu::Buffer,
    paints: &wgpu::Buffer,
    ramps: &wgpu::Texture,
    sampler: &wgpu::Sampler,
    atlas: &wgpu::Texture,
) -> wgpu::BindGroup {
    let ramp_view = ramps.create_view(&wgpu::TextureViewDescriptor::default());
    let atlas_view = atlas.create_view(&wgpu::TextureViewDescriptor::default());
    device.create_bind_group(&wgpu::BindGroupDescriptor {
        label: Some("vektör bağlama"),
        layout,
        entries: &[
            wgpu::BindGroupEntry {
                binding: 0,
                resource: view.as_entire_binding(),
            },
            wgpu::BindGroupEntry {
                binding: 1,
                resource: paints.as_entire_binding(),
            },
            wgpu::BindGroupEntry {
                binding: 2,
                resource: wgpu::BindingResource::TextureView(&ramp_view),
            },
            wgpu::BindGroupEntry {
                binding: 3,
                resource: wgpu::BindingResource::Sampler(sampler),
            },
            wgpu::BindGroupEntry {
                binding: 4,
                resource: wgpu::BindingResource::TextureView(&atlas_view),
            },
        ],
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn color_transform_composition() {
        let a = ColorTransform::alpha(0.5);
        let b = ColorTransform {
            mul: [0.5, 1.0, 1.0, 1.0],
            add: [0.1, 0.0, 0.0, 0.0],
        };
        let c = a.then(b);
        assert_eq!(c.mul, [0.5, 1.0, 1.0, 0.5]);
        assert_eq!(c.add, [0.1, 0.0, 0.0, 0.0]);
        assert_eq!(ColorTransform::IDENTITY.then(a), a);
    }

    #[test]
    fn unpremultiply_restores_color() {
        let mut img = RgbaImage::filled(1, 1, [64, 32, 0, 128]);
        unpremultiply(&mut img);
        assert_eq!(img.pixel(0, 0), [128, 64, 0, 128]);
    }
}
