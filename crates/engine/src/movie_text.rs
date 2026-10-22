//! Sabit yazıların (DefineText) ve yazı alanlarının (DefineEditText) dizilmesi ve çizimi.
//!
//! Oyunların gömülü yazı tipleri aktarılmaz; yazılar açık lisanslı karşılıklarıyla dizilir
//! (`texts.json` → `fonts.<kimlik>.file`). Çeviri verilirse (`ceviri/sabit.json`,
//! `ceviri/kutular.json`) Türkçe SWF'yi üreten aracın kuralları uygulanır:
//! - Sabit yazı: her kayıt (satır ya da parça) çevirideki parçayla değişir; harf aralıkları yazı
//!   tipinin kendisinden gelir. `"hiza": "orta"` satırı eski satırın ortasına hizalar; `"boyut"` yazıyı o
//!   oranda küçültür.
//! - Yazı alanı: özgün yazısı elle satırlara bölünmüş çok satırlı kutu yazıyı kendisi kaydırır; kutunun
//!   genişliği özgün yazının en uzun satırına indirilir (Liberation yazı tipiyle ölçülür; %3 ve 6
//!   piksel pay). `"kaydir"` bu kararı elle verir (kutu özgün genişliğinde kalır); `"boyut"` yazı boyunu
//!   küçültür; `html:` ile başlayan değer HTML'dir.
//!
//! Flash'ın yazı alanı kuralları: her kenarda 2 piksel boşluk; ilk satırın taban çizgisi üst kenar + 2 +
//! satırdaki en büyük yükselme; sonraki satır bir öncekinin alçalması ve satır aralığı ("leading")
//! kadar aşağıda. Kutunun dışı kırpılmaz (Türkçe karşılığı uzun olan tek satırlık etiketler kutuyu
//! büyütür).

use std::collections::HashMap;
use std::fmt;
use std::sync::Arc;

use glam::{Affine2, Vec2};
use lyon_tessellation::path::Path;
use serde_json::Value;

use crate::assets::Assets;
use crate::color::Color;
use crate::movie::{CharId, MovieError, as_f32, as_id, entries, field, matrix};
use crate::paint::Paint;
use crate::shape::{Fill, FillRule, Shape, VectorImage};
use crate::text::{Align, Font, FontError, PlacedGlyph};

/// Flash yazı alanının her kenarındaki boşluk (piksel).
const GUTTER: f32 = 2.0;

#[derive(Debug)]
pub enum TextError {
    Data(MovieError),
    /// Kütüphanede böyle bir yazı yok.
    Unknown(CharId),
    /// Yazı tipi dosyası okunamadı.
    Font(String),
    /// Kayıttaki harf, yazı tipinin harf listesinde yok.
    Glyph {
        text: CharId,
        index: u32,
    },
    Shaping(FontError),
}

impl fmt::Display for TextError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            TextError::Data(e) => write!(f, "{e}"),
            TextError::Unknown(id) => write!(f, "yazı {id} yok"),
            TextError::Font(file) => write!(f, "yazı tipi okunamadı: {file}"),
            TextError::Glyph { text, index } => {
                write!(f, "yazı {text}: {index}. harf yazı tipinde yok")
            }
            TextError::Shaping(e) => write!(f, "{e}"),
        }
    }
}

impl std::error::Error for TextError {}

impl From<MovieError> for TextError {
    fn from(e: MovieError) -> Self {
        TextError::Data(e)
    }
}

impl From<FontError> for TextError {
    fn from(e: FontError) -> Self {
        TextError::Shaping(e)
    }
}

/// Oyundaki yazı tipi ve yerine kullanılan dosya.
#[derive(Clone, Debug, PartialEq)]
pub struct FontEntry {
    pub name: String,
    pub bold: bool,
    pub italic: bool,
    /// Gömülü harflerin karakter kodları (sabit yazılardaki harf numaraları bu listeye göredir).
    pub codes: Vec<u32>,
    /// İçerik klasörüne göre yazı tipi dosyası.
    pub file: String,
}

/// Sabit yazının bir kaydı: verilmeyen alanlar önceki kayıttan sürer.
#[derive(Clone, Debug, PartialEq)]
pub struct TextRecord {
    pub font: Option<CharId>,
    /// Yazı boyu (piksel).
    pub size: Option<f32>,
    pub color: Option<Color>,
    pub x: Option<f32>,
    /// Taban çizgisi.
    pub y: Option<f32>,
    /// (Harf numarası, harften sonraki ilerleme).
    pub glyphs: Vec<(u32, f32)>,
}

#[derive(Clone, Debug, PartialEq)]
pub struct StaticText {
    pub bounds: (Vec2, Vec2),
    pub matrix: Affine2,
    pub records: Vec<TextRecord>,
    /// Çeviri: kayıt başına bir parça.
    pub parts: Option<Vec<String>>,
    /// Çevrilen satırlar eski satırın ortasına hizalanır.
    pub center: bool,
    /// Çeviride yazı boyunun çarpanı.
    pub scale: f32,
}

/// Kutu genişliğinin indirileceği özgün yazı (çeviri kuralı).
#[derive(Clone, Debug, PartialEq)]
pub struct FitWidth {
    pub text: String,
    /// Kalın yazıyla ölçülür.
    pub bold: bool,
    /// Ölçüdeki yazı boyu (çeviride küçültülmeden önceki).
    pub size: f32,
}

#[derive(Clone, Debug, PartialEq)]
pub struct EditText {
    pub min: Vec2,
    pub max: Vec2,
    pub font: CharId,
    pub size: f32,
    pub color: Color,
    pub align: Align,
    pub left_margin: f32,
    pub right_margin: f32,
    pub indent: f32,
    pub leading: f32,
    pub word_wrap: bool,
    pub multiline: bool,
    pub html: bool,
    /// Koddaki değişken adı (boşsa yok).
    pub variable: String,
    /// Başlangıç yazısı (çeviri verildiyse Türkçesi).
    pub text: String,
    pub fit_width: Option<FitWidth>,
}

