"""Feudalism 1 ve 2'nin görsellerini oyunun içerik klasörüne aktarır.

Görseller hak sahibinin izniyle kullanılır (bkz. docs/LISANSLAR.md). Aktarılan:

- şekiller: FFDec'in SVG çıktısı, motorun okuduğu biçimde (`content/feudalism/<oyun>/shapes/<id>.svg`);
- sembol kütüphanesi (`content/feudalism/<oyun>/library.json`): sahne bilgisi, dışa aktarılan adlar,
  sprite ve kök film zaman çizelgeleri (kare kare yerleştir / taşı / kaldır işlemleri), kare
  etiketleri, kare betiklerinden çıkarılan basit komutlar (dur, oynat, git, olay), düğmeler.

Aktarılmayan (hak sahibinin olmayan ya da lisansı ayrı olan):

- sponsor logoları (ArcadeTown, Newgrounds), oyunun kendi ekranlarında kullanılanlar da: `EXCLUDED`,
  `third_party`;
- Macromedia/Adobe arayüz bileşenleri (mx.*): `is_component_export`;
- üçüncü tarafların kodu (sponsor ekranları, Adobe sınıfları, MochiAds, MochiBot): `third_party_code`;
- gömülü yazı tipleri (yazı tiplerinin lisansı yazı tipi yapımcısındadır).

Morph uçlarının renkleri ve degrade matrisleri SWF'den yazılır (`apply_animates`).

Kullanım (depo kökünden; önce araclar/olcum/cikar.sh çalıştırılmış olmalı):
    python3 araclar/aktar/aktar.py [swf-oyunlar klasörü]
"""
import json
import math
import os
import re
import shutil
import sys
import xml.etree.ElementTree as ET

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import ceviri  # noqa: E402
import swf  # noqa: E402
import swfstats  # noqa: E402

ROOT = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
GAMES = {
    "f1": "oyunlar/feudalism/feudalism-orijinal.swf",
    "f2": "oyunlar/feudalism-2/feudalism-2-orijinal.swf",
}
# Oyunun yazarına ait olmayan, aktarılmayan karakterler (kimlik → neden)
# (oyunun kendi ekranlarında kullanılsa da; bkz. third_party)
EXCLUDED = {
    "f1": {140: "açılıştaki ArcadeTown ve Newgrounds logoları",
           54: "ArcadeTown logosu; yükleme ekranında ve ana menünün köşesinde"},
    "f2": {1763: "açılıştaki ArcadeTown animasyonu",
           1962: "ArcadeTown logosu; ana menünün ve oyun sonu ekranlarının köşesinde",
           # Sahibinin kararı (16 Ekim 2026): sponsor yazıları ve korsan kopya ekranı gösterilmez
           **{cid: "korsan kopya uyarı ekranı (kök filmde 'STOLEN'; gösterilmez)"
              for cid in (3125, 3126, 3127, 3128, 3129, 3130, 3131, 3132)},
           **{cid: "özel karakterlerin yalnız ArcadeTown'da olduğunu söyleyen panel (sprite 2024, 2. kare; "
                   "gösterilmez)" for cid in (2020, 2021, 2022, 2023)}},
}
# Üçüncü tarafların dışa aktarılan sınıfları (sınıf kodunu taşıyan boş sprite'lar): ad → neden
EXCLUDED_EXPORTS = {"__Packages.MochiAd": "MochiAds reklam kütüphanesi (üçüncü taraf)"}
# Kendi başına üçüncü tarafın olan kod dosyaları (FFDec'in betik dökümünde): yol → (neden, içinde olması gereken)
THIRD_PARTY_CODE = {
    "f1": {"frame_1/DoAction_2.as": ("MochiBot izleme kodu (üçüncü taraf)", "function __com_mochibot__(")},
    "f2": {"frame_1/DoAction_2.as": ("MochiBot izleme kodu (üçüncü taraf)", "function __com_mochibot__(")},
}
# Macromedia/Adobe v2 arayüz bileşenlerinin dışa aktarılan adları
COMPONENT_EXPORTS = re.compile(
    r"^(Border|BoundingBox|Brdr\w+|Btn\w*Arrow|Button|ButtonSkin|Combo\w+|CustomBorder|Data\w+|Defaults|"
    r"Focus\w+|HScrollBar|List|NumericStepper\w*|RectBorder|Scroll\w+|SelectableRow|SimpleButton\w*|"
    r"Step\w+|TextInput|Thumb\w+|UI\w+|VScrollBar|View)$")


def is_component_export(name):
    return name.startswith("__Packages.") or bool(COMPONENT_EXPORTS.match(name))


def round_list(values, digits=4):
    return [round(v, digits) for v in values]


def clean_op(op):
    """Zaman çizelgesi işlemini JSON için sadeleştirir (yuvarlama, yeni yerleştirmede birim değerleri
    atma). "Taşı" işleminde birim matris ve renk dönüşümü korunur: orada "başlangıca dön" demektir,
    eksik alan ise "değişmedi"."""
    out = {}
    moves = bool(op.get("move"))
    for k, v in op.items():
        if k == "matrix":
            # 6 ondalık: SWF'deki 16.16 sabit noktalı değer bundan geri kurulabilir
            if moves or v != [1.0, 0.0, 0.0, 1.0, 0.0, 0.0]:
                out[k] = round_list(v, 6)
        elif k == "cxform":
            if moves or v != [[1.0, 1.0, 1.0, 1.0], [0.0, 0.0, 0.0, 0.0]]:
                out[k] = [round_list(v[0], 6), round_list(v[1], 6)]
        elif k == "ratio":
            out[k] = round(v, 6)
        else:
            out[k] = v
    return out


# --- Kare betikleri ------------------------------------------------------------------------------

GOTO = re.compile(r"^(?:this\.)?goto(AndPlay|AndStop)\((\"[^\"]*\"|\d+)\);?$")
EVENT = re.compile(r"^this\._parent\.(\w+)\(\);?$")


def parse_actions(source):
    """Kare betiğinden oynatıcının anlayacağı komutlar: stop, play, goto (kare ya da etiket, oynat/dur),
    event (üst sprite'a bildirilen an, ör. vuruş). Yalnızca en dış düzeydeki satırlar okunur: bir
    koşulun ya da işlevin içindeki komut her karede çalışmaz. Öbür satırlar oyunun kendi mantığıdır."""
    out = []
    depth = 0
    for line in source.splitlines():
        s = line.strip()
        if depth == 0:
            if s in ("stop();", "this.stop();"):
                out.append({"stop": True})
            elif s in ("play();", "this.play();"):
                out.append({"play": True})
            elif m := GOTO.match(s):
                target = m.group(2)
                target = target.strip('"') if target.startswith('"') else int(target)
                out.append({"goto": target, "play": m.group(1) == "AndPlay"})
            elif m := EVENT.match(s):
                out.append({"event": m.group(1)})
        depth += s.count("{") - s.count("}")
    return out


