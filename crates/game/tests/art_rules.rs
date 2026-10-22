//! Sanat kurallarının otomatik denetimi (docs/SANAT.md, "Otomatik denetim").
//!
//! İçerikteki her SVG, motorun okuduğu biçimde yüklenip ölçülür. Çizimin türünü bulunduğu
//! klasör belirler: `characters`, `landscape`, `ui`.
#![allow(clippy::unwrap_used, clippy::expect_used, clippy::panic)]

use std::collections::HashSet;
use std::path::PathBuf;

use engine::color::Color;
use engine::paint::{Gradient, Paint};
use engine::shape::{SegmentCounts, VectorImage, segment_counts};
use engine::svg::load_svg;
use game::content::EMBEDDED;

/// Paletin kaynağı: çizim betikleri de aynı dosyayı okur.
const PALETTE: &str = include_str!("../../../tools/art/palet.txt");

/// Degradedeki en fazla durak sayısı. Esinin kahramanlarında degradelerin %88–100'ü 2 duraklı,
/// kalanı 3 duraklı (bkz. olcum/sonuclar.md).
const MAX_STOPS: usize = 3;
/// Doğrusal degradenin yatay ya da dikey eksenden en fazla sapması (derece). Esinde en büyük 14,6°.
const MAX_GRADIENT_TILT: f32 = 15.0;
/// Karakterde degradeyle boyanmış şekillerin en fazla oranı. Esinin kahramanlarında en büyük %56
/// (savaş kuklasında 0).
const MAX_CHARACTER_GRADIENT_SHARE: f32 = 0.56;
/// Karakter yollarındaki eğri parça oranının sınırları. Esinde ölçülen: savaş kuklası %55–67,
/// kahraman %59–75 (bkz. olcum/sonuclar.md).
const CHARACTER_CURVE_RATIO: (f32, f32) = (0.55, 0.75);
/// Karakterde izin verilen en kalın çizgi (yay kirişi, ip): SVG birimi.
const MAX_CHARACTER_STROKE: f32 = 1.5;
/// Manzara katmanında yarı saydam şekillerin en fazla oranı (siyah gölge ve beyaz ışık hariç).
const MAX_LANDSCAPE_TRANSLUCENT_SHARE: f32 = 0.10;

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
enum Kind {
    Character,
    Landscape,
    Ui,
    Other,
}

fn kind_of(path: &str) -> Kind {
    let parts: Vec<&str> = path.split('/').collect();
    if parts.contains(&"characters") {
        Kind::Character
    } else if parts.contains(&"landscape") {
        Kind::Landscape
    } else if parts.contains(&"ui") {
        Kind::Ui
    } else {
        Kind::Other
    }
}

fn parse_palette(text: &str) -> HashSet<[u8; 3]> {
    let mut colors = HashSet::new();
    for (no, line) in text.lines().enumerate() {
        let line = line.trim();
        if line.is_empty() || line.starts_with('#') {
            continue;
        }
        let hex = line
            .split_whitespace()
            .nth(1)
            .unwrap_or_else(|| panic!("palet.txt:{}: renk yok: {line:?}", no + 1));
        let c = Color::from_hex(hex)
            .unwrap_or_else(|e| panic!("palet.txt:{}: {e}", no + 1))
            .to_rgba8();
        colors.insert([c[0], c[1], c[2]]);
    }
    colors
}

fn hex(c: Color) -> String {
    let [r, g, b, _] = c.to_rgba8();
    format!("#{r:02X}{g:02X}{b:02X}")
}

fn rgb(c: Color) -> [u8; 3] {
    let [r, g, b, _] = c.to_rgba8();
    [r, g, b]
}

fn paint_colors(paint: &Paint) -> Vec<Color> {
    match paint {
        Paint::Solid(c) => vec![*c],
        Paint::Gradient(g) => g.stops.iter().map(|s| s.color).collect(),
        // Eski örnek çizimlerde resim boyası yok; renk kuralları yalnız vektör boyalara bakar
        Paint::Image(_) => Vec::new(),
    }
}

/// Doğrusal degradenin en yakın eksenden sapması (derece).
fn gradient_tilt(g: &Gradient) -> Option<f32> {
    let d = g.linear_direction()?;
    let angle = d.y.abs().atan2(d.x.abs()).to_degrees();
    Some(angle.min(90.0 - angle))
}

fn is_black_or_white(c: Color) -> bool {
    matches!(rgb(c), [0, 0, 0] | [255, 255, 255])
}