/// Bir oyunun yazıları.
#[derive(Clone, Debug, Default)]
pub struct TextBank {
    pub fonts: HashMap<CharId, FontEntry>,
    pub texts: HashMap<CharId, StaticText>,
    pub edit_texts: HashMap<CharId, EditText>,
}

/// Yazı tipi dosyalarının önbelleği.
#[derive(Debug, Default)]
pub struct Fonts {
    assets: Assets,
    loaded: HashMap<String, Option<Arc<Font>>>,
}

impl Fonts {
    pub fn new(assets: Assets) -> Self {
        Fonts {
            assets,
            loaded: HashMap::new(),
        }
    }

    pub fn get(&mut self, file: &str) -> Result<Arc<Font>, TextError> {
        let assets = &self.assets;
        self.loaded
            .entry(file.to_string())
            .or_insert_with(|| {
                let data = assets.read(file).ok()?;
                Font::from_bytes(data.into_owned(), None).ok().map(Arc::new)
            })
            .clone()
            .ok_or_else(|| TextError::Font(file.to_string()))
    }
}

/// Tek yazı tipi, boy ve renkte dizilmiş harfler (yazının kendi koordinatlarında).
#[derive(Clone, Debug)]
pub struct GlyphRun {
    pub font: Arc<Font>,
    pub size: f32,
    pub color: Color,
    pub glyphs: Vec<PlacedGlyph>,
}

/// HTML yazısında ya da düz yazıda bir parçanın biçimi.
#[derive(Clone, Debug, PartialEq)]
struct Style {
    file: String,
    size: f32,
    color: Color,
}

/// Biçimli yazı parçaları.
type Pieces = Vec<(Style, String)>;

#[derive(Clone, Debug, PartialEq)]
struct Paragraph {
    align: Align,
    pieces: Vec<(Style, String)>,
}

impl Paragraph {
    /// Paragrafı bitirir; yerinde aynı hizada boş bir paragraf kalır.
    fn next(&mut self) -> Paragraph {
        std::mem::replace(
            self,
            Paragraph {
                align: self.align,
                pieces: Vec::new(),
            },
        )
    }
}

fn colour(v: Option<&Value>, alpha: Option<&Value>) -> Result<Option<Color>, TextError> {
    let Some(v) = v else { return Ok(None) };
    let hex = v.as_str().ok_or_else(|| field("color"))?;
    let c = Color::from_hex(hex).map_err(|_| field("color"))?;
    let a = match alpha {
        Some(a) => as_f32(a, "alpha")?,
        None => 1.0,
    };
    Ok(Some(c.with_alpha(c.a * a)))
}

fn opt_f32(v: &Value, key: &str) -> Result<Option<f32>, TextError> {
    v.get(key).map(|x| Ok(as_f32(x, key)?)).transpose()
}

fn parse_json(data: &[u8]) -> Result<Value, TextError> {
    serde_json::from_slice(data).map_err(|e| TextError::Data(MovieError::Json(e.to_string())))
}

/// Flash'ın serif yazı tiplerini tanıması (Türkçe SWF'yi üreten araçla aynı kural).
fn is_serif(name: &str) -> bool {
    name.contains("serif") || name.contains("Times") || name.contains("Book")
}

/// Sistem yazı tipinin (ör. `_sans`) açık lisanslı karşılığı.
fn device_font(name: &str, bold: bool, italic: bool) -> String {
    let family = if is_serif(name) {
        "LiberationSerif"
    } else {
        "LiberationSans"
    };
    let style = match (bold, italic) {
        (true, true) => "BoldItalic",
        (true, false) => "Bold",
        // Liberation'ın yalnız italik dosyası içerikte yok
        (false, _) => "Regular",
    };
    format!("fonts/{family}-{style}.ttf")
}

fn static_text(id: CharId, v: &Value) -> Result<StaticText, TextError> {
    let b = v.get("bounds").ok_or_else(|| field("bounds"))?;
    let b: Vec<f32> = b
        .as_array()
        .ok_or_else(|| field("bounds"))?
        .iter()
        .map(|x| as_f32(x, "bounds"))
        .collect::<Result<_, _>>()?;
    if b.len() != 4 {
        return Err(field(&format!("yazı {id} bounds")).into());
    }
    let mut records = Vec::new();
    for r in v
        .get("records")
        .and_then(Value::as_array)
        .ok_or_else(|| field("records"))?
    {
        let glyphs = r
            .get("glyphs")
            .and_then(Value::as_array)
            .ok_or_else(|| field("glyphs"))?
            .iter()
            .map(|g| {
                let index = g
                    .get(0)
                    .and_then(Value::as_u64)
                    .ok_or_else(|| field("glyphs"))?;
                let advance = as_f32(g.get(1).ok_or_else(|| field("glyphs"))?, "glyphs")?;
                Ok((index as u32, advance))
            })
            .collect::<Result<Vec<_>, MovieError>>()?;
        records.push(TextRecord {
            font: r
                .get("font")
                .map(|f| f.as_u64().and_then(|f| CharId::try_from(f).ok()))
                .map(|f| f.ok_or_else(|| field("font")))
                .transpose()?,
            size: opt_f32(r, "height")?,
            color: colour(r.get("color"), r.get("alpha"))?,
            x: opt_f32(r, "x")?,
            y: opt_f32(r, "y")?,
            glyphs,
        });
    }
    Ok(StaticText {
        bounds: (Vec2::new(b[0], b[1]), Vec2::new(b[2], b[3])),
        matrix: matrix(v.get("matrix").ok_or_else(|| field("matrix"))?)?,
        records,
        parts: None,
        center: false,
        scale: 1.0,
    })
}

