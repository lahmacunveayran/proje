"""Türkçe çeviriyi oyunun içeriğine aktarır ve doğrular.

Çeviri, oyunların sahibinin swf-oyunlar deposundadır (oyunlar/<oyun>/ceviri). Tablolar değiştirilmeden
content/feudalism/<oyun>/ceviri/ altına kopyalanır; her girdinin hedefi aktarılan içerikte doğrulanır,
tutmayan bir şey varsa aktarım durur. Ayrıca:

- Resim olarak çizilmiş yazıların Türkçe hâlleri (sekiller.json) Türkçe SWF'nin FFDec dökümünden
  (referans/<oyun>/tr/shapes) alınır: ceviri/sekiller/<kimlik>.svg.
- Koddaki metinler, çevirinin kendi aracıyla (swf-oyunlar/araclar/kod_cevir.py) aktarılan kod dökümüne
  uygulanır: kaynak/feudalism/<oyun>/kod-tr/ (yalnız çevrilen dosyalar; oyuna gömülmez).
- Oyunun gömülü yazı tipleri aktarılmadığı için (lisansları yazı tipi yapımcılarındadır) her yazı tipine
  açık lisanslı bir karşılık seçilir: önce çevirinin kendi eşlemesi (yazitipleri.json), yoksa ad ve
  stile göre Liberation Sans ya da Serif. Dosyalar content/fonts/ altına kopyalanır.
"""
import json
import os
import re
import shutil
import subprocess
import sys

TRANSLATIONS = {"f1": "oyunlar/feudalism", "f2": "oyunlar/feudalism-2"}
TABLES = ("adlar", "kod", "sabit", "kutular", "yazitipleri", "sekiller")
META_KEYS = ("_aciklama", "_anahtar_adlar")  # "__Packages/..." gibi kod yolları da alt çizgiyle başlar
# Gömülü olmayan ya da çeviri tablosunda karşılığı olmayan yazı tipleri: ad → Liberation ailesi
FONT_FAMILIES = {"Arial": "LiberationSans", "_sans": "LiberationSans",
                 "Times New Roman": "LiberationSerif", "_serif": "LiberationSerif"}
# Yazı tipi dosyalarının lisans metinleri: dosya adının başı → (swf-oyunlar'daki lisans, content/fonts'taki adı)
FONT_LICENSES = {"Liberation": ("yazitipleri/OFL-1.1.txt", "OFL-Liberation.txt"),
                 "texgyre": ("araclar/yazitipleri/GUST-Font-License.txt", "GUST-Font-License.txt")}


def entries(table):
    """Tablonun çeviri girdileri (açıklama ve ayar satırları dışında)."""
    return {k: v for k, v in table.items() if k not in META_KEYS}


def load_tables(folder):
    tables = {}
    for name in TABLES:
        with open(os.path.join(folder, f"{name}.json"), encoding="utf-8") as f:
            tables[name] = json.load(f)
    return tables


def block_end(text, start):
    """FFDec biçimli yazısında `[` ile başlayan ayar bloğunun sonu; tırnak içindeki `]` atlanır."""
    quoted = False
    for i in range(start, len(text)):
        if text[i] == '"':
            quoted = not quoted
        elif text[i] == "]" and not quoted:
            return i
    return len(text) - 1


def text_parts(formatted):
    """FFDec biçimli yazısının metin parçaları: ayar blokları arasında kalan her parça (çevirinin
    Cevir.java aracıyla aynı kural; ters bölüyle kaçırılmış `\\[` metne dahildir)."""
    parts = []
    i = 0
    while i < len(formatted):
        if formatted[i] == "[":
            i = block_end(formatted, i) + 1
            continue
        end = i
        while end < len(formatted) and formatted[end] != "[":
            end += 2 if formatted[end] == "\\" else 1
        parts.append(formatted[i:end])
        i = end
    return parts


