//! Flash tarzı sembol kütüphanesi ve zaman çizelgesi oynatıcı.
//!
//! Kütüphane (`library.json`; `araclar/aktar/aktar.py` üretir) sembolleri ve zaman çizelgelerini
//! SWF'deki gibi tutar: her kare bir işlem listesidir (yerleştir, taşı, kaldır). Oynatıcı ([`Clip`]) bu
//! işlemleri sırayla uygulayarak her karenin görüntü listesini kurar; [`Clip::draw_commands`] iç içe
//! sprite'ları düzleştirip çizim sırasıyla çizim komutlarını verir (matris ve renk dönüşümü
//! birleşmiş, maskeler başlangıç ve bitiş komutlarıyla).
//!
//! Kurallar (Flash 8 oynatıcısının davranışı):
//! - Bir karenin işlemleri o kareye girilince uygulanır, ardından karenin komutları (dur, oynat,
//!   git, olay) çalışır.
//! - Yerleştir (karakter var, "taşı" yok): derinliğe yeni örnek konur; oradaki örnek gider.
//! - Taşı: derinlikteki örneğin yalnız verilen alanları değişir; karakter de verilmişse karakter değişir.
//! - Sprite örnekleri kendi zaman çizelgelerini bağımsız oynatır; yeni konan sprite 1. karesindedir.
//! - Geriye gitmek ya da sona gelip başa dönmek görüntü listesini baştan kurar. İleri atlamada aradaki
//!   karelerin işlemleri uygulanır, komutları çalışmaz.
//! - Karesi olmayan sprite (SWF başlığında 1, kütüphanede 0 kare) 1 boş karelik sayılır.
//! - Kütüphanede tanımı olmayan karakter (ör. dışarıda bırakılmış sponsor logosu) yerleştirilmez.
//! - Kırpma derinliği olan örnek maskedir: kendisinden sonraki, derinliği kırpma derinliğine kadar olan
//!   örnekler yalnız onun içinde görünür; kendisi görünmez.

use std::collections::{BTreeMap, HashMap, HashSet};
use std::fmt;

use glam::{Affine2, Vec2};
use serde_json::Value;

use crate::render::ColorTransform;

/// Karakter (sembol) kimliği.
pub type CharId = u16;
/// Görüntü listesinde derinlik.
pub type Depth = u16;

#[derive(Debug)]
pub enum MovieError {
    Json(String),
    Field(String),
}

impl fmt::Display for MovieError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            MovieError::Json(e) => write!(f, "kütüphane okunamadı: {e}"),
            MovieError::Field(e) => write!(f, "kütüphanede hatalı alan: {e}"),
        }
    }
}

impl std::error::Error for MovieError {}

/// Zaman çizelgesinde yerleştirme ya da taşıma.
#[derive(Clone, Debug, PartialEq)]
pub struct Place {
    pub depth: Depth,
    /// Var olan örneği değiştir (yoksa yeni örnek koy).
    pub moves: bool,
    pub char: Option<CharId>,
    pub matrix: Option<Affine2>,
    pub color: Option<ColorTransform>,
    /// Morph oranı (0 başlangıç, 1 bitiş).
    pub ratio: Option<f32>,
    pub name: Option<String>,
    /// Kırpma derinliği: bu örnek maskedir.
    pub clip: Option<Depth>,
    pub visible: Option<bool>,
}

#[derive(Clone, Debug, PartialEq)]
pub enum FrameOp {
    Place(Place),
    Remove(Depth),
}

/// Kare komutu (kare betiğinden çıkarılan basit komutlar).
#[derive(Clone, Debug, PartialEq)]
pub enum Action {
    Stop,
    Play,
    /// Kare sırası 0'dan.
    GotoFrame {
        frame: usize,
        play: bool,
    },
    GotoLabel {
        label: String,
        play: bool,
    },
    /// Üst sprite'a bildirilen an (ör. vuruş).
    Event(String),
}

/// Ses başlatma ya da durdurma.
#[derive(Clone, Debug, PartialEq)]
pub struct SoundStart {
    pub id: CharId,
    pub stop: bool,
}

#[derive(Clone, Debug, Default, PartialEq)]
pub struct Timeline {
    pub frames: Vec<Vec<FrameOp>>,
    /// Etiket → kare sırası (0'dan).
    pub labels: HashMap<String, usize>,
    pub actions: HashMap<usize, Vec<Action>>,
    pub sounds: HashMap<usize, Vec<SoundStart>>,
}

impl Timeline {
    /// Kare sayısı; karesi olmayan zaman çizelgesi 1 boş karelidir.
    pub fn frame_count(&self) -> usize {
        self.frames.len().max(1)
    }
}

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct ButtonStates {
    pub up: bool,
    pub over: bool,
    pub down: bool,
    pub hit: bool,
}

#[derive(Clone, Debug, PartialEq)]
pub struct ButtonRecord {
    pub states: ButtonStates,
    pub char: CharId,
    pub depth: Depth,
    pub matrix: Affine2,
    pub color: ColorTransform,
}

/// Düğmenin görünen durumu.
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub enum ButtonState {
    #[default]
    Up,
    Over,
    Down,
}

