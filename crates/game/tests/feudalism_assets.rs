//! Aktarılan Feudalism içeriğinin (content/feudalism) ve Türkçe çevirinin motorca okunabildiğini denetler.
#![allow(clippy::unwrap_used, clippy::expect_used, clippy::panic)]

use std::collections::HashMap;

use game::content::EMBEDDED;

use engine::svg::load_svg;
use engine::tessellate::tessellate;
use engine::text::Font;

#[test]
fn every_imported_shape_loads_and_tessellates() {
    let mut count = 0;
    let mut failures = Vec::new();
    // Vektör şekiller, resim dolgulu şekiller ve morph şekillerin başlangıç / bitiş hâlleri motorca
    // çizilir. Canlandırmalı özgün morph dosyaları (FFDec'in SVG'si) çizilmez.
    let drawable = |n: &str| {
        n.starts_with("feudalism/")
            && (n.contains("/shapes/")
                || n.contains("/shapes-bitmap/")
                || n.ends_with(".start.svg")
                || n.ends_with(".end.svg"))
    };
    for (name, data) in EMBEDDED.iter().filter(|(n, _)| drawable(n)) {
        count += 1;
        let result = load_svg(data)
            .map_err(|e| e.to_string())
            .and_then(|image| tessellate(&image, 0.1).map_err(|e| e.to_string()));
        if let Err(e) = result {
            failures.push(format!("{name}: {e}"));
        }
    }
    assert!(
        count > 3000,
        "aktarılan şekil sayısı beklenenden az: {count}"
    );
    assert!(
        failures.is_empty(),
        "okunamayan şekiller:\n{}",
        failures.join("\n")
    );
}

#[test]
fn both_libraries_are_embedded() {
    for game in ["f1", "f2"] {
        for file in ["library.json", "texts.json"] {
            let name = format!("feudalism/{game}/{file}");
            assert!(
                EMBEDDED.iter().any(|(n, _)| *n == name),
                "{name} gömülü değil"
            );
        }
    }
}

#[test]
fn images_and_sounds_are_embedded() {
    for (game, images, sounds) in [("f1", 18, 16), ("f2", 24, 16)] {
        let count = |dir: &str| {
            let prefix = format!("feudalism/{game}/{dir}/");
            EMBEDDED
                .iter()
                .filter(|(n, d)| n.starts_with(&prefix) && !d.is_empty())
                .count()
        };
        assert_eq!(count("images"), images, "{game} resim sayısı");
        assert_eq!(count("sounds"), sounds, "{game} ses sayısı");
    }
}

fn embedded(name: &str) -> &'static [u8] {
    EMBEDDED
        .iter()
        .find(|(n, _)| *n == name)
        .map(|(_, d)| *d)
        .unwrap_or_else(|| panic!("{name} gömülü değil"))
}

fn json(name: &str) -> serde_json::Value {
    serde_json::from_slice(embedded(name)).unwrap_or_else(|e| panic!("{name}: {e}"))
}

/// texts.json'daki yazı tipi kimliği → açık lisanslı karşılığı (yüklenmiş).
fn substitute_fonts(texts: &serde_json::Value) -> HashMap<String, (String, Font)> {
    let mut out = HashMap::new();
    for (fid, font) in texts["fonts"].as_object().expect("fonts") {
        let file = font["file"]
            .as_str()
            .unwrap_or_else(|| panic!("yazı tipi {fid} için karşılık yok"));
        let loaded = Font::from_bytes(embedded(file).to_vec(), None)
            .unwrap_or_else(|e| panic!("{file} okunamadı: {e}"));
        out.insert(fid.clone(), (file.to_string(), loaded));
    }
    out
}

#[test]
fn every_font_has_an_open_substitute_with_turkish_letters() {
    for game in ["f1", "f2"] {
        let texts = json(&format!("feudalism/{game}/texts.json"));
        for (fid, (file, font)) in substitute_fonts(&texts) {
            for c in "çğıİöşüÇĞÖŞÜ".chars() {
                assert!(
                    font.has_char(c),
                    "{game} yazı tipi {fid} ({file}): '{c}' yok"
                );
            }
        }
    }
}

