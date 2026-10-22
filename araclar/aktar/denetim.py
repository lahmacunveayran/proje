"""Ayıklama denetimi: oyuna aktarılanı, FFDec'in kendi ayrıştırıcısıyla ürettiği XML dökümüyle
(referans/<oyun>/tam/swf.xml) kayıt kayıt karşılaştırır. İki ayrı ayrıştırıcı (bizimki ve FFDec'inki)
aynı sonucu vermelidir.

Denetlenen:
  1. etiket türlerinin sayıları (en dış düzey ve sprite'ların içi);
  2. karakter kimlikleri (türüne göre) ve her birinin listede (manifest) bir yeri olması;
  3. bütün zaman çizelgeleri: kare kare her yerleştirme (karakter, derinlik, matris, renk dönüşümü,
     oran, ad, kırpma derinliği, klip eylemi, süzgeç, karışım), kaldırma, kare etiketi, ses başlatma;
  4. düğmeler, dışa aktarılan adlar, sabit yazılar (glif glif), yazı alanları;
  5. sesler (dosya baytları SWF'deki veriyle aynı mı), resimler (SWF'deki veriden çözülenle piksel piksel);
  6. şekiller (resim dolgulular dahil): motorun çizdiği ile FFDec'in çizdiği, yerel ölçütle; morph
     başlangıç ve bitişleri; morph uçlarının stilleri sayısal;
  7. kod parçaları yer yer; kod çevirisi sahibinin Türkçe SWF'sinin bayt koduyla;
  8. tanımsız karakter başvurusu; sponsor ve üçüncü taraf izi (çizimlerin içerik özetiyle).

Kullanım (depo kökünden; önce cikar.sh ve aktar.py):
    python3 araclar/aktar/denetim.py [--gorsel]     → docs/AYIKLAMA_DENETIMI.md
`--gorsel` şekillerin piksel karşılaştırmasını da yapar (birkaç dakika sürer).
"""
import base64
import io
import json
import os
import re
import subprocess
import sys
import tempfile
import xml.etree.ElementTree as ET

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import aktar  # noqa: E402
import ceviri  # noqa: E402
import swf  # noqa: E402

ROOT = aktar.ROOT
# Sayısal karşılaştırma payı: library.json 6 ondalık yazar (16.16 değer bundan geri kurulur); pay bunun
# yuvarlama hatasının biraz üstünde, 4 ondalığa yuvarlanmış bir değeri yakalar (D3-3)
TOL = 1e-6
XML_NAME = {"CSMSettings": "CSMTextSettings"}


# --- XML dökümünü okuma -------------------------------------------------------------------------

def xml_matrix(el):
    if el is None:
        return [1.0, 0.0, 0.0, 1.0, 0.0, 0.0]
    a = float(el.get("scaleX")) if el.get("hasScale") == "true" else 1.0
    d = float(el.get("scaleY")) if el.get("hasScale") == "true" else 1.0
    b = float(el.get("rotateSkew0")) if el.get("hasRotate") == "true" else 0.0
    c = float(el.get("rotateSkew1")) if el.get("hasRotate") == "true" else 0.0
    return [a, b, c, d, int(el.get("translateX")) / 20, int(el.get("translateY")) / 20]


def xml_cxform(el):
    if el is None:
        return [[1.0] * 4, [0.0] * 4]
    keys = ("red", "green", "blue", "alpha")
    mul = [int(el.get(k + "MultTerm", 256)) / 256 if el.get("hasMultTerms") == "true" else 1.0 for k in keys]
    add = [int(el.get(k + "AddTerm", 0)) / 255 if el.get("hasAddTerms") == "true" else 0.0 for k in keys]
    if el.get("type") == "CXFORM":
        mul[3], add[3] = 1.0, 0.0
    return [mul, add]


FILTER_TYPES = {"DROPSHADOWFILTER": "drop_shadow", "BLURFILTER": "blur", "GLOWFILTER": "glow",
                "BEVELFILTER": "bevel", "GRADIENTGLOWFILTER": "gradient_glow", "CONVOLUTIONFILTER": "convolution",
                "COLORMATRIXFILTER": "color_matrix", "GRADIENTBEVELFILTER": "gradient_bevel"}


def xml_rgba(el):
    """RGB ya da RGBA öğesi → [r, g, b, a] (RGB'de saydamlık 255)."""
    return [int(el.get(k, "255" if k == "alpha" else "0")) for k in ("red", "green", "blue", "alpha")]


# XML süzgeç türü → (bizim tür, {XML özniteliği: bizim alan}, {XML alt öğesi (renk): bizim alan})
FILTER_FIELDS = {
    "DROPSHADOWFILTER": ("drop_shadow", {"angle": "angle", "distance": "distance", "strength": "strength",
                                         "innerShadow": "inner", "knockout": "knockout",
                                         "compositeSource": "composite", "passes": "passes"},
                         {"dropShadowColor": "color"}),
    "BLURFILTER": ("blur", {"passes": "passes"}, {}),
    "GLOWFILTER": ("glow", {"strength": "strength", "innerGlow": "inner", "knockout": "knockout",
                            "compositeSource": "composite", "passes": "passes"}, {"glowColor": "color"}),
    "BEVELFILTER": ("bevel", {"angle": "angle", "distance": "distance", "strength": "strength",
                              "innerShadow": "inner", "knockout": "knockout", "compositeSource": "composite",
                              "onTop": "on_top", "passes": "passes"},
                    {"shadowColor": "shadow", "highlightColor": "highlight"}),
}


def xml_filter(f):
    """XML süzgeci → library.json'daki biçim. Bu dosyalarda bulunmayan türler (degrade ışıma ve kabartma,
    evrişim, renk matrisi) yalnız türüyle karşılaştırılır ve "unchecked" işaretlenir."""
    t = f.get("type")
    if t not in FILTER_FIELDS:
        return {"type": FILTER_TYPES.get(t, t), "unchecked": True}
    kind, attrs, colours = FILTER_FIELDS[t]
    out = {"type": kind, "blur": [float(f.get("blurX")), float(f.get("blurY"))]}
    for attr, key in attrs.items():
        v = f.get(attr)
        out[key] = (v == "true") if v in ("true", "false") else (int(v) if key == "passes" else float(v))
    for child, key in colours.items():
        out[key] = xml_rgba(f.find(child))
    return out


def xml_place(el):
    op = {"depth": int(el.get("depth"))}
    if el.get("placeFlagMove") == "true":
        op["move"] = True
    if el.get("placeFlagHasCharacter") == "true":
        op["char"] = int(el.get("characterId"))
    if el.get("placeFlagHasMatrix") == "true":
        op["matrix"] = xml_matrix(el.find("matrix"))
    if el.get("placeFlagHasColorTransform") == "true":
        op["cxform"] = xml_cxform(el.find("colorTransform"))
    if el.get("placeFlagHasRatio") == "true":
        op["ratio"] = int(el.get("ratio")) / 65535
    if el.get("placeFlagHasName") == "true":
        op["name"] = el.get("name")
    if el.get("placeFlagHasClipDepth") == "true":
        op["clip"] = int(el.get("clipDepth"))
    if el.get("placeFlagHasClipActions") == "true":
        op["clip_actions"] = True
    if el.get("placeFlagHasFilterList") == "true":
        op["filters"] = [xml_filter(f) for f in el.find("surfaceFilterList")]
    if el.get("placeFlagHasBlendMode") == "true":
        op["blend"] = swf.BLEND_MODES.get(int(el.get("blendMode")), "normal")
    return op


def xml_sound_info(el):
    """SOUNDINFO → library.json'daki biçim: yalnız varsayılandan farklı alanlar (bkz. swf.read_sound_info)."""
    info = {}
    if el is None:
        return info
    if el.get("syncStop") == "true":
        info["stop"] = True
    if el.get("syncNoMultiple") == "true":
        info["no_multiple"] = True
    for flag, key, attr in (("hasInPoint", "in", "inPoint"), ("hasOutPoint", "out", "outPoint"),
                            ("hasLoops", "loops", "loopCount")):
        if el.get(flag) == "true":
            info[key] = int(el.get(attr))
    if el.get("hasEnvelope") == "true":
        records = el.find("envelopeRecords")
        info["envelope"] = [[int(r.get("pos44")), int(r.get("leftLevel")), int(r.get("rightLevel"))]
                            for r in (records if records is not None else [])]
    return info


class XmlTimeline:
    def __init__(self):
        self.frames = [[]]
        self.labels = {}
        self.sounds = {}
        self.counts = {}

    def add(self, el):
        kind = el.get("type")[:-3] if el.get("type", "").endswith("Tag") else el.get("type")
        kind = XML_NAME.get(kind, kind)
        self.counts[kind] = self.counts.get(kind, 0) + 1
        if kind in ("PlaceObject2", "PlaceObject3"):
            self.frames[-1].append(xml_place(el))
        elif kind == "RemoveObject2":
            self.frames[-1].append({"remove": int(el.get("depth"))})
        elif kind == "FrameLabel":
            self.labels[el.get("name")] = len(self.frames) - 1
        elif kind == "StartSound":
            self.sounds.setdefault(len(self.frames) - 1, []).append(
                {"id": int(el.get("soundId")), **xml_sound_info(el.find("soundInfo"))})
        elif kind == "ShowFrame":
            self.frames.append([])

    def finish(self):
        if self.frames and not self.frames[-1]:
            self.frames.pop()