/// Kütüphanedeki sembol.
#[derive(Clone, Debug, PartialEq)]
pub enum Symbol {
    /// Vektör şekil; `origin`: SVG'nin sol üst köşesinin şeklin kendi koordinatlarındaki yeri.
    Shape {
        origin: Vec2,
    },
    /// Resim dolgulu şekil.
    BitmapShape {
        origin: Vec2,
    },
    /// Morph şekil (başlangıç ve bitiş uçları ayrı SVG).
    Morph {
        origin: Vec2,
    },
    Sprite(Timeline),
    Button(Vec<ButtonRecord>),
    /// Sabit yazı.
    Text,
    /// Yazı alanı.
    EditText,
}

#[derive(Clone, Debug, PartialEq)]
pub struct Stage {
    pub width: f32,
    pub height: f32,
    pub fps: f32,
    pub background: String,
}

#[derive(Clone, Debug)]
pub struct Library {
    pub stage: Stage,
    pub symbols: HashMap<CharId, Symbol>,
    pub root: Timeline,
    pub exports: HashMap<String, CharId>,
    /// Bilerek aktarılmamış karakterler (neden).
    pub excluded: HashMap<CharId, String>,
    /// İnce çizgiler: şekil → [(yolun belgedeki sırası, özgün kalınlık)].
    pub hairlines: HashMap<CharId, Vec<(usize, f32)>>,
}

pub(crate) fn field(what: &str) -> MovieError {
    MovieError::Field(what.to_string())
}

pub(crate) fn as_f32(v: &Value, what: &str) -> Result<f32, MovieError> {
    v.as_f64().map(|x| x as f32).ok_or_else(|| field(what))
}

pub(crate) fn as_id(text: &str) -> Result<CharId, MovieError> {
    text.parse().map_err(|_| field(&format!("kimlik {text}")))
}

fn as_u16(v: &Value, what: &str) -> Result<u16, MovieError> {
    v.as_u64()
        .and_then(|x| u16::try_from(x).ok())
        .ok_or_else(|| field(what))
}

fn floats(v: &Value, n: usize, what: &str) -> Result<Vec<f32>, MovieError> {
    let list = v.as_array().ok_or_else(|| field(what))?;
    if list.len() != n {
        return Err(field(what));
    }
    list.iter().map(|x| as_f32(x, what)).collect()
}

pub(crate) fn matrix(v: &Value) -> Result<Affine2, MovieError> {
    let m = floats(v, 6, "matrix")?;
    Ok(Affine2::from_cols_array(&[
        m[0], m[1], m[2], m[3], m[4], m[5],
    ]))
}

fn cxform(v: &Value) -> Result<ColorTransform, MovieError> {
    let parts = v.as_array().ok_or_else(|| field("cxform"))?;
    if parts.len() != 2 {
        return Err(field("cxform"));
    }
    let mul = floats(&parts[0], 4, "cxform")?;
    let add = floats(&parts[1], 4, "cxform")?;
    Ok(ColorTransform {
        mul: [mul[0], mul[1], mul[2], mul[3]],
        add: [add[0], add[1], add[2], add[3]],
    })
}

fn origin(v: &Value) -> Result<Vec2, MovieError> {
    let o = floats(v, 2, "origin")?;
    Ok(Vec2::new(o[0], o[1]))
}

fn frame_op(v: &Value) -> Result<FrameOp, MovieError> {
    if let Some(depth) = v.get("remove") {
        return Ok(FrameOp::Remove(as_u16(depth, "remove")?));
    }
    let depth = as_u16(v.get("depth").ok_or_else(|| field("depth"))?, "depth")?;
    Ok(FrameOp::Place(Place {
        depth,
        moves: v.get("move").and_then(Value::as_bool).unwrap_or(false),
        char: v.get("char").map(|c| as_u16(c, "char")).transpose()?,
        matrix: v.get("matrix").map(matrix).transpose()?,
        color: v.get("cxform").map(cxform).transpose()?,
        ratio: v.get("ratio").map(|r| as_f32(r, "ratio")).transpose()?,
        name: v.get("name").and_then(Value::as_str).map(str::to_string),
        clip: v.get("clip").map(|c| as_u16(c, "clip")).transpose()?,
        visible: v.get("visible").and_then(Value::as_bool),
    }))
}

fn action(v: &Value) -> Result<Action, MovieError> {
    if v.get("stop").is_some() {
        return Ok(Action::Stop);
    }
    if let Some(target) = v.get("goto") {
        let play = v.get("play").and_then(Value::as_bool).unwrap_or(false);
        return match target {
            // Kare betiklerindeki kare numarası 1'den başlar
            Value::Number(n) => Ok(Action::GotoFrame {
                frame: (n.as_u64().ok_or_else(|| field("goto"))? as usize).saturating_sub(1),
                play,
            }),
            Value::String(label) => Ok(Action::GotoLabel {
                label: label.clone(),
                play,
            }),
            _ => Err(field("goto")),
        };
    }
    if let Some(name) = v.get("event").and_then(Value::as_str) {
        return Ok(Action::Event(name.to_string()));
    }
    if v.get("play").is_some() {
        return Ok(Action::Play);
    }
    Err(field("action"))
}

fn by_frame<T>(
    v: Option<&Value>,
    item: impl Fn(&Value) -> Result<T, MovieError>,
) -> Result<HashMap<usize, Vec<T>>, MovieError> {
    let mut out = HashMap::new();
    if let Some(map) = v.and_then(Value::as_object) {
        for (frame, list) in map {
            let frame: usize = frame.parse().map_err(|_| field("kare"))?;
            let list = list.as_array().ok_or_else(|| field("kare listesi"))?;
            out.insert(frame, list.iter().map(&item).collect::<Result<_, _>>()?);
        }
    }
    Ok(out)
}