#[test]
fn every_translated_text_can_be_drawn_with_its_font() {
    let drawable = |c: &char| !c.is_whitespace() && !c.is_control();
    for game in ["f1", "f2"] {
        let texts = json(&format!("feudalism/{game}/texts.json"));
        let fonts = substitute_fonts(&texts);
        let mut missing = Vec::new();
        // Sabit yazılar: her parça orijinaldeki bir kayda denk gelir; yazı tipi önceki kayıttan sürer
        let statics = json(&format!("feudalism/{game}/ceviri/sabit.json"));
        for (tid, entry) in statics.as_object().expect("sabit").iter() {
            if tid.starts_with('_') {
                continue;
            }
            let records = texts["texts"][tid]["records"].as_array().expect("kayıtlar");
            let mut font = String::new();
            for (record, part) in records
                .iter()
                .zip(entry["parcalar"].as_array().expect("parçalar"))
            {
                if let Some(f) = record["font"].as_u64() {
                    font = f.to_string();
                }
                let (file, f) = &fonts[&font];
                for c in part.as_str().expect("parça").chars().filter(drawable) {
                    if !f.has_char(c) {
                        missing.push(format!("sabit yazı {tid}: '{c}' {file} içinde yok"));
                    }
                }
            }
        }
        // Ekran kutuları: kutunun kendi yazı tipiyle (HTML etiketleri harf sayılmaz)
        let boxes = json(&format!("feudalism/{game}/ceviri/kutular.json"));
        for (eid, value) in boxes.as_object().expect("kutular").iter() {
            if eid.starts_with('_') {
                continue;
            }
            let Some(font) = texts["edit_texts"][eid]["font"].as_u64() else {
                continue;
            };
            let raw = value
                .as_str()
                .or_else(|| value["metin"].as_str())
                .expect("kutu yazısı");
            let raw = raw.strip_prefix("html:").unwrap_or(raw);
            let mut text = String::new();
            let mut in_tag = false;
            for c in raw.chars() {
                match c {
                    '<' => in_tag = true,
                    '>' => in_tag = false,
                    _ if !in_tag => text.push(c),
                    _ => {}
                }
            }
            let (file, f) = &fonts[&font.to_string()];
            for c in text.chars().filter(drawable) {
                if !f.has_char(c) {
                    missing.push(format!("ekran kutusu {eid}: '{c}' {file} içinde yok"));
                }
            }
        }
        assert!(
            missing.is_empty(),
            "{game}: çizilemeyen harfler:\n{}",
            missing.join("\n")
        );
    }
}

#[test]
fn every_text_and_text_field_lays_out_in_both_languages() {
    use engine::movie_text::{Fonts, TextBank};
    let assets = game::content::assets(None);
    for game in ["f1", "f2"] {
        let prefix = format!("feudalism/{game}/");
        for turkish in [false, true] {
            let bank = TextBank::load(&assets, &prefix, turkish).unwrap();
            let mut fonts = Fonts::new(assets.clone());
            let mut problems = Vec::new();
            let mut glyphs = 0;
            let mut ids: Vec<_> = bank.texts.keys().copied().collect();
            ids.sort();
            for id in ids {
                match bank.static_runs(id, &mut fonts) {
                    Ok((_, runs)) => {
                        for g in runs.iter().flat_map(|r| &r.glyphs) {
                            glyphs += 1;
                            if g.id == 0 {
                                problems.push(format!("yazı {id}: yazı tipinde olmayan harf"));
                            }
                        }
                    }
                    Err(e) => problems.push(format!("yazı {id}: {e}")),
                }
            }
            let mut ids: Vec<_> = bank.edit_texts.keys().copied().collect();
            ids.sort();
            for id in ids {
                match bank.edit_runs(id, None, &mut fonts) {
                    Ok(runs) => {
                        for g in runs.iter().flat_map(|r| &r.glyphs) {
                            glyphs += 1;
                            if g.id == 0 {
                                problems.push(format!("kutu {id}: yazı tipinde olmayan harf"));
                            }
                        }
                    }
                    Err(e) => problems.push(format!("kutu {id}: {e}")),
                }
            }
            assert!(glyphs > 5000, "{game}: yalnız {glyphs} harf dizildi");
            assert!(
                problems.is_empty(),
                "{game} (Türkçe: {turkish}):\n{}",
                problems.join("\n")
            );
        }
    }
}

#[test]
fn translation_tables_and_drawn_texts_are_embedded() {
    for (game, drawn) in [("f1", "2019"), ("f2", "3094")] {
        for table in [
            "adlar",
            "kod",
            "sabit",
            "kutular",
            "yazitipleri",
            "sekiller",
        ] {
            json(&format!("feudalism/{game}/ceviri/{table}.json"));
        }
        let svg = embedded(&format!("feudalism/{game}/ceviri/sekiller/{drawn}.svg"));
        let image = load_svg(svg).expect("Öldün... çizimi okunur");
        tessellate(&image, 0.1).expect("Öldün... çizimi üçgenlenir");
    }
}

