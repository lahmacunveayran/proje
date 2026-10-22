"""Feudalism 1 ve 2'de ne var, ne yok: içerik dökümü (docs/FEUDALISM_ICERIK.md).

Her içerik türü için sayı, ayrıntı ve aktarım durumu: aktarıldı, bekliyor ya da aktarılmayacak (ve
nedeni). Yazılar ve sesler tek tek listelenir.

Kullanım (depo kökünden):  python3 araclar/aktar/envanter.py [swf-oyunlar klasörü]
"""
import json
import os
import re
import struct
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import aktar  # noqa: E402
import ceviri  # noqa: E402
import swf  # noqa: E402
from swfstats import tags  # noqa: E402

NAMES = {"f1": "Feudalism", "f2": "Feudalism 2"}
# Kök filmdeki ekran etiketlerinin Türkçesi
SCREENS = {"TOWN_SCREEN": "kamp / kasaba", "WORLD_MAP": "dünya haritası", "SPLASH_SCREEN": "savaşa hazırlık",
           "GAME_LOAD": "kayıt yükleme", "GAME_OVER": "oyun bitti", "VICTORY": "zafer", "STOLEN": "korsan kopya uyarısı",
           "BATTLE_TUT": "savaş öğreticisi", "TUTORIAL": "öğretici"}


class Details:
    """Bir SWF'nin döküm ayrıntıları: sesler, yazı tipleri, yazılar, alanlar, resimler."""

    def __init__(self, path):
        _, _, _, _, data, pos = swf.load(path)
        self.sounds, self.fonts, self.texts, self.edit_texts, self.images = [], {}, [], [], []
        font_codes = {}
        all_tags = list(tags(data, pos))
        for code, body in all_tags:
            if code in (48, 75):
                fid, name, bold, italic, codes = swf.read_font(body)
                font_codes[fid] = codes
                self.fonts[fid] = {"name": name, "bold": bold, "italic": italic, "glyphs": len(codes)}
        for code, body in all_tags:
            if code == 14:
                self.sounds.append(swf.read_sound(body))
            elif code in (11, 33):
                tid, lines = swf.read_text(body, code == 33)
                self.texts.append((tid, swf.decode_text(lines, font_codes)))
            elif code == 37:
                self.edit_texts.append(swf.read_edit_text(body))
            elif code in (6, 21, 35):
                bid = struct.unpack_from("<H", body, 0)[0]
                jpeg = body[6:6 + struct.unpack_from("<I", body, 2)[0]] if code == 35 else body[2:]
                self.images.append({"id": bid, "size": swf.jpeg_size(jpeg), "bytes": len(body)})
            elif code in (20, 36):
                bid = struct.unpack_from("<H", body, 0)[0]
                w, h = struct.unpack_from("<HH", body, 3)
                self.images.append({"id": bid, "size": (w, h), "bytes": len(body)})


def sprite_names(movie):
    """Sprite kimliği → okunur ad: dışa aktarılan ad ya da üst sprite'taki örnek adı."""
    names = {c: n for n, c in movie.exports.items()}
    for pid, t in movie.sprites.items():
        for ops in t.frames:
            for op in ops:
                if "char" in op and "name" in op and op["char"] not in names:
                    parent = names.get(pid, f"#{pid}")
                    names[op["char"]] = f"{parent}.{op['name']}"
    return names


def sound_uses(movie, names):
    """Ses kimliği → [kullanıldığı yer (kök film ya da sprite, kare etiketi, kare; sesi durduruyorsa
    "durdurur")]."""
    out = {}
    timelines = [("kök film", movie.root)] + [(names.get(sid, f"#{sid}"), t) for sid, t in sorted(movie.sprites.items())]
    for name, t in timelines:
        for frame, sounds in sorted(t.sounds.items()):
            label = max(((lb, f) for lb, f in t.labels.items() if f <= frame), key=lambda x: x[1], default=(None, 0))[0]
            where = name + (f" / {label}" if label else "") + f" / kare {frame + 1}"
            for s in sounds:
                out.setdefault(s["id"], []).append(where + (" (durdurur)" if s.get("stop") else ""))
    return out


def md_escape(text):
    return text.replace("|", "\\|").replace("\r", "").replace("\n", " / ").strip()