fn timeline(v: &Value) -> Result<Timeline, MovieError> {
    let frames = v
        .get("frames")
        .and_then(Value::as_array)
        .ok_or_else(|| field("frames"))?
        .iter()
        .map(|ops| {
            ops.as_array()
                .ok_or_else(|| field("frames"))?
                .iter()
                .map(frame_op)
                .collect::<Result<Vec<_>, _>>()
        })
        .collect::<Result<Vec<_>, _>>()?;
    let mut labels = HashMap::new();
    if let Some(map) = v.get("labels").and_then(Value::as_object) {
        for (name, frame) in map {
            let frame = frame.as_u64().ok_or_else(|| field("labels"))? as usize;
            labels.insert(name.clone(), frame);
        }
    }
    Ok(Timeline {
        frames,
        labels,
        actions: by_frame(v.get("actions"), action)?,
        sounds: by_frame(v.get("sounds"), |s| {
            Ok(SoundStart {
                id: as_u16(s.get("id").ok_or_else(|| field("sound"))?, "sound")?,
                stop: s.get("stop").and_then(Value::as_bool).unwrap_or(false),
            })
        })?,
    })
}

fn button(v: &Value) -> Result<Vec<ButtonRecord>, MovieError> {
    v.as_array()
        .ok_or_else(|| field("button"))?
        .iter()
        .map(|r| {
            let states = r
                .get("states")
                .and_then(Value::as_array)
                .ok_or_else(|| field("states"))?;
            let has = |s: &str| states.iter().any(|x| x.as_str() == Some(s));
            Ok(ButtonRecord {
                states: ButtonStates {
                    up: has("up"),
                    over: has("over"),
                    down: has("down"),
                    hit: has("hit"),
                },
                char: as_u16(r.get("char").ok_or_else(|| field("char"))?, "char")?,
                depth: as_u16(r.get("depth").ok_or_else(|| field("depth"))?, "depth")?,
                matrix: r
                    .get("matrix")
                    .map(matrix)
                    .transpose()?
                    .unwrap_or(Affine2::IDENTITY),
                color: r
                    .get("cxform")
                    .map(cxform)
                    .transpose()?
                    .unwrap_or(ColorTransform::IDENTITY),
            })
        })
        .collect()
}

pub(crate) fn entries(v: &Value, key: &str) -> impl Iterator<Item = (String, Value)> {
    v.get(key)
        .and_then(Value::as_object)
        .map(|m| {
            m.iter()
                .map(|(k, x)| (k.clone(), x.clone()))
                .collect::<Vec<_>>()
        })
        .unwrap_or_default()
        .into_iter()
}

impl Library {
    /// `library.json` ve isteğe bağlı `texts.json` (sabit yazılar ve yazı alanları sembol olarak eklenir).
    pub fn from_json(library: &[u8], texts: Option<&[u8]>) -> Result<Self, MovieError> {
        let v: Value =
            serde_json::from_slice(library).map_err(|e| MovieError::Json(e.to_string()))?;
        let stage = v.get("stage").ok_or_else(|| field("stage"))?;
        let stage = Stage {
            width: as_f32(stage.get("width").ok_or_else(|| field("width"))?, "width")?,
            height: as_f32(
                stage.get("height").ok_or_else(|| field("height"))?,
                "height",
            )?,
            fps: as_f32(stage.get("fps").ok_or_else(|| field("fps"))?, "fps")?,
            background: stage
                .get("background")
                .and_then(Value::as_str)
                .unwrap_or("#FFFFFF")
                .to_string(),
        };
        let mut symbols = HashMap::new();
        for (id, o) in entries(&v, "shapes") {
            symbols.insert(
                as_id(&id)?,
                Symbol::Shape {
                    origin: origin(&o)?,
                },
            );
        }
        for (id, o) in entries(&v, "bitmap_shapes") {
            symbols.insert(
                as_id(&id)?,
                Symbol::BitmapShape {
                    origin: origin(&o)?,
                },
            );
        }
        for (id, o) in entries(&v, "morphs") {
            symbols.insert(
                as_id(&id)?,
                Symbol::Morph {
                    origin: origin(&o)?,
                },
            );
        }
        for (id, t) in entries(&v, "sprites") {
            symbols.insert(as_id(&id)?, Symbol::Sprite(timeline(&t)?));
        }
        for (id, b) in entries(&v, "buttons") {
            symbols.insert(as_id(&id)?, Symbol::Button(button(&b)?));
        }
        if let Some(texts) = texts {
            let t: Value =
                serde_json::from_slice(texts).map_err(|e| MovieError::Json(e.to_string()))?;
            for (id, _) in entries(&t, "texts") {
                symbols.insert(as_id(&id)?, Symbol::Text);
            }
            for (id, _) in entries(&t, "edit_texts") {
                symbols.insert(as_id(&id)?, Symbol::EditText);
            }
        }
        let mut exports = HashMap::new();
        for (name, id) in entries(&v, "exports") {
            exports.insert(name, as_u16(&id, "exports")?);
        }
        let mut excluded = HashMap::new();
        for (id, reason) in entries(&v, "excluded") {
            excluded.insert(as_id(&id)?, reason.as_str().unwrap_or_default().to_string());
        }
        let mut hairlines = HashMap::new();
        for (id, list) in entries(&v, "hairlines") {
            let list = list
                .as_array()
                .ok_or_else(|| field("hairlines"))?
                .iter()
                .map(|p| {
                    let index = p
                        .get(0)
                        .and_then(Value::as_u64)
                        .ok_or_else(|| field("hairlines"))?;
                    let width = as_f32(p.get(1).ok_or_else(|| field("hairlines"))?, "hairlines")?;
                    Ok((index as usize, width))
                })
                .collect::<Result<Vec<_>, MovieError>>()?;
            hairlines.insert(as_id(&id)?, list);
        }
        Ok(Library {
            stage,
            symbols,
            root: timeline(v.get("root").ok_or_else(|| field("root"))?)?,
            exports,
            excluded,
            hairlines,
        })
    }