/// Bir çizimin kurallara aykırı yanlarını sıralar.
fn problems(image: &VectorImage, kind: Kind, palette: &HashSet<[u8; 3]>) -> Vec<String> {
    let mut out = Vec::new();
    let mut off_palette = Vec::new();
    let mut filled = 0usize;
    let mut gradient_filled = 0usize;
    let mut translucent = 0usize;
    let mut segments = SegmentCounts::default();

    for (i, shape) in image.shapes.iter().enumerate() {
        let paints = shape
            .fill
            .iter()
            .map(|f| &f.paint)
            .chain(shape.stroke.iter().map(|s| &s.paint));
        for paint in paints {
            for c in paint_colors(paint) {
                if !palette.contains(&rgb(c)) && !off_palette.contains(&hex(c)) {
                    off_palette.push(hex(c));
                }
            }
            if let Paint::Gradient(g) = paint {
                if g.stops.len() > MAX_STOPS {
                    out.push(format!("şekil {i}: degradede {} durak var", g.stops.len()));
                }
                if let Some(tilt) = gradient_tilt(g)
                    && tilt > MAX_GRADIENT_TILT
                {
                    out.push(format!("şekil {i}: degrade eksenden {tilt:.0}° eğik"));
                }
            }
        }
        if let Some(fill) = &shape.fill {
            filled += 1;
            if matches!(fill.paint, Paint::Gradient(_)) {
                gradient_filled += 1;
            }
            let colors = paint_colors(&fill.paint);
            if colors.iter().any(|c| c.a < 0.999) && !colors.iter().all(|c| is_black_or_white(*c)) {
                translucent += 1;
            }
        }
        if let Some(stroke) = &shape.stroke {
            match kind {
                Kind::Character if stroke.width > MAX_CHARACTER_STROKE => out.push(format!(
                    "şekil {i}: karakterde {:.1} birimlik kontur (en fazla {MAX_CHARACTER_STROKE})",
                    stroke.width
                )),
                Kind::Landscape => out.push(format!("şekil {i}: manzarada kontur")),
                _ => {}
            }
        }
        let c = segment_counts(&shape.path);
        segments.lines += c.lines;
        segments.curves += c.curves;
    }

    if !off_palette.is_empty() {
        out.push(format!(
            "paletin dışında renkler: {}",
            off_palette.join(", ")
        ));
    }
    if kind == Kind::Character && filled > 0 {
        let share = gradient_filled as f32 / filled as f32;
        if share > MAX_CHARACTER_GRADIENT_SHARE {
            out.push(format!(
                "şekillerin %{:.0}'i degradeli (en fazla %{:.0})",
                share * 100.0,
                MAX_CHARACTER_GRADIENT_SHARE * 100.0
            ));
        }
        let ratio = segments.curve_ratio();
        let (lo, hi) = CHARACTER_CURVE_RATIO;
        if !(lo..=hi).contains(&ratio) {
            out.push(format!(
                "eğri parça oranı %{:.0} (izin verilen %{:.0}–%{:.0})",
                ratio * 100.0,
                lo * 100.0,
                hi * 100.0
            ));
        }
    }
    if kind == Kind::Landscape && filled > 0 {
        let share = translucent as f32 / filled as f32;
        if share > MAX_LANDSCAPE_TRANSLUCENT_SHARE {
            out.push(format!(
                "şekillerin %{:.0}'i yarı saydam (en fazla %{:.0})",
                share * 100.0,
                MAX_LANDSCAPE_TRANSLUCENT_SHARE * 100.0
            ));
        }
    }
    out
}

fn art_files() -> Vec<(&'static str, &'static [u8])> {
    EMBEDDED
        .iter()
        .filter(|(name, _)| name.starts_with("art/") && name.ends_with(".svg"))
        .map(|(n, d)| (*n, *d))
        .collect()
}

#[test]
fn all_art_follows_the_rules() {
    let palette = parse_palette(PALETTE);
    let files = art_files();
    assert!(!files.is_empty(), "içerikte hiç çizim yok");
    let mut report = Vec::new();
    for (name, data) in files {
        let image = load_svg(data).unwrap_or_else(|e| panic!("{name}: {e}"));
        for p in problems(&image, kind_of(name), &palette) {
            report.push(format!("{name}: {p}"));
        }
    }
    assert!(
        report.is_empty(),
        "sanat kurallarına aykırı çizimler:\n{}",
        report.join("\n")
    );
}

#[test]
fn art_document_lists_every_palette_color() {
    let doc = std::fs::read_to_string(
        PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../../docs/SANAT.md"),
    )
    .unwrap()
    .to_uppercase();
    let missing: Vec<String> = parse_palette(PALETTE)
        .into_iter()
        .map(|c| format!("#{:02X}{:02X}{:02X}", c[0], c[1], c[2]))
        .filter(|h| !doc.contains(h))
        .collect();
    assert!(
        missing.is_empty(),
        "SANAT.md'de olmayan renkler: {missing:?}"
    );
}

#[test]
fn scene_text_colors_come_from_the_palette() {
    let palette = parse_palette(PALETTE);
    for (name, data) in EMBEDDED.iter().filter(|(n, _)| n.ends_with(".ron")) {
        let text = std::str::from_utf8(data).unwrap();
        for (i, _) in text.match_indices("\"#") {
            let code = &text[i + 1..i + 8];
            let c = Color::from_hex(code).unwrap_or_else(|e| panic!("{name}: {e}"));
            assert!(palette.contains(&rgb(c)), "{name}: {code} paletin dışında");
        }
    }
}

// --- Denetimin kendi testleri -------------------------------------------------------------