class XmlDump:
    """FFDec XML dökümünden denetimin gerektirdiği her şey (akış hâlinde okunur)."""

    def __init__(self, path):
        self.counts = {}
        self.sprite_counts = {}
        self.chars = {}  # kimlik → tür
        self.sprites = {}
        self.root = XmlTimeline()
        self.buttons = {}
        self.exports = {}
        self.texts = {}
        self.edit_texts = {}
        self.sounds = {}
        self.sound_samples = {}
        self.images = {}
        self.jpeg_tables = b""
        self.morph_bounds = {}
        self.morph_styles = {}
        self.shape_styles = {}
        self.text_meta = {}  # sabit yazı → {bounds, matrix}
        self.edit_text_full = {}
        self.code_keys = {}  # kod parçasının yeri (FFDec betik dökümündeki gibi) → sayı
        self.init_actions = []  # DoInitAction'ların sprite kimlikleri (dışa aktarılan adları sonra çözülür)
        self.bitmap_fills = {}  # şekil → [(resim kimliği, desen matrisi piksel biriminde, dolgu türü)]
        self.scripts = {"DoAction": 0, "DoInitAction": 0, "BUTTONCONDACTION": 0, "CLIPACTIONRECORD": 0}
        self.root_counts = {}
        depth = 0
        for event, el in ET.iterparse(path, events=("start", "end")):
            if event == "start":
                depth += 1
                continue
            depth -= 1
            if el.tag != "item" or depth != 2:
                continue
            self.top_level(el)
            el.clear()
        self.root.finish()
        self.counts = self.root_counts
        names = {}
        for n, c in self.exports.items():
            names.setdefault(c, n)
        unnamed = 0
        for sid in self.init_actions:
            name = names.get(sid)
            if name is None:
                # FFDec dışa aktarılmamış sprite'ın sınıf kodunu kimliksiz, sırayla adlandırır
                unnamed += 1
                key = "DoInitAction.as" if unnamed == 1 else f"DoInitAction_{unnamed}.as"
            elif name.startswith("__Packages."):
                key = "__Packages/" + name[len("__Packages."):].replace(".", "/") + ".as"
            else:
                key = name + ".as"
            self.code_keys[key] = self.code_keys.get(key, 0) + 1

    def top_level(self, el):
        t = el.get("type", "")
        kind = XML_NAME.get(t[:-3], t[:-3]) if t.endswith("Tag") else t
        self.root_counts[kind] = self.root_counts.get(kind, 0) + 1
        self.count_scripts(el)
        self.code_places(el, kind, f"frame_{len(self.root.frames)}/")
        cid = None
        for key in ("shapeId", "spriteId", "buttonId", "characterID", "characterId", "soundId", "fontId",
                    "fontID"):
            if el.get(key) is not None and kind.startswith("Define"):
                cid = int(el.get(key))
                break
        if kind.startswith("DefineShape"):
            self.chars[cid] = "shape"
            self.shape_styles[cid] = xml_shape_styles(el)
            fills = bitmap_fills(el)
            if fills:
                self.bitmap_fills[cid] = fills
        elif kind.startswith("DefineMorphShape"):
            self.chars[cid] = "morph"
            self.morph_styles[cid] = xml_morph_styles(el)
            self.morph_bounds[cid] = {end: [int(el.find(f"{end}Bounds").get(k)) / 20
                                            for k in ("Xmin", "Ymin", "Xmax", "Ymax")] for end in ("start", "end")}
        elif kind.startswith("DefineBits") and kind != "DefineBitsTag":
            self.chars[cid] = "bitmap"
            self.images[cid] = (kind, bytes.fromhex(el.get("jpegData") or el.get("imageData") or ""))
        elif kind in ("DefineText", "DefineText2"):
            self.chars[cid] = "text"
            self.texts[cid] = text_records(el)
            self.text_meta[cid] = {"bounds": xml_rect(el.find("textBounds")), "matrix": xml_matrix(el.find("textMatrix"))}
        elif kind == "DefineEditText":
            self.chars[cid] = "edit_text"
            self.edit_texts[cid] = dict(el.attrib)
            self.edit_text_full[cid] = xml_edit_text(el)
        elif kind.startswith("DefineFont") and kind not in ("DefineFontAlignZones", "DefineFontInfo",
                                                           "DefineFontInfo2", "DefineFontName"):
            self.chars[cid] = "font"
        elif kind == "DefineSound":
            self.chars[cid] = "sound"
            self.sounds[cid] = bytes.fromhex(el.get("soundData", ""))
            self.sound_samples[cid] = int(el.get("soundSampleCount", "0"))
        elif kind == "DefineButton2":
            self.chars[cid] = "button"
            self.buttons[cid] = [button_record(r) for r in el.find("characters")]
        elif kind == "DefineSprite":
            self.chars[cid] = "sprite"
            t = XmlTimeline()
            for sub in el.find("subTags"):
                sk = sub.get("type", "")
                self.code_places(sub, sk[:-3] if sk.endswith("Tag") else sk, f"DefineSprite_{cid}/frame_{len(t.frames)}/")
                t.add(sub)
                k = sub.get("type", "")
                k = XML_NAME.get(k[:-3], k[:-3]) if k.endswith("Tag") else k
                self.sprite_counts[k] = self.sprite_counts.get(k, 0) + 1
            t.finish()
            self.sprites[cid] = t
        elif kind == "ExportAssets":
            ids = [int(i.text) for i in el.find("tags")]
            names = [n.text for n in el.find("names")]
            self.exports.update(dict(zip(names, ids)))
        elif kind == "JPEGTables":
            self.jpeg_tables = bytes.fromhex(el.get("jpegData", ""))
        if kind == "DefineBits":
            self.chars[cid] = "bitmap"
            self.images[cid] = (kind, bytes.fromhex(el.get("jpegData") or el.get("imageData") or ""))
        self.root.add(el)

    def code_places(self, el, kind, frame_prefix):
        """Kod parçalarının yerleri, FFDec'in betik dökümündeki klasör düzeniyle: kare kodu
        (<kare>/DoAction), klip eylemi (<kare>/<yerleştirme>_<karakter>_<derinlik>/CLIPACTIONRECORD),
        düğme (DefineButton2_<kimlik>/BUTTONCONDACTION), sınıf kodu (dışa aktarılan adıyla, sonra çözülür)."""
        def add(key, n=1):
            if n:
                self.code_keys[key] = self.code_keys.get(key, 0) + n
        if kind == "DoAction":
            add(frame_prefix + "DoAction")
        elif kind == "DoInitAction":
            self.init_actions.append(int(el.get("spriteId")))
        elif kind in ("PlaceObject2", "PlaceObject3") and el.get("placeFlagHasClipActions") == "true":
            n = sum(1 for x in el.iter("item") if x.get("type") == "CLIPACTIONRECORD")
            add(f"{frame_prefix}{kind}_{el.get('characterId')}_{el.get('depth')}/CLIPACTIONRECORD", n)
        elif kind == "DefineButton2":
            add(f"DefineButton2_{el.get('buttonId')}/BUTTONCONDACTION",
                sum(1 for x in el.iter("item") if x.get("type") == "BUTTONCONDACTION"))

    def count_scripts(self, el):
        for sub in el.iter("item"):
            t = sub.get("type", "")
            if t in ("DoActionTag", "DoInitActionTag"):
                self.scripts[t[:-3]] += 1
            elif t in ("BUTTONCONDACTION", "CLIPACTIONRECORD"):
                self.scripts[t] += 1


BITMAP_FILL_TYPES = (0x40, 0x41, 0x42, 0x43)  # tekrarlı, kırpılmış, yumuşatmasız tekrarlı, yumuşatmasız kırpılmış


def fill_style_items(parent):
    """Bir şeklin ya da stil değişim kaydının dolgu stilleri (XML öğeleri, sırayla)."""
    outer = parent.find("fillStyles")
    inner = outer.find("fillStyles") if outer is not None else None
    return list(inner) if inner is not None else []


def bitmap_fills(el):
    """Şeklin kenarlarının kullandığı resim dolguları: [(resim kimliği, [a, b, c, d, tx, ty])]. Stil
    değişim kaydı yeni stil dizisi getirebilir; sonraki dolgu numaraları o diziyi gösterir. Üçüncü öğe dolgu
    türüdür (0x40 tekrarlı, 0x41 kırpılmış, 0x42/0x43 yumuşatmasız). SWF'de dolgu
    matrisi resim pikselini twip'e taşır; 20'ye bölünce SVG desen matrisi (piksel) çıkar. Hiçbir kenarın
    kullanmadığı dolgu (ör. "resim yok" anlamındaki 65535) çizilmez, listeye girmez."""
    shapes = el.find("shapes")
    if shapes is None:
        return []
    arrays = [fill_style_items(shapes)]
    used = []
    records = shapes.find("shapeRecords")
    for r in records if records is not None else []:
        if r.get("type") != "StyleChangeRecord":
            continue
        if r.get("stateNewStyles") == "true":
            arrays.append(fill_style_items(r))
        for k in ("0", "1"):
            index = int(r.get("fillStyle" + k, "0"))
            if r.get("stateFillStyle" + k) == "true" and 0 < index <= len(arrays[-1]):
                key = (len(arrays) - 1, index - 1)
                if key not in used:
                    used.append(key)
    out = []
    for a, i in sorted(used):
        fs = arrays[a][i]
        if int(fs.get("fillStyleType", "0")) in BITMAP_FILL_TYPES:
            m = xml_matrix(fs.find("bitmapMatrix"))
            out.append((int(fs.get("bitmapId")), [v / 20 for v in m[:4]] + m[4:], int(fs.get("fillStyleType"))))
    return out


def xml_rect(el):
    return [int(el.get(k)) / 20 for k in ("Xmin", "Ymin", "Xmax", "Ymax")]


ALIGN = ["left", "right", "center", "justify"]
EDIT_FLAGS = (("word_wrap", "wordWrap"), ("multiline", "multiline"), ("password", "password"),
              ("read_only", "readOnly"), ("auto_size", "autoSize"), ("no_select", "noSelect"), ("border", "border"),
              ("was_static", "wasStatic"), ("html", "html"), ("use_outlines", "useOutlines"))


def xml_edit_text(el):
    """XML yazı alanı → texts.json'daki biçim (bütün alanlar; bkz. swf.read_edit_text_full)."""
    a = el.attrib
    out = {"id": int(a["characterID"]), "bounds": xml_rect(el.find("bounds")),
           "flags": [k for k, x in EDIT_FLAGS if a.get(x) == "true"]}
    if a.get("hasFont") == "true":
        out["font"] = int(a["fontId"])
    if a.get("hasFontClass") == "true":
        out["font_class"] = xml_unescape(a.get("fontClass", ""))
    if a.get("hasFont") == "true" or a.get("hasFontClass") == "true":
        out["font_height"] = int(a["fontHeight"]) / 20
    if a.get("hasTextColor") == "true":
        c = xml_rgba(el.find("textColor"))
        out["color"] = "#%02X%02X%02X" % tuple(c[:3])
        out["alpha"] = round(c[3] / 255, 4)
    if a.get("hasMaxLength") == "true":
        out["max_length"] = int(a["maxLength"])
    if a.get("hasLayout") == "true":
        align = int(a["align"])
        out["layout"] = {"align": ALIGN[align] if align < 4 else str(align), "left_margin": int(a["leftMargin"]) / 20,
                         "right_margin": int(a["rightMargin"]) / 20, "indent": int(a["indent"]) / 20,
                         "leading": int(a["leading"]) / 20}
    out["variable"] = xml_unescape(a.get("variableName", ""))
    if a.get("hasText") == "true":
        out["text"] = xml_unescape(a.get("initialText", ""))
    return out


def xml_morph_fill(f):
    """XML MORPHFILLSTYLE → swf.read_morph_styles'daki biçim."""
    t = int(f.get("fillStyleType"))
    if t == 0:
        return {"type": "solid", "start": xml_rgba(f.find("startColor")), "end": xml_rgba(f.find("endColor"))}
    if t in (0x10, 0x12, 0x13):
        recs = list(f.find("gradient").find("gradientRecords"))
        out = {"type": {0x10: "linear", 0x12: "radial", 0x13: "focal"}[t],
               "spread": int(f.find("gradient").get("spreadMode", "0"))}
        for end in ("start", "end"):
            out[end] = {"matrix": xml_matrix(f.find(f"{end}GradientMatrix")),
                        "stops": [[int(r.get(f"{end}Ratio")), xml_rgba(r.find(f"{end}Color"))] for r in recs]}
        return out
    return {"type": "bitmap", "bitmap": int(f.get("bitmapId")),
            "start": {"matrix": xml_matrix(f.find("startBitmapMatrix"))},
            "end": {"matrix": xml_matrix(f.find("endBitmapMatrix"))}}