def strip_html(text):
    """Flash'ın HTML yazı alanlarından düz yazı: etiketler atılır, <sbr/> ve </p> satır sonu olur."""
    text = re.sub(r"<sbr\s*/?>|</p>", "\n", text)
    text = re.sub(r"<[^>]+>", "", text)
    return text.replace("&apos;", "'").replace("&quot;", '"').replace("&lt;", "<").replace("&gt;", ">").replace("&amp;", "&")


SPONSOR_TEXT = re.compile(r"arcadetown|armorgames|newgrounds|https?://|this version|other site|contact dev", re.I)


def instance_names(lib):
    """Karakter kimliği → zaman çizelgelerinde verilen örnek adları."""
    out = {}
    for t in [lib["root"]] + list(lib["sprites"].values()):
        for ops in t["frames"]:
            for op in ops:
                if "char" in op and "name" in op:
                    out.setdefault(op["char"], set()).add(op["name"])
    return out


def sponsor_boxes(lib, edit_texts):
    """Sponsor ekranlarındaki kutular: içinde sponsor ya da site metni geçen bir kutu bulunan ekranın bütün
    yazı kutuları (kimlik kümesi). Ekran: bir sprite'ın tamamı ya da kök filmin bir karesi."""
    screens = [[op for ops in t["frames"] for op in ops] for t in lib["sprites"].values()]
    screens += lib["root"]["frames"]
    out = set()
    for ops in screens:
        boxes = {op["char"] for op in ops if str(op.get("char")) in edit_texts}
        if any(SPONSOR_TEXT.search(strip_html(edit_texts[str(b)].get("text", ""))) for b in boxes):
            out |= boxes
    return out


# Çeviri tablosunda olmayan, ekranlara bakılarak bulunmuş çizilmiş yazılar: (şekil, yazı, durum)
KNOWN_DRAWN_TEXTS = {
    "f1": [(995, "The Age of...", "ana menüde oyunun başlığının parçası; İngilizce kalır (yeni çizim yapılmaz; "
                                  "sahibinin Türkçe sürümünde de İngilizce)"),
           (1019, "FEUDALISM", "oyunun adı; özel ad, çevrilmez")],
    "f2": [(None, "Feudalism II", "ana menüdeki oyunun adı; özel ad, çevrilmez")],
}
SPONSOR_REASON = "sponsor ya da site metni (sahibinin kararıyla gösterilmez)"


def untranslated_reason(edit, names, code, sponsor=False):
    """Çeviri tablosunda olmayan bir ekran kutusunun neden çevrilmediği. `names`: kutunun örnek adları,
    `code`: oyunun bütün kodu (tek metin), `sponsor`: kutu bir sponsor ekranında mı."""
    text = strip_html(edit.get("text", "")).strip()
    if not text:
        return "boş"
    if not any(ch.isalpha() for ch in text):  # her alfabeden harf (Latin dışı da)
        return "yalnız sayı ve işaret (oyun doldurur)"
    if sponsor or SPONSOR_TEXT.search(text):
        return SPONSOR_REASON
    if re.fullmatch(r"v\d[\d.]*[a-z]?", text):
        return "sürüm numarası (çevrilmez)"
    filled = edit.get("variable") or any(re.search(rf"\b{re.escape(n)}\.(?:html)?[tT]ext\s*=", code) for n in names)
    if filled:
        return "tasarım örneği; oyun kodla doldurur (Türkçesi kod çevirisinde)"
    tokens = text.split()
    if len(tokens) == 1 or all(len(t) == 1 for t in tokens):
        return "tek kelime: özel ad ya da kodda anahtar (çevrilmez)"
    return "ELLE BAKILMALI"