fn svg(body: &str) -> VectorImage {
    let text =
        format!(r#"<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100">{body}</svg>"#);
    load_svg(text.as_bytes()).unwrap()
}

fn small_palette() -> HashSet<[u8; 3]> {
    parse_palette("# deneme\nkırmızı #CC0000\nsiyah #000000\nbeyaz #FFFFFF\n")
}

#[test]
fn kind_comes_from_the_folder() {
    assert_eq!(kind_of("art/samples/characters/hero.svg"), Kind::Character);
    assert_eq!(kind_of("art/samples/landscape/1-sky.svg"), Kind::Landscape);
    assert_eq!(kind_of("art/ui/window.svg"), Kind::Ui);
    assert_eq!(kind_of("art/other.svg"), Kind::Other);
}

#[test]
fn palette_file_parses() {
    let p = parse_palette(PALETTE);
    assert!(p.len() > 100, "{}", p.len());
    assert!(p.contains(&[0x00, 0x45, 0xAB]));
}

#[test]
fn off_palette_colors_and_strokes_are_reported() {
    let image = svg(
        r##"<path d="M0 0 Q50 10 100 0 L100 100 Q50 90 0 100 Z" fill="#CC0001" stroke="#000000" stroke-width="4"/>"##,
    );
    let p = problems(&image, Kind::Character, &small_palette());
    assert!(p.iter().any(|s| s.contains("#CC0001")), "{p:?}");
    assert!(p.iter().any(|s| s.contains("kontur")), "{p:?}");
    assert!(
        problems(&image, Kind::Landscape, &small_palette())
            .iter()
            .any(|s| s.contains("manzarada kontur"))
    );
}

#[test]
fn tilted_and_many_stop_gradients_are_reported() {
    let image = svg(
        r##"<defs><linearGradient id="g" gradientUnits="userSpaceOnUse" x1="0" y1="0" x2="100" y2="100">
        <stop offset="0" stop-color="#CC0000"/><stop offset="0.3" stop-color="#000000"/>
        <stop offset="0.6" stop-color="#FFFFFF"/><stop offset="1" stop-color="#CC0000"/></linearGradient></defs>
        <rect width="100" height="100" fill="url(#g)"/>"##,
    );
    let p = problems(&image, Kind::Ui, &small_palette());
    assert!(p.iter().any(|s| s.contains("4 durak")), "{p:?}");
    assert!(p.iter().any(|s| s.contains("45° eğik")), "{p:?}");

    let ok = svg(
        r##"<defs><linearGradient id="g" gradientUnits="userSpaceOnUse" x1="0" y1="0" x2="10" y2="100">
        <stop offset="0" stop-color="#CC0000"/><stop offset="1" stop-color="#000000"/></linearGradient></defs>
        <rect width="100" height="100" fill="url(#g)"/>"##,
    );
    assert!(problems(&ok, Kind::Ui, &small_palette()).is_empty());
}

#[test]
fn character_curve_ratio_and_gradient_share_are_checked() {
    // Yalnızca düz kenarlı çokgenler: "low-poly" görünüş.
    let poly = svg(r##"<path d="M0 0 L50 10 L100 0 L90 50 L100 100 L0 100 Z" fill="#CC0000"/>"##);
    let p = problems(&poly, Kind::Character, &small_palette());
    assert!(p.iter().any(|s| s.contains("eğri parça oranı %0")), "{p:?}");

    // Üç eğri, iki düz kenar (%60 eğri, esindeki gibi): kabul.
    let mixed = svg(
        r##"<path d="M0 0 Q50 10 100 0 L100 100 Q50 90 0 100 Q-5 50 0 10 Z" fill="#CC0000"/>"##,
    );
    assert!(problems(&mixed, Kind::Character, &small_palette()).is_empty());

    let graded = svg(
        r##"<defs><linearGradient id="g" x1="0" y1="0" x2="0" y2="1">
        <stop offset="0" stop-color="#CC0000"/><stop offset="1" stop-color="#000000"/></linearGradient></defs>
        <path d="M0 0 Q50 10 100 0 L100 100 Q50 90 0 100 Z" fill="url(#g)"/>"##,
    );
    let p = problems(&graded, Kind::Character, &small_palette());
    assert!(p.iter().any(|s| s.contains("degradeli")), "{p:?}");
}

#[test]
fn landscape_translucency_is_limited_but_shadows_are_free() {
    let shapes: String = (0..10)
        .map(|i| format!(r##"<rect x="{i}" width="5" height="5" fill="#CC0000"/>"##))
        .collect();
    let shadow = r##"<ellipse cx="50" cy="50" rx="20" ry="5" fill="#000000" opacity="0.3"/>"##;
    let fog = r##"<rect width="100" height="20" fill="#CC0000" opacity="0.5"/>"##;
    let with_shadow = svg(&format!("{shapes}{shadow}"));
    assert!(problems(&with_shadow, Kind::Landscape, &small_palette()).is_empty());
    let with_fog = svg(&format!("{shapes}{fog}{fog}"));
    let p = problems(&with_fog, Kind::Landscape, &small_palette());
    assert!(p.iter().any(|s| s.contains("yarı saydam")), "{p:?}");
}