def script_dir_id(name):
    """FFDec betik klasörünün adından karakter kimliği: DefineSprite_547 ya da DefineSprite_547_Human."""
    m = re.match(r"DefineSprite_(\d+)", name)
    return int(m.group(1)) if m else None


def read_frame_actions(folder):
    """{kare sırası (0'dan): [komut]} — FFDec'in frame_<n>/DoAction*.as dosyalarından."""
    out = {}
    if not os.path.isdir(folder):
        return out
    for entry in sorted(os.listdir(folder)):
        m = re.match(r"frame_(\d+)$", entry)
        if not m:
            continue
        cmds = []
        for f in sorted(os.listdir(os.path.join(folder, entry))):
            if f.startswith("DoAction") and f.endswith(".as"):
                with open(os.path.join(folder, entry, f), encoding="utf-8") as fh:
                    cmds += parse_actions(fh.read())
        if cmds:
            out[int(m.group(1)) - 1] = cmds
    return out


def scripts_by_sprite(scripts):
    out = {}
    if not os.path.isdir(scripts):
        return out
    for name in os.listdir(scripts):
        cid = script_dir_id(name)
        if cid is not None:
            out[cid] = read_frame_actions(os.path.join(scripts, name))
    return out


# --- Şekiller ------------------------------------------------------------------------------------

FFDEC_ATTR = re.compile(r'\s+(?:xmlns:)?ffdec(?::[\w-]+)?="[^"]*"')
# Flash'ta 1 pikselden ince çizgi (kıl çizgi) her ölçekte 1 ekran pikseli çizilir. FFDec bunu işaretler;
# işaret ve özgün kalınlık data- öznitelikleri olarak korunur (motor kıl çizgiyi buna göre çizer).
HAIRLINE = re.compile(r'\s+ffdec:has-small-stroke="true"')
ORIGINAL_WIDTH = re.compile(r'\s+ffdec:original-stroke-width="([^"]*)"')


def hairlines(svg):
    """Kıl çizgi yolları: [[<path> öğesinin belgedeki sırası (0'dan), özgün kalınlık]]."""
    out = []
    for i, m in enumerate(re.finditer(r"<path\b[^>]*>", svg)):
        tag = m.group(0)
        if 'data-hairline="true"' in tag:
            w = re.search(r'data-original-stroke-width="([^"]*)"', tag)
            out.append([i, float(w.group(1)) if w else 0.0])
    return out


def keep_stroke_hints(svg):
    svg = HAIRLINE.sub(' data-hairline="true"', svg)
    return ORIGINAL_WIDTH.sub(lambda m: f' data-original-stroke-width="{m.group(1)}"', svg)
TRANSLATE = re.compile(r'<g transform="matrix\(1\.0, 0\.0, 0\.0, 1\.0, (-?[\d.]+), (-?[\d.]+)\)">')


def convert_shape(svg):
    """FFDec şekil SVG'si → (motorun okuyacağı SVG, şeklin kendi koordinatlarında sol üst köşesi).

    FFDec şekli `translate(-xmin, -ymin)` ile kaydırır; oynatıcı şekli kendi koordinatlarında
    çizebilmek için bu köşeyi bilir. Bit eşlem dolgulu şekiller (<image>) için None döner."""
    if "<image" in svg or "<pattern" in svg:
        return None
    m = TRANSLATE.search(svg)
    origin = (-float(m.group(1)), -float(m.group(2))) if m else (0.0, 0.0)
    out = FFDEC_ATTR.sub("", keep_stroke_hints(svg))
    out = re.sub(r"<\?xml[^>]*\?>\s*", "", out)
    out = re.sub(r">\s+<", "><", out).strip() + "\n"
    return out, origin


# --- Aktarım -----------------------------------------------------------------------------------

def timeline_json(t, actions=None):
    out = {"frames": [[clean_op(op) for op in ops] for ops in t.frames]}
    if t.labels:
        out["labels"] = dict(sorted(t.labels.items(), key=lambda x: (x[1], x[0])))
    if actions:
        out["actions"] = {str(k): v for k, v in sorted(actions.items())}
    if t.sounds:
        out["sounds"] = {str(k): v for k, v in sorted(t.sounds.items())}
    return out


# --- Morph şekiller ------------------------------------------------------------------------------

SVG_NS = "{http://www.w3.org/2000/svg}"
ANIMATIONS = (SVG_NS + "animate", SVG_NS + "animateTransform")


def apply_animates(svg, which, styles=None):
    """FFDec morph SVG'sinde her öznitelik <animate values="başlangıç;bitiş"> ile verilir. `which`
    (0 başlangıç, 1 bitiş) değeri öğenin özniteliğine yazılır, <animate>'ler silinir. İki ucun yol
    yapısı aynıdır; oynatıcı aradaki hâli oranla hesaplar.

    `styles` (swf.read_morph_styles) verilirse renkler, saydamlıklar, çizgi kalınlıkları ve degrade
    matrisleri SWF'deki değerlerden yazılır: FFDec 180° dönmüş degrade matrisini dönmesiz ayrıştırır ve
    bitiş rengini başlangıçtan ayırmak için mavi kanala 1 ekler. Her SVG stili SWF'deki stile başlangıç
    değerleriyle eşlenir; eşi bulunmayan ya da birden çok farklı eşi olan stil hata verir."""
    ET.register_namespace("", "http://www.w3.org/2000/svg")
    ET.register_namespace("xlink", "http://www.w3.org/1999/xlink")
    ET.register_namespace("ffdec", "https://www.free-decompiler.com/flash")
    root = ET.fromstring(re.sub(r"<\?xml[^>]*\?>", "", svg).strip())
    resolved = resolve_morph_styles(root, styles) if styles is not None else []
    for parent in list(root.iter()):
        for anim in [c for c in parent if c.tag == SVG_NS + "animate"]:
            values = anim.get("values", "").split(";")
            parent.set(anim.get("attributeName"), values[which] if which < len(values) else values[-1])
            parent.remove(anim)
        transforms = [c for c in parent if c.tag == SVG_NS + "animateTransform"]
        if transforms:
            # Sırayla uygulanır: "replace" baştan başlatır, "sum" öncekinin ardına ekler
            m = (1.0, 0.0, 0.0, 1.0, 0.0, 0.0)
            for anim in transforms:
                t = transform_matrix(anim.get("type"), anim.get("from" if which == 0 else "to"))
                m = t if anim.get("additive") == "replace" else multiply(m, t)
                parent.remove(anim)
            parent.set(transforms[0].get("attributeName"),
                       "matrix(" + ", ".join(f"{round(v, 6):g}" for v in m) + ")")
    end = "start" if which == 0 else "end"
    for el, role, style in resolved:
        if role == "gradient":
            write_gradient(el, style, end)
        elif role == "fill":
            el.set("fill", hex_colour(style[end]))
            el.set("fill-opacity", opacity(style[end][3]))
        elif role == "line":
            el.set("stroke", hex_colour(style[end]["color"]))
            el.set("stroke-opacity", opacity(style[end]["color"][3]))
            el.set("stroke-width", number(style[end]["width"]))
    return ET.tostring(root, encoding="unicode")