def translation_section(game, lib, swf_root):
    """Türkçe çevirinin kapsamı ve çevrilmeyen her ekran kutusunun nedeni."""
    with open(os.path.join(aktar.ROOT, "content", "feudalism", game, "texts.json"), encoding="utf-8") as f:
        texts = json.load(f)
    tables = ceviri.load_tables(os.path.join(swf_root, ceviri.TRANSLATIONS[game], "ceviri"))
    code = ""
    for d, _, files in os.walk(os.path.join(aktar.ROOT, "kaynak", "feudalism", game, "kod")):
        for n in sorted(files):
            with open(os.path.join(d, n), encoding="utf-8", errors="replace") as f:
                code += f.read() + "\n"
    names = instance_names(lib)
    sponsor = sponsor_boxes(lib, texts["edit_texts"])
    counts = lib["translation"]["counts"]
    sabit, kutular = ceviri.entries(tables["sabit"]), ceviri.entries(tables["kutular"])
    s = ["### Türkçe çeviri", "",
         f"Kaynak: `{lib['translation']['source']}` (oyunların sahibinin çevirisi). Tablolar değiştirilmeden "
         f"`content/feudalism/{game}/ceviri/` altında; çevrilmiş kod `{lib['translation']['code']}`.", "",
         "| Ne | Çevrilen | Toplam |", "|---|---|---|",
         f"| Sabit yazı | {len([t for t in texts['texts'] if t in sabit])} | {len(texts['texts'])} |",
         f"| Ekran kutusu | {len([e for e in texts['edit_texts'] if e in kutular])} | {len(texts['edit_texts'])} |",
         f"| Kod dosyası (ekranda görünen metinler) | {counts['code_files']} | – |",
         f"| Silah, zırh ve birlik adı | {counts['names']} | – |",
         f"| Resim olarak çizilmiş yazı | {counts['drawn_texts']} | – (kendiliğinden bulunamaz; bilinenler aşağıda) |", ""]
    s += ["Resim olarak çizilmiş yazılar, ekranlara bakılarak bulunanlar (başkaları da olabilir):", ""]
    s += [f"- şekil {sid}: \"{d.get('metin', '')}\" → çevrildi (`ceviri/sekiller/{sid}.svg`)"
          for sid, d in ceviri.entries(tables["sekiller"]).items()]
    s += [f"- {'şekil ' + str(sid) if sid else 'birkaç parça'}: \"{text}\" → {note}"
          for sid, text, note in KNOWN_DRAWN_TEXTS.get(game, [])]
    s.append("")
    rest = [(eid, e) for eid, e in sorted(texts["edit_texts"].items(), key=lambda x: int(x[0])) if eid not in kutular]
    reasons = {}
    for eid, e in rest:
        reasons.setdefault(untranslated_reason(e, names.get(int(eid), set()), code, int(eid) in sponsor),
                           []).append((eid, e))
    s += ["Çevrilmeyen ekran kutuları ve nedeni:", "", "| Neden | Sayı | Kutular |", "|---|---|---|"]
    for reason, items in sorted(reasons.items(), key=lambda x: (x[0] != "ELLE BAKILMALI", x[0])):
        listed = ", ".join(f"{eid}" + (f" ({md_escape(strip_html(e.get('text', '')))[:30]})"
                                       if strip_html(e.get("text", "")).strip() else "") for eid, e in items)
        s.append(f"| {reason} | {len(items)} | {listed} |")
    s.append("")
    return s