fn edit_text(v: &Value) -> Result<EditText, TextError> {
    let b: Vec<f32> = v
        .get("bounds")
        .and_then(Value::as_array)
        .ok_or_else(|| field("bounds"))?
        .iter()
        .map(|x| as_f32(x, "bounds"))
        .collect::<Result<_, _>>()?;
    if b.len() != 4 {
        return Err(field("bounds").into());
    }
    let flags: Vec<&str> = v
        .get("flags")
        .and_then(Value::as_array)
        .map(|f| f.iter().filter_map(Value::as_str).collect())
        .unwrap_or_default();
    let layout = v.get("layout");
    let get = |key: &str| -> Result<f32, TextError> {
        Ok(match layout.and_then(|l| l.get(key)) {
            Some(x) => as_f32(x, key)?,
            None => 0.0,
        })
    };
    let align = match layout.and_then(|l| l.get("align")).and_then(Value::as_str) {
        Some("center") => Align::Center,
        Some("right") => Align::Right,
        _ => Align::Left,
    };
    let font = v
        .get("font")
        .and_then(Value::as_u64)
        .and_then(|f| CharId::try_from(f).ok())
        .ok_or_else(|| field("font"))?;
    Ok(EditText {
        min: Vec2::new(b[0], b[1]),
        max: Vec2::new(b[2], b[3]),
        font,
        size: opt_f32(v, "font_height")?.unwrap_or(12.0),
        color: colour(v.get("color"), v.get("alpha"))?.unwrap_or(Color::BLACK),
        align,
        left_margin: get("left_margin")?,
        right_margin: get("right_margin")?,
        indent: get("indent")?,
        leading: get("leading")?,
        word_wrap: flags.contains(&"word_wrap"),
        multiline: flags.contains(&"multiline"),
        html: flags.contains(&"html"),
        variable: v
            .get("variable")
            .and_then(Value::as_str)
            .unwrap_or_default()
            .to_string(),
        text: v
            .get("text")
            .and_then(Value::as_str)
            .unwrap_or_default()
            .to_string(),
        fit_width: None,
    })
}

/// HTML'den düz yazı (kutu genişliği ölçüsü için; Türkçe SWF'yi üreten araç gibi varlık adları
/// çözülmez).
fn strip_tags(html: &str) -> String {
    let mut out = String::new();
    let mut rest = html;
    while let Some(start) = rest.find('<') {
        out.push_str(&rest[..start]);
        let tag_end = rest[start..]
            .find('>')
            .map_or(rest.len(), |e| start + e + 1);
        let tag = &rest[start..tag_end];
        if tag.starts_with("<sbr") {
            out.push('\n');
        }
        rest = &rest[tag_end..];
    }
    out.push_str(rest);
    out
}

/// Kutu çevirisini uygular (Türkçe SWF'yi üreten aracın kuralları).
fn translate_edit(e: &mut EditText, value: &Value) -> Result<(), TextError> {
    let (text, scale, wrap) = match value {
        Value::String(s) => (s.as_str(), 1.0, None),
        Value::Object(o) => (
            o.get("metin").and_then(Value::as_str).unwrap_or_default(),
            match o.get("boyut") {
                Some(b) => as_f32(b, "boyut")?,
                None => 1.0,
            },
            o.get("kaydir").and_then(Value::as_bool),
        ),
        _ => return Err(field("kutu çevirisi").into()),
    };
    let original = e.text.clone();
    if let Some(html) = text.strip_prefix("html:") {
        e.html = true;
        e.text = html.to_string();
        // Elle satır kırılmış HTML kutuları kaydırılır; tek satırlıklar olduğu gibi kalır
        if original.contains("<sbr") {
            e.fit_width = Some(FitWidth {
                text: strip_tags(&original),
                bold: original.contains("<b>"),
                size: e.size,
            });
            e.word_wrap = true;
        }
    } else {
        let text = text.replace('\n', "\r");
        let stripped = original.trim();
        let paragraph = stripped.contains(['\r', '\n']) || text.contains('\r');
        e.text = text;
        if e.word_wrap {
            // Zaten kendisi kaydıran kutu olduğu gibi kalır
        } else if paragraph && e.multiline {
            e.fit_width = Some(FitWidth {
                text: stripped.to_string(),
                bold: false,
                size: e.size,
            });
            e.word_wrap = true;
        } else {
            e.word_wrap = false;
        }
    }
    if let Some(wrap) = wrap {
        // Kodun doldurduğu kutularda kaydırma kararı elle verilir; kutu özgün genişliğinde kalır
        e.word_wrap = wrap;
        e.fit_width = None;
    }
    e.size *= scale;
    Ok(())
}

impl TextBank {
    /// `texts.json` ve isteğe bağlı çeviri tabloları (`sabit.json`, `kutular.json`).
    pub fn from_json(
        texts: &[u8],
        statics: Option<&[u8]>,
        fields: Option<&[u8]>,
    ) -> Result<Self, TextError> {
        let v = parse_json(texts)?;
        let mut bank = TextBank::default();
        for (id, f) in entries(&v, "fonts") {
            let flag = |k: &str| f.get(k).and_then(Value::as_bool).unwrap_or(false);
            bank.fonts.insert(
                as_id(&id)?,
                FontEntry {
                    name: f
                        .get("name")
                        .and_then(Value::as_str)
                        .unwrap_or_default()
                        .to_string(),
                    bold: flag("bold"),
                    italic: flag("italic"),
                    codes: f
                        .get("codes")
                        .and_then(Value::as_array)
                        .map(|c| c.iter().filter_map(|x| x.as_u64()).map(|x| x as u32))
                        .into_iter()
                        .flatten()
                        .collect(),
                    file: f
                        .get("file")
                        .and_then(Value::as_str)
                        .ok_or_else(|| field("file"))?
                        .to_string(),
                },
            );
        }
        for (id, t) in entries(&v, "texts") {
            let id = as_id(&id)?;
            bank.texts.insert(id, static_text(id, &t)?);
        }
        for (id, t) in entries(&v, "edit_texts") {
            bank.edit_texts.insert(as_id(&id)?, edit_text(&t)?);
        }
        if let Some(statics) = statics {
            let table = parse_json(statics)?;
            for (id, entry) in table.as_object().into_iter().flatten() {
                if id.starts_with('_') {
                    continue;
                }
                let id = as_id(id)?;
                let text = bank.texts.get_mut(&id).ok_or(TextError::Unknown(id))?;
                let parts: Vec<String> = entry
                    .get("parcalar")
                    .and_then(Value::as_array)
                    .ok_or_else(|| field("parcalar"))?
                    .iter()
                    .map(|p| {
                        p.as_str()
                            .map(str::to_string)
                            .ok_or_else(|| field("parcalar"))
                    })
                    .collect::<Result<_, _>>()?;
                if parts.len() != text.records.len() {
                    return Err(field(&format!(
                        "yazı {id}: {} kayıt, çeviride {} parça",
                        text.records.len(),
                        parts.len()
                    ))
                    .into());
                }
                text.parts = Some(parts);
                text.center = entry.get("hiza").and_then(Value::as_str) == Some("orta");
                text.scale = opt_f32(entry, "boyut")?.unwrap_or(1.0);
            }
        }
        if let Some(fields) = fields {
            let table = parse_json(fields)?;
            for (id, value) in table.as_object().into_iter().flatten() {
                if id.starts_with('_') {
                    continue;
                }
                let id = as_id(id)?;
                // Dışarıda bırakılmış kutuların çevirisi kullanılmaz
                if let Some(e) = bank.edit_texts.get_mut(&id) {
                    translate_edit(e, value)?;
                }
            }
        }
        Ok(bank)
    }