def number(v):
    """Sayı SVG'ye 6 ondalıkla (16.16 sabit noktalı değer bundan geri kurulabilir)."""
    v = round(v, 6)
    return repr(0.0 if v == 0 else v)


def opacity(alpha):
    return repr(round(alpha / 255, 7))


def hex_colour(rgba):
    return "#%02x%02x%02x" % tuple(rgba[:3])


def write_gradient(el, style, end):
    el.set("gradientTransform", "matrix(" + ", ".join(number(v) for v in style[end]["matrix"]) + ")")
    if "focal" in style[end]:
        el.set("fx", number(style[end]["focal"] * 819.2))
    for stop, (ratio, rgba) in zip([c for c in el if c.tag == SVG_NS + "stop"], style[end]["stops"]):
        stop.set("offset", repr(ratio / 255))
        stop.set("stop-color", hex_colour(rgba))
        stop.set("stop-opacity", opacity(rgba[3]))


def start_value(el, name, default=None):
    """Öğenin bir özniteliğinin başlangıç değeri: <animate> varsa onun ilk değeri, yoksa öznitelik."""
    for anim in el:
        if anim.tag == SVG_NS + "animate" and anim.get("attributeName") == name:
            return anim.get("values", "").split(";")[0]
    return el.get(name, default)


def parse_matrix(text):
    m = re.match(r"\s*matrix\(([^)]*)\)", text or "")
    return [float(v) for v in re.split(r"[\s,]+", m.group(1).strip())] if m else [1.0, 0.0, 0.0, 1.0, 0.0, 0.0]


def same_colour(text, op, rgba):
    """FFDec'in yazdığı renk ve saydamlık (#rrggbb, 0–1) SWF'deki [r, g, b, a] ile aynı mı."""
    return (text or "").lower() == hex_colour(rgba) and abs(float(op) - rgba[3] / 255) < 1e-3


def gradient_matches(el, fill):
    """SVG degradesinin başlangıcı SWF'deki degrade dolgusunun başlangıcıyla aynı mı (FFDec matrisi 4
    ondalığa yuvarlar; öteleme twip'in 1/20'si olarak tamdır)."""
    kind = el.tag[len(SVG_NS):]
    if fill["type"] not in (("linear",) if kind == "linearGradient" else ("radial", "focal")):
        return False
    ours = parse_matrix(el.get("gradientTransform"))
    theirs = fill["start"]["matrix"]
    if any(abs(a - b) > 6e-5 for a, b in zip(ours[:4], theirs[:4])) or \
            any(abs(a - b) > 1e-3 for a, b in zip(ours[4:], theirs[4:])):
        return False
    stops = [c for c in el if c.tag == SVG_NS + "stop"]
    if len(stops) != len(fill["start"]["stops"]):
        return False
    return all(abs(float(start_value(s, "offset", "0")) - ratio / 255) < 1e-3
               and same_colour(start_value(s, "stop-color"), start_value(s, "stop-opacity", "1"), rgba)
               for s, (ratio, rgba) in zip(stops, fill["start"]["stops"]))


def end_value(el, name, default=None):
    """Öğenin bir özniteliğinin FFDec'teki bitiş değeri: <animate> varsa onun son değeri, yoksa öznitelik."""
    for anim in el:
        if anim.tag == SVG_NS + "animate" and anim.get("attributeName") == name:
            return anim.get("values", "").split(";")[-1]
    return el.get(name, default)


def near_colour(text, op, rgba):
    """FFDec'in bitiş rengi SWF'dekine yakın mı: kırmızı ve yeşil aynı, mavi en çok 1 farklı (FFDec bitiş
    rengini başlangıçtan ayırmak için maviye 1 ekler), saydamlık aynı."""
    text = (text or "").lstrip("#")
    if len(text) != 6:
        return False
    r, g, b = int(text[0:2], 16), int(text[2:4], 16), int(text[4:6], 16)
    return r == rgba[0] and g == rgba[1] and abs(b - rgba[2]) <= 1 and abs(float(op) - rgba[3] / 255) < 1e-3


def unique_style(candidates, what, end_ok):
    """Başlangıcı eşleşen SWF stillerinden, FFDec'in bitiş değerlerine de uyan tek bir sonuç (hepsi aynı
    değerdeyse ilki). Hiçbiri uymuyorsa ya da farklı birden çoğu uyuyorsa hata."""
    if not candidates:
        raise ValueError(f"morph: {what} SWF'deki hiçbir stile uymuyor")
    fitting = [c for c in candidates if end_ok(c)]
    if not fitting:
        raise ValueError(f"morph: {what} bitişi SWF'deki adayların hiçbirine uymuyor")
    if any(c != fitting[0] for c in fitting[1:]):
        raise ValueError(f"morph: {what} SWF'de başlangıcı aynı, bitişi farklı birden çok stile uyuyor")
    return fitting[0]


def gradient_end_fits(el, fill):
    """Degradenin FFDec'teki bitiş durakları SWF'deki bitişe yakın mı (matris karşılaştırılmaz: FFDec'in
    ayrıştırması dönmeyi kaybedebilir)."""
    stops = [c for c in el if c.tag == SVG_NS + "stop"]
    return all(abs(float(end_value(s, "offset", "0")) - ratio / 255) < 1e-3
               and near_colour(end_value(s, "stop-color"), end_value(s, "stop-opacity", "1"), rgba)
               for s, (ratio, rgba) in zip(stops, fill["end"]["stops"]))