def game_section(game, path):
    movie = swf.Movie(path)
    det = Details(path)
    with open(os.path.join(aktar.ROOT, "content", "feudalism", game, "library.json"), encoding="utf-8") as f:
        lib = json.load(f)
    names = sprite_names(movie)
    with open(os.path.join(aktar.ROOT, "kaynak", "feudalism", game, "manifest.json"), encoding="utf-8") as f:
        man = json.load(f)
    local = {k for k, v in man["characters"].items() if v["where"].startswith("yalnız yerel arşiv")}

    def local_count(kind):
        return sum(1 for k in local if man["characters"][k]["type"] == kind)
    game_exports = sorted(n for n in movie.exports if not aktar.is_component_export(n))
    components = sorted(n for n in movie.exports if aktar.is_component_export(n) and not n.startswith("__Packages."))
    sponsor_count = sum(1 for v in lib["excluded"].values() if v.startswith("sponsor"))
    classes = sorted(n[len("__Packages."):] for n in movie.exports if n.startswith("__Packages.")
                     and not n.startswith("__Packages.mx."))
    code_files = sum(len(files) for _, _, files in os.walk(os.path.join(aktar.ROOT, "kaynak", "feudalism", game, "kod")))
    s = [f"## {NAMES[game]} ({game})", "",
         f"Sahne {movie.width:.0f}×{movie.height:.0f} piksel, saniyede {movie.rate:.0f} kare, arka plan "
         f"`{movie.background}`. Kaynak: `{lib['source']['file']}`.", "",
         "| İçerik | Sayı | Oyuna aktarılan | Yalnız yerel arşivde (neden) |", "|---|---|---|---|",
         f"| Şekil (vektör çizim) | {len(movie.shapes)} | {len(lib['shapes'])} vektör + {len(lib['bitmap_shapes'])} "
         f"resim dolgulu | {local_count('shape')} (sponsor ya da Macromedia) |",
         f"| Sprite (hareketli sembol) | {len(movie.sprites)} | {len(lib['sprites'])} | {local_count('sprite')} |",
         f"| Düğme | {len(movie.buttons)} | {len(lib['buttons'])} | {local_count('button')} |",
         f"| Morph (biçim değiştiren şekil) | {len(movie.morphs)} | {len(lib['morphs'])} (başlangıç ve bitiş) | "
         f"{local_count('morph')} |",
         f"| Ekran (kök film karesi) | {len(movie.root.frames)} | {len(lib['root']['frames'])} | – |",
         f"| Resim (bit eşlem) | {len(det.images)} | {len(lib['images'])} | – |",
         f"| Ses efekti | {len(det.sounds)} | {len(lib['sounds'])} | – |",
         "| Müzik | 0 | oyunda müzik yok | – |",
         f"| Sabit yazı | {len(det.texts)} | {len(movie.texts) - local_count('text')} (yerleşimiyle; Türkçesiyle) | "
         f"{local_count('text')} |",
         f"| Yazı alanı | {len(det.edit_texts)} | {len(movie.edit_texts) - local_count('edit_text')} (bütün özellikleriyle) | "
         f"{local_count('edit_text')} |",
         f"| Yazı tipi | {len(det.fonts)} | harf kodları; yerine açık lisanslı karşılığı | {len(det.fonts)} (lisans yazı tipi "
         f"yapımcısında) |",
         f"| Türkçe çeviri | {lib['translation']['counts']['texts']} sabit yazı, {lib['translation']['counts']['edit_texts']} "
         f"kutu, {lib['translation']['counts']['code_files']} kod dosyası | `content/feudalism/{game}/ceviri/` | – |",
         f"| Oyun kodu | {len(classes)} sınıf, {code_files} dosya | `kaynak/feudalism/{game}/kod` (oyuna gömülmez) | – |",
         f"| Macromedia arayüz bileşeni | {len(components)} | – | "
         f"{'hepsi (Adobe' + chr(39) + 'nin; oyunda kullanılmıyor)' if components else '–'} |",
         f"| Sponsor parçası | {len(aktar.EXCLUDED[game])} kök sembol, altlarıyla {sponsor_count} karakter | – | "
         f"hepsi (sponsorun; oyunun ekranlarında kullanılanlar dahil) |",
         f"| Üçüncü taraf kodu | {len(man.get('code_excluded', {}))} dosya | – | hepsi (sponsor, Adobe, MochiAds, "
         f"MochiBot; listesi manifest.json → code_excluded) |", "",
         f"Eksik kalan karakter: {len(man['missing'])}. Tanınmayan etiket türü: "
         f"{sum(1 for v in man['dispositions'].values() if v == 'TANINMAYAN ETİKET')}. Her karakterin ve her etiket "
         f"türünün nereye gittiği: `kaynak/feudalism/{game}/manifest.json`.", ""]
    # Ekranlar
    s += ["### Ekranlar (kök film)", "", "| Kare | Ne |", "|---|---|"]
    labels = {f: lb for lb, f in movie.root.labels.items()}
    first_label = min(movie.root.labels.values()) if movie.root.labels else len(movie.root.frames)
    s.append(f"| 1–3 | açılış: yükleme, sponsor logoları{' (aktarılmadı)' if game == 'f1' else ''}, giriş animasyonu |")
    s.append(f"| 4 | ana menü |")
    s.append(f"| 5–{first_label} | savaş alanı arka planları ({first_label - 4} kare) |")
    for f in sorted(labels):
        s.append(f"| {f + 1} | {SCREENS.get(labels[f], labels[f])} (`{labels[f]}`) |")
    s.append("")
    # Semboller
    s += ["### Dışa aktarılan semboller (oyunun kodla çağırdığı)", "",
          ", ".join(f"`{n}`" for n in game_exports if not n.startswith("__Packages.")), ""]
    # Sesler
    uses = sound_uses(movie, names)
    s += ["### Sesler", "", "Hepsi kısa ses efekti; müzik yok.", "",
          "| Kimlik | Ad | Süre | Biçim | Nerede çalıyor |", "|---|---|---|---|---|"]
    for snd in det.sounds:
        name = next((n for n, c in movie.exports.items() if c == snd["id"]), "")
        where = "; ".join(uses.get(snd["id"], [])) or ("kodla çalınır" if name else "kullanılmıyor")
        s.append(f"| {snd['id']} | {name} | {snd['seconds']:.1f} sn | {snd['format']} {snd['rate']:.0f} Hz "
                 f"{'stereo' if snd['stereo'] else 'mono'} | {md_escape(where)} |")
    s.append("")
    # Resimler
    s += ["### Resimler", "", "| Kimlik | Boyut | Not |", "|---|---|---|"]
    for img in det.images:
        size = f"{img['size'][0]}×{img['size'][1]}" if img["size"] else "?"
        note = "savaş alanı zemin dokusu" if img["size"] == (800, 200) else ""
        s.append(f"| {img['id']} | {size} | {note} |")
    s.append("")
    # Yazı tipleri
    with open(os.path.join(aktar.ROOT, "content", "feudalism", game, "texts.json"), encoding="utf-8") as f:
        font_files = {int(k): v.get("file", "") for k, v in json.load(f)["fonts"].items()}
    s += ["### Yazı tipleri", "",
          "Gömülü hâlleri aktarılmaz (lisansları yazı tipi yapımcılarındadır); yazılar açık lisanslı karşılığıyla "
          "çizilir (bkz. `docs/LISANSLAR.md`).", "",
          "| Kimlik | Ad | Biçem | Gömülü glif | Karşılığı |", "|---|---|---|---|---|"]
    for fid, fo in sorted(det.fonts.items()):
        style = ", ".join(x for x, on in (("kalın", fo["bold"]), ("italik", fo["italic"])) if on) or "normal"
        s.append(f"| {fid} | {fo['name']} | {style} | {fo['glyphs'] or 'yok (sistem yazı tipi)'} | "
                 f"`{font_files.get(fid, '?')}` |")
    s.append("")
    s += translation_section(game, lib, os.path.dirname(os.path.dirname(os.path.dirname(path))))
    # Oyun kodu
    s += ["### Oyun kodunun sınıfları", "", ", ".join(f"`{c}`" for c in classes), ""]
    return s, det