def xml_shape_styles(el):
    """XML şeklinin bütün dolgu ve çizgi stilleri (yeni stil dizileri dahil), morph stilleriyle aynı biçimde
    ama tek uçlu ("start")."""
    fills, lines = [], []
    for item in el.iter("item"):
        t = item.get("type")
        if t == "FILLSTYLE":
            kind = int(item.get("fillStyleType"))
            if kind == 0:
                fills.append({"type": "solid", "start": xml_rgba(item.find("color"))})
            elif kind in (0x10, 0x12, 0x13):
                recs = list(item.find("gradient").find("gradientRecords"))
                fills.append({"type": {0x10: "linear", 0x12: "radial", 0x13: "focal"}[kind],
                              "spread": int(item.find("gradient").get("spreadMode", "0")),
                              "start": {"matrix": xml_matrix(item.find("gradientMatrix")),
                                        "stops": [[int(r.get("ratio")), xml_rgba(r.find("color"))] for r in recs]}})
        elif t in ("LINESTYLE", "LINESTYLE2") and item.find("color") is not None:
            lines.append({"start": {"width": int(item.get("width")) / 20, "color": xml_rgba(item.find("color"))}})
    return {"fills": fills, "lines": lines}


def xml_morph_styles(el):
    """XML morph şeklinin dolgu ve çizgi stilleri (iki uçta)."""
    fills_el = el.find("morphFillStyles")
    lines_el = el.find("morphLineStyles")
    fills = [xml_morph_fill(f) for f in fills_el.find("fillStyles")] if fills_el is not None else []
    lines = []
    items = []
    if lines_el is not None:
        for tag in ("lineStyles", "lineStyles2"):
            if lines_el.find(tag) is not None:
                items = list(lines_el.find(tag))
    for item in items:
        line = {"start": {"width": int(item.get("startWidth")) / 20}, "end": {"width": int(item.get("endWidth")) / 20}}
        if item.find("startColor") is not None:
            line["start"]["color"] = xml_rgba(item.find("startColor"))
            line["end"]["color"] = xml_rgba(item.find("endColor"))
        lines.append(line)
    return {"fills": fills, "lines": lines}


def text_records(el):
    out = []
    for r in el.find("textRecords"):
        rec = {}
        if r.get("styleFlagsHasFont") == "true":
            rec["font"] = int(r.get("fontId"))
            rec["height"] = int(r.get("textHeight")) / 20
        if r.get("styleFlagsHasColor") == "true":
            c = r.find("textColor")
            rec["color"] = "#%02X%02X%02X" % (int(c.get("red")), int(c.get("green")), int(c.get("blue")))
            if c.get("type") == "RGBA":
                rec["alpha"] = round(int(c.get("alpha")) / 255, 4)
        if r.get("styleFlagsHasXOffset") == "true":
            rec["x"] = int(r.get("xOffset")) / 20
        if r.get("styleFlagsHasYOffset") == "true":
            rec["y"] = int(r.get("yOffset")) / 20
        rec["glyphs"] = [[int(g.get("glyphIndex")), int(g.get("glyphAdvance")) / 20] for g in r.find("glyphEntries")]
        out.append(rec)
    return out


def button_record(r):
    states = [s for s, key in (("up", "buttonStateUp"), ("over", "buttonStateOver"), ("down", "buttonStateDown"),
                               ("hit", "buttonStateHitTest")) if r.get(key) == "true"]
    rec = {"states": states, "char": int(r.get("characterId")), "depth": int(r.get("placeDepth")),
           "matrix": xml_matrix(r.find("placeMatrix")), "cxform": xml_cxform(r.find("colorTransform"))}
    if r.get("buttonHasBlendMode") == "true":
        rec["blend"] = swf.BLEND_MODES.get(int(r.get("blendMode")), "normal")
    return rec


# --- Karşılaştırma ------------------------------------------------------------------------------

def ffdec_plain_text(formatted):
    """FFDec'in biçimli yazı dökümü: her kaydın önünde [ ... ] ayar bloğu ve [space N] aralıkları
    vardır; aradaki yazı parçaları birleştirilir. Yazıdaki köşeli ayraç ters bölüyle kaçırılır (\\[),
    ayar bloğundaki tırnaklı değerler köşeli ayraç içerebilir."""
    out = []
    block = quote = False
    i = 0
    while i < len(formatted):
        ch = formatted[i]
        if ch == "\\" and i + 1 < len(formatted):
            if not block:
                out.append(formatted[i + 1])
            i += 2
            continue
        if block:
            if ch == '"':
                quote = not quote
            elif ch == "]" and not quote:
                block = False
        elif ch == "[":
            block = True
        else:
            out.append(ch)
        i += 1
    return "".join(out)


def xml_unescape(text):
    """FFDec XML'i satır sonlarını ters bölüyle yazar (\\r, \\n, \\t)."""
    out = []
    i = 0
    while i < len(text):
        if text[i] == "\\" and i + 1 < len(text):
            out.append({"r": "\r", "n": "\n", "t": "\t", "\\": "\\"}.get(text[i + 1], text[i + 1]))
            i += 2
        else:
            out.append(text[i])
            i += 1
    return "".join(out)


def close(a, b):
    """Sayılar TOL payıyla, listeler öğe öğe, geri kalan her şey birebir karşılaştırılır (doğru/yanlış
    değeri bir sayıya eşit sayılmaz)."""
    if isinstance(a, list) and isinstance(b, list):
        return len(a) == len(b) and all(close(x, y) for x, y in zip(a, b))
    if isinstance(a, dict) and isinstance(b, dict):
        return set(a) == set(b) and all(close(a[k], b[k]) for k in a)
    if isinstance(a, bool) or isinstance(b, bool):
        return type(a) is type(b) and a == b
    if isinstance(a, (int, float)) and isinstance(b, (int, float)):
        return abs(a - b) <= TOL * max(1.0, abs(b)) + 1e-12
    return a == b


def normalize_ours(op):
    """library.json işlemi → XML'deki biçim (atılmış birim matris ve renk dönüşümü geri eklenmez:
    XML'de bayrak varsa ve değer birimse eşit sayılır)."""
    return dict(op)


def same_filters(ours, theirs):
    """Süzgeç listeleri alan alan; XML'de karşılaştırılamayan türler yalnız türüyle."""
    if len(ours) != len(theirs):
        return False
    for a, b in zip(ours, theirs):
        if b.get("unchecked"):
            if a.get("type") != b["type"]:
                return False
        elif not close(a, b):
            return False
    return True


IDENTITY = {"matrix": [1.0, 0.0, 0.0, 1.0, 0.0, 0.0], "cxform": [[1.0] * 4, [0.0] * 4]}


def same_op(ours, theirs):
    ours = normalize_ours(ours)
    keys = set(ours) | set(theirs)
    for k in keys:
        if k == "filters":
            if not same_filters(ours.get(k, []), theirs.get(k, [])):
                return f"süzgeç: bizim {ours.get(k)} / FFDec {theirs.get(k)}"
        elif k in IDENTITY and not theirs.get("move"):
            # Yeni yerleştirmede eksik matris/renk dönüşümü birimdir; taşımada "değişmedi" demektir (D3-1)
            a = ours.get(k, IDENTITY[k] if k in theirs else None)
            b = theirs.get(k, IDENTITY[k] if k in ours else None)
            if not close(a, b):
                return f"{k}: bizim {ours.get(k)} / FFDec {theirs.get(k)}"
        elif not close(ours.get(k), theirs.get(k)):
            return f"{k}: bizim {ours.get(k)} / FFDec {theirs.get(k)}"
    return None


def compare_timeline(name, ours, theirs, problems):
    """ours: library.json zaman çizelgesi; theirs: XmlTimeline."""
    if len(ours["frames"]) != len(theirs.frames):
        problems.append(f"{name}: kare sayısı bizim {len(ours['frames'])} / FFDec {len(theirs.frames)}")
        return 0
    checked = 0
    for i, (a, b) in enumerate(zip(ours["frames"], theirs.frames)):
        if len(a) != len(b):
            problems.append(f"{name} kare {i + 1}: işlem sayısı bizim {len(a)} / FFDec {len(b)}")
            continue
        for x, y in zip(a, b):
            diff = same_op(x, y)
            checked += 1
            if diff:
                problems.append(f"{name} kare {i + 1} derinlik {y.get('depth', y.get('remove'))}: {diff}")
    if ours.get("labels", {}) != theirs.labels:
        problems.append(f"{name}: etiketler farklı")
    if {int(k): v for k, v in ours.get("sounds", {}).items()} != theirs.sounds:
        problems.append(f"{name}: ses başlatmaları farklı")
    return checked


