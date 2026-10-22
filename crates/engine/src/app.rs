//! Pencere ve oyun döngüsü.
//!
//! Oyun [`Game`] özelliğini uygular; motor pencereyi açar, girdiyi toplar, oyunun kurallarını
//! saniyede sabit sayıda adımla ilerletir ve her karede oyunun çizim listesini çizer.
//! F11 tam ekran ile pencere arasında geçiş yapar.

use std::error::Error;
use std::fmt;
use std::sync::Arc;
use std::time::{Duration, Instant};

use glam::{UVec2, Vec2};
use winit::application::ApplicationHandler;
use winit::dpi::LogicalSize;
use winit::event::{ElementState, WindowEvent};
use winit::event_loop::{ActiveEventLoop, ControlFlow, EventLoop};
use winit::keyboard::{KeyCode, PhysicalKey};
use winit::window::{Fullscreen, Window, WindowId};

use crate::input::{Input, MouseButton};
use crate::render::{DrawList, Renderer, request_adapter};
use crate::time::FixedStep;
use crate::viewport::Viewport;

#[derive(Clone, Debug)]
pub struct AppConfig {
    pub title: String,
    /// Mantıksal ekran boyu (genellikle 1920×1080).
    pub logical_size: Vec2,
    /// Pencerenin açılıştaki boyu (işletim sisteminin ölçeklemesine göre).
    pub window_size: UVec2,
    /// Oyun kurallarının saniyedeki adım sayısı.
    pub ticks_per_second: u32,
    pub fullscreen: bool,
}

/// Oyunun motordan istekleri.
#[derive(Clone, Debug, Default)]
pub struct Control {
    quit: bool,
    fullscreen: Option<bool>,
}

impl Control {
    pub fn quit(&mut self) {
        self.quit = true;
    }

    pub fn set_fullscreen(&mut self, on: bool) {
        self.fullscreen = Some(on);
    }
}

/// Çizilen kare hakkında bilgi.
#[derive(Clone, Copy, Debug)]
pub struct FrameInfo {
    /// Son iki benzetim adımı arasındaki konum (0..1); hareketi yumuşatmak için.
    pub alpha: f32,
    pub viewport: Viewport,
    /// Son saniyedeki ortalama kare hızı.
    pub fps: f32,
}

pub trait Game {
    /// Oyun kurallarını bir sabit adım ilerletir.
    fn update(&mut self, input: &Input, control: &mut Control);
    /// Bir kare çizer.
    fn draw(&mut self, renderer: &mut Renderer, frame: &FrameInfo) -> DrawList;
}

#[derive(Debug)]
pub enum AppError {
    EventLoop(String),
    Window(String),
    Render(String),
    Game(String),
}

impl fmt::Display for AppError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            AppError::EventLoop(e) => write!(f, "olay döngüsü başlatılamadı: {e}"),
            AppError::Window(e) => write!(f, "pencere açılamadı: {e}"),
            AppError::Render(e) => write!(f, "grafik hatası: {e}"),
            AppError::Game(e) => write!(f, "oyun başlatılamadı: {e}"),
        }
    }
}

impl Error for AppError {}

/// Kare hızı sayacı.
#[derive(Clone, Debug, Default)]
pub struct FpsCounter {
    frames: u32,
    elapsed: f64,
    fps: f32,
}

impl FpsCounter {
    pub fn tick(&mut self, dt: f64) -> f32 {
        self.frames += 1;
        self.elapsed += dt;
        if self.elapsed >= 1.0 {
            self.fps = (f64::from(self.frames) / self.elapsed) as f32;
            self.frames = 0;
            self.elapsed = 0.0;
        }
        self.fps
    }
}

/// Oyunu kurmak için çağrılan işlev: grafik kartı hazır olunca bir kez çalışır.
pub type GameFactory<G> = Box<dyn FnOnce(&mut Renderer) -> Result<G, Box<dyn Error>>>;

/// Pencereyi açar ve oyun kapanana kadar çalıştırır.
pub fn run<G: Game + 'static>(config: AppConfig, make: GameFactory<G>) -> Result<(), AppError> {
    let event_loop = EventLoop::new().map_err(|e| AppError::EventLoop(e.to_string()))?;
    event_loop.set_control_flow(ControlFlow::Wait);
    let mut runner = Runner {
        config,
        make: Some(make),
        state: None,
        error: None,
    };
    event_loop
        .run_app(&mut runner)
        .map_err(|e| AppError::EventLoop(e.to_string()))?;
    match runner.error {
        Some(e) => Err(e),
        None => Ok(()),
    }
}

struct WindowState<G> {
    window: Arc<Window>,
    surface: wgpu::Surface<'static>,
    surface_config: wgpu::SurfaceConfiguration,
    view_format: wgpu::TextureFormat,
    renderer: Renderer,
    game: G,
    input: Input,
    clock: FixedStep,
    last: Instant,
    fps: FpsCounter,
    viewport: Viewport,
    logical: Vec2,
}