def font_file(fid, font, table):
    """Yazı tipinin açık lisanslı karşılığı: swf-oyunlar içindeki dosya yolu; bulunamazsa None."""
    if str(fid) in entries(table):
        return entries(table)[str(fid)]["kaynak"]
    family = FONT_FAMILIES.get(font["name"])
    if family is None:
        return None
    style = {(False, False): "Regular", (True, False): "Bold", (False, True): "Italic",
             (True, True): "BoldItalic"}[(bool(font.get("bold")), bool(font.get("italic")))]
    return f"yazitipleri/{family}-{style}.ttf"


def check(tables, texts, lib, ffdec_texts):
    """Her çeviri girdisinin hedefi aktarılan içerikte var mı. `ffdec_texts`: FFDec'in biçimli yazı
    dökümü klasörü (sabit yazının parça sayısı oradan sayılır, kayıt sayısıyla da aynı olmalıdır)."""
    probs = []
    excluded = lib.get("excluded", {})
    for tid, entry in entries(tables["sabit"]).items():
        if tid in excluded:
            continue
        if tid not in texts["texts"]:
            probs.append(f"sabit yazı {tid}: oyunda yok")
            continue
        with open(os.path.join(ffdec_texts, f"{tid}.txt"), encoding="utf-8") as f:
            original = len(text_parts(f.read()))
        n = len(entry["parcalar"])
        if n != original or n != len(texts["texts"][tid]["records"]):
            probs.append(f"sabit yazı {tid}: çeviride {n} parça, orijinalde {original} parça "
                         f"ve {len(texts['texts'][tid]['records'])} kayıt")
    probs += [f"ekran kutusu {eid}: oyunda yok" for eid in entries(tables["kutular"])
              if eid not in texts["edit_texts"] and eid not in excluded]
    probs += [f"yazı tipi {fid}: oyunda yok" for fid in entries(tables["yazitipleri"]) if fid not in texts["fonts"]]
    probs += [f"çizilmiş yazı {sid}: oyunda şekil olarak yok" for sid in entries(tables["sekiller"])
              if sid not in lib["shapes"]]
    return probs


def unused_entries(tables, lib):
    """Hedefi bilerek dışarıda bırakılan (ör. gösterilmeyen sponsor yazısı) çeviri girdileri; tablolar
    değiştirilmez, bu girdiler yalnız kullanılmaz."""
    excluded = lib.get("excluded", {})
    out = {}
    for name in ("sabit", "kutular"):
        ids = sorted((k for k in entries(tables[name]) if k in excluded), key=int)
        if ids:
            out[name] = ids
    return out


def translate_code(swf_root, code_dir, tables_dir, out_dir):
    """Çevirinin kendi kod aracını aktarılan kod dökümüne uygular; çevrilen dosyalar `out_dir`'e yazılır.
    Araç bir çiftin eski metnini bulamazsa hata verir; o zaman aktarım durur."""
    if os.path.exists(out_dir):
        shutil.rmtree(out_dir)
    tool = os.path.join(swf_root, "araclar", "kod_cevir.py")
    result = subprocess.run([sys.executable, tool, code_dir, tables_dir, out_dir], capture_output=True, text=True)
    if result.returncode != 0:
        raise ValueError(f"kod çevirisi uygulanamadı:\n{result.stderr.strip()}")
    return sorted(os.path.relpath(os.path.join(d, n), out_dir).replace(os.sep, "/")
                  for d, _, names in os.walk(out_dir) for n in names)


# TeX Gyre ailelerinin dağıtım belgeleri ve LPPL 1.3c metni (GUST yazı tipi lisansı LPPL'nin bir örneğidir;
# kaynak: Ubuntu "fonts-texgyre 20180621" = TeX Gyre dağıtımı 2.501 ve "texlive-latex-base-doc", bkz.
# docs/LISANSLAR.md)
LICENCE_DOCS = os.path.join(os.path.dirname(os.path.abspath(__file__)), "lisanslar")
TEX_GYRE_FAMILY = re.compile(r"^texgyre([a-z]+)-")