def resolve_morph_styles(root, styles):
    """SVG'deki her degradeyi, düz dolguyu ve çizgiyi SWF'deki stiliyle eşler: [(öğe, rol, stil)]."""
    fills = styles["fills"] + [line["fill"] for line in styles["lines"] if "fill" in line]
    out = []
    for el in root.iter():
        kind = el.tag[len(SVG_NS):] if el.tag.startswith(SVG_NS) else el.tag
        if kind in ("linearGradient", "radialGradient"):
            out.append((el, "gradient", unique_style([f for f in fills if f["type"] != "solid" and f["type"] != "bitmap"
                                                      and gradient_matches(el, f)], f"degrade {el.get('id')}",
                                                     lambda f, el=el: gradient_end_fits(el, f))))
        elif kind == "path":
            fill = el.get("fill", "none")
            if fill.startswith("#"):
                found = [f for f in fills if f["type"] == "solid"
                         and same_colour(start_value(el, "fill"), start_value(el, "fill-opacity", "1"), f["start"])]
                out.append((el, "fill", unique_style(
                    found, f"düz dolgu {fill}",
                    lambda f, el=el: near_colour(end_value(el, "fill"), end_value(el, "fill-opacity", "1"), f["end"]))))
            stroke = el.get("stroke", "none")
            if stroke.startswith("#"):
                found = [line for line in styles["lines"] if "color" in line["start"]
                         and same_colour(start_value(el, "stroke"), start_value(el, "stroke-opacity", "1"),
                                         line["start"]["color"])
                         and abs(float(start_value(el, "stroke-width", "1")) - line["start"]["width"]) < 1e-3]
                out.append((el, "line", unique_style(
                    found, f"çizgi {stroke}",
                    lambda line, el=el: near_colour(end_value(el, "stroke"), end_value(el, "stroke-opacity", "1"),
                                                    line["end"]["color"])
                    and abs(float(end_value(el, "stroke-width", "1")) - line["end"]["width"]) < 1e-3)))
    return out


def multiply(m1, m2):
    """m1 · m2 (önce m2 uygulanır)."""
    a1, b1, c1, d1, e1, f1 = m1
    a2, b2, c2, d2, e2, f2 = m2
    return (a1 * a2 + c1 * b2, b1 * a2 + d1 * b2, a1 * c2 + c1 * d2, b1 * c2 + d1 * d2,
            a1 * e2 + c1 * f2 + e1, b1 * e2 + d1 * f2 + f1)


def transform_matrix(kind, value):
    """SVG animateTransform türü ve değeri → matris."""
    v = [float(x) for x in re.split(r"[\s,]+", (value or "").strip()) if x]
    if kind == "translate":
        return (1.0, 0.0, 0.0, 1.0, v[0], v[1] if len(v) > 1 else 0.0)
    if kind == "scale":
        return (v[0], 0.0, 0.0, v[1] if len(v) > 1 else v[0], 0.0, 0.0)
    if kind == "rotate":
        a = math.radians(v[0])
        r = (math.cos(a), math.sin(a), -math.sin(a), math.cos(a), 0.0, 0.0)
        if len(v) == 3:
            return multiply(multiply((1.0, 0.0, 0.0, 1.0, v[1], v[2]), r), (1.0, 0.0, 0.0, 1.0, -v[1], -v[2]))
        return r
    if kind == "skewX":
        return (1.0, 0.0, math.tan(math.radians(v[0])), 1.0, 0.0, 0.0)
    if kind == "skewY":
        return (1.0, math.tan(math.radians(v[0])), 0.0, 1.0, 0.0, 0.0)
    raise ValueError(f"bilinmeyen dönüşüm türü: {kind}")


PATTERN_TAG = re.compile(r'<pattern\b[^>]*\bid="([^"]+)"[^>]*\bpatternTransform="matrix\(([^)]*)\)"[^>]*>')
SHAPE_VERSION = {2: 1, 22: 2, 32: 3, 83: 4}


def bitmap_fills(movie, sid):
    """Şeklin resim dolguları (bütün stil dizilerinden): [{id, matrix, clip, smooth}]."""
    code, body = movie.shape_bodies[sid]
    fills = swfstats.parse_shape(body, SHAPE_VERSION[code])[2]
    return [f for f in fills if f["type"] == "bitmap"]


MATRIX_ATTR = re.compile(r'<(linearGradient|radialGradient|pattern)\b[^>]*?\b(gradientTransform|patternTransform)='
                         r'"matrix\(([^)]*)\)"')


def shape_fills(movie, sid):
    """Şeklin bütün dolgu stilleri (yeni stil dizileri dahil), swfstats biçiminde."""
    code, body = movie.shape_bodies[sid]
    return swfstats.parse_shape(body, SHAPE_VERSION[code])[2]


def precise_matrices(svg, fills):
    """Degrade ve desen matrislerini SWF'deki değerden 6 ondalıkla yazar (FFDec 4 ondalığa yuvarlar). Her
    matris, türü uyan ve FFDec'in yuvarlamasıyla tutan SWF dolgusuna eşlenir; eşi yoksa ya da tam değeri
    farklı birden çok eşi varsa hata. Degradede matris birimsizdir, desende resim pikselini twip'e taşır
    (20'ye bölünür); öteleme twip'tir."""
    def replace(m):
        tag, attr, values = m.group(1), m.group(2), [float(v) for v in m.group(3).split(",")]
        kinds = {"linearGradient": ("linear",), "radialGradient": ("radial", "focal"), "pattern": ("bitmap",)}[tag]
        div = 20.0 if tag == "pattern" else 1.0
        found = []
        for f in fills:
            if f["type"] not in kinds:
                continue
            full = [v / div for v in f["matrix"][:4]] + [v / 20 for v in f["matrix"][4:]]
            if all(abs(a - b) <= 6e-5 for a, b in zip(values[:4], full[:4])) and \
                    all(abs(a - b) <= 0.01 for a, b in zip(values[4:], full[4:])):
                found.append([round(v, 6) for v in full])
        if not found or any(x != found[0] for x in found[1:]):
            raise ValueError(f"{tag} matrisi ({m.group(3)}) SWF'deki dolgulara tek biçimde eşlenemedi")
        text = ", ".join(number(v) for v in found[0])
        return m.group(0).replace(f"{attr}=\"matrix({m.group(3)})\"", f"{attr}=\"matrix({text})\"")
    return MATRIX_ATTR.sub(replace, svg)