struct Runner<G> {
    config: AppConfig,
    make: Option<GameFactory<G>>,
    state: Option<WindowState<G>>,
    error: Option<AppError>,
}

impl<G: Game> Runner<G> {
    fn fail(&mut self, event_loop: &ActiveEventLoop, error: AppError) {
        log::error!("{error}");
        self.error = Some(error);
        event_loop.exit();
    }

    fn init(&mut self, event_loop: &ActiveEventLoop) -> Result<WindowState<G>, AppError> {
        let mut attrs = Window::default_attributes()
            .with_title(self.config.title.clone())
            .with_inner_size(LogicalSize::new(
                self.config.window_size.x,
                self.config.window_size.y,
            ))
            .with_min_inner_size(LogicalSize::new(640, 360));
        if self.config.fullscreen {
            attrs = attrs.with_fullscreen(Some(Fullscreen::Borderless(None)));
        }
        let window = Arc::new(
            event_loop
                .create_window(attrs)
                .map_err(|e| AppError::Window(e.to_string()))?,
        );
        let instance =
            wgpu::Instance::new(wgpu::InstanceDescriptor::new_with_display_handle_from_env(
                Box::new(event_loop.owned_display_handle()),
            ));
        let surface = instance
            .create_surface(window.clone())
            .map_err(|e| AppError::Render(e.to_string()))?;
        let adapter = request_adapter(&instance, Some(&surface))
            .map_err(|e| AppError::Render(e.to_string()))?;
        log::info!("grafik kartı: {:?}", adapter.get_info());
        let mut renderer =
            Renderer::from_adapter(&adapter).map_err(|e| AppError::Render(e.to_string()))?;

        let caps = surface.get_capabilities(&adapter);
        let (format, view_format) = choose_formats(&caps.formats)
            .ok_or_else(|| AppError::Render("yüzey için uygun renk biçimi yok".into()))?;
        let size = window.inner_size();
        let surface_config = wgpu::SurfaceConfiguration {
            usage: wgpu::TextureUsages::RENDER_ATTACHMENT,
            format,
            width: size.width.max(1),
            height: size.height.max(1),
            present_mode: wgpu::PresentMode::AutoVsync,
            color_space: wgpu::SurfaceColorSpace::Auto,
            desired_maximum_frame_latency: 2,
            alpha_mode: caps
                .alpha_modes
                .first()
                .copied()
                .unwrap_or(wgpu::CompositeAlphaMode::Auto),
            view_formats: if view_format == format {
                vec![]
            } else {
                vec![view_format]
            },
        };
        surface.configure(renderer.device(), &surface_config);

        let make = self
            .make
            .take()
            .ok_or_else(|| AppError::Game("oyun iki kez kurulamaz".into()))?;
        let game = make(&mut renderer).map_err(|e| AppError::Game(e.to_string()))?;
        let logical = self.config.logical_size;
        Ok(WindowState {
            viewport: Viewport::fit(
                logical,
                UVec2::new(surface_config.width, surface_config.height),
            ),
            window,
            surface,
            surface_config,
            view_format,
            renderer,
            game,
            input: Input::default(),
            clock: FixedStep::new(self.config.ticks_per_second, 8),
            last: Instant::now(),
            fps: FpsCounter::default(),
            logical,
        })
    }
}

/// Yüzey biçimini seçer: renkler sRGB uzayında karışsın diye "sRGB" olmayan bir görünüm gerekir.
fn choose_formats(
    formats: &[wgpu::TextureFormat],
) -> Option<(wgpu::TextureFormat, wgpu::TextureFormat)> {
    use wgpu::TextureFormat as F;
    for wanted in [F::Bgra8Unorm, F::Rgba8Unorm] {
        if formats.contains(&wanted) {
            return Some((wanted, wanted));
        }
    }
    for f in formats {
        let plain = f.remove_srgb_suffix();
        if matches!(plain, F::Bgra8Unorm | F::Rgba8Unorm) {
            return Some((*f, plain));
        }
    }
    formats.first().map(|f| (*f, f.remove_srgb_suffix()))
}

impl<G: Game> WindowState<G> {
    fn resize(&mut self, width: u32, height: u32) {
        if width == 0 || height == 0 {
            return;
        }
        self.surface_config.width = width;
        self.surface_config.height = height;
        self.surface
            .configure(self.renderer.device(), &self.surface_config);
        self.viewport = Viewport::fit(self.logical, UVec2::new(width, height));
    }

    fn toggle_fullscreen(&self, on: bool) {
        self.window
            .set_fullscreen(on.then_some(Fullscreen::Borderless(None)));
    }