def check_game(game, visual):
    swf_path = os.path.join(os.environ.get("SWF_KOK", os.path.join(ROOT, "..", "swf-oyunlar")), aktar.GAMES[game])
    archive = os.path.join(ROOT, "referans", game, "tam")
    content = os.path.join(ROOT, "content", "feudalism", game)
    with open(os.path.join(content, "library.json"), encoding="utf-8") as f:
        lib = json.load(f)
    with open(os.path.join(content, "texts.json"), encoding="utf-8") as f:
        texts = json.load(f)
    with open(os.path.join(ROOT, "kaynak", "feudalism", game, "manifest.json"), encoding="utf-8") as f:
        man = json.load(f)
    movie = swf.Movie(swf_path)
    dump = XmlDump(os.path.join(archive, "swf.xml"))
    rows = []
    problems = []
    infos = []

    def row(name, count, probs):
        rows.append((name, count, len(probs)))
        problems.extend(probs)

    # 1. Etiket sayıları
    ours_top = {k: v for k, v in aktar.named_counts(movie.tag_counts).items() if k != "End"}
    ours_in = {k: v for k, v in aktar.named_counts(movie.sprite_tag_counts).items() if k != "End"}
    probs = [f"en dış düzey {k}: bizim {ours_top.get(k)} / FFDec {dump.counts.get(k)}"
             for k in sorted(set(ours_top) | set(dump.counts)) if ours_top.get(k) != dump.counts.get(k)]
    probs += [f"sprite içi {k}: bizim {ours_in.get(k)} / FFDec {dump.sprite_counts.get(k)}"
              for k in sorted(set(ours_in) | set(dump.sprite_counts)) if ours_in.get(k) != dump.sprite_counts.get(k)]
    row("Etiket türlerinin sayıları", sum(ours_top.values()) + sum(ours_in.values()), probs)
    # 2. Karakterler
    ours_chars = {int(k): v["type"] for k, v in man["characters"].items()}
    probs = [f"karakter {c}: bizim {ours_chars.get(c)} / FFDec {dump.chars.get(c)}"
             for c in sorted(set(ours_chars) | set(dump.chars)) if ours_chars.get(c) != dump.chars.get(c)]
    probs += [f"karakter {c}: listede yeri yok" for c, v in man["characters"].items()
              if v["where"] in ("EKSİK", "") or not v["where"]]
    for c, v in man["characters"].items():
        w = v["where"]
        if not w.startswith("yalnız yerel") and w not in ("library.json", "texts.json") \
                and not os.path.exists(os.path.join(content, w)):
            probs.append(f"karakter {c}: dosyası yok ({w})")
    row("Karakterler (tür ve yer)", len(ours_chars), probs)
    # 3. Zaman çizelgeleri
    probs = []
    checked = compare_timeline("kök film", lib["root"], dump.root, probs)
    for sid, t in lib["sprites"].items():
        checked += compare_timeline(f"sprite {sid}", t, dump.sprites[int(sid)], probs)
    excluded = {int(k) for k in lib["excluded"]}
    missing = [s for s in dump.sprites if str(s) not in lib["sprites"] and s not in excluded]
    probs += [f"sprite {s}: library.json'da yok ve yerel arşiv listesinde de değil" for s in missing]
    row("Zaman çizelgeleri: her yerleştirme ve kaldırma, etiketler, sesler (durdurma, tekrar, zarf dahil)",
        checked, probs)
    # 4. Düğmeler
    probs = []
    for bid, recs in lib["buttons"].items():
        theirs = dump.buttons[int(bid)]
        if len(recs) != len(theirs):
            probs.append(f"düğme {bid}: kayıt sayısı {len(recs)} / {len(theirs)}")
            continue
        for a, b in zip(recs, theirs):
            diff = same_op({k: v for k, v in a.items()}, b)
            if diff:
                probs.append(f"düğme {bid}: {diff}")
    row("Düğmeler (her kayıt)", sum(len(r) for r in lib["buttons"].values()), probs)
    # Dışa aktarılan adlar
    expected = {n: c for n, c in dump.exports.items() if not aktar.is_component_export(n) and c not in excluded}
    probs = [f"dışa aktarılan {n}: bizim {lib['exports'].get(n)} / FFDec {expected.get(n)}"
             for n in sorted(set(expected) | set(lib["exports"])) if lib["exports"].get(n) != expected.get(n)]
    row("Dışa aktarılan adlar (bileşen, sınıf ve dışarıda bırakılanlar hariç)", len(expected), probs)
    # Sabit yazılar
    probs = []
    for tid, t in texts["texts"].items():
        theirs = dump.texts[int(tid)]
        meta = dump.text_meta[int(tid)]
        for k in ("bounds", "matrix"):
            if not close(t[k], meta[k]):
                probs.append(f"yazı {tid}: {k} bizim {t[k]} / FFDec {meta[k]}")
        if len(t["records"]) != len(theirs):
            probs.append(f"yazı {tid}: kayıt sayısı farklı")
            continue
        for i, (a, b) in enumerate(zip(t["records"], theirs)):
            for k in ("glyphs", "font", "height", "color", "alpha", "x", "y"):
                if not close(a.get(k), b.get(k)):
                    probs.append(f"yazı {tid} kayıt {i + 1}: {k} bizim {a.get(k)} / FFDec {b.get(k)}")
    probs += [f"yazı {t}: texts.json'da yok" for t in dump.texts if str(t) not in texts["texts"]
              and man["characters"][str(t)]["where"] != "yalnız yerel arşiv"
              and not man["characters"][str(t)]["where"].startswith("yalnız yerel")]
    # Çözülmüş yazı FFDec'in düz yazı dökümüyle aynı mı
    for tid, t in texts["texts"].items():
        path = os.path.join(archive, "texts", f"{tid}.txt")
        if os.path.exists(path):
            with open(path, encoding="utf-8") as f:
                plain = ffdec_plain_text(f.read())
            if "".join(plain.split()) != "".join(t["text"].split()):
                probs.append(f"yazı {tid}: çözülen yazı FFDec'inkinden farklı: {t['text']!r} / {plain!r}")
    row("Sabit yazılar (sınır, matris; her kaydın yazı tipi, boyu, rengi, saydamlığı, yeri, glifleri; çözülmüş yazı)",
        sum(len(t["records"]) for t in texts["texts"].values()), probs)
    # Yazı alanları
    probs = []
    for eid, e in texts["edit_texts"].items():
        x = dump.edit_text_full[int(eid)]
        for k in sorted(set(e) | set(x)):
            if not close(e.get(k), x.get(k)):
                probs.append(f"yazı alanı {eid}: {k} bizim {e.get(k)!r} / FFDec {x.get(k)!r}")
    row("Yazı alanları (bütün alanlar: sınır, bayraklar, yazı tipi, boy, renk, uzunluk, hizalama, değişken, yazı)",
        len(texts["edit_texts"]), probs)
    # 5. Sesler
    probs = []
    for sid, s in lib["sounds"].items():
        with open(os.path.join(content, s["file"]), "rb") as f:
            data = f.read()
        raw = dump.sounds[int(sid)]
        if data != raw[2:]:
            probs.append(f"ses {sid}: dosya SWF'deki MP3 verisiyle aynı değil")
        seek = int.from_bytes(raw[:2], "little", signed=True)
        if s.get("seek") != seek or s.get("samples") != dump.sound_samples[int(sid)] or s.get("bytes") != len(data):
            probs.append(f"ses {sid}: gecikme, örnek sayısı ya da boyut farklı ({s.get('seek')}/{seek}, "
                         f"{s.get('samples')}/{dump.sound_samples[int(sid)]}, {s.get('bytes')}/{len(data)})")
        if not data[:2] in (b"\xff\xfb", b"\xff\xf3", b"\xff\xe3", b"\xff\xf2", b"\xff\xfa") and data[:3] != b"ID3":
            probs.append(f"ses {sid}: MP3 çerçeve başlığı yok")
    row("Sesler (baytlar, örnek sayısı ve MP3 gecikmesi SWF'dekiyle aynı)", len(lib["sounds"]), probs)
    # Resimler
    probs = []
    for bid, rel in lib["images"].items():
        try:
            d = image_difference(image_bytes(dump.images[int(bid)], dump.jpeg_tables), os.path.join(content, rel))
        except Exception as e:  # noqa: BLE001 - denetim her hatayı rapor eder
            probs.append(f"resim {bid}: açılamadı ({e})")
            continue
        if d is None or d != 0:
            probs.append(f"resim {bid}: SWF'deki resimle piksel piksel aynı değil (en büyük kanal farkı {d})")
    row("Resimler (SWF'deki veriden çözülen resimle piksel piksel aynı)", len(lib["images"]), probs)
    # 7. Kod: FFDec her kod parçasını ayrı .as dosyasına yazar (kare kodu, sınıf, düğme, klip eylemi)
    probs = code_problems(game, dump, man)
    row("Kod parçaları: yer yer (kare, sınıf, düğme, klip eylemi); üçüncü tarafınkiler yalnız listede",
        sum(dump.code_keys.values()), probs)
    row("Resim dolgulu şekiller (desen matrisi ve resmi SWF'dekiyle aynı)", len(lib["bitmap_shapes"]),
        bitmap_shape_problems(game, lib, dump))
    row("İnce çizgi işaretleri (işaretli çizgiler; FFDec'in SVG'sindekilerle aynı)",
        sum(len(v) for v in lib.get("hairlines", {}).values()), hairline_problems(game, lib, archive))
    swf_root = os.environ.get("SWF_KOK", os.path.join(ROOT, "..", "swf-oyunlar"))
    t_probs, g_probs, f_probs = translation_problems(game, lib, texts, dump, swf_root, archive)
    row("Türkçe çeviri tabloları (kaynağıyla bayt bayt aynı)", len(ceviri.TABLES), t_probs)
    row("Çeviri hedefleri (her yazı, kutu, yazı tipi ve çizim SWF'de; parça sayısı kayıt sayısıyla aynı)",
        sum(lib.get("translation", {}).get("counts", {}).get(k, 0) for k in ("texts", "edit_texts", "drawn_texts")),
        g_probs)
    checked, c_probs = code_translation_problems(game, swf_root)
    tr_files = sum(len(n) for _, _, n in os.walk(os.path.join(ROOT, "kaynak", "feudalism", game, "kod-tr")))
    if lib.get("translation", {}).get("counts", {}).get("code_files") != tr_files:
        c_probs.append(f"{game} çevrilmiş kod sayısı library.json'da "
                       f"{lib['translation']['counts'].get('code_files')}, kod-tr altında {tr_files}")
    row("Koddaki çeviriler (çevrilen koddaki her yeni dize sahibinin Türkçe SWF'sinin bayt kodunda)", checked,
        c_probs)
    row("Yazı tiplerinin açık lisanslı karşılıkları (dosya kaynağıyla aynı, lisansı yanında)", len(texts["fonts"]),
        f_probs)
    row("Morph sınırları (iki ucun SWF'deki sınırlarının birleşimi)", len(lib["morphs"]),
        morph_bounds_problems(game, lib, dump))
    checked, probs = shape_style_problems(game, lib, dump)
    row("Şekillerin renkleri, saydamlıkları, çizgi kalınlıkları, degrade matrisleri ve durakları (FFDec XML'iyle "
        "sayısal)", checked, probs)
    checked, probs = morph_style_problems(game, lib, dump)
    row("Morph uçlarının renkleri, saydamlıkları, çizgi kalınlıkları ve degrade matrisleri (FFDec XML'iyle sayısal)",
        checked, probs)
    refs, probs = undefined_references(lib, texts)
    row(f"Tanımsız karakter başvurusu (dışarıda bırakılana {refs} başvuru: oynatıcı atlar)",
        sum(len(ops) for t in [lib["root"], *lib["sprites"].values()] for ops in t["frames"]), probs)
    checked, probs, notes = third_party_traces(game, lib, texts)
    # Sahibinin kararı (16 Ekim 2026): sponsor yazıları gösterilmez, içerikte olmamalı
    probs += [f"{n} (sponsor adı geçiyor; sahibinin kararıyla gösterilmez)" for n in notes]
    row("Sponsor ve üçüncü taraf izi (çizimlerin içerik özetiyle iki oyunda; yazılarda; kaynak/ kodunda)",
        checked, probs)
    # 6. Şekillerin görsel karşılaştırması
    if visual:
        probs, worst = compare_shapes(game, lib, archive)
        row(f"Şekiller (resim dolgulular dahil): motorun çizimi FFDec'inkiyle piksel piksel (en kötü: "
            f"%{worst[0]:.2f} farklı, katı {worst[1]})", len(lib["shapes"]) + len(lib["bitmap_shapes"]), probs)
        probs, worst = compare_morphs(game, lib, archive)
        row(f"Morph başlangıç ve bitişleri piksel piksel (en kötü: %{worst[0]:.2f} farklı, katı {worst[1]})",
            2 * len(lib["morphs"]), probs)
        probs, worst = compare_drawn_texts(game, lib)
        row(f"Çizilmiş yazıların Türkçe hâlleri, Türkçe SWF'nin çizimiyle (en kötü: %{worst[0]:.2f} farklı, "
            f"katı {worst[1]})", len(lib.get("translation", {}).get("drawn_texts", {})), probs)
    return rows, problems, infos


# --- Görsel karşılaştırma -------------------------------------------------------------------------