    /// İçerikten okur: `<prefix>texts.json`; `turkish` ise `<prefix>ceviri/` altındaki tablolar da.
    pub fn load(assets: &Assets, prefix: &str, turkish: bool) -> Result<Self, TextError> {
        let read = |file: &str| {
            assets
                .read(&format!("{prefix}{file}"))
                .map_err(|e| TextError::Data(MovieError::Json(e.to_string())))
        };
        let texts = read("texts.json")?;
        if turkish {
            let statics = read("ceviri/sabit.json")?;
            let fields = read("ceviri/kutular.json")?;
            TextBank::from_json(&texts, Some(&statics), Some(&fields))
        } else {
            TextBank::from_json(&texts, None, None)
        }
    }

    fn font_file(&self, id: CharId) -> Result<&FontEntry, TextError> {
        self.fonts
            .get(&id)
            .ok_or_else(|| TextError::Data(field(&format!("yazı tipi {id}"))))
    }

    /// HTML'deki yazı tipi adı ve biçimi için dosya: oyunda o adla ve biçimle bir yazı tipi varsa onun
    /// karşılığı, yoksa sistem yazı tipinin karşılığı.
    fn face_file(&self, face: &str, bold: bool, italic: bool) -> String {
        let mut ids: Vec<&CharId> = self.fonts.keys().collect();
        ids.sort();
        ids.into_iter()
            .map(|id| &self.fonts[id])
            .find(|f| f.name == face && f.bold == bold && f.italic == italic)
            .map_or_else(|| device_font(face, bold, italic), |f| f.file.clone())
    }

    /// Sabit yazının harfleri (yazının kendi koordinatlarında; matris dahil değil).
    pub fn static_runs(
        &self,
        id: CharId,
        fonts: &mut Fonts,
    ) -> Result<(Affine2, Vec<GlyphRun>), TextError> {
        let text = self.texts.get(&id).ok_or(TextError::Unknown(id))?;
        let mut runs = Vec::new();
        let (mut font_id, mut size, mut color) = (None, 12.0, Color::BLACK);
        let mut pos = Vec2::ZERO;
        for (i, r) in text.records.iter().enumerate() {
            font_id = r.font.or(font_id);
            size = r.size.unwrap_or(size);
            color = r.color.unwrap_or(color);
            pos.x = r.x.unwrap_or(pos.x);
            pos.y = r.y.unwrap_or(pos.y);
            let entry = self.font_file(font_id.ok_or_else(|| field("font"))?)?;
            let font = fonts.get(&entry.file)?;
            let old_width: f32 = r.glyphs.iter().map(|g| g.1).sum();
            let (glyphs, run_size) = match &text.parts {
                Some(parts) => {
                    let run_size = size * text.scale;
                    let (glyphs, width) = font.shape_line(&parts[i], run_size)?;
                    let start = if text.center {
                        pos.x + old_width / 2.0 - width / 2.0
                    } else {
                        pos.x
                    };
                    let glyphs = glyphs
                        .into_iter()
                        .map(|g| PlacedGlyph {
                            id: g.id,
                            position: g.position + Vec2::new(start, pos.y),
                        })
                        .collect();
                    pos.x = start + width;
                    (glyphs, run_size)
                }
                None => {
                    let mut glyphs = Vec::with_capacity(r.glyphs.len());
                    for &(index, advance) in &r.glyphs {
                        let glyph = entry
                            .codes
                            .get(index as usize)
                            .and_then(|&c| char::from_u32(c))
                            .and_then(|c| font.glyph_id(c))
                            .ok_or(TextError::Glyph { text: id, index })?;
                        glyphs.push(PlacedGlyph {
                            id: glyph,
                            position: pos,
                        });
                        pos.x += advance;
                    }
                    (glyphs, size)
                }
            };
            runs.push(GlyphRun {
                font,
                size: run_size,
                color,
                glyphs,
            });
        }
        Ok((text.matrix, runs))
    }

    pub fn static_image(&self, id: CharId, fonts: &mut Fonts) -> Result<VectorImage, TextError> {
        let (matrix, runs) = self.static_runs(id, fonts)?;
        let (min, max) = self.texts[&id].bounds;
        Ok(runs_image(&runs, matrix, max - min))
    }

    fn default_style(&self, e: &EditText) -> Result<Style, TextError> {
        Ok(Style {
            file: self.font_file(e.font)?.file.clone(),
            size: e.size,
            color: e.color,
        })
    }

    fn plain_paragraphs(&self, e: &EditText, text: &str) -> Result<Vec<Paragraph>, TextError> {
        let style = self.default_style(e)?;
        Ok(text
            .replace("\r\n", "\r")
            .split(['\r', '\n'])
            .map(|line| Paragraph {
                align: e.align,
                pieces: vec![(style.clone(), line.to_string())],
            })
            .collect())
    }