    /// Bir kare: benzetim adımları, çizim, ekrana verme. Çıkış istenirse `true` döner.
    fn frame(&mut self) -> bool {
        let now = Instant::now();
        let dt = now
            .duration_since(self.last)
            .min(Duration::from_millis(250));
        self.last = now;
        let fps = self.fps.tick(dt.as_secs_f64());
        let mut control = Control::default();
        for _ in 0..self.clock.advance(dt.as_secs_f64()) {
            self.game.update(&self.input, &mut control);
            self.input.end_step();
        }
        if let Some(on) = control.fullscreen {
            self.toggle_fullscreen(on);
        }
        if control.quit {
            return true;
        }
        let info = FrameInfo {
            alpha: self.clock.alpha(),
            viewport: self.viewport,
            fps,
        };
        let list = self.game.draw(&mut self.renderer, &info);
        let texture = match self.surface.get_current_texture() {
            wgpu::CurrentSurfaceTexture::Success(t) => t,
            wgpu::CurrentSurfaceTexture::Suboptimal(t) => {
                // Bu kareyi çiz, sonra yüzeyi yeniden kur.
                self.draw_to(&t, &list);
                self.renderer.queue().present(t);
                let (w, h) = (self.surface_config.width, self.surface_config.height);
                self.resize(w, h);
                return false;
            }
            wgpu::CurrentSurfaceTexture::Outdated | wgpu::CurrentSurfaceTexture::Lost => {
                let (w, h) = (self.surface_config.width, self.surface_config.height);
                self.resize(w, h);
                return false;
            }
            wgpu::CurrentSurfaceTexture::Timeout | wgpu::CurrentSurfaceTexture::Occluded => {
                return false;
            }
            wgpu::CurrentSurfaceTexture::Validation => {
                log::error!("yüzey dokusu alınamadı (doğrulama hatası)");
                return false;
            }
        };
        self.draw_to(&texture, &list);
        self.renderer.queue().present(texture);
        false
    }

    fn draw_to(&mut self, texture: &wgpu::SurfaceTexture, list: &DrawList) {
        let view = texture.texture.create_view(&wgpu::TextureViewDescriptor {
            format: Some(self.view_format),
            ..Default::default()
        });
        self.renderer
            .render(&view, self.view_format, &self.viewport, list);
    }
}

impl<G: Game> ApplicationHandler for Runner<G> {
    fn resumed(&mut self, event_loop: &ActiveEventLoop) {
        if self.state.is_some() {
            return;
        }
        match self.init(event_loop) {
            Ok(state) => self.state = Some(state),
            Err(e) => self.fail(event_loop, e),
        }
    }

    fn window_event(&mut self, event_loop: &ActiveEventLoop, _id: WindowId, event: WindowEvent) {
        let Some(state) = self.state.as_mut() else {
            return;
        };
        match event {
            WindowEvent::CloseRequested => event_loop.exit(),
            WindowEvent::Resized(size) => state.resize(size.width, size.height),
            WindowEvent::Focused(false) => state.input.release_all(),
            WindowEvent::KeyboardInput { event, .. } => {
                if let PhysicalKey::Code(code) = event.physical_key {
                    let down = event.state == ElementState::Pressed;
                    if code == KeyCode::F11 && down && !event.repeat {
                        let on = state.window.fullscreen().is_none();
                        state.toggle_fullscreen(on);
                    }
                    state.input.on_key(code, down);
                }
            }
            WindowEvent::CursorMoved { position, .. } => {
                let p = Vec2::new(position.x as f32, position.y as f32);
                state
                    .input
                    .on_mouse_move(state.viewport.physical_to_logical(p));
            }
            WindowEvent::MouseInput {
                state: button_state,
                button,
                ..
            } => {
                let b = match button {
                    winit::event::MouseButton::Left => Some(MouseButton::Left),
                    winit::event::MouseButton::Right => Some(MouseButton::Right),
                    winit::event::MouseButton::Middle => Some(MouseButton::Middle),
                    _ => None,
                };
                if let Some(b) = b {
                    state
                        .input
                        .on_mouse_button(b, button_state == ElementState::Pressed);
                }
            }
            WindowEvent::RedrawRequested if state.frame() => event_loop.exit(),
            _ => {}
        }
    }

    fn about_to_wait(&mut self, _event_loop: &ActiveEventLoop) {
        if let Some(state) = &self.state {
            state.window.request_redraw();
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use wgpu::TextureFormat as F;

    #[test]
    fn prefers_non_srgb_surface_formats() {
        assert_eq!(
            choose_formats(&[F::Bgra8UnormSrgb, F::Bgra8Unorm]),
            Some((F::Bgra8Unorm, F::Bgra8Unorm))
        );
        assert_eq!(
            choose_formats(&[F::Rgba8UnormSrgb]),
            Some((F::Rgba8UnormSrgb, F::Rgba8Unorm))
        );
        assert_eq!(choose_formats(&[]), None);
    }

    #[test]
    fn fps_counter_averages_over_a_second() {
        let mut c = FpsCounter::default();
        let mut fps = 0.0;
        for _ in 0..60 {
            fps = c.tick(1.0 / 60.0);
        }
        assert!((fps - 60.0).abs() < 0.5, "{fps}");
    }

    #[test]
    fn control_requests() {
        let mut c = Control::default();
        c.set_fullscreen(true);
        c.quit();
        assert!(c.quit && c.fullscreen == Some(true));
    }
}