def mark_bitmap_modes(svg, fills):
    """Resim dolgusunun türünü desenin kimliğine yazar: "-kirp" kırpılmış (resmin kenarı uzar, tekrar
    etmez), "-yumusak" yumuşatmalı (yoksa en yakın piksel). Desen, matrisi SWF'deki dolgunun matrisiyle
    (FFDec 4 ondalığa yuvarlar) eşlenir; eşi yoksa hata."""
    for pid, values in PATTERN_TAG.findall(svg):
        m = [float(v) for v in values.split(",")]
        match = [f for f in fills if all(abs(a - b / 20) < 1e-3 for a, b in zip(m[:4], f["matrix"][:4]))
                 and all(abs(a - b / 20) < 0.01 for a, b in zip(m[4:], f["matrix"][4:]))]
        if not match or any((f["clip"], f["smooth"]) != (match[0]["clip"], match[0]["smooth"]) for f in match):
            raise ValueError(f"desen {pid}: SWF'deki resim dolgusuyla eşlenemedi")
        suffix = ("-kirp" if match[0]["clip"] else "") + ("-yumusak" if match[0]["smooth"] else "")
        if suffix:
            svg = svg.replace(f'id="{pid}"', f'id="{pid}{suffix}"').replace(f"url(#{pid})", f"url(#{pid}{suffix})")
    return svg


def clean_svg(svg):
    out = FFDEC_ATTR.sub("", keep_stroke_hints(svg))
    out = re.sub(r"<\?xml[^>]*\?>\s*", "", out)
    out = re.sub(r">\s+<", "><", out).strip() + "\n"
    # ElementTree'nin yazdığı ad alanı öneki (ns0:) varsa düz SVG'ye çevrilir
    return out.replace("ns0:", "").replace(":ns0", "")


def svg_origin(svg):
    m = TRANSLATE.search(svg)
    return (-float(m.group(1)), -float(m.group(2))) if m else (0.0, 0.0)


# --- Aktarım -----------------------------------------------------------------------------------

TAG_NAMES = {0: "End", 1: "ShowFrame", 2: "DefineShape", 4: "PlaceObject", 5: "RemoveObject", 6: "DefineBits",
             8: "JPEGTables", 9: "SetBackgroundColor", 10: "DefineFont", 11: "DefineText", 12: "DoAction",
             13: "DefineFontInfo", 14: "DefineSound", 15: "StartSound", 17: "DefineButtonSound",
             18: "SoundStreamHead", 19: "SoundStreamBlock", 20: "DefineBitsLossless", 21: "DefineBitsJPEG2",
             22: "DefineShape2", 24: "Protect", 26: "PlaceObject2", 28: "RemoveObject2", 32: "DefineShape3",
             33: "DefineText2", 34: "DefineButton2", 35: "DefineBitsJPEG3", 36: "DefineBitsLossless2",
             37: "DefineEditText", 39: "DefineSprite", 41: "ProductInfo", 43: "FrameLabel", 45: "SoundStreamHead2",
             46: "DefineMorphShape", 48: "DefineFont2", 56: "ExportAssets", 58: "EnableDebugger", 59: "DoInitAction",
             62: "DefineFontInfo2", 64: "EnableDebugger2", 65: "ScriptLimits", 69: "FileAttributes",
             70: "PlaceObject3", 73: "DefineFontAlignZones", 74: "CSMTextSettings", 75: "DefineFont3",
             77: "Metadata", 83: "DefineShape4", 84: "DefineMorphShape2"}
# Her etiket türünün nereye gittiği
DISPOSITION = {
    "End": "dosya sonu işareti; içerik taşımaz",
    "ShowFrame": "kare sınırı → library.json zaman çizelgeleri",
    "DefineShape": "shapes/<id>.svg (resim dolgulular shapes-bitmap/<id>.svg)",
    "DefineShape2": "shapes/<id>.svg (resim dolgulular shapes-bitmap/<id>.svg)",
    "DefineShape3": "shapes/<id>.svg (resim dolgulular shapes-bitmap/<id>.svg)",
    "DefineShape4": "shapes/<id>.svg (resim dolgulular shapes-bitmap/<id>.svg)",
    "DefineMorphShape": "morphs/<id>.svg, <id>.start.svg, <id>.end.svg",
    "DefineMorphShape2": "morphs/<id>.svg, <id>.start.svg, <id>.end.svg",
    "DefineBits": "images/<id>.jpg",
    "DefineBitsJPEG2": "images/<id>.jpg",
    "DefineBitsJPEG3": "images/<id>.png (saydamlıklı)",
    "DefineBitsLossless": "images/<id>.png",
    "DefineBitsLossless2": "images/<id>.png",
    "JPEGTables": "JPEG tabloları; images/ içindeki resimlere katıldı",
    "DefineSound": "sounds/<id>.mp3",
    "StartSound": "library.json → zaman çizelgesi 'sounds'",
    "SoundStreamHead": "boş ses akışı başlığı (akış verisi yok)",
    "SoundStreamHead2": "boş ses akışı başlığı (akış verisi yok)",
    "DefineText": "texts.json → texts (yerleşim + çözülmüş yazı)",
    "DefineText2": "texts.json → texts (yerleşim + çözülmüş yazı)",
    "DefineEditText": "texts.json → edit_texts (bütün özellikler)",
    "CSMTextSettings": "texts.json → csm (kenar yumuşatma ayarı)",
    "DefineFont": "yazı tipi: yalnız yerel arşivde (lisans yazı tipi yapımcısında); kodları texts.json → fonts",
    "DefineFont2": "yazı tipi: yalnız yerel arşivde (lisans yazı tipi yapımcısında); kodları texts.json → fonts",
    "DefineFont3": "yazı tipi: yalnız yerel arşivde (lisans yazı tipi yapımcısında); kodları texts.json → fonts",
    "DefineFontAlignZones": "yazı tipi hizalama ipucu: yalnız yerel arşivde (yazı tipiyle birlikte)",
    "DefineButton2": "library.json → buttons (eylemleri kaynak/feudalism/<oyun>/kod/)",
    "DefineSprite": "library.json → sprites",
    "PlaceObject2": "library.json → zaman çizelgeleri (klip eylemleri kaynak/.../kod/)",
    "PlaceObject3": "library.json → zaman çizelgeleri (süzgeç, karışım dahil)",
    "RemoveObject2": "library.json → zaman çizelgeleri",
    "FrameLabel": "library.json → zaman çizelgeleri 'labels'",
    "DoAction": "kaynak/feudalism/<oyun>/kod/ (basit komutlar library.json 'actions')",
    "DoInitAction": "kaynak/feudalism/<oyun>/kod/ (sınıf kodu)",
    "ExportAssets": "library.json → exports",
    "SetBackgroundColor": "library.json → stage.background",
    "FileAttributes": "dosya bilgisi (manifest.json → file_info)",
}