#[test]
fn both_movies_play_every_root_frame_and_draw_only_imported_symbols() {
    use engine::glam::Affine2;
    use engine::movie::{Clip, DrawCommand, DrawKind, Library};
    use engine::render::ColorTransform;

    for game in ["f1", "f2"] {
        let lib = Library::from_json(
            embedded(&format!("feudalism/{game}/library.json")),
            Some(embedded(&format!("feudalism/{game}/texts.json"))),
        )
        .unwrap_or_else(|e| panic!("{game}: {e}"));
        let mut events = Vec::new();
        let mut root = Clip::root(&lib, &mut events);
        let frames = root.frame_count(&lib);
        let mut drawn = 0;
        for frame in 0..frames {
            root.goto(&lib, frame, false, &mut events);
            // Her ekranın içindeki sprite'lar birkaç kare oynatılır
            for _ in 0..3 {
                root.tick(&lib, &mut events);
            }
            for cmd in root.draw_commands(&lib, Affine2::IDENTITY, ColorTransform::IDENTITY) {
                let item = match cmd {
                    DrawCommand::Draw(item) => item,
                    DrawCommand::MaskStart(items) if !items.is_empty() => items[0].clone(),
                    _ => continue,
                };
                drawn += 1;
                let file = match item.kind {
                    DrawKind::Shape(id) => format!("feudalism/{game}/shapes/{id}.svg"),
                    DrawKind::BitmapShape(id) => format!("feudalism/{game}/shapes-bitmap/{id}.svg"),
                    DrawKind::Morph { id, ratio } => {
                        assert!(
                            (0.0..=1.0).contains(&ratio),
                            "{game} morph {id}: oran {ratio}"
                        );
                        format!("feudalism/{game}/morphs/{id}.start.svg")
                    }
                    DrawKind::Text(_) | DrawKind::EditText(_) => continue,
                };
                assert!(
                    EMBEDDED.iter().any(|(n, _)| *n == file),
                    "{game} kare {}: çizilecek {file} yok",
                    frame + 1
                );
            }
        }
        assert!(drawn > 1000, "{game}: çok az çizim ({drawn})");
        // Dışarıda bırakılan sponsor parçaları hiçbir karede çizilmez
        for frame in 0..frames {
            root.goto(&lib, frame, false, &mut events);
            for cmd in root.draw_commands(&lib, Affine2::IDENTITY, ColorTransform::IDENTITY) {
                if let DrawCommand::Draw(item) = cmd
                    && let DrawKind::Shape(id)
                    | DrawKind::BitmapShape(id)
                    | DrawKind::Morph { id, .. } = item.kind
                {
                    assert!(
                        !lib.excluded.contains_key(&id),
                        "{game} kare {}: {id} dışarıda",
                        frame + 1
                    );
                }
            }
        }
    }
}

#[test]
fn every_morph_has_matching_ends_and_interpolates() {
    use engine::morph::lerp_image;
    let mut count = 0;
    let mut failures = Vec::new();
    for (name, data) in EMBEDDED
        .iter()
        .filter(|(n, _)| n.starts_with("feudalism/") && n.ends_with(".start.svg"))
    {
        count += 1;
        let end = embedded(&name.replace(".start.svg", ".end.svg"));
        let result = load_svg(data)
            .and_then(|a| load_svg(end).map(|b| (a, b)))
            .map_err(|e| e.to_string())
            .and_then(|(a, b)| lerp_image(&a, &b, 0.5).map_err(|e| e.to_string()))
            .and_then(|m| tessellate(&m, 0.1).map_err(|e| e.to_string()));
        if let Err(e) = result {
            failures.push(format!("{name}: {e}"));
        }
    }
    assert_eq!(count, 11 + 24, "morph sayısı");
    assert!(
        failures.is_empty(),
        "ara hâli kurulamayan morph'lar:\n{}",
        failures.join("\n")
    );
}

#[test]
fn hairline_indices_point_at_stroked_paths() {
    // library.json "hairlines": şekil → [yolun SVG'deki sırası, özgün kalınlık]. Motor bu sırayla
    // vektör resmin şeklini bulur ve çizgisini en az 1 ekran pikseli yapar.
    let mut checked = 0;
    for game in ["f1", "f2"] {
        let lib = json(&format!("feudalism/{game}/library.json"));
        for (id, list) in lib["hairlines"].as_object().unwrap() {
            let image = load_svg(embedded(&format!("feudalism/{game}/shapes/{id}.svg"))).unwrap();
            for entry in list.as_array().unwrap() {
                let index = entry[0].as_u64().unwrap() as usize;
                let shape = image
                    .shapes
                    .get(index)
                    .unwrap_or_else(|| panic!("{game} {id}: yol {index} yok"));
                assert!(shape.stroke.is_some(), "{game} {id}: yol {index} çizgisiz");
                checked += 1;
            }
        }
    }
    assert_eq!(checked, 35 + 48, "ince çizgi sayısı");
}

#[test]
fn sponsor_texts_and_the_pirate_copy_screen_are_not_imported() {
    // Sahibinin kararı (16 Ekim 2026): sponsor adı geçen yazılar ve korsan kopya uyarı ekranı oyunda
    // gösterilmez; içerikten de çıkarılır (yalnız yerel arşivde kalır).
    for game in ["f1", "f2"] {
        let texts = json(&format!("feudalism/{game}/texts.json"));
        for kind in ["texts", "edit_texts"] {
            for (id, t) in texts[kind].as_object().unwrap() {
                let text = t["text"].as_str().unwrap_or("").to_lowercase();
                for word in [
                    "arcadetown",
                    "newgrounds",
                    "armorgames",
                    "addictinggames",
                    "stolen",
                    "сперли",
                ] {
                    assert!(!text.contains(word), "{game} yazı {id}: {word}");
                }
            }
        }
    }
    let lib = json("feudalism/f2/library.json");
    for id in [
        "2020", "2022", "2023", "3125", "3126", "3127", "3129", "3131", "3132",
    ] {
        assert!(lib["excluded"].get(id).is_some(), "f2 {id} dışarıda değil");
    }
}