    pub fn symbol(&self, id: CharId) -> Option<&Symbol> {
        self.symbols.get(&id)
    }

    fn timeline(&self, source: Source) -> Option<&Timeline> {
        match source {
            Source::Root => Some(&self.root),
            Source::Sprite(id) => match self.symbols.get(&id) {
                Some(Symbol::Sprite(t)) => Some(t),
                _ => None,
            },
        }
    }
}

/// Oynatıcının bildirdiği şey: ses başlatma/durdurma ya da kare betiğinden bir olay.
#[derive(Clone, Debug, PartialEq)]
pub enum Event {
    Sound(SoundStart),
    /// Sprite'ın (kimliği) kare betiğindeki olay (ör. "directHit").
    Script {
        sprite: Option<CharId>,
        name: String,
    },
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
enum Source {
    Root,
    Sprite(CharId),
}

/// Görüntü listesindeki örnek.
#[derive(Clone, Debug)]
pub struct Instance {
    pub char: CharId,
    pub matrix: Affine2,
    pub color: ColorTransform,
    pub ratio: f32,
    pub name: Option<String>,
    pub clip: Option<Depth>,
    pub visible: bool,
    pub button_state: ButtonState,
    /// Sprite örneğinin kendi oynatıcısı.
    pub clip_player: Option<Box<Clip>>,
}

/// Bir zaman çizelgesinin oynatıcısı (kök film ya da bir sprite örneği).
#[derive(Clone, Debug)]
pub struct Clip {
    source: Source,
    frame: usize,
    playing: bool,
    display: BTreeMap<Depth, Instance>,
    /// Bu karede konan örneklerin derinlikleri (kendi 1. karelerindedir; bu karede ilerlemezler).
    placed: HashSet<Depth>,
}

/// Bir karede yapılabilecek en çok "git" komutu (birbirine giden komutlarla sonsuz döngüye karşı).
const MAX_GOTOS: usize = 16;

impl Clip {
    /// Kök filmin oynatıcısı, 1. karesinde.
    pub fn root(lib: &Library, events: &mut Vec<Event>) -> Clip {
        Clip::start(lib, Source::Root, events)
    }

    /// Bir sprite'ın oynatıcısı, 1. karesinde.
    pub fn sprite(lib: &Library, id: CharId, events: &mut Vec<Event>) -> Clip {
        Clip::start(lib, Source::Sprite(id), events)
    }

    fn start(lib: &Library, source: Source, events: &mut Vec<Event>) -> Clip {
        let mut clip = Clip {
            source,
            frame: 0,
            playing: true,
            display: BTreeMap::new(),
            placed: HashSet::new(),
        };
        clip.apply_frame(lib, 0, events);
        clip.run_frame_script(lib, events, 0);
        clip
    }

    /// Şu anki kare (0'dan).
    pub fn frame(&self) -> usize {
        self.frame
    }

    pub fn is_playing(&self) -> bool {
        self.playing
    }

    pub fn frame_count(&self, lib: &Library) -> usize {
        lib.timeline(self.source).map_or(1, Timeline::frame_count)
    }

    /// Görüntü listesi (derinlik sırasıyla).
    pub fn display(&self) -> &BTreeMap<Depth, Instance> {
        &self.display
    }

    /// Adıyla bir alt örnek.
    pub fn child(&self, name: &str) -> Option<&Instance> {
        self.display
            .values()
            .find(|i| i.name.as_deref() == Some(name))
    }

    pub fn child_mut(&mut self, name: &str) -> Option<&mut Instance> {
        self.display
            .values_mut()
            .find(|i| i.name.as_deref() == Some(name))
    }

    pub fn play(&mut self) {
        self.playing = true;
    }

    pub fn stop(&mut self) {
        self.playing = false;
    }

    /// Bir sonraki kare (saniyede kütüphanenin kare hızı kadar çağrılır): önce bu oynatıcı ilerler,
    /// sonra bu karede yeni konmamış alt sprite'lar.
    pub fn tick(&mut self, lib: &Library, events: &mut Vec<Event>) {
        self.placed.clear();
        if self.playing {
            let count = self.frame_count(lib);
            if count > 1 {
                let next = (self.frame + 1) % count;
                self.enter(lib, next, events, 0);
            }
        }
        for (depth, inst) in self.display.iter_mut() {
            if !self.placed.contains(depth)
                && let Some(child) = inst.clip_player.as_mut()
            {
                child.tick(lib, events);
            }
        }
    }