def third_party(game, movie):
    """Oyunun yazarına ait olmayan karakterler: sponsor ve Macromedia bileşen ağaçları. Kimlik → neden.

    `EXCLUDED`'daki her sponsor kökü, oyunun kendi sembollerinde kullanılsa da dışarıda kalır (ör. ana
    menünün köşesindeki ArcadeTown logosu): oyunun ağacı taranırken sponsor köklerine girilmez. Bir sponsor
    kökünün altındaki karakter yalnız oyunun da (sponsor kökleri dışından) kullanmadığı durumda dışarıda
    kalır (ör. düğmelerin genel tıklama alanı aktarılır). Her karakterin nedeni, ona sponsor kökleri
    arasından ulaşan kökün nedenidir (birden çoksa en küçük kimlikli)."""
    sponsor = set(EXCLUDED[game])
    game_roots = (movie.root.characters() - sponsor) | {
        c for n, c in movie.exports.items() if not is_component_export(n) and c not in sponsor}
    used_by_game = movie.reachable(game_roots, blocked=sponsor)
    out = {}
    for root in sorted(sponsor):
        for cid in sorted(movie.reachable({root}, blocked=sponsor - {root}) - used_by_game):
            out.setdefault(cid, "sponsor: " + EXCLUDED[game][root])
    for name, reason in EXCLUDED_EXPORTS.items():
        if name in movie.exports:
            out.setdefault(movie.exports[name], reason)
    comp = {c for n, c in movie.exports.items()
            if (is_component_export(n) and not n.startswith("__Packages.")) or n.startswith("__Packages.mx.")}
    for cid in movie.reachable(comp, blocked=sponsor) - used_by_game - set(out):
        out[cid] = "Macromedia/Adobe arayüz bileşeni (oyunda kullanılmıyor)"
    return out


CONTAINER = re.compile(r"^(?:DefineSprite|DefineButton2?)_(\d+)(?:_.*)?$")
CLIP_PLACE = re.compile(r"^PlaceObject\d?_(\d+)(?:_.+)?_\d+$")


UNNAMED_INIT = re.compile(r"^DoInitAction(?:_(\d+))?\.as$")


def third_party_code(game, rel, tp, exports, unnamed_inits=()):
    """FFDec betik dökümündeki bir kod dosyası (göreli yol) üçüncü tarafınsa nedeni, değilse None: dışarıda
    bırakılan bir karakterin (sprite, düğme) kodu, dışarıda bırakılan karakteri yerleştiren klip eylemi,
    dışarıda bırakılan dışa aktarılmış sınıfın kodu, ya da `THIRD_PARTY_CODE` listesindeki dosya.
    `unnamed_inits`: dışa aktarılmamış sprite'ların sınıf kodları, SWF'deki sırayla (FFDec onları
    DoInitAction.as, DoInitAction_2.as ... diye yazar)."""
    if rel in THIRD_PARTY_CODE.get(game, {}):
        return THIRD_PARTY_CODE[game][rel][0]
    m = UNNAMED_INIT.match(rel)
    if m:
        i = int(m.group(1) or 1) - 1
        cid = unnamed_inits[i] if i < len(unnamed_inits) else None
        return tp.get(cid)
    parts = rel.split("/")
    if len(parts) == 1 or parts[0] == "__Packages":
        name = ".".join(parts)[:-len(".as")]
        cid = exports.get(name)
        if cid in tp:
            return tp[cid]
    for part in parts[:-1]:
        m = CONTAINER.match(part) or CLIP_PLACE.match(part)
        if m and int(m.group(1)) in tp:
            return tp[int(m.group(1))]
    return None


def prune_code(folder, reason_of):
    """Klasördeki kod dosyalarından `reason_of(göreli yol)` bir neden verenleri siler (boş kalan klasörler
    de silinir). Dönen: {silinen göreli yol: neden}."""
    removed = {}
    for d, _, names in os.walk(folder, topdown=False):
        for n in names:
            rel = os.path.relpath(os.path.join(d, n), folder).replace(os.sep, "/")
            reason = reason_of(rel)
            if reason:
                os.remove(os.path.join(d, n))
                removed[rel] = reason
        if d != folder and not os.listdir(d):
            os.rmdir(d)
    return removed


def reset_dir(path):
    if os.path.isdir(path):
        shutil.rmtree(path)
    os.makedirs(path)


def find_file(folder, cid, exts):
    """FFDec çıktısında karakterin dosyası: <id>.<uzantı> ya da <id>_<ad>.<uzantı>."""
    for name in sorted(os.listdir(folder)):
        stem, ext = os.path.splitext(name)
        if ext.lower() in exts and (stem == str(cid) or stem.startswith(f"{cid}_")):
            return os.path.join(folder, name)
    return None