INK_LEVEL = 8  # beyazdan bu kadar (0–255) uzak piksel "mürekkepli"
DIFF_LEVEL = 32  # 1 piksellik kayma payından sonra bu kadar (0–255) farklı piksel "belirgin farklı"
# Şekil başına sınırlar. Ayar (16 Ekim 2026, iki oyunun 3255 şekli ve 70 morph ucu): doğru çizimlerde
# iç piksellerin en çok %8,9'u belirgin farklı, katı farklı bölge en çok 2 piksel (kenar yumuşatma).
# B2'deki ters degrade %13,9 ve 433 752 katı piksel verir.
INK_LIMIT = 12.0  # iç piksellerin en çok %12'si belirgin farklı olabilir
SOLID_LIMIT = 16  # katı farklı bölge en çok 16 piksel (4× çizimde 1 kaynak pikseli)


def ink_difference(a, b, offset_a=(0, 0), offset_b=(0, 0)):
    """Yerel ölçüt: (iç piksellerin yüzde kaçı belirgin farklı, katı farklı piksel sayısı).

    İki resim beyaz tuvale gerilmeden konur. Bir piksel, öbür resmin 3×3 komşuluğundaki en yakın
    pikselden bile DIFF_LEVEL'dan fazla farklıysa (iki yönde de bakılır) belirgin farklıdır: kenar
    yumuşatmasındaki 1 piksellik kaymalar böylece affedilir. Oran iç piksellerde (3×3 komşuluğu iki çizimde
    de mürekkepli) ölçülür: ince çizgilerin bütün pikselleri kenardır, kenar farkı orana girmez. Katı farklı
    piksel: 3×3 komşuluğunun tamamı belirgin farklı olan piksel. Kenar boyunca uzanan ince (1–2 piksellik) fark çizgileri katı
    sayılmaz; gerçek hatalar (yanlış renk, ters degrade, eksik parça) kümelenir ve katı bölge bırakır."""
    import numpy as np
    from PIL import Image
    x0 = min(offset_a[0], offset_b[0])
    y0 = min(offset_a[1], offset_b[1])
    x1 = max(offset_a[0] + a.width, offset_b[0] + b.width)
    y1 = max(offset_a[1] + a.height, offset_b[1] + b.height)
    size = (int(round(x1 - x0)), int(round(y1 - y0)))

    def place(im, off):
        canvas = Image.new("RGBA", size, (255, 255, 255, 255))
        canvas.alpha_composite(im.convert("RGBA"), (int(round(off[0] - x0)), int(round(off[1] - y0))))
        return np.asarray(canvas.convert("RGB"), dtype=np.int16)
    pa, pb = place(a, offset_a), place(b, offset_b)
    ink_a = (255 - pa).max(axis=2) > INK_LEVEL
    ink_b = (255 - pb).max(axis=2) > INK_LEVEL
    inked = ink_a | ink_b
    if not inked.any():
        return 0.0, 0
    # Yalnız mürekkepli bölge (2 piksel paylı) karşılaştırılır
    ys, xs = np.nonzero(inked)
    y0, y1 = max(0, ys.min() - 2), ys.max() + 3
    x0, x1 = max(0, xs.min() - 2), xs.max() + 3
    pa, pb = pa[y0:y1, x0:x1], pb[y0:y1, x0:x1]
    ink_a, ink_b, inked = ink_a[y0:y1, x0:x1], ink_b[y0:y1, x0:x1], inked[y0:y1, x0:x1]
    h, w = inked.shape

    def nearest(p, q):
        # q'nun 3×3 komşuluğundaki en yakın piksele uzaklık (kanalların en büyük farkı); dışı beyaz
        padded = np.pad(q, ((1, 1), (1, 1), (0, 0)), constant_values=255)
        best = None
        for dy in range(3):
            for dx in range(3):
                d = np.abs(p - padded[dy:dy + h, dx:dx + w]).max(axis=2)
                best = d if best is None else np.minimum(best, d)
        return best

    def eroded(mask):
        padded = np.pad(mask, 1, mode="edge")
        out = np.ones_like(mask)
        for dy in range(3):
            for dx in range(3):
                out &= padded[dy:dy + h, dx:dx + w]
        return out
    bad = (np.maximum(nearest(pa, pb), nearest(pb, pa)) > DIFF_LEVEL) & inked
    # İç pikseller: 3×3 komşuluğu iki çizimde de mürekkepli (kenar yumuşatması buraya ulaşmaz)
    interior = eroded(ink_a) & eroded(ink_b)
    total = int(interior.sum())
    ratio = 100 * float((bad & interior).sum()) / total if total else 0.0
    return ratio, int(eroded(bad).sum())


def render_all(jobs):
    """[(svg, png, ölçek)] → motorun toplu çizicisiyle (tek süreç) PNG'ler."""
    with tempfile.NamedTemporaryFile("w", suffix=".txt", delete=False, encoding="utf-8") as f:
        f.write("\n".join(f"{a}\t{b}\t{c}" for a, b, c in jobs) + "\n")
        name = f.name
    try:
        subprocess.run([os.path.join(ROOT, "target", "release", "examples", "svg-batch"), name], check=True,
                       capture_output=True)
    finally:
        os.remove(name)


def ink_centre(im):
    """Resmin mürekkep (beyazdan uzaklık × örtücülük) ağırlıklı merkezi, piksel olarak; boş resimde None."""
    import numpy as np
    rgba = np.asarray(im.convert("RGBA"), dtype=np.float64) / 255.0
    ink = (1.0 - rgba[..., :3].mean(axis=2)) * rgba[..., 3]
    total = ink.sum()
    if total <= 0:
        return None
    ys, xs = np.indices(ink.shape)
    return (float((xs * ink).sum() / total), float((ys * ink).sum() / total))


def best_offset(a, b, window=3):
    """b'nin a'ya göre kaymasını bulur: önce iki resmin mürekkep merkezleri üst üste konur, sonra
    çevresinde ±window piksel içinde en iyi örtüşme aranır (FFDec'in morph PNG dökümleri sınıra
    belgelenmemiş bir pay ekler; bu yüzden yer resmin kendisinden ölçülür)."""
    import numpy as np
    from PIL import Image

    def gray(im):
        white = Image.new("RGBA", im.size, (255, 255, 255, 255))
        return np.asarray(Image.alpha_composite(white, im.convert("RGBA")).convert("L"), dtype=np.float32)
    ca, cb = ink_centre(a), ink_centre(b)
    if ca is None or cb is None:
        return (0, 0)
    ga, gb = gray(a), gray(b)
    gx, gy = int(round(ca[0] - cb[0])), int(round(ca[1] - cb[1]))
    best = None
    for dy in range(-window, window + 1):
        for dx in range(-window, window + 1):
            ox, oy = gx + dx, gy + dy
            x0, y0 = max(0, ox), max(0, oy)
            x1, y1 = min(ga.shape[1], ox + gb.shape[1]), min(ga.shape[0], oy + gb.shape[0])
            if x1 <= x0 or y1 <= y0:
                continue
            # Örtüşmeyen kısımlar beyaz sayılır: bütün mürekkep karşılaştırılmış olur
            d = float(np.abs(ga[y0:y1, x0:x1] - gb[y0 - oy:y1 - oy, x0 - ox:x1 - ox]).sum()
                      + (255 - ga).sum() - (255 - ga[y0:y1, x0:x1]).sum()
                      + (255 - gb).sum() - (255 - gb[y0 - oy:y1 - oy, x0 - ox:x1 - ox]).sum())
            if best is None or d < best[0]:
                best = (d, ox, oy)
    return (best[1], best[2]) if best else (gx, gy)


PATTERN = re.compile(r"<pattern\b.*?</pattern>", re.S)


def svg_patterns(svg):
    """SVG'deki desenler: [(desen matrisi, desenin resim baytları, desen kimliği)]."""
    out = []
    for m in PATTERN.finditer(svg):
        tag = m.group(0)
        mat = re.search(r'patternTransform="matrix\(([^)]*)\)"', tag)
        data = re.search(r"base64,([A-Za-z0-9+/=]+)", tag)
        pid = re.search(r'\bid="([^"]*)"', tag)
        out.append(([float(v) for v in mat.group(1).split(",")] if mat else [1.0, 0.0, 0.0, 1.0, 0.0, 0.0],
                    base64.b64decode(data.group(1)) if data else b"", pid.group(1) if pid else ""))
    return out


def image_difference(a, b):
    """İki resmin piksel piksel en büyük kanal farkı (0–255); boyutlar farklıysa None."""
    import numpy as np
    from PIL import Image
    with Image.open(io.BytesIO(a) if isinstance(a, bytes) else a) as ia, \
            Image.open(io.BytesIO(b) if isinstance(b, bytes) else b) as ib:
        if ia.size != ib.size:
            return None
        return int(np.abs(np.asarray(ia.convert("RGBA"), dtype=np.int16)
                          - np.asarray(ib.convert("RGBA"), dtype=np.int16)).max())


IMAGE_TOLERANCE = 2  # JPEG çözücüleri arasında izin verilen en büyük kanal farkı


def bitmap_shape_problems(game, lib, dump):
    """Resim dolgulu şekiller: SWF'de resim dolgusu olan her şekil aktarılmış mı; her desenin matrisi SWF'deki
    dolgu matrisi mi; desenin resmi, aktardığımız resim dosyasıyla piksel piksel aynı mı."""
    probs = []
    excluded = {int(k) for k in lib["excluded"]}
    content = os.path.join(ROOT, "content", "feudalism", game)
    for sid in sorted(set(dump.bitmap_fills) - {int(k) for k in lib["bitmap_shapes"]} - excluded):
        probs.append(f"{game} şekil {sid}: SWF'de resim dolgusu var ama resim dolgulu şekiller arasında yok")
    for sid in lib["bitmap_shapes"]:
        fills = dump.bitmap_fills.get(int(sid), [])
        if not fills:
            probs.append(f"{game} şekil {sid}: SWF'de resim dolgusu yok")
            continue
        with open(os.path.join(content, "shapes-bitmap", f"{sid}.svg"), encoding="utf-8") as f:
            patterns = svg_patterns(f.read())
        used = set()
        for k, (matrix, data, pid) in enumerate(patterns, 1):
            match = [i for i, (_, m, _) in enumerate(fills) if close(m, matrix)]
            if not match:
                probs.append(f"{game} şekil {sid} desen {k}: matrisi SWF'deki hiçbir resim dolgusuna uymuyor")
                continue
            used.update(match)
            bid, _, kind = fills[match[0]]
            # Dolgunun türü desenin kimliğindeki ekle aynı mı (motor türü oradan okur)
            if ("-kirp" in pid) != bool(kind & 1) or ("-yumusak" in pid) != (kind < 0x42):
                probs.append(f"{game} şekil {sid} desen {k}: kimliği {pid!r}, SWF'deki dolgu türü {kind:#x}")
            rel = lib["images"].get(str(bid))
            if rel is None:
                probs.append(f"{game} şekil {sid} desen {k}: resim {bid} aktarılmamış")
                continue
            d = image_difference(data, os.path.join(content, rel))
            if d is None or d > IMAGE_TOLERANCE:
                probs.append(f"{game} şekil {sid} desen {k}: resmi {rel} ile aynı değil (fark {d})")
        probs += [f"{game} şekil {sid}: SWF'deki resim dolgusu {i + 1} (resim {fills[i][0]}) SVG'de yok"
                  for i in range(len(fills)) if i not in used]
    return probs