    /// Bir kareye git (0'dan) ve oynamayı ya da durmayı seç.
    pub fn goto(&mut self, lib: &Library, frame: usize, play: bool, events: &mut Vec<Event>) {
        self.playing = play;
        let frame = frame.min(self.frame_count(lib) - 1);
        self.enter(lib, frame, events, 0);
    }

    /// Bir etikete git; etiket yoksa hiçbir şey olmaz.
    pub fn goto_label(&mut self, lib: &Library, label: &str, play: bool, events: &mut Vec<Event>) {
        if let Some(frame) = lib
            .timeline(self.source)
            .and_then(|t| t.labels.get(label))
            .copied()
        {
            self.goto(lib, frame, play, events);
        }
    }

    fn enter(&mut self, lib: &Library, frame: usize, events: &mut Vec<Event>, gotos: usize) {
        // Bulunulan kareye gitmek bir şey değiştirmez
        if frame == self.frame {
            return;
        }
        if frame <= self.frame {
            self.display.clear();
            for f in 0..=frame {
                self.apply_frame(lib, f, events);
            }
        } else {
            for f in self.frame + 1..=frame {
                self.apply_frame(lib, f, events);
            }
        }
        self.frame = frame;
        self.run_frame_script(lib, events, gotos);
    }

    fn run_frame_script(&mut self, lib: &Library, events: &mut Vec<Event>, gotos: usize) {
        let Some(t) = lib.timeline(self.source) else {
            return;
        };
        if let Some(sounds) = t.sounds.get(&self.frame) {
            events.extend(sounds.iter().cloned().map(Event::Sound));
        }
        let actions = t.actions.get(&self.frame).cloned().unwrap_or_default();
        for a in actions {
            match a {
                Action::Stop => self.playing = false,
                Action::Play => self.playing = true,
                Action::Event(name) => events.push(Event::Script {
                    sprite: match self.source {
                        Source::Root => None,
                        Source::Sprite(id) => Some(id),
                    },
                    name,
                }),
                Action::GotoFrame { frame, play } => {
                    if gotos < MAX_GOTOS {
                        self.playing = play;
                        let frame = frame.min(self.frame_count(lib) - 1);
                        self.enter(lib, frame, events, gotos + 1);
                    }
                    return;
                }
                Action::GotoLabel { label, play } => {
                    if let Some(frame) = t.labels.get(&label).copied()
                        && gotos < MAX_GOTOS
                    {
                        self.playing = play;
                        self.enter(lib, frame, events, gotos + 1);
                    }
                    return;
                }
            }
        }
    }

    fn apply_frame(&mut self, lib: &Library, frame: usize, events: &mut Vec<Event>) {
        let Some(ops) = lib.timeline(self.source).and_then(|t| t.frames.get(frame)) else {
            return;
        };
        for op in ops {
            match op {
                FrameOp::Remove(depth) => {
                    self.display.remove(depth);
                }
                FrameOp::Place(p) => self.place(lib, p, events),
            }
        }
    }

    fn new_instance(lib: &Library, char: CharId, p: &Place, events: &mut Vec<Event>) -> Instance {
        let clip_player = match lib.symbol(char) {
            Some(Symbol::Sprite(_)) => Some(Box::new(Clip::sprite(lib, char, events))),
            _ => None,
        };
        Instance {
            char,
            matrix: p.matrix.unwrap_or(Affine2::IDENTITY),
            color: p.color.unwrap_or(ColorTransform::IDENTITY),
            ratio: p.ratio.unwrap_or(0.0),
            name: p.name.clone(),
            clip: p.clip,
            visible: p.visible.unwrap_or(true),
            button_state: ButtonState::Up,
            clip_player,
        }
    }

    fn place(&mut self, lib: &Library, p: &Place, events: &mut Vec<Event>) {
        let defined = |c: CharId| lib.symbol(c).is_some();
        if !p.moves {
            match p.char {
                Some(c) if defined(c) => {
                    let inst = Clip::new_instance(lib, c, p, events);
                    self.display.insert(p.depth, inst);
                    self.placed.insert(p.depth);
                }
                // Tanımı olmayan karakter yerleştirilmez; derinlik boş kalır
                _ => {
                    self.display.remove(&p.depth);
                }
            }
            return;
        }
        let Some(inst) = self.display.get_mut(&p.depth) else {
            return;
        };
        if let Some(c) = p.char
            && c != inst.char
            && defined(c)
        {
            let mut fresh = Clip::new_instance(lib, c, p, events);
            fresh.matrix = p.matrix.unwrap_or(inst.matrix);
            fresh.color = p.color.unwrap_or(inst.color);
            fresh.ratio = p.ratio.unwrap_or(inst.ratio);
            fresh.name = p.name.clone().or(inst.name.take());
            fresh.clip = p.clip.or(inst.clip);
            *inst = fresh;
            self.placed.insert(p.depth);
            return;
        }
        if let Some(m) = p.matrix {
            inst.matrix = m;
        }
        if let Some(c) = p.color {
            inst.color = c;
        }
        if let Some(r) = p.ratio {
            inst.ratio = r;
        }
        if let Some(n) = &p.name {
            inst.name = Some(n.clone());
        }
        if let Some(c) = p.clip {
            inst.clip = Some(c);
        }
        if let Some(v) = p.visible {
            inst.visible = v;
        }
    }