def copy_fonts(swf_root, files, fonts_dir, docs_dir=LICENCE_DOCS):
    """Gereken yazı tipi dosyalarını ve lisans metinlerini content/fonts'a kopyalar. TeX Gyre yazı
    tiplerinin yanına LPPL 1.3c metni ve ailenin MANIFEST ve README dosyaları da konur (`docs_dir`'den;
    eksikse hata). Dönen: dosya adları."""
    os.makedirs(fonts_dir, exist_ok=True)
    copied = []
    for rel in sorted(set(files)):
        name = os.path.basename(rel)
        shutil.copyfile(os.path.join(swf_root, rel), os.path.join(fonts_dir, name))
        copied.append(name)
        for prefix, (lic, lic_name) in FONT_LICENSES.items():
            if name.startswith(prefix):
                shutil.copyfile(os.path.join(swf_root, lic), os.path.join(fonts_dir, lic_name))
        m = TEX_GYRE_FAMILY.match(name)
        if m:
            family = m.group(1).capitalize()
            for doc in ("LPPL-1.3c.txt", f"MANIFEST-TeX-Gyre-{family}.txt", f"README-TeX-Gyre-{family}.txt"):
                shutil.copyfile(os.path.join(docs_dir, doc), os.path.join(fonts_dir, doc))
    return copied


def import_translation(game, swf_root, archive, tr_archive, out_dir, code_dir, lib, texts, convert_shape):
    """Bir oyunun çevirisini aktarır. `archive`: orijinal SWF'nin FFDec dökümü; `tr_archive`: Türkçe
    SWF'nin dökümü (çizilmiş yazılar). Dönen: library.json'daki "translation" kaydı."""
    src = os.path.join(swf_root, TRANSLATIONS[game], "ceviri")
    tables = load_tables(src)
    probs = check(tables, texts, lib, os.path.join(archive, "texts"))
    if probs:
        raise ValueError(f"{game}: çeviri aktarılan içerikle uyuşmuyor:\n" + "\n".join(probs))
    dst = os.path.join(out_dir, "ceviri")
    if os.path.exists(dst):
        shutil.rmtree(dst)
    os.makedirs(os.path.join(dst, "sekiller"))
    for name in TABLES:
        shutil.copyfile(os.path.join(src, f"{name}.json"), os.path.join(dst, f"{name}.json"))
    drawn = {}
    for sid in entries(tables["sekiller"]):
        with open(os.path.join(tr_archive, "shapes", f"{sid}.svg"), encoding="utf-8") as f:
            converted = convert_shape(f.read())
        if converted is None:
            raise ValueError(f"{game}: çizilmiş yazı {sid} vektör şekil değil")
        svg, origin = converted
        with open(os.path.join(dst, "sekiller", f"{sid}.svg"), "w", encoding="utf-8") as f:
            f.write(svg)
        drawn[sid] = {"file": f"ceviri/sekiller/{sid}.svg", "origin": [round(v, 3) for v in origin]}
    code = translate_code(swf_root, os.path.join(code_dir, "kod"), src, os.path.join(code_dir, "kod-tr"))
    return {
        "source": f"swf-oyunlar/{TRANSLATIONS[game]}/ceviri",
        "tables": {name: f"ceviri/{name}.json" for name in TABLES},
        "unused": unused_entries(tables, lib),
        "counts": {"texts": len(entries(tables["sabit"])) - len(unused_entries(tables, lib).get("sabit", [])),
                   "edit_texts": len(entries(tables["kutular"])) - len(unused_entries(tables, lib).get("kutular", [])),
                   "code_files": len(code), "names": sum(len(v) for k, v in entries(tables["adlar"]).items()),
                   "drawn_texts": len(drawn)},
        "drawn_texts": drawn,
        "code": f"kaynak/feudalism/{game}/kod-tr",
    }