# FFDec'in kendi çizim hataları: motorun çizimi SWF'nin verisine ve Flash'ın kuralına uyuyor, FFDec'inki
# uymuyor. Bunlar sorun sayılmaz, raporda gerekçesiyle listelenir.
KNOWN_FFDEC_ERRORS = {
    "f2 şekil 1791": "FFDec tekrarlı resim dolgusunu (0x42, resim 1789) dokunun satır sınırında, parke "
                     "bölgesinin SWF'deki alt kenarından (y = 9795 twip = 489,75 px) 1,35 piksel önce kesiyor; "
                     "Flash'ın kuralında doku kenara kadar sürer, motor da öyle çiziyor (Denetim 3, D3-4)",
}


def rendered_difference(pair):
    """Bir çizim çiftinin ölçüsü (paralel çalışabilsin diye modül düzeyinde)."""
    from PIL import Image
    name, ours, off_ours, theirs, off_theirs, search = pair
    if not os.path.exists(ours):
        return name, "motor çizemedi"
    if not os.path.exists(theirs):
        return name, "FFDec'in çizimi yok"
    with Image.open(ours) as a, Image.open(theirs) as b:
        if search:
            off_ours, off_theirs = (0, 0), best_offset(a, b)
        return name, ink_difference(a, b, off_ours, off_theirs)


def compare_rendered(pairs, search=False):
    """[(ad, bizim png, bizim kayma, FFDec png, FFDec kayma)] → (sorunlar, en kötü (oran, katı)).
    Ölçüt `ink_difference`: şekil başına iç piksellerin en çok %INK_LIMIT'i belirgin farklı olabilir ve
    SOLID_LIMIT'ten büyük katı farklı bölge olmamalıdır. `search`: FFDec çiziminin yerini en iyi
    örtüşmeyle bul (morph PNG'lerinin belgelenmemiş payı için). Bütün işlemci çekirdeklerinde çalışır."""
    from multiprocessing import Pool
    jobs = [(*p, search) for p in pairs]
    if len(jobs) > 8:
        with Pool() as pool:
            results = pool.map(rendered_difference, jobs, chunksize=8)
    else:
        results = [rendered_difference(j) for j in jobs]
    probs, worst = [], (0.0, 0)
    for name, result in results:
        if isinstance(result, str):
            probs.append(f"{name}: {result}")
            continue
        ratio, solid = result
        if name in KNOWN_FFDEC_ERRORS:
            continue
        worst = (max(worst[0], ratio), max(worst[1], solid))
        if ratio > INK_LIMIT or solid > SOLID_LIMIT:
            probs.append(f"{name}: iç piksellerin %{ratio:.2f}'i belirgin farklı, katı farklı bölge {solid} piksel")
    return probs, worst


HAIRLINE_PATH = re.compile(r'<path\b[^>]*\bdata-hairline="true"[^>]*>')


def hairline_svg(svg, scale):
    """Flash'ın ince çizgi kuralını SVG'ye uygular: 1 pikselden ince çizgi ekranda 1 piksel çizilir,
    yani kalınlık = en büyüğü(asıl kalınlık, 1 / ölçek). Motor bu kuralı oynatıcıda uygulayacak
    (library.json'daki "hairlines"); denetim, ayıklanan verinin doğruluğunu aynı kuralla çizerek sınar."""
    def fix(m):
        tag = m.group(0)
        original = re.search(r'data-original-stroke-width="([\d.]+)"', tag)
        if not original:
            return tag
        width = max(float(original.group(1)), 1.0 / scale)
        return re.sub(r'stroke-width="[\d.]+"', f'stroke-width="{width:g}"', tag)
    return HAIRLINE_PATH.sub(fix, svg)


MAX_TEXTURE = 8192  # grafik kartının doku sınırı (piksel)


def svg_size(path):
    with open(path, encoding="utf-8") as f:
        head = f.read(400)
    return [float(re.search(rf'{k}="([\d.]+)px"', head).group(1)) for k in ("width", "height")]


def compare_shapes(game, lib, archive):
    """Şekiller 4 kat büyütülerek çizilir; iki çizim de şeklin sınırının sol üst köşesinden başlar.
    İnce çizgili şekiller `hairline_svg` kuralıyla çizilir. 4 katı grafik kartının doku sınırını aşan
    şekil 2 katla çizilir ve FFDec'in 4× çizimi yarıya küçültülerek karşılaştırılır."""
    from PIL import Image
    ref_png = os.path.join(ROOT, "referans", game, "png")
    with tempfile.TemporaryDirectory() as td:
        jobs, pairs = [], []
        items = [("shapes", sid) for sid in lib["shapes"]] + [("shapes-bitmap", sid) for sid in lib["bitmap_shapes"]]
        for folder, sid in items:
            src = os.path.join(ROOT, "content", "feudalism", game, folder, f"{sid}.svg")
            scale = 4 if max(svg_size(src)) * 4 <= MAX_TEXTURE else 2
            if str(sid) in lib.get("hairlines", {}):
                with open(src, encoding="utf-8") as f:
                    svg = hairline_svg(f.read(), scale)
                src = os.path.join(td, f"{sid}.svg")
                with open(src, "w", encoding="utf-8") as f:
                    f.write(svg)
            jobs.append((src, os.path.join(td, f"{sid}.png"), scale))
            reference = os.path.join(ref_png, f"{sid}.png")
            if scale != 4 and os.path.exists(reference):
                with Image.open(reference) as im:
                    small = im.convert("RGBA").resize((round(im.width / 2), round(im.height / 2)), Image.LANCZOS)
                reference = os.path.join(td, f"{sid}.ffdec-2x.png")
                small.save(reference)
            pairs.append((f"{game} şekil {sid}" + (" (2×)" if scale != 4 else ""), os.path.join(td, f"{sid}.png"),
                          (0, 0), reference, (0, 0)))
        render_all(jobs)
        return compare_rendered(pairs)


def hairline_problems(game, lib, archive):
    """Her şeklin ince çizgi işaretleri FFDec'in SVG'sindekilerle aynı sayıda mı, library.json'daki
    "hairlines" listesi de SVG'deki işaretlerle aynı mı."""
    probs = []
    content = os.path.join(ROOT, "content", "feudalism", game)
    for folder, ids in (("shapes", lib["shapes"]), ("shapes-bitmap", lib["bitmap_shapes"])):
        for sid in ids:
            with open(os.path.join(content, folder, f"{sid}.svg"), encoding="utf-8") as f:
                ours = f.read().count('data-hairline="true"')
            with open(os.path.join(archive, "shapes", f"{sid}.svg"), encoding="utf-8") as f:
                theirs = f.read().count('ffdec:has-small-stroke="true"')
            listed = len(lib.get("hairlines", {}).get(str(sid), []))
            if ours != theirs or listed != ours:
                probs.append(f"{game} şekil {sid}: ince çizgi bizim {ours} / listede {listed} / FFDec {theirs}")
    return probs


def file_hash(path):
    import hashlib
    with open(path, "rb") as f:
        return hashlib.sha256(f.read()).hexdigest()


def translation_problems(game, lib, texts, dump, swf_root, archive):
    """Türkçe çeviri: tablolar kaynağıyla bayt bayt aynı mı; her girdinin hedefi FFDec'in dökümünde var mı
    ve sabit yazıların parça sayısı XML'deki kayıt sayısıyla aynı mı; her yazı tipinin açık lisanslı karşılığı
    ve lisansı yerinde mi. (Kod çevirisi ayrıca, sahibinin Türkçe SWF'siyle: `code_translation_problems`.)
    Dönen: (tablo sorunları, hedef sorunları, yazı tipi sorunları)."""
    src = os.path.join(swf_root, ceviri.TRANSLATIONS[game], "ceviri")
    content = os.path.join(ROOT, "content", "feudalism", game)
    tables_probs = []
    for name in ceviri.TABLES:
        ours = os.path.join(content, "ceviri", f"{name}.json")
        if not os.path.exists(ours) or file_hash(ours) != file_hash(os.path.join(src, f"{name}.json")):
            tables_probs.append(f"{game} çeviri {name}.json: kaynağıyla aynı değil")
    tables = ceviri.load_tables(src)
    target_probs = []
    for tid, entry in ceviri.entries(tables["sabit"]).items():
        if int(tid) not in dump.texts:
            target_probs.append(f"{game} sabit yazı {tid}: SWF'de yok")
        elif len(entry["parcalar"]) != len(dump.texts[int(tid)]):
            target_probs.append(f"{game} sabit yazı {tid}: çeviride {len(entry['parcalar'])} parça, SWF'de "
                                f"{len(dump.texts[int(tid)])} kayıt")
    target_probs += [f"{game} ekran kutusu {eid}: SWF'de yok" for eid in ceviri.entries(tables["kutular"])
                     if int(eid) not in dump.edit_texts]
    target_probs += [f"{game} yazı tipi {fid}: SWF'de yok" for fid in ceviri.entries(tables["yazitipleri"])
                     if dump.chars.get(int(fid)) != "font"]
    for sid in ceviri.entries(tables["sekiller"]):
        if dump.chars.get(int(sid)) != "shape":
            target_probs.append(f"{game} çizilmiş yazı {sid}: SWF'de şekil değil")
        if lib.get("translation", {}).get("drawn_texts", {}).get(sid, {}).get("file") != f"ceviri/sekiller/{sid}.svg":
            target_probs.append(f"{game} çizilmiş yazı {sid}: library.json'da yok")
    font_probs = []
    table = tables["yazitipleri"]
    for fid, font in texts["fonts"].items():
        rel = ceviri.font_file(fid, font, table)
        path = os.path.join(ROOT, "content", font.get("file", "?"))
        if rel is None or font.get("file") != f"fonts/{os.path.basename(rel)}":
            font_probs.append(f"{game} yazı tipi {fid}: karşılığı yanlış ({font.get('file')} / {rel})")
        elif not os.path.exists(path) or file_hash(path) != file_hash(os.path.join(swf_root, rel)):
            font_probs.append(f"{game} yazı tipi {fid}: {font['file']} kaynağıyla aynı değil")
        else:
            lic = next((name for prefix, (_, name) in ceviri.FONT_LICENSES.items()
                        if os.path.basename(rel).startswith(prefix)), None)
            if lic is None or not os.path.exists(os.path.join(ROOT, "content", "fonts", lic)):
                font_probs.append(f"{game} yazı tipi {fid}: lisans metni yok")
    return tables_probs, target_probs, font_probs


def image_bytes(image, jpeg_tables):
    """XmlDump.images kaydı (tür, veri) → çözülebilir JPEG/PNG baytları. DefineBits'in verisi dosyanın ortak
    JPEG tablolarıyla birleştirilir; bazı dosyalarda başta duran hatalı FFD9FFD8 atılır."""
    kind, data = image
    if data[:4] == b"\xff\xd9\xff\xd8":
        data = data[4:]
    if kind == "DefineBits":
        tables = jpeg_tables[4:] if jpeg_tables[:4] == b"\xff\xd9\xff\xd8" else jpeg_tables
        if tables.endswith(b"\xff\xd9") and data.startswith(b"\xff\xd8"):
            data = tables[:-2] + data[2:]
    return data