    fn html_paragraphs(&self, e: &EditText, html: &str) -> Result<Vec<Paragraph>, TextError> {
        let base = self.font_file(e.font)?;
        // Yazı tipi etiketleri iç içe: (ad, boy, renk)
        let fallback = (base.name.clone(), e.size, e.color);
        let mut fonts = vec![fallback.clone()];
        let (mut bold, mut italic) = (0u32, 0u32);
        let mut paragraphs = Vec::new();
        let mut current = Paragraph {
            align: e.align,
            pieces: Vec::new(),
        };
        let mut rest = html;
        loop {
            let (text, tag) = match rest.find('<') {
                Some(start) => {
                    let end = rest[start..]
                        .find('>')
                        .map_or(rest.len(), |e| start + e + 1);
                    let tag = &rest[start + 1..end.saturating_sub(1).max(start + 1)];
                    let text = &rest[..start];
                    rest = &rest[end..];
                    (text, Some(tag))
                }
                None => {
                    let text = rest;
                    rest = "";
                    (text, None)
                }
            };
            if !text.is_empty() {
                let (face, size, color) = fonts.last().cloned().unwrap_or_else(|| fallback.clone());
                let style = Style {
                    file: self.face_file(&face, bold > 0, italic > 0),
                    size,
                    color,
                };
                current.pieces.push((style, decode_entities(text)));
            }
            let Some(tag) = tag else { break };
            let tag = tag.trim().trim_end_matches('/').trim();
            let (name, attrs) = tag.split_once(char::is_whitespace).unwrap_or((tag, ""));
            match name.to_ascii_lowercase().as_str() {
                "p" => {
                    if !current.pieces.is_empty() {
                        paragraphs.push(current.next());
                    }
                    current.align = match attribute(attrs, "align").as_deref() {
                        Some("center") => Align::Center,
                        Some("right") => Align::Right,
                        _ => e.align,
                    };
                }
                "/p" | "br" | "sbr" => paragraphs.push(current.next()),
                "font" => {
                    let (mut face, mut size, mut color) =
                        fonts.last().cloned().unwrap_or_else(|| fallback.clone());
                    if let Some(f) = attribute(attrs, "face") {
                        face = f;
                    }
                    if let Some(s) = attribute(attrs, "size").and_then(|s| s.parse().ok()) {
                        size = s;
                    }
                    if let Some(c) =
                        attribute(attrs, "color").and_then(|c| Color::from_hex(&c).ok())
                    {
                        color = c.with_alpha(e.color.a);
                    }
                    fonts.push((face, size, color));
                }
                "/font" if fonts.len() > 1 => {
                    fonts.pop();
                }
                "b" => bold += 1,
                "/b" => bold = bold.saturating_sub(1),
                "i" => italic += 1,
                "/i" => italic = italic.saturating_sub(1),
                _ => {}
            }
        }
        if !current.pieces.is_empty() || paragraphs.is_empty() {
            paragraphs.push(current);
        }
        Ok(paragraphs)
    }

    /// Çeviri kuralıyla daraltılmış kutunun sağ kenarı.
    fn right_edge(&self, e: &EditText, fonts: &mut Fonts) -> Result<f32, TextError> {
        let Some(fit) = &e.fit_width else {
            return Ok(e.max.x);
        };
        let name = &self.font_file(e.font)?.name;
        let font = fonts.get(&device_font(name, fit.bold, false))?;
        let mut widest: f32 = 0.0;
        for line in fit.text.split(['\r', '\n']).filter(|l| !l.is_empty()) {
            widest = widest.max(font.measure(line.trim_end(), fit.size)?);
        }
        if widest <= 0.0 {
            return Ok(e.max.x);
        }
        // Twip'e yukarı yuvarlanır
        let width = ((widest * 1.03 + 6.0) * 20.0).ceil() / 20.0;
        Ok(if e.min.x + width < e.max.x {
            e.min.x + width
        } else {
            e.max.x
        })
    }

    /// Yazı alanının harfleri. `text` verilirse başlangıç yazısının yerine o yazılır (alan HTML ise
    /// HTML olarak).
    pub fn edit_runs(
        &self,
        id: CharId,
        text: Option<&str>,
        fonts: &mut Fonts,
    ) -> Result<Vec<GlyphRun>, TextError> {
        let e = self.edit_texts.get(&id).ok_or(TextError::Unknown(id))?;
        let content = text.unwrap_or(&e.text);
        let paragraphs = if e.html {
            self.html_paragraphs(e, content)?
        } else {
            self.plain_paragraphs(e, content)?
        };
        let default = self.default_style(e)?;
        let left = e.min.x + GUTTER + e.left_margin;
        let right = self.right_edge(e, fonts)? - GUTTER - e.right_margin;
        let mut top = e.min.y + GUTTER;
        let mut runs = Vec::new();
        for paragraph in &paragraphs {
            let lines = if e.word_wrap {
                wrap(&paragraph.pieces, right - left, e.indent, fonts)?
            } else {
                vec![paragraph.pieces.clone()]
            };
            for (i, line) in lines.iter().enumerate() {
                let line = merge(line);
                let mut shaped = Vec::with_capacity(line.len());
                let (mut ascent, mut descent, mut width) = (0.0f32, 0.0f32, 0.0);
                for (style, piece) in &line {
                    let font = fonts.get(&style.file)?;
                    let (a, d) = font.vertical_metrics(style.size);
                    ascent = ascent.max(a);
                    descent = descent.max(d);
                    let (glyphs, w) = font.shape_line(piece, style.size)?;
                    shaped.push((font, style, glyphs, width));
                    width += w;
                }
                if line.is_empty() {
                    let style = paragraph.pieces.first().map_or(&default, |p| &p.0);
                    let (a, d) = fonts.get(&style.file)?.vertical_metrics(style.size);
                    (ascent, descent) = (a, d);
                }
                let indent = if i == 0 { e.indent } else { 0.0 };
                let x = match paragraph.align {
                    Align::Left => left + indent,
                    Align::Center => left + indent + (right - left - indent - width) / 2.0,
                    Align::Right => right - width,
                };
                let baseline = top + ascent;
                for (font, style, glyphs, offset) in shaped {
                    runs.push(GlyphRun {
                        font,
                        size: style.size,
                        color: style.color,
                        glyphs: glyphs
                            .into_iter()
                            .map(|g| PlacedGlyph {
                                id: g.id,
                                position: g.position + Vec2::new(x + offset, baseline),
                            })
                            .collect(),
                    });
                }
                top = baseline + descent + e.leading;
            }
        }
        Ok(runs)
    }