def main(argv):
    swf_root = argv[0] if argv else os.environ.get("SWF_KOK", os.path.join(aktar.ROOT, "..", "swf-oyunlar"))
    out = ["# Feudalism 1 ve 2: içerik dökümü", "",
           "`python3 araclar/aktar/envanter.py` üretir; elle değiştirmeyin. Oyunların neyi var, neyi yok ve",
           "her birinin oyunumuza aktarılma durumu. Görseller hak sahibinin izniyle kullanılır",
           "(bkz. `docs/LISANSLAR.md`).", ""]
    texts = {}
    for game, rel in aktar.GAMES.items():
        section, det = game_section(game, os.path.join(swf_root, rel))
        out += section
        texts[game] = det
    out += ["## Ek: oyunlardaki sabit yazılar", "",
            "Ekranlarda çizili yazılar ve Türkçeleri. Yazı alanlarının başlangıç değerleri ayrıca listelenir.", ""]
    for game, det in texts.items():
        tables = ceviri.load_tables(os.path.join(swf_root, ceviri.TRANSLATIONS[game], "ceviri"))
        sabit, kutular = ceviri.entries(tables["sabit"]), ceviri.entries(tables["kutular"])
        out += [f"### {NAMES[game]}", "", "| Kimlik | Yazı | Türkçesi |", "|---|---|---|"]
        out += [f"| {tid} | {md_escape(t)} | {md_escape(' / '.join(sabit[str(tid)]['parcalar'])) if str(tid) in sabit else ''} |"
                for tid, t in det.texts if t.strip()]
        out.append("")
        initial = [(e["id"], strip_html(e["text"])) for e in det.edit_texts if strip_html(e.get("text", "")).strip()]
        if initial:
            def tr(eid):
                v = kutular.get(str(eid))
                return "" if v is None else strip_html(v if isinstance(v, str) else v.get("metin", "")).replace("html:", "")
            out += [f"Yazı alanlarının başlangıç değerleri ({NAMES[game]}): oyun bunların çoğunu çalışırken "
                    "değiştirir; burada tasarımdaki örnek değerleri var.", "", "| Kimlik | Yazı | Türkçesi |",
                    "|---|---|---|"]
            out += [f"| {tid} | {md_escape(t)} | {md_escape(tr(tid))} |" for tid, t in initial]
            out.append("")
    path = os.path.join(aktar.ROOT, "docs", "FEUDALISM_ICERIK.md")
    with open(path, "w", encoding="utf-8") as f:
        f.write("\n".join(out).rstrip() + "\n")
    print(path)


if __name__ == "__main__":
    main(sys.argv[1:])