CODE_FILE = re.compile(r"^(DoAction|BUTTONCONDACTION|CLIPACTIONRECORD)(?:_\d+)?(?:\.as$| )")
# FFDec klasör adına adı ekler: DefineSprite_<kimlik>_<ad>, PlaceObject2_<karakter>_<ad>_<derinlik>
SPRITE_FOLDER = re.compile(r"^(DefineSprite_\d+)(?:_.*)?$")
PLACE_FOLDER = re.compile(r"^(PlaceObject\d?_\d+)(?:_.+)?(_\d+)$")


def code_key(rel):
    """FFDec betik dökümündeki dosyanın kod parçası yeri (bkz. XmlDump.code_places)."""
    parts = rel.split("/")
    m = CODE_FILE.match(parts[-1])
    if not m:
        return rel
    folders = [PLACE_FOLDER.sub(r"\1\2", SPRITE_FOLDER.sub(r"\1", p)) for p in parts[:-1]]
    return "/".join(folders + [m.group(1)])


def code_problems(game, dump, man):
    """Her kod parçası yerinde mi: SWF'deki (XML) her parça ya kaynak/.../kod altında ya da üçüncü tarafın
    kodu olarak manifest'te (yalnız yerel arşiv) olmalı; fazlası da eksiği de sorundur."""
    folder = os.path.join(ROOT, "kaynak", "feudalism", game, "kod")
    ours = {}
    for d, _, names in os.walk(folder):
        for n in names:
            key = code_key(os.path.relpath(os.path.join(d, n), folder).replace(os.sep, "/"))
            ours[key] = ours.get(key, 0) + 1
    for rel in man.get("code_excluded", {}):
        if not os.path.exists(os.path.join(ROOT, "referans", game, "tam", "scripts", rel)):
            ours["?"] = ours.get("?", 0) + 1
        key = code_key(rel)
        ours[key] = ours.get(key, 0) + 1
    return [f"{game} kod {k}: bizde {ours.get(k, 0)} / SWF'de {dump.code_keys.get(k, 0)}"
            for k in sorted(set(ours) | set(dump.code_keys)) if ours.get(k, 0) != dump.code_keys.get(k, 0)]


AS_STRING = re.compile(r'"((?:[^"\\\n]|\\.)*)"')
AS_ESCAPES = {"n": "\n", "r": "\r", "t": "\t", "b": "\b", "f": "\f"}


def as_literals(source):
    """FFDec'in yazdığı ActionScript kaynağındaki dize sabitleri (kaçış dizileri çözülmüş)."""
    def unescape(m):
        e = m.group(1)
        if e[0] in "ux" and len(e) > 1:
            return chr(int(e[1:], 16))
        return AS_ESCAPES.get(e, e)
    return [re.sub(r"\\(u[0-9a-fA-F]{4}|x[0-9a-fA-F]{2}|.)", unescape, lit) for lit in AS_STRING.findall(source)]


def code_translation_problems(game, swf_root, strings=None):
    """Çevrilen kod (kaynak/.../kod-tr): her dosyanın orijinali kod/ altında olmalı; orijinalde olmayan her
    dize sabiti sahibinin Türkçe SWF'sinin bayt kodundaki dizeler arasında bulunmalı. Dönen: (denetlenen
    yeni dize sayısı, sorunlar)."""
    tr_swf = os.path.join(swf_root, os.path.dirname(aktar.GAMES[game]),
                          os.path.basename(aktar.GAMES[game]).replace("-orijinal.swf", "-tr.swf"))
    if strings is None:
        strings = set(swf.movie_strings(tr_swf))
    base = os.path.join(ROOT, "kaynak", "feudalism", game)
    checked, probs = 0, []
    for d, _, names in os.walk(os.path.join(base, "kod-tr")):
        for n in names:
            rel = os.path.relpath(os.path.join(d, n), os.path.join(base, "kod-tr"))
            original = os.path.join(base, "kod", rel)
            if not os.path.exists(original):
                probs.append(f"{game} çevrilmiş kod {rel}: orijinali kod/ altında yok")
                continue
            with open(original, encoding="utf-8") as f:
                old = set(as_literals(f.read()))
            with open(os.path.join(d, n), encoding="utf-8") as f:
                for lit in as_literals(f.read()):
                    if lit in old:
                        continue
                    checked += 1
                    if lit not in strings:
                        probs.append(f"{game} çevrilmiş kod {rel}: {lit[:60]!r} Türkçe SWF'de yok")
    return checked, probs


def svg_styles(svg):
    """Morph ucu SVG'sindeki stiller: [(tür, değerler)]: degrade (matris, [(oran, renk, saydamlık)]),
    düz dolgu (renk, saydamlık), çizgi (renk, saydamlık, kalınlık)."""
    root = ET.fromstring(svg)
    out = []
    for el in root.iter():
        tag = el.tag.split("}")[-1]
        if tag in ("linearGradient", "radialGradient"):
            stops = [(float(st.get("offset")), st.get("stop-color", "").lower(), float(st.get("stop-opacity", "1")))
                     for st in el if st.tag.split("}")[-1] == "stop"]
            spread = {"pad": 0, "reflect": 1, "repeat": 2}.get(el.get("spreadMethod", "pad"), -1)
            out.append(("gradient", (tag, aktar.parse_matrix(el.get("gradientTransform")), stops, spread)))
        elif tag == "path":
            if el.get("fill", "none").startswith("#"):
                out.append(("fill", (el.get("fill").lower(), float(el.get("fill-opacity", "1")))))
            if el.get("stroke", "none").startswith("#"):
                # İnce çizgide SVG'deki kalınlık ekran içindir; özgün kalınlık işaretinde
                width = el.get("data-original-stroke-width") or el.get("stroke-width", "1")
                out.append(("line", (el.get("stroke").lower(), float(el.get("stroke-opacity", "1")), float(width))))
    return out


def style_matches(kind, value, styles, end):
    """SVG'deki stil, XML'deki stillerden birinin `end` ucuyla aynı mı (matris 6 ondalığa yuvarlanmış)."""
    hexc = aktar.hex_colour
    if kind == "gradient":
        tag, matrix, stops, spread = value
        types = ("linear",) if tag == "linearGradient" else ("radial", "focal")
        for f in styles["fills"]:
            if f["type"] not in types or len(f[end]["stops"]) != len(stops) or f.get("spread", spread) != spread:
                continue
            if any(abs(a - b) > 1e-6 for a, b in zip(matrix, f[end]["matrix"])):
                continue
            if all(abs(o - r / 255) < 1e-6 and c == hexc(rgba) and abs(op - rgba[3] / 255) < 1e-6
                   for (o, c, op), (r, rgba) in zip(stops, f[end]["stops"])):
                return True
        return False
    if kind == "fill":
        colour, op = value
        return any(f["type"] == "solid" and colour == hexc(f[end]) and abs(op - f[end][3] / 255) < 1e-6
                   for f in styles["fills"])
    colour, op, width = value
    return any("color" in line[end] and colour == hexc(line[end]["color"]) and abs(op - line[end]["color"][3] / 255)
               < 1e-6 and abs(width - line[end]["width"]) < 1e-6 for line in styles["lines"])


def shape_style_problems(game, lib, dump):
    """Şekillerin her stili (düz renk ve saydamlık, çizgi rengi ve kalınlığı, degrade matrisi ve durakları)
    FFDec XML'indeki o şeklin stillerinden biriyle sayısal olarak aynı mı (D3-3). Dönen: (denetlenen stil
    sayısı, sorunlar)."""
    checked, probs = 0, []
    content = os.path.join(ROOT, "content", "feudalism", game)
    for folder, ids in (("shapes", lib["shapes"]), ("shapes-bitmap", lib["bitmap_shapes"])):
        for sid in ids:
            with open(os.path.join(content, folder, f"{sid}.svg"), encoding="utf-8") as f:
                styles = svg_styles(f.read())
            for kind, value in styles:
                checked += 1
                if not style_matches(kind, value, dump.shape_styles[int(sid)], "start"):
                    probs.append(f"{game} şekil {sid}: {kind} {value} SWF'deki hiçbir stile uymuyor")
    return checked, probs


def morph_style_problems(game, lib, dump):
    """Morph uçlarındaki her stil (degrade matrisi ve durakları, düz renk, çizgi rengi ve kalınlığı) FFDec
    XML'indeki aynı ucun bir stiliyle sayısal olarak aynı mı. Dönen: (denetlenen stil sayısı, sorunlar)."""
    checked, probs = 0, []
    for mid in lib["morphs"]:
        for end in ("start", "end"):
            with open(os.path.join(ROOT, "content", "feudalism", game, "morphs", f"{mid}.{end}.svg"),
                      encoding="utf-8") as f:
                styles = svg_styles(f.read())
            for kind, value in styles:
                checked += 1
                if not style_matches(kind, value, dump.morph_styles[int(mid)], end):
                    probs.append(f"{game} morph {mid} {end}: {kind} {value} SWF'deki hiçbir stile uymuyor")
    return checked, probs


def undefined_references(lib, texts):
    """Zaman çizelgelerinde ve düğmelerde, kütüphanede tanımı olmayan karaktere başvuru. Dışarıda bırakılana
    (library.json "excluded") başvuru sorun değildir, sayılır (oynatıcı onu atlar). Dönen: (o sayı, sorunlar)."""
    defined = {int(k) for key in ("shapes", "bitmap_shapes", "morphs", "sprites", "buttons") for k in lib[key]}
    defined |= {int(k) for key in ("texts", "edit_texts") for k in texts[key]}
    excluded = {int(k) for k in lib["excluded"]}
    refs, probs = 0, []
    timelines = [("kök film", lib["root"])] + [(f"sprite {k}", t) for k, t in lib["sprites"].items()]
    places = [(name, i, op["char"]) for name, t in timelines for i, ops in enumerate(t["frames"]) for op in ops
              if "char" in op]
    places += [(f"düğme {b}", 0, r["char"]) for b, recs in lib["buttons"].items() for r in recs]
    for name, frame, char in places:
        if char in excluded:
            refs += 1
        elif char not in defined:
            probs.append(f"{name} kare {frame + 1}: karakter {char} tanımlı değil ve dışarıda bırakılanlarda da yok")
    return refs, probs


def body_digest(body):
    """Karakter tanımının kimliği dışındaki baytlarının özeti: aynı çizim başka kimlikle de bulunur."""
    import hashlib
    return hashlib.sha256(body[2:]).hexdigest()


SPONSOR_WORDS = re.compile(r"arcadetown|newgrounds|armorgames|addictinggames|mochibot|mochiad|mochimedia", re.I)