def build(game, swf_path, archive, out_dir, code_dir, swf_root=None, tr_archive=None):
    """Bir oyunu aktarır. `archive`: FFDec'in tam dökümü (referans/<oyun>/tam). `swf_root` verilirse Türkçe
    çeviri de aktarılır (bkz. ceviri.py); `tr_archive`: Türkçe SWF'nin dökümü (referans/<oyun>/tr).
    Dönen: (library, manifest, gereken yazı tipi dosyaları)."""
    movie = swf.Movie(swf_path)
    font_table = {}
    if swf_root:
        with open(os.path.join(swf_root, ceviri.TRANSLATIONS[game], "ceviri", "yazitipleri.json"),
                  encoding="utf-8") as f:
            font_table = json.load(f)
    font_files = []
    tp = third_party(game, movie)
    exports = {n: c for n, c in movie.exports.items() if not is_component_export(n) and c not in tp}

    def keep(kind):
        return sorted(c for c in movie.reachable(set(movie.sprites) | movie.shapes | movie.morphs | set(movie.buttons))
                      | movie.bitmaps | movie.sounds | movie.texts | movie.edit_texts
                      if movie.kind(c) == kind and c not in tp)

    where = {}
    for sub in ("shapes", "shapes-bitmap", "morphs", "images", "sounds"):
        reset_dir(os.path.join(out_dir, sub))
    # Şekiller
    shapes, bitmap_shapes, hairline_paths = {}, {}, {}
    for sid in keep("shape"):
        with open(os.path.join(archive, "shapes", f"{sid}.svg"), encoding="utf-8") as f:
            raw = f.read()
        converted = convert_shape(raw)
        fills = shape_fills(movie, sid)
        if converted is None:
            text = precise_matrices(mark_bitmap_modes(clean_svg(raw), bitmap_fills(movie, sid)), fills)
            origin, sub = svg_origin(raw), "shapes-bitmap"
            bitmap_shapes[str(sid)] = round_list(origin, 3)
        else:
            (text, origin), sub = converted, "shapes"
            text = precise_matrices(text, fills)
            shapes[str(sid)] = round_list(origin, 3)
            lines = hairlines(text)
            if lines:
                hairline_paths[str(sid)] = lines
        with open(os.path.join(out_dir, sub, f"{sid}.svg"), "w", encoding="utf-8") as f:
            f.write(text)
        where[sid] = f"{sub}/{sid}.svg"
    # Morph şekiller: özgün (canlandırmalı) ve başlangıç / bitiş
    morphs = {}
    for mid in keep("morph"):
        with open(os.path.join(archive, "morphshapes", f"{mid}.svg"), encoding="utf-8") as f:
            raw = f.read()
        code, body = movie.morph_bodies[mid]
        styles = swf.read_morph_styles(body, code)
        start, end = apply_animates(raw, 0, styles), apply_animates(raw, 1, styles)
        for suffix, text in (("", raw), (".start", start), (".end", end)):
            with open(os.path.join(out_dir, "morphs", f"{mid}{suffix}.svg"), "w", encoding="utf-8") as f:
                f.write(clean_svg(text))
        morphs[str(mid)] = round_list(svg_origin(raw), 3)
        where[mid] = f"morphs/{mid}.svg"
    # Resimler
    images = {}
    for bid in sorted(movie.bitmaps):
        src = find_file(os.path.join(archive, "images"), bid, {".jpg", ".png", ".gif"})
        if src is None:
            raise FileNotFoundError(f"{game}: resim {bid} FFDec dökümünde yok")
        name = f"{bid}{os.path.splitext(src)[1].lower()}"
        shutil.copyfile(src, os.path.join(out_dir, "images", name))
        images[str(bid)] = f"images/{name}"
        where[bid] = images[str(bid)]
    # Sesler
    sounds = {}
    for sid in sorted(movie.sounds):
        src = find_file(os.path.join(archive, "sounds"), sid, {".mp3", ".wav"})
        if src is None:
            raise FileNotFoundError(f"{game}: ses {sid} FFDec dökümünde yok")
        name = f"{sid}{os.path.splitext(src)[1].lower()}"
        body = sound_body(movie, sid)
        if swf.read_sound(body)["format"] == "MP3":
            # MP3 doğrudan SWF'den yazılır; FFDec'in dökümüyle bayt bayt aynı olmalı (iki bağımsız okuma)
            data = swf.sound_file_data(body)
            with open(src, "rb") as f:
                if f.read() != data:
                    raise ValueError(f"{game}: ses {sid} SWF'deki veriyle FFDec'in dökümü farklı")
            with open(os.path.join(out_dir, "sounds", name), "wb") as f:
                f.write(data)
        else:
            # Sıkıştırılmamış ya da ADPCM ses: FFDec'in çözdüğü WAV
            shutil.copyfile(src, os.path.join(out_dir, "sounds", name))
        export = next((n for n, c in movie.exports.items() if c == sid), None)
        sounds[str(sid)] = {"file": f"sounds/{name}", **({"export": export} if export else {}),
                            **{k: v for k, v in swf.read_sound(body).items() if k != "id"}}
        where[sid] = sounds[str(sid)]["file"]
    # Yazılar ve yazı alanları
    fonts = {}
    for fid, (code, body) in sorted(movie.font_bodies.items()):
        _, name, bold, italic, codes = swf.read_font(body)
        fonts[str(fid)] = {"name": name, "bold": bold, "italic": italic, "codes": codes}
        if swf_root:
            # Gömülü yazı tipi aktarılmaz; yerine açık lisanslı karşılığı (content/ köküne göre yol)
            rel = ceviri.font_file(fid, fonts[str(fid)], font_table)
            if rel is None:
                raise ValueError(f"{game}: yazı tipi {fid} ({name}) için karşılık yok")
            fonts[str(fid)]["file"] = f"fonts/{os.path.basename(rel)}"
            font_files.append(rel)
        where[fid] = "yalnız yerel arşiv (yazı tipi lisansı); kodlar texts.json"
    font_codes = {int(k): v["codes"] for k, v in fonts.items()}
    texts = {}
    for tid in keep("text"):
        code, body = movie.text_bodies[tid]
        full = swf.read_text_full(body, code == 33)
        full["text"] = decode_records(full["records"], font_codes)
        texts[str(tid)] = full
        where[tid] = "texts.json"
    edit_texts = {str(eid): swf.read_edit_text_full(movie.edit_text_bodies[eid]) for eid in keep("edit_text")}
    for eid in edit_texts:
        where[int(eid)] = "texts.json"
    with open(os.path.join(out_dir, "texts.json"), "w", encoding="utf-8") as f:
        json.dump({"description": "Feudalism yazıları; araclar/aktar/aktar.py üretir, elle değiştirmeyin.",
                   "fonts": fonts, "texts": texts, "edit_texts": edit_texts,
                   "csm": {str(k): v for k, v in sorted(movie.csm.items())}}, f, ensure_ascii=False,
                  separators=(",", ":"))
        f.write("\n")
    # Zaman çizelgeleri, düğmeler
    actions = scripts_by_sprite(os.path.join(archive, "scripts"))
    root_actions = read_frame_actions(os.path.join(archive, "scripts"))
    sprites = {str(cid): timeline_json(movie.sprites[cid], actions.get(cid)) for cid in keep("sprite")}
    for cid in sprites:
        where[int(cid)] = "library.json"
    buttons = {}
    for bid in keep("button"):
        recs = []
        for r in movie.buttons[bid]:
            rec = {"states": [s for s, on in zip(("up", "over", "down", "hit"), r["states"]) if on],
                   "char": r["char"], "depth": r["depth"]}
            rec.update(clean_op({k: r[k] for k in ("matrix", "cxform", "filters", "blend") if k in r}))
            recs.append(rec)
        buttons[str(bid)] = recs
        where[bid] = "library.json"
    # Oyunun kodu (görsel değil; oyunun kurallarını yazarken başvuru)
    reset_dir(code_dir)
    shutil.copytree(os.path.join(archive, "scripts"), os.path.join(code_dir, "kod"))
    library = {
        "description": "Feudalism görselleri; araclar/aktar/aktar.py üretir, elle değiştirmeyin.",
        "source": {"file": os.path.basename(swf_path), "sha256": swf.sha256(swf_path)},
        "stage": {"width": movie.width, "height": movie.height, "fps": movie.rate, "background": movie.background},
        "exports": dict(sorted(exports.items())),
        "shapes": shapes,
        "bitmap_shapes": bitmap_shapes,
        # Kıl çizgiler: şekil → [[yolun belgedeki sırası, özgün kalınlık]]; her ölçekte 1 ekran pikseli
        "hairlines": hairline_paths,
        "morphs": morphs,
        "images": images,
        "sounds": sounds,
        "sprites": sprites,
        "buttons": buttons,
        "root": timeline_json(movie.root, root_actions),
        "excluded": {str(k): v for k, v in sorted(tp.items())},
    }
    if swf_root:
        with open(os.path.join(out_dir, "texts.json"), encoding="utf-8") as f:
            text_data = json.load(f)
        library["translation"] = ceviri.import_translation(game, swf_root, archive, tr_archive, out_dir, code_dir,
                                                           library, text_data, convert_shape)
    # Üçüncü tarafların kodu kaynak/ altına girmez (yalnız yerel arşivde, FFDec dökümünde kalır)
    for rel, (reason, marker) in THIRD_PARTY_CODE.get(game, {}).items():
        with open(os.path.join(archive, "scripts", rel), encoding="utf-8") as f:
            if marker not in f.read():
                raise ValueError(f"{game}: {rel} beklenen üçüncü taraf kodu değil ({reason})")
    named = set(movie.exports.values())
    unnamed = [cid for cid in movie.init_actions if cid not in named]

    def reason_of(rel):
        return third_party_code(game, rel, tp, movie.exports, unnamed)
    code_excluded = prune_code(os.path.join(code_dir, "kod"), reason_of)
    if os.path.isdir(os.path.join(code_dir, "kod-tr")):
        removed = prune_code(os.path.join(code_dir, "kod-tr"), reason_of)
        # Çevrilen kod sayısı dışarıda bırakılanlar çıktıktan sonra; onların çevirisi kullanılmaz (D3-6)
        library["translation"]["counts"]["code_files"] -= len(removed)
        if removed:
            library["translation"]["unused"]["kod"] = sorted(removed)
    with open(os.path.join(out_dir, "library.json"), "w", encoding="utf-8") as f:
        json.dump(library, f, ensure_ascii=False, separators=(",", ":"))
        f.write("\n")
    # Manifest: her karakterin ve her etiket türünün nereye gittiği
    for cid, reason in tp.items():
        where[cid] = "yalnız yerel arşiv: " + reason
    all_chars = (set(movie.sprites) | movie.shapes | movie.morphs | movie.bitmaps | movie.sounds | movie.texts
                 | movie.edit_texts | movie.fonts | set(movie.buttons))
    missing = sorted(c for c in all_chars if c not in where)
    manifest = {
        "description": "Ayıklama listesi: SWF'deki her etiket türünün ve her karakterin nereye gittiği. "
                       "araclar/aktar/aktar.py üretir.",
        "source": library["source"],
        "tags": {"top_level": named_counts(movie.tag_counts), "inside_sprites": named_counts(movie.sprite_tag_counts)},
        "dispositions": {n: DISPOSITION.get(n, "TANINMAYAN ETİKET") for n in
                         sorted(set(named_counts(movie.tag_counts)) | set(named_counts(movie.sprite_tag_counts)))},
        "characters": {str(c): {"type": movie.kind(c), "where": where.get(c, "EKSİK")} for c in sorted(all_chars)},
        "missing": missing,
        "code_excluded": dict(sorted(code_excluded.items())),
        "file_info": file_info(movie),
    }
    with open(os.path.join(code_dir, "manifest.json"), "w", encoding="utf-8") as f:
        json.dump(manifest, f, ensure_ascii=False, indent=1)
        f.write("\n")
    return library, manifest, font_files