    pub fn edit_image(
        &self,
        id: CharId,
        text: Option<&str>,
        fonts: &mut Fonts,
    ) -> Result<VectorImage, TextError> {
        let runs = self.edit_runs(id, text, fonts)?;
        let e = &self.edit_texts[&id];
        Ok(runs_image(&runs, Affine2::IDENTITY, e.max - e.min))
    }
}

fn attribute(attrs: &str, name: &str) -> Option<String> {
    let mut rest = attrs;
    while let Some(eq) = rest.find('=') {
        let key = rest[..eq].trim();
        let after = rest[eq + 1..].trim_start();
        let quote = after.chars().next()?;
        if quote != '"' && quote != '\'' {
            return None;
        }
        let end = after[1..].find(quote)? + 1;
        if key.eq_ignore_ascii_case(name) {
            return Some(after[1..end].to_string());
        }
        rest = &after[end + 1..];
    }
    None
}

fn decode_entities(text: &str) -> String {
    text.replace("&lt;", "<")
        .replace("&gt;", ">")
        .replace("&quot;", "\"")
        .replace("&apos;", "'")
        .replace("&nbsp;", "\u{a0}")
        .replace("&amp;", "&")
}

/// Aynı biçimdeki komşu parçaları birleştirir (harf aralığı ayarı parçalar arasında da işlesin).
fn merge(pieces: &[(Style, String)]) -> Vec<(Style, String)> {
    let mut out: Vec<(Style, String)> = Vec::new();
    for (style, text) in pieces {
        match out.last_mut() {
            Some((s, t)) if s == style => t.push_str(text),
            _ => out.push((style.clone(), text.clone())),
        }
    }
    out
}

fn width_of(pieces: &[(Style, String)], fonts: &mut Fonts) -> Result<f32, TextError> {
    let mut w = 0.0;
    for (style, text) in merge(pieces) {
        w += fonts.get(&style.file)?.measure(&text, style.size)?;
    }
    Ok(w)
}

/// Paragrafı sözcük sınırlarından satırlara böler; satır sonundaki boşluklar atılır.
fn wrap(
    pieces: &[(Style, String)],
    width: f32,
    indent: f32,
    fonts: &mut Fonts,
) -> Result<Vec<Vec<(Style, String)>>, TextError> {
    // (sözcükten önceki boşluklar, sözcük)
    let mut words: Vec<(Pieces, Pieces)> = vec![(vec![], vec![])];
    for (style, text) in pieces {
        let mut rest = text.as_str();
        while !rest.is_empty() {
            let space = rest.starts_with(' ');
            let end = rest
                .find(|c: char| (c == ' ') != space)
                .unwrap_or(rest.len());
            let (chunk, tail) = rest.split_at(end);
            rest = tail;
            let piece = (style.clone(), chunk.to_string());
            if space {
                if words.last().is_some_and(|w| !w.1.is_empty()) {
                    words.push((vec![], vec![]));
                }
                if let Some(w) = words.last_mut() {
                    w.0.push(piece);
                }
            } else if let Some(w) = words.last_mut() {
                w.1.push(piece);
            }
        }
    }
    let mut lines = Vec::new();
    let mut line: Vec<(Style, String)> = Vec::new();
    let mut line_width = 0.0;
    for (spaces, word) in words {
        let available = if lines.is_empty() {
            width - indent
        } else {
            width
        };
        let space_width = width_of(&spaces, fonts)?;
        let word_width = width_of(&word, fonts)?;
        if !line.is_empty() && line_width + space_width + word_width > available {
            lines.push(std::mem::take(&mut line));
            line_width = 0.0;
        } else {
            line.extend(spaces);
            line_width += space_width;
        }
        line.extend(word);
        line_width += word_width;
    }
    lines.push(line);
    Ok(lines)
}

/// Harfleri vektör resme çevirir (her parça kendi rengiyle).
pub fn runs_image(runs: &[GlyphRun], transform: Affine2, size: Vec2) -> VectorImage {
    let mut image = VectorImage::new(size);
    for run in runs {
        let mut builder = Path::builder();
        run.font
            .append_glyphs(&mut builder, &run.glyphs, run.size, transform);
        let path = builder.build();
        if path.iter().next().is_none() {
            continue;
        }
        image.push(Shape {
            path,
            fill: Some(Fill {
                paint: Paint::Solid(run.color),
                rule: FillRule::NonZero,
            }),
            stroke: None,
        });
    }
    image
}

#[cfg(test)]
mod tests {
    #![allow(clippy::unwrap_used, clippy::expect_used, clippy::panic)]

    use super::*;

    fn fonts() -> Fonts {
        Fonts::new(Assets::from_dir(
            std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../../content"),
        ))
    }