def third_party_traces(game, lib, texts):
    """Sponsor ve üçüncü taraf izi: (1) aktarılan şekil, morph ve resimlerin içerik özeti, iki oyunda da
    dışarıda bırakılan karakterlerinkiyle aynı olmamalı (aynı logo öbür oyunda başka kimlikle durabilir);
    (2) kaynak/ altında Adobe mx sınıfı ya da reklam/izleme kütüphanesi olmamalı; (3) sponsor adı geçen
    yazılar ayrıca döner (çağıran sorun sayar). Dönen: (denetlenen kayıt sayısı, sorunlar, sponsor yazıları)."""
    swf_root = os.environ.get("SWF_KOK", os.path.join(ROOT, "..", "swf-oyunlar"))
    sponsor = {}
    for g in aktar.GAMES:
        movie = swf.Movie(os.path.join(swf_root, aktar.GAMES[g]))
        with open(os.path.join(ROOT, "content", "feudalism", g, "library.json"), encoding="utf-8") as f:
            excluded = {int(k) for k in json.load(f)["excluded"]}
        bodies = {**movie.shape_bodies, **movie.morph_bodies}
        for cid in excluded & set(bodies):
            sponsor[body_digest(bodies[cid][1])] = f"{g} {cid}"
        if g == game:
            ours = bodies
    imported = [int(k) for key in ("shapes", "bitmap_shapes", "morphs") for k in lib[key]]
    probs = [f"{game} karakter {cid}: dışarıda bırakılan {sponsor[body_digest(ours[cid][1])]} ile aynı çizim"
             for cid in imported if body_digest(ours[cid][1]) in sponsor]
    checked = len(imported)
    # Sponsor adı geçen yazılar (oyunun kendi yazıları; sahibinin kararıyla gösterilmezler)
    notes = [f"{game} {'yazı' if kind == 'texts' else 'yazı alanı'} {tid}: {re.sub(r'<[^>]+>', '', t['text'])[:90]!r}"
             for kind in ("texts", "edit_texts") for tid, t in texts[kind].items()
             if SPONSOR_WORDS.search(t.get("text", ""))]
    for sub in ("kod", "kod-tr"):
        folder = os.path.join(ROOT, "kaynak", "feudalism", game, sub)
        for d, _, names in os.walk(folder):
            for n in names:
                rel = os.path.relpath(os.path.join(d, n), folder).replace(os.sep, "/")
                checked += 1
                with open(os.path.join(d, n), encoding="utf-8") as f:
                    src = f.read()
                # Kütüphanelerin kendisi (oyunun kodundaki bir çağrı değil)
                if rel.startswith("__Packages/mx/") or re.search(r"function __com_mochibot__|class MochiAd\b", src):
                    probs.append(f"{game} {sub}/{rel}: üçüncü tarafın kodu")
    return checked, probs, notes


def compare_drawn_texts(game, lib):
    """Çizilmiş yazıların Türkçe hâlleri: motorun çizimi, Türkçe SWF'nin FFDec çizimiyle (4×)."""
    drawn = lib.get("translation", {}).get("drawn_texts", {})
    with tempfile.TemporaryDirectory() as td:
        jobs = [(os.path.join(ROOT, "content", "feudalism", game, d["file"]), os.path.join(td, f"{sid}.png"), 4)
                for sid, d in drawn.items()]
        render_all(jobs)
        return compare_rendered([(f"{game} çizilmiş yazı {sid}", os.path.join(td, f"{sid}.png"), (0, 0),
                                  os.path.join(ROOT, "referans", game, "tr", "png", f"{sid}.png"), (0, 0))
                                 for sid in drawn])


def morph_bounds_problems(game, lib, dump):
    """Morph uçlarımızın tuvali iki ucun SWF'deki sınırlarının birleşimi mi (başlangıç noktası ve boyut)."""
    probs = []
    for mid, origin in lib["morphs"].items():
        b = dump.morph_bounds[int(mid)]
        x0, y0 = min(b["start"][0], b["end"][0]), min(b["start"][1], b["end"][1])
        x1, y1 = max(b["start"][2], b["end"][2]), max(b["start"][3], b["end"][3])
        if not close(origin, [x0, y0]):
            probs.append(f"{game} morph {mid}: başlangıç noktası {origin} / SWF {[x0, y0]}")
        for end in ("start", "end"):
            with open(os.path.join(ROOT, "content", "feudalism", game, "morphs", f"{mid}.{end}.svg"),
                      encoding="utf-8") as f:
                head = f.read(400)
            size = [float(re.search(rf'{k}="([\d.]+)px"', head).group(1)) for k in ("width", "height")]
            if not close(size, [x1 - x0, y1 - y0]):
                probs.append(f"{game} morph {mid} {end}: boyut {size} / SWF {[x1 - x0, y1 - y0]}")
    return probs


def compare_morphs(game, lib, archive):
    """Morph uçları şekiller gibi 4 kat büyütülerek çizilir. FFDec'in morph PNG'leri sınıra belgelenmemiş
    bir pay eklediği için iki çizim, mürekkep merkezleri ve en iyi örtüşmeyle hizalanır (sınırın
    kendisi `morph_bounds_problems` ile sayısal olarak ayrıca denetlenir)."""
    with tempfile.TemporaryDirectory() as td:
        jobs, pairs = [], []
        for mid in lib["morphs"]:
            for end in ("start", "end"):
                out = os.path.join(td, f"{mid}.{end}.png")
                jobs.append((os.path.join(ROOT, "content", "feudalism", game, "morphs", f"{mid}.{end}.svg"), out, 4))
                pairs.append((f"{game} morph {mid} {end}", out, (0, 0),
                              os.path.join(archive, "morph-png", f"{mid}.{end}.png"), (0, 0)))
        render_all(jobs)
        return compare_rendered(pairs, search=True)


def main(argv):
    visual = "--gorsel" in argv
    out = ["# Ayıklama denetimi", "",
           "`python3 araclar/aktar/denetim.py --gorsel` üretir. Oyuna aktarılanı FFDec'in kendi",
           "ayrıştırıcısıyla ürettiği XML dökümüyle kayıt kayıt karşılaştırır; şekilleri motorun çizimiyle",
           "FFDec'in çizimi arasında piksel piksel karşılaştırır.", ""]
    all_problems = 0
    for game in ("f1", "f2"):
        rows, problems, infos = check_game(game, visual)
        all_problems += len(problems)
        out += [f"## {'Feudalism' if game == 'f1' else 'Feudalism 2'} ({game})", "",
                "| Denetim | Denetlenen | Sorun |", "|---|---|---|"]
        out += [f"| {n} | {c} | {p} |" for n, c, p in rows]
        out.append("")
        if infos:
            out += ["Bilgi (sorun sayılmaz): sponsor adı geçen yazılar (oyunun kendi yazıları). Sahibinin kararı",
                    "sponsor yazılarının gösterilmemesidir; bunlar dışarıda bırakılmalı.", ""] + [f"- {i}" for i in infos] + [""]
        if problems:
            out += ["Sorunlar:", ""] + [f"- {p}" for p in problems[:300]]
            if len(problems) > 300:
                out.append(f"- … ve {len(problems) - 300} sorun daha")
            out.append("")
        print(game, " | ".join(f"{n}: {p}" for n, c, p in rows))
    out.append(f"Toplam sorun: {all_problems}.")
    out += ["", "## Yöntem ve sınırlar", "",
            "- Kaynak: SWF'yi bizim ayrıştırıcımızdan bağımsız okuyan FFDec 24.1.1'in XML dökümü (`-swf2xml`)",
            "  ve FFDec'in kendi PNG çizimleri (şekiller ve morph uçları 4× büyütülmüş).",
            "- Piksel karşılaştırması (şekil başına, yerel): iki çizim beyaz tuvale gerilmeden konur. Bir piksel,",
            "  öbür çizimin 3×3 komşuluğundaki en yakın pikselden bile 32/255'ten fazla farklıysa belirgin",
            "  farklıdır (kenar yumuşatmasındaki 1 piksellik kayma affedilir). Sorun: iç piksellerin (3×3",
            "  komşuluğu iki çizimde de dolu) %12'sinden fazlası belirgin farklı, ya da 16 pikselden büyük katı",
            "  farklı bölge (3×3 komşuluğunun tamamı farklı) var. Ayar: doğru çizimlerde en çok %8,9 ve 2 piksel;",
            "  Denetim 2'nin B2 hatası (ters degrade) %13,9 ve 433 752 piksel verir.",
            "- İnce çizgiler: Flash 1 pikselden ince çizgiyi ekranda 1 piksel çizer. Bu çizgiler",
            "  `data-hairline` ile işaretli aktarılır ve library.json'da listelenir; denetim onları bu kuralla",
            "  çizer. Motor kuralı oynatıcıda uygulayacak (Faz B).",
            "- Morph uçları: FFDec'in morph PNG'leri sınıra belgelenmemiş bir pay ekler; çizimler mürekkep",
            "  merkezi ve en iyi örtüşmeyle hizalanır (yalnız bütünün yeri; parçaların yerel kayması ölçütte",
            "  görünür). Sınırın kendisi XML'deki iki ucun sınırıyla sayısal olarak ayrıca denetlenir. Uçların",
            "  renkleri, saydamlıkları, çizgi kalınlıkları ve degrade matrisleri FFDec'in XML'iyle sayısal",
            "  olarak karşılaştırılır.",
            "- FFDec'in bilinen çizim hataları (sorun sayılmaz; motorun çizimi SWF'nin verisine uyar):",
            *[f"  - {k}: {v}" for k, v in KNOWN_FFDEC_ERRORS.items()],
            "- Resim dolgulu şekiller (zemin dokuları): kenarların kullandığı her resim dolgusunun SVG'deki desen",
            "  matrisi SWF'deki dolgu matrisiyle, desenin resmi aktarılan resim dosyasıyla piksel piksel aynıdır;",
            "  motorun çizimi (resim boyası) FFDec'in çizimiyle öbür şekiller gibi karşılaştırılır.",
            "- Sesler: dosyalar SWF'deki MP3 verisiyle bayt bayt, örnek sayısı ve MP3 başlangıç gecikmesi",
            "  XML'deki değerlerle aynıdır. Zaman çizelgelerindeki ses kayıtları durdurma, tekrar, giriş/çıkış",
            "  noktası ve zarf bilgisiyle karşılaştırılır.",
            "- Türkçe çeviri: tablolar kaynağıyla (swf-oyunlar) bayt bayt aynıdır; her girdinin hedefi FFDec'in",
            "  dökümünde aranır, sabit yazıların parça sayısı XML'deki kayıt sayısıyla karşılaştırılır. Kod",
            "  çevirisinde orijinalde olmayan her dize, sahibinin Türkçe SWF'sinin bayt kodundaki dizeler",
            "  arasında aranır (kendi okuyucumuzla). \"Öldün...\" çizimi Türkçe SWF'nin FFDec çizimiyle",
            "  piksel piksel karşılaştırılır.",
            "- Aktarılmayanlar (yerel arşivde): sponsor logoları, Macromedia/Adobe arayüz bileşenleri, gömülü",
            "  yazı tipleri (yerine açık lisanslı karşılıkları). Listesi ve nedenleri",
            "  `kaynak/feudalism/<oyun>/manifest.json` içindedir."]
    with open(os.path.join(ROOT, "docs", "AYIKLAMA_DENETIMI.md"), "w", encoding="utf-8") as f:
        f.write("\n".join(out) + "\n")
    return 1 if all_problems else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