def sound_body(movie, sid):
    return movie.sound_bodies[sid]


def decode_records(records, font_codes):
    """Kayıtlar → satırlar; y'si verilen kayıt yeni satır başlatır, yazı tipi verilmeyen kayıt öncekini
    sürdürür."""
    lines = []
    font = None
    for rec in records:
        font = rec.get("font", font)
        codes = font_codes.get(font, [])
        piece = "".join(chr(codes[g]) if g < len(codes) else "?" for g, _ in rec["glyphs"])
        if "y" in rec or not lines:
            lines.append(piece)
        else:
            lines[-1] += piece
    return "\n".join(lines)


def named_counts(counts):
    return {TAG_NAMES.get(k, f"etiket {k}"): v for k, v in sorted(counts.items(), key=lambda x: TAG_NAMES.get(x[0], str(x[0])))}


def file_info(movie):
    info = {"swf_version": movie.version}
    for code, body in movie.other:
        if code == 69:
            fl = body[0]
            info["file_attributes"] = {"use_network": bool(fl & 1), "actionscript3": bool(fl & 8),
                                       "has_metadata": bool(fl & 16), "use_gpu": bool(fl & 32),
                                       "use_direct_blit": bool(fl & 64)}
        elif code == 8:
            info["jpeg_tables_bytes"] = len(body)
        else:
            info[TAG_NAMES.get(code, str(code))] = body.hex()[:200]
    return info


def main(argv):
    swf_root = argv[0] if argv else os.environ.get("SWF_KOK", os.path.join(ROOT, "..", "swf-oyunlar"))
    fonts = []
    for game, rel in GAMES.items():
        out_dir = os.path.join(ROOT, "content", "feudalism", game)
        code_dir = os.path.join(ROOT, "kaynak", "feudalism", game)
        os.makedirs(out_dir, exist_ok=True)
        lib, man, font_files = build(game, os.path.join(swf_root, rel), os.path.join(ROOT, "referans", game, "tam"),
                                     out_dir, code_dir, swf_root, os.path.join(ROOT, "referans", game, "tr"))
        fonts += font_files
        tr = lib["translation"]["counts"]
        print(f"{game}: şekil {len(lib['shapes'])} + resim dolgulu {len(lib['bitmap_shapes'])}, morph {len(lib['morphs'])}, "
              f"resim {len(lib['images'])}, ses {len(lib['sounds'])}, sprite {len(lib['sprites'])}, "
              f"düğme {len(lib['buttons'])}, kök kare {len(lib['root']['frames'])}; yerel arşivde kalan "
              f"{len(lib['excluded'])}; eksik {len(man['missing'])}; tanınmayan etiket "
              f"{sum(1 for v in man['dispositions'].values() if v == 'TANINMAYAN ETİKET')}; çeviri: sabit yazı "
              f"{tr['texts']}, ekran kutusu {tr['edit_texts']}, kod dosyası {tr['code_files']}, ad {tr['names']}, "
              f"çizilmiş yazı {tr['drawn_texts']}")
    copied = ceviri.copy_fonts(swf_root, fonts, os.path.join(ROOT, "content", "fonts"))
    print(f"yazı tipleri (content/fonts): {', '.join(copied)}")


if __name__ == "__main__":
    main(sys.argv[1:])