    /// Bu karenin çizim komutları, çizim sırasıyla. `transform` ve `color` en dıştaki dönüşümlerdir
    /// (ör. sahneyi ekrana yerleştiren matris).
    pub fn draw_commands(
        &self,
        lib: &Library,
        transform: Affine2,
        color: ColorTransform,
    ) -> Vec<DrawCommand> {
        let mut out = Vec::new();
        self.collect(lib, transform, color, &mut out);
        out
    }

    fn collect(
        &self,
        lib: &Library,
        transform: Affine2,
        color: ColorTransform,
        out: &mut Vec<DrawCommand>,
    ) {
        collect_list(
            lib,
            self.display.iter().map(|(d, i)| (*d, i)),
            transform,
            color,
            out,
        );
    }
}

/// Çizilecek tek bir sembol.
#[derive(Clone, Debug, PartialEq)]
pub enum DrawKind {
    Shape(CharId),
    BitmapShape(CharId),
    Morph { id: CharId, ratio: f32 },
    Text(CharId),
    EditText(CharId),
}

#[derive(Clone, Debug, PartialEq)]
pub struct DrawItem {
    pub kind: DrawKind,
    /// Sembolün kendi koordinatlarından ekrana dönüşüm. Şekiller için SVG'nin sol üst köşesi
    /// (`Symbol::Shape::origin`) bu dönüşüme dahil değildir; bkz. [`DrawItem::svg_transform`].
    pub transform: Affine2,
    pub color: ColorTransform,
}

impl DrawItem {
    /// SVG dosyasının (kendi sol üst köşesinden başlayan) çizimini ekrana taşıyan dönüşüm.
    pub fn svg_transform(&self, lib: &Library) -> Affine2 {
        let id = match self.kind {
            DrawKind::Shape(id) | DrawKind::BitmapShape(id) | DrawKind::Morph { id, .. } => id,
            DrawKind::Text(_) | DrawKind::EditText(_) => return self.transform,
        };
        match lib.symbol(id) {
            Some(
                Symbol::Shape { origin }
                | Symbol::BitmapShape { origin }
                | Symbol::Morph { origin },
            ) => self.transform * Affine2::from_translation(*origin),
            _ => self.transform,
        }
    }
}

#[derive(Clone, Debug, PartialEq)]
pub enum DrawCommand {
    Draw(DrawItem),
    /// Maske başlar: sonraki çizimler, `MaskEnd`'e kadar, bu şekillerin içinde görünür.
    MaskStart(Vec<DrawItem>),
    MaskEnd,
}

fn collect_list<'a>(
    lib: &Library,
    list: impl Iterator<Item = (Depth, &'a Instance)>,
    transform: Affine2,
    color: ColorTransform,
    out: &mut Vec<DrawCommand>,
) {
    let mut masks: Vec<Depth> = Vec::new();
    for (depth, inst) in list {
        while masks.last().is_some_and(|&end| depth > end) {
            masks.pop();
            out.push(DrawCommand::MaskEnd);
        }
        let t = transform * inst.matrix;
        let c = inst.color.then(color);
        if let Some(end) = inst.clip {
            // Maskenin kendisi görünmez; yalnız şekilleri kırpma alanı olur
            let mut mask = Vec::new();
            instance_commands(lib, inst, t, c, &mut mask);
            let items = mask
                .into_iter()
                .filter_map(|cmd| match cmd {
                    DrawCommand::Draw(item) => Some(item),
                    _ => None,
                })
                .collect();
            out.push(DrawCommand::MaskStart(items));
            masks.push(end);
            continue;
        }
        if inst.visible {
            instance_commands(lib, inst, t, c, out);
        }
    }
    for _ in masks {
        out.push(DrawCommand::MaskEnd);
    }
}

fn instance_commands(
    lib: &Library,
    inst: &Instance,
    t: Affine2,
    c: ColorTransform,
    out: &mut Vec<DrawCommand>,
) {
    let item = |kind| {
        DrawCommand::Draw(DrawItem {
            kind,
            transform: t,
            color: c,
        })
    };
    match lib.symbol(inst.char) {
        Some(Symbol::Shape { .. }) => out.push(item(DrawKind::Shape(inst.char))),
        Some(Symbol::BitmapShape { .. }) => out.push(item(DrawKind::BitmapShape(inst.char))),
        Some(Symbol::Morph { .. }) => out.push(item(DrawKind::Morph {
            id: inst.char,
            ratio: inst.ratio,
        })),
        Some(Symbol::Text) => out.push(item(DrawKind::Text(inst.char))),
        Some(Symbol::EditText) => out.push(item(DrawKind::EditText(inst.char))),
        Some(Symbol::Sprite(_)) => {
            if let Some(child) = &inst.clip_player {
                child.collect(lib, t, c, out);
            }
        }
        Some(Symbol::Button(records)) => {
            let shown = |r: &&ButtonRecord| match inst.button_state {
                ButtonState::Up => r.states.up,
                ButtonState::Over => r.states.over,
                ButtonState::Down => r.states.down,
            };
            let mut records: Vec<&ButtonRecord> = records.iter().filter(shown).collect();
            records.sort_by_key(|r| r.depth);
            // Düğmenin içindeki sprite'lar burada 1. karelerinde çizilir (düğme durumu değişince baştan)
            let children: Vec<(Depth, Instance)> = records
                .iter()
                .map(|r| {
                    let place = Place {
                        depth: r.depth,
                        moves: false,
                        char: Some(r.char),
                        matrix: Some(r.matrix),
                        color: Some(r.color),
                        ratio: None,
                        name: None,
                        clip: None,
                        visible: None,
                    };
                    (
                        r.depth,
                        Clip::new_instance(lib, r.char, &place, &mut Vec::new()),
                    )
                })
                .collect();
            collect_list(lib, children.iter().map(|(d, i)| (*d, i)), t, c, out);
        }
        None => {}
    }
}

#[cfg(test)]
mod tests {
    #![allow(clippy::unwrap_used, clippy::expect_used, clippy::panic)]