    const FONTS: &str = r##""fonts": {
        "1": {"name": "Arial", "bold": false, "italic": false, "codes": [65, 66, 32],
              "file": "fonts/LiberationSans-Regular.ttf"},
        "2": {"name": "Times New Roman", "bold": true, "italic": false, "codes": [],
              "file": "fonts/LiberationSerif-Bold.ttf"},
        "3": {"name": "_sans", "bold": true, "italic": true, "codes": [],
              "file": "fonts/LiberationSans-BoldItalic.ttf"}
    }"##;

    fn bank(texts: &str, statics: Option<&str>, fields: Option<&str>) -> TextBank {
        let json = format!("{{{FONTS}, {texts}}}");
        TextBank::from_json(
            json.as_bytes(),
            statics.map(str::as_bytes),
            fields.map(str::as_bytes),
        )
        .unwrap()
    }

    const STATIC: &str = r##""texts": {"10": {"id": 10, "bounds": [0, 0, 100, 40],
        "matrix": [1, 0, 0, 1, 5, 0],
        "records": [
            {"font": 1, "color": "#FF0000", "y": 20, "height": 10, "glyphs": [[0, 7], [1, 6]]},
            {"x": 50, "y": 34, "glyphs": [[1, 6], [2, 3], [0, 7]]}
        ]}}"##;

    fn xs(run: &GlyphRun) -> Vec<f32> {
        run.glyphs.iter().map(|g| g.position.x).collect()
    }

    #[test]
    fn static_text_keeps_original_positions_without_translation() {
        let b = bank(STATIC, None, None);
        let mut f = fonts();
        let (matrix, runs) = b.static_runs(10, &mut f).unwrap();
        assert_eq!(matrix.translation, Vec2::new(5.0, 0.0));
        assert_eq!(runs.len(), 2);
        assert_eq!(xs(&runs[0]), [0.0, 7.0]);
        assert!(runs[0].glyphs.iter().all(|g| g.position.y == 20.0));
        // Yazı tipi, boy ve renk sonraki kayda geçer
        assert_eq!(xs(&runs[1]), [50.0, 56.0, 59.0]);
        assert_eq!(
            (runs[1].size, runs[1].color),
            (10.0, Color::rgba(1.0, 0.0, 0.0, 1.0))
        );
        let font = &runs[0].font;
        assert_eq!(runs[0].glyphs[0].id, font.glyph_id('A').unwrap());
        assert_eq!(runs[1].glyphs[1].id, font.glyph_id(' ').unwrap());
        // Matris resme uygulanır
        let (min, _) = b.static_image(10, &mut f).unwrap().bounds().unwrap();
        assert!((5.0..6.0).contains(&min.x), "{min}");
    }

    #[test]
    fn translated_static_text_is_shaped_and_optionally_centred() {
        let mut f = fonts();
        let plain = bank(STATIC, Some(r#"{"10": {"parcalar": ["Şİ", "ığ"]}}"#), None);
        let (_, runs) = plain.static_runs(10, &mut f).unwrap();
        let font = runs[0].font.clone();
        let (_, width) = font.shape_line("Şİ", 10.0).unwrap();
        assert_eq!(runs[0].glyphs[0].position, Vec2::new(0.0, 20.0));
        assert_eq!(runs[0].glyphs[0].id, font.glyph_id('Ş').unwrap());
        assert_eq!(runs[1].glyphs[0].position, Vec2::new(50.0, 34.0));

        let centred = bank(
            STATIC,
            Some(r#"{"10": {"parcalar": ["Şİ", "ığ"], "hiza": "orta", "boyut": 0.5}}"#),
            None,
        );
        let (_, runs) = centred.static_runs(10, &mut f).unwrap();
        assert_eq!(runs[0].size, 5.0);
        // Eski satır 0..13, yeni satır onun ortasında
        let (_, half) = font.shape_line("Şİ", 5.0).unwrap();
        assert!((half - width / 2.0).abs() < 1e-4);
        assert!((runs[0].glyphs[0].position.x - (6.5 - half / 2.0)).abs() < 1e-4);
    }

    #[test]
    fn translation_with_wrong_part_count_is_an_error() {
        let json = format!("{{{FONTS}, {STATIC}}}");
        let r = TextBank::from_json(
            json.as_bytes(),
            Some(br#"{"10": {"parcalar": ["tek"]}}"#),
            None,
        );
        assert!(r.is_err());
    }

    fn field_json(extra: &str, text: &str, flags: &str) -> String {
        format!(
            r##""edit_texts": {{"20": {{"id": 20, "bounds": [10, 100, 210, 200],
            "flags": [{flags}], "font": 1, "font_height": 20, "color": "#0000FF", "alpha": 1.0,
            "layout": {{"align": "{extra}", "left_margin": 3, "right_margin": 5, "indent": 0,
            "leading": 2}}, "variable": "", "text": {text}}}}}"##
        )
    }

    #[test]
    fn edit_text_follows_flash_gutter_alignment_and_line_spacing() {
        let mut f = fonts();
        let b = bank(
            &field_json("left", r#""AB\rB""#, r#""multiline""#),
            None,
            None,
        );
        let runs = b.edit_runs(20, None, &mut f).unwrap();
        let font = runs[0].font.clone();
        let (ascent, descent) = font.vertical_metrics(20.0);
        let first = runs[0].glyphs[0].position;
        assert_eq!(first, Vec2::new(10.0 + 2.0 + 3.0, 100.0 + 2.0 + ascent));
        let second = runs[1].glyphs[0].position;
        assert!((second.y - (first.y + descent + 2.0 + ascent)).abs() < 1e-4);
        assert_eq!(runs[0].color, Color::rgba(0.0, 0.0, 1.0, 1.0));

        let width = font.measure("AB", 20.0).unwrap();
        let right = bank(&field_json("right", r#""AB""#, ""), None, None);
        let runs = right.edit_runs(20, None, &mut f).unwrap();
        assert!((runs[0].glyphs[0].position.x - (210.0 - 2.0 - 5.0 - width)).abs() < 1e-3);
        let centre = bank(&field_json("center", r#""AB""#, ""), None, None);
        let runs = centre.edit_runs(20, None, &mut f).unwrap();
        let mid = (15.0 + 203.0) / 2.0;
        assert!((runs[0].glyphs[0].position.x - (mid - width / 2.0)).abs() < 1e-3);
        // Yazı verilirse başlangıç yazısının yerine o yazılır
        let runs = centre.edit_runs(20, Some("A"), &mut f).unwrap();
        assert_eq!(runs[0].glyphs.len(), 1);
    }

    #[test]
    fn word_wrap_breaks_lines_inside_the_box() {
        let mut f = fonts();
        let long = "Merhaba yolcu! Sana temel bilgileri anlatacağım ve bu dünyada nasıl hayatta kalacağını öğreteceğim.";
        let b = bank(
            &field_json(
                "left",
                &format!("\"{long}\""),
                r#""multiline", "word_wrap""#,
            ),
            None,
            None,
        );
        let runs = b.edit_runs(20, None, &mut f).unwrap();
        assert!(runs.len() >= 3, "{} satır", runs.len());
        let font = runs[0].font.clone();
        for run in &runs {
            let first = run.glyphs[0].position.x;
            assert_eq!(first, 15.0);
            let last = run.glyphs.last().unwrap();
            assert!(last.position.x <= 203.0, "{}", last.position.x);
        }
        let joined: usize = runs.iter().map(|r| r.glyphs.len()).sum();
        let spaces = long.matches(' ').count();
        // Satır sonlarındaki boşluklar atılır
        assert_eq!(joined, long.chars().count() - (runs.len() - 1));
        assert!(spaces >= runs.len() - 1);
        assert!(font.has_char('ğ'));
    }

    #[test]
    fn translated_paragraph_box_wraps_at_the_original_widest_line() {
        let mut f = fonts();
        // Özgün yazı elle iki satıra bölünmüş, kutu kendisi kaydırmıyor
        let json = field_json("left", r#""AB AB\rAB""#, r#""multiline""#);
        let b = bank(&json, None, Some(r#"{"20": "AB AB AB AB AB AB AB AB"}"#));
        let e = &b.edit_texts[&20];
        assert!(e.word_wrap);
        let mut fonts = f;
        let sans = fonts.get("fonts/LiberationSans-Regular.ttf").unwrap();
        let widest = sans.measure("AB AB", 20.0).unwrap();
        let right = b.right_edge(e, &mut fonts).unwrap();
        let expected = 10.0 + ((widest * 1.03 + 6.0) * 20.0).ceil() / 20.0;
        assert!((right - expected).abs() < 1e-3, "{right} / {expected}");
        let runs = b.edit_runs(20, None, &mut fonts).unwrap();
        assert!(runs.len() >= 3);
        f = fonts;

        // "kaydir": false kararı kutuyu özgün genişliğinde ve tek satırda bırakır
        let b = bank(
            &json,
            None,
            Some(r#"{"20": {"metin": "AB AB AB AB AB AB AB AB", "kaydir": false, "boyut": 0.5}}"#),
        );
        let e = &b.edit_texts[&20];
        assert!(!e.word_wrap);
        assert_eq!(e.size, 10.0);
        assert_eq!(b.right_edge(e, &mut f).unwrap(), 210.0);
        assert_eq!(b.edit_runs(20, None, &mut f).unwrap().len(), 1);

        // Tek satırlık etiket kaydırılmaz (kutunun dışına taşabilir)
        let b = bank(
            &field_json("left", r#""AB""#, ""),
            None,
            Some(r#"{"20": "Çok uzun bir Türkçe etiket yazısı burada"}"#),
        );
        assert!(!b.edit_texts[&20].word_wrap);
        assert_eq!(b.edit_runs(20, None, &mut f).unwrap().len(), 1);
    }

    #[test]
    fn html_text_uses_its_fonts_colours_and_breaks() {
        let mut f = fonts();
        let html = r##""<p align=\"center\"><font face=\"_sans\" size=\"10\" color=\"#5b482d\"><b>Bir </b><b><i>iki</i></b>&apos;<sbr />üç</font></p>""##;
        let b = bank(
            &field_json("left", html, r#""html", "multiline""#),
            None,
            None,
        );
        let runs = b.edit_runs(20, None, &mut f).unwrap();
        // Satır 1: kalın "Bir " + kalın italik "iki" + düz "'"; satır 2: düz "üç"
        assert_eq!(runs.len(), 4);
        let sizes: Vec<f32> = runs.iter().map(|r| r.size).collect();
        assert_eq!(sizes, [10.0; 4]);
        assert_eq!(runs[0].color, Color::from_hex("#5b482d").unwrap());
        let bold_italic = f.get("fonts/LiberationSans-BoldItalic.ttf").unwrap();
        let bold = f.get("fonts/LiberationSans-Bold.ttf").unwrap();
        assert!(Arc::ptr_eq(&runs[1].font, &bold_italic));
        assert!(Arc::ptr_eq(&runs[0].font, &bold));
        let regular = f.get("fonts/LiberationSans-Regular.ttf").unwrap();
        assert!(Arc::ptr_eq(&runs[2].font, &regular));
        assert!(Arc::ptr_eq(&runs[3].font, &regular));
        assert_eq!(runs[2].glyphs[0].id, regular.glyph_id('\'').unwrap());
        assert!(runs[3].glyphs[0].position.y > runs[0].glyphs[0].position.y);
        // Ortalanmış
        assert!(runs[0].glyphs[0].position.x > 50.0);
    }

    #[test]
    fn html_translation_of_a_broken_box_wraps_it() {
        let html = r#""<p align=\"left\"><font face=\"_sans\" size=\"10\"><b>AB AB<sbr />AB</b></font></p>""#;
        let b = bank(
            &field_json("left", html, r#""html", "multiline""#),
            None,
            Some(
                r#"{"20": "html:<p align=\"left\"><font face=\"_sans\" size=\"10\"><b>Uzun bir yazı</b></font></p>"}"#,
            ),
        );
        let e = &b.edit_texts[&20];
        assert!(e.html && e.word_wrap);
        let fit = e.fit_width.as_ref().unwrap();
        assert_eq!(fit.text, "AB AB\nAB");
        assert!(fit.bold);
    }

    #[test]
    fn empty_and_unknown_texts() {
        let mut f = fonts();
        let b = bank(&field_json("left", r#""""#, ""), None, None);
        assert!(b.edit_image(20, None, &mut f).unwrap().shapes.is_empty());
        assert!(matches!(
            b.edit_runs(99, None, &mut f),
            Err(TextError::Unknown(99))
        ));
        assert!(f.get("fonts/yok.ttf").is_err());
    }
}