    use super::*;

    const LIB: &str = r##"{
      "stage": {"width": 800, "height": 600, "fps": 30, "background": "#35567B"},
      "exports": {"Kale": 10},
      "shapes": {"1": [-5.0, -5.0], "2": [0.0, 0.0], "3": [0, 0]},
      "bitmap_shapes": {},
      "morphs": {"4": [-1.0, -2.0]},
      "hairlines": {"2": [[0, 0.05]]},
      "sprites": {
        "10": {"frames": [[{"depth": 1, "char": 1}], [{"depth": 1, "move": true, "matrix": [2,0,0,2,0,0]}],
                          [{"remove": 1}, {"depth": 2, "char": 2}]],
               "labels": {"son": 2}, "actions": {"2": [{"stop": true}, {"event": "directHit"}]}},
        "11": {"frames": []},
        "12": {"frames": [[{"depth": 1, "char": 3, "clip": 3}, {"depth": 2, "char": 1}, {"depth": 3, "char": 2},
                           {"depth": 4, "char": 1}]]}
      },
      "buttons": {"20": [{"states": ["up"], "char": 1, "depth": 1}, {"states": ["over", "hit"], "char": 2, "depth": 1}]},
      "root": {"frames": [[{"depth": 1, "char": 140}, {"depth": 2, "char": 10, "matrix": [1,0,0,1,100,50], "name": "kale"}],
                          [{"depth": 3, "char": 4, "ratio": 0.25, "cxform": [[1,1,1,0.5],[0,0,0,0]]}],
                          [{"depth": 3, "move": true, "ratio": 0.75}]],
               "actions": {"2": [{"goto": 1, "play": false}]},
               "sounds": {"1": [{"id": 930, "stop": true}]}},
      "excluded": {"140": "sponsor"}
    }"##;

    fn lib() -> Library {
        Library::from_json(LIB.as_bytes(), None).unwrap()
    }

    fn drawn(cmds: &[DrawCommand]) -> Vec<DrawKind> {
        cmds.iter()
            .filter_map(|c| match c {
                DrawCommand::Draw(i) => Some(i.kind.clone()),
                _ => None,
            })
            .collect()
    }

    #[test]
    fn reads_symbols_timelines_and_extras() {
        let lib = lib();
        assert_eq!(lib.stage.fps, 30.0);
        assert_eq!(
            lib.symbol(1),
            Some(&Symbol::Shape {
                origin: Vec2::new(-5.0, -5.0)
            })
        );
        assert!(matches!(lib.symbol(4), Some(Symbol::Morph { .. })));
        assert!(
            matches!(lib.symbol(20), Some(Symbol::Button(r)) if r.len() == 2 && r[1].states.hit)
        );
        let Some(Symbol::Sprite(t)) = lib.symbol(10) else {
            panic!()
        };
        assert_eq!(t.labels["son"], 2);
        assert_eq!(
            t.actions[&2],
            vec![Action::Stop, Action::Event("directHit".into())]
        );
        assert_eq!(
            lib.root.actions[&2],
            vec![Action::GotoFrame {
                frame: 0,
                play: false
            }]
        );
        assert_eq!(lib.hairlines[&2], vec![(0, 0.05)]);
        assert_eq!(lib.exports["Kale"], 10);
        assert!(lib.excluded.contains_key(&140));
    }

    #[test]
    fn undefined_character_is_skipped() {
        // Kök film 1. karede dışarıda bırakılmış sponsor logosunu (140) yerleştirir: atlanır
        let lib = lib();
        let root = Clip::root(&lib, &mut Vec::new());
        assert!(!root.display().contains_key(&1));
        assert_eq!(root.display()[&2].char, 10);
    }

    #[test]
    fn sprites_play_on_their_own_and_frame_scripts_run() {
        let lib = lib();
        let mut events = Vec::new();
        let mut kale = Clip::sprite(&lib, 10, &mut events);
        assert_eq!(
            drawn(&kale.draw_commands(&lib, Affine2::IDENTITY, ColorTransform::IDENTITY)),
            vec![DrawKind::Shape(1)]
        );
        kale.tick(&lib, &mut events);
        let cmds = kale.draw_commands(&lib, Affine2::IDENTITY, ColorTransform::IDENTITY);
        let DrawCommand::Draw(item) = &cmds[0] else {
            panic!()
        };
        assert_eq!(item.transform, Affine2::from_scale(Vec2::splat(2.0)));
        kale.tick(&lib, &mut events);
        assert_eq!(kale.frame(), 2);
        assert!(!kale.is_playing());
        assert_eq!(
            events,
            vec![Event::Script {
                sprite: Some(10),
                name: "directHit".into()
            }]
        );
        // Durmuş sprite ilerlemez; geri gitmek görüntü listesini baştan kurar
        kale.tick(&lib, &mut events);
        assert_eq!(kale.frame(), 2);
        kale.goto(&lib, 0, false, &mut events);
        assert_eq!(
            drawn(&kale.draw_commands(&lib, Affine2::IDENTITY, ColorTransform::IDENTITY)),
            vec![DrawKind::Shape(1)]
        );
        kale.goto_label(&lib, "son", false, &mut events);
        assert_eq!(
            drawn(&kale.draw_commands(&lib, Affine2::IDENTITY, ColorTransform::IDENTITY)),
            vec![DrawKind::Shape(2)]
        );
    }

    #[test]
    fn nested_transforms_colours_and_morph_ratio_combine() {
        let lib = lib();
        let mut events = Vec::new();
        let mut root = Clip::root(&lib, &mut events);
        root.tick(&lib, &mut events);
        assert_eq!(
            events,
            vec![Event::Sound(SoundStart {
                id: 930,
                stop: true
            })]
        );
        let outer = ColorTransform {
            mul: [1.0, 1.0, 1.0, 0.5],
            add: [0.0; 4],
        };
        let cmds = root.draw_commands(&lib, Affine2::from_translation(Vec2::new(10.0, 0.0)), outer);
        let items: Vec<&DrawItem> = cmds
            .iter()
            .filter_map(|c| match c {
                DrawCommand::Draw(i) => Some(i),
                _ => None,
            })
            .collect();
        // Sprite 10 kendi 2. karesinde (ölçek 2), kök filmde (100, 50) konumunda
        assert_eq!(items[0].kind, DrawKind::Shape(1));
        assert_eq!(
            items[0].transform,
            Affine2::from_cols_array(&[2.0, 0.0, 0.0, 2.0, 110.0, 50.0])
        );
        assert_eq!(
            items[0].svg_transform(&lib).translation,
            Vec2::new(100.0, 40.0)
        );
        assert_eq!(items[1].kind, DrawKind::Morph { id: 4, ratio: 0.25 });
        assert_eq!(items[1].color.mul[3], 0.25);
        // 3. karede taşı: oran değişir; ardından kare betiği 1. kareye gidip durur
        root.tick(&lib, &mut events);
        assert_eq!(root.frame(), 0);
        assert!(!root.is_playing());
    }

    #[test]
    fn last_frame_loops_to_the_first() {
        let lib = lib();
        let mut events = Vec::new();
        let mut root = Clip::root(&lib, &mut events);
        root.goto(&lib, 1, true, &mut events);
        root.tick(&lib, &mut events);
        // 3. karenin betiği 1. kareye götürür
        assert_eq!(root.frame(), 0);
        root.play();
        root.tick(&lib, &mut events);
        root.tick(&lib, &mut events);
        root.goto(&lib, 2, true, &mut events);
        assert_eq!(root.frame(), 0);
    }

    #[test]
    fn empty_sprite_counts_as_one_empty_frame() {
        let lib = lib();
        let mut clip = Clip::sprite(&lib, 11, &mut Vec::new());
        assert_eq!(clip.frame_count(&lib), 1);
        clip.tick(&lib, &mut Vec::new());
        assert_eq!(clip.frame(), 0);
        assert!(
            clip.draw_commands(&lib, Affine2::IDENTITY, ColorTransform::IDENTITY)
                .is_empty()
        );
    }

    #[test]
    fn mask_clips_the_depths_up_to_its_clip_depth() {
        let lib = lib();
        let clip = Clip::sprite(&lib, 12, &mut Vec::new());
        let cmds = clip.draw_commands(&lib, Affine2::IDENTITY, ColorTransform::IDENTITY);
        assert!(
            matches!(&cmds[0], DrawCommand::MaskStart(m) if m.len() == 1 && m[0].kind == DrawKind::Shape(3))
        );
        assert!(matches!(&cmds[1], DrawCommand::Draw(i) if i.kind == DrawKind::Shape(1)));
        assert!(matches!(&cmds[2], DrawCommand::Draw(i) if i.kind == DrawKind::Shape(2)));
        assert_eq!(cmds[3], DrawCommand::MaskEnd);
        assert!(matches!(&cmds[4], DrawCommand::Draw(i) if i.kind == DrawKind::Shape(1)));
        assert_eq!(cmds.len(), 5);
    }

    #[test]
    fn button_shows_the_records_of_its_state() {
        let lib = lib();
        let mut inst = Clip::new_instance(
            &lib,
            20,
            &Place {
                depth: 1,
                moves: false,
                char: Some(20),
                matrix: None,
                color: None,
                ratio: None,
                name: None,
                clip: None,
                visible: None,
            },
            &mut Vec::new(),
        );
        let mut out = Vec::new();
        instance_commands(
            &lib,
            &inst,
            Affine2::IDENTITY,
            ColorTransform::IDENTITY,
            &mut out,
        );
        assert_eq!(drawn(&out), vec![DrawKind::Shape(1)]);
        inst.button_state = ButtonState::Over;
        out.clear();
        instance_commands(
            &lib,
            &inst,
            Affine2::IDENTITY,
            ColorTransform::IDENTITY,
            &mut out,
        );
        assert_eq!(drawn(&out), vec![DrawKind::Shape(2)]);
    }

    #[test]
    fn bad_json_is_an_error() {
        assert!(Library::from_json(b"{", None).is_err());
        assert!(
            Library::from_json(br#"{"stage": {"width": 1, "height": 1, "fps": 1}}"#, None).is_err()
        );
    }
}
