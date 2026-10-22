"""SWF dosyasını okur: sahne bilgisi, karakter tanımları ve zaman çizelgeleri.

Yalnızca aktarımın gerektirdiği kadarını çözer. Şekillerin kendisi FFDec'in SVG çıktısından alınır
(bkz. aktar.py); burada şekillerin yalnızca kimliği ve türü tutulur.

Zaman çizelgesi SWF'deki gibi kare kare "işlem" olarak saklanır: yerleştir, taşı, kaldır. Oynatıcı
bunları sırayla uygulayarak her karenin görüntü listesini kurar.
"""
import hashlib
import os
import struct
import sys
import zlib

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "olcum"))
from swfstats import Bits, tags  # noqa: E402

SHAPE_TAGS = {2, 22, 32, 83}
MORPH_TAGS = {46, 84}
BITMAP_TAGS = {6, 20, 21, 35, 36, 90}
TEXT_TAGS = {11, 33}
FONT_TAGS = {10, 48, 75}
BLEND_MODES = {0: "normal", 1: "normal", 2: "layer", 3: "multiply", 4: "screen", 5: "lighten", 6: "darken",
               7: "difference", 8: "add", 9: "subtract", 10: "invert", 11: "alpha", 12: "erase",
               13: "overlay", 14: "hardlight"}


def load(path):
    """SWF'yi açar: (sürüm, sahne genişliği, sahne yüksekliği, kare hızı, veri, ilk etiketin yeri)."""
    with open(path, "rb") as f:
        raw = f.read()
    sig, version = raw[:3], raw[3]
    if sig == b"CWS":
        data = raw[:8] + zlib.decompress(raw[8:])
    elif sig == b"FWS":
        data = raw
    else:
        raise ValueError(f"desteklenmeyen SWF imzası: {sig!r}")
    b = Bits(data, 8)
    nbits = b.ub(5)
    xmin, xmax, ymin, ymax = (b.sb(nbits) for _ in range(4))
    b.align()
    rate = struct.unpack_from("<H", data, b.pos)[0] / 256
    pos = b.pos + 4
    return version, (xmax - xmin) / 20, (ymax - ymin) / 20, rate, data, pos


def sha256(path):
    with open(path, "rb") as f:
        return hashlib.sha256(f.read()).hexdigest()


def read_matrix(b):
    """MATRIX → [a, b, c, d, tx, ty]; öteleme piksel."""
    b.align()
    a = d = 1.0
    bb = c = 0.0
    if b.ub(1):
        n = b.ub(5)
        a = b.sb(n) / 65536
        d = b.sb(n) / 65536
    if b.ub(1):
        n = b.ub(5)
        bb = b.sb(n) / 65536
        c = b.sb(n) / 65536
    n = b.ub(5)
    tx = b.sb(n) / 20
    ty = b.sb(n) / 20
    b.align()
    return [a, bb, c, d, tx, ty]


def read_cxform(b, alpha=True):
    """CXFORM(WITHALPHA) → [[çarpanlar r, g, b, a], [ekler r, g, b, a]]; çarpan 1 = değişmez,
    ek 0..1 aralığında (255'e bölünmüş)."""
    b.align()
    has_add = b.ub(1)
    has_mul = b.ub(1)
    n = b.ub(4)
    count = 4 if alpha else 3
    mul = [1.0, 1.0, 1.0, 1.0]
    add = [0.0, 0.0, 0.0, 0.0]
    if has_mul:
        for i in range(count):
            mul[i] = b.sb(n) / 256
    if has_add:
        for i in range(count):
            add[i] = b.sb(n) / 255
    b.align()
    return [mul, add]


def _filter_flags(byte, on_top):
    """Süzgeç bayrak baytı: iç, delme, bileşim, [üstte], geçiş sayısı."""
    out = {"inner": bool(byte & 0x80), "knockout": bool(byte & 0x40), "composite": bool(byte & 0x20)}
    if on_top:
        out["on_top"] = bool(byte & 0x10)
        out["passes"] = byte & 0x0F
    else:
        out["passes"] = byte & 0x1F
    return out


def read_filters(data, p):
    """FILTERLIST → ([{tür, bütün alanları}], yeni konum). Bulanıklık, açı ve uzaklık 16.16, güç 8.8 sabit
    noktalıdır; açı radyan. Oynatıcı süzgeçleri şimdilik çizmez."""
    count = data[p]
    p += 1
    out = []
    for _ in range(count):
        kind = data[p]
        p += 1
        if kind == 0:  # DropShadow: renk, bulanıklık x/y, açı, uzaklık, güç, bayraklar (23 bayt)
            rgba = list(data[p:p + 4])
            bx, by, ang, dist, strength = struct.unpack_from("<iiiih", data, p + 4)
            out.append({"type": "drop_shadow", "color": rgba, "blur": [bx / 65536, by / 65536],
                        "angle": ang / 65536, "distance": dist / 65536, "strength": strength / 256,
                        **_filter_flags(data[p + 22], False)})
            p += 23
        elif kind == 1:  # Blur: bulanıklık x/y, geçiş sayısı (9 bayt)
            bx, by = struct.unpack_from("<ii", data, p)
            out.append({"type": "blur", "blur": [bx / 65536, by / 65536], "passes": data[p + 8] >> 3})
            p += 9
        elif kind == 2:  # Glow: renk, bulanıklık x/y, güç, bayraklar (15 bayt)
            rgba = list(data[p:p + 4])
            bx, by, strength = struct.unpack_from("<iih", data, p + 4)
            out.append({"type": "glow", "color": rgba, "blur": [bx / 65536, by / 65536], "strength": strength / 256,
                        **_filter_flags(data[p + 14], False)})
            p += 15
        elif kind == 3:  # Bevel: gölge ve parlak renk, bulanıklık x/y, açı, uzaklık, güç, bayraklar (27 bayt)
            bx, by, ang, dist, strength = struct.unpack_from("<iiiih", data, p + 8)
            out.append({"type": "bevel", "shadow": list(data[p:p + 4]), "highlight": list(data[p + 4:p + 8]),
                        "blur": [bx / 65536, by / 65536], "angle": ang / 65536, "distance": dist / 65536,
                        "strength": strength / 256, **_filter_flags(data[p + 26], True)})
            p += 27
        elif kind in (4, 7):  # GradientGlow, GradientBevel
            n = data[p]
            colours = [list(data[p + 1 + 4 * i:p + 5 + 4 * i]) for i in range(n)]
            ratios = list(data[p + 1 + 4 * n:p + 1 + 5 * n])
            q = p + 1 + 5 * n
            bx, by, ang, dist, strength = struct.unpack_from("<iiiih", data, q)
            out.append({"type": "gradient_glow" if kind == 4 else "gradient_bevel",
                        "stops": [[r, c] for r, c in zip(ratios, colours)], "blur": [bx / 65536, by / 65536],
                        "angle": ang / 65536, "distance": dist / 65536, "strength": strength / 256,
                        **_filter_flags(data[q + 18], True)})
            p = q + 19
        elif kind == 5:  # Convolution
            mx, my = data[p], data[p + 1]
            divisor, bias = struct.unpack_from("<ff", data, p + 2)
            matrix = list(struct.unpack_from(f"<{mx * my}f", data, p + 10))
            q = p + 10 + mx * my * 4
            out.append({"type": "convolution", "size": [mx, my], "divisor": divisor, "bias": bias, "matrix": matrix,
                        "default_color": list(data[q:q + 4]), "clamp": bool(data[q + 4] & 0x02),
                        "preserve_alpha": bool(data[q + 4] & 0x01)})
            p = q + 5
        elif kind == 6:  # ColorMatrix
            values = struct.unpack_from("<20f", data, p)
            out.append({"type": "color_matrix", "matrix": [round(v, 5) for v in values]})
            p += 80
        else:
            raise ValueError(f"bilinmeyen süzgeç türü: {kind}")
    return out, p


def read_place(body, code):
    """PlaceObject2 (26) / PlaceObject3 (70) → işlem sözlüğü.

    Anahtarlar: depth, move (var olanı değiştir), char, matrix, cxform, ratio, name, clip (kırpma
    derinliği: bu nesne, derinliği clip'e kadar olanlar için maske olur), filters, blend."""
    flags = body[0]
    p = 1
    flags2 = 0
    if code == 70:
        flags2 = body[1]
        p = 2
    op = {"depth": struct.unpack_from("<H", body, p)[0]}
    p += 2
    if flags & 1:
        op["move"] = True
    if code == 70 and (flags2 & 0x08 or (flags2 & 0x10 and flags & 0x02)):
        p = body.index(b"\0", p) + 1  # sınıf adı
    if flags & 0x02:
        op["char"] = struct.unpack_from("<H", body, p)[0]
        p += 2
    if flags & 0x04:
        b = Bits(body, p)
        op["matrix"] = read_matrix(b)
        p = b.pos
    if flags & 0x08:
        b = Bits(body, p)
        op["cxform"] = read_cxform(b)
        p = b.pos
    if flags & 0x10:
        op["ratio"] = struct.unpack_from("<H", body, p)[0] / 65535
        p += 2
    if flags & 0x20:
        e = body.index(b"\0", p)
        op["name"] = body[p:e].decode("latin1")
        p = e + 1
    if flags & 0x40:
        op["clip"] = struct.unpack_from("<H", body, p)[0]
        p += 2
    if code == 70:
        # PlaceObject3'te süzgeç ve karışım kırpma derinliğinden sonra, klip eylemlerinden önce gelir
        if flags2 & 0x01:
            op["filters"], p = read_filters(body, p)
        if flags2 & 0x02:
            op["blend"] = BLEND_MODES.get(body[p], "normal")
            p += 1
        if flags2 & 0x04:
            p += 1  # bit eşlem önbelleği: çizimi değiştirmez
        if flags2 & 0x20:
            op["visible"] = bool(body[p])
            p += 1
        if flags2 & 0x40:
            op["background"] = list(body[p:p + 4])
            p += 4
    if flags & 0x80:
        # Klip eylemleri (onClipEvent): oyunun kodu; metni FFDec'in betik dökümündedir
        op["clip_actions"] = True
        op["_clip_actions_at"] = p
    return op


class Timeline:
    """Bir sprite'ın ya da kök filmin zaman çizelgesi."""

    def __init__(self):
        self.frames = [[]]  # her kare: işlem listesi
        self.labels = {}  # etiket → kare sırası (0'dan)
        self.sounds = {}  # kare sırası → [{id, ses bilgisi (bkz. read_sound_info)}]

    def add_tag(self, code, body):
        ops = self.frames[-1]
        if code in (26, 70):
            op = read_place(body, code)
            op.pop("_clip_actions_at", None)
            ops.append(op)
        elif code == 28:  # RemoveObject2
            ops.append({"remove": struct.unpack_from("<H", body, 0)[0]})
        elif code == 5:  # RemoveObject
            ops.append({"remove": struct.unpack_from("<H", body, 2)[0]})
        elif code == 43:  # FrameLabel
            label = body[:body.index(b"\0")].decode("latin1")
            if label in self.labels:
                # Etiketler ada göre tutulur; aynı ad ikinci kez gelirse biri kaybolurdu
                raise ValueError(f"aynı adlı iki kare etiketi: {label!r}")
            self.labels[label] = len(self.frames) - 1
        elif code == 15:  # StartSound
            self.sounds.setdefault(len(self.frames) - 1, []).append(
                {"id": struct.unpack_from("<H", body, 0)[0], **read_sound_info(body, 2)})
        elif code == 1:  # ShowFrame
            self.frames.append([])

    def finish(self):
        # Son ShowFrame'den sonra açılan boş kare atılır
        if self.frames and not self.frames[-1]:
            self.frames.pop()
        return self

    def characters(self):
        return {op["char"] for ops in self.frames for op in ops if "char" in op}


def read_button(body):
    """DefineButton2 → (kimlik, kayıtlar). Kayıt: {states: [up, over, down, hit], char, depth, matrix, cxform}."""
    bid = struct.unpack_from("<H", body, 0)[0]
    p = 2 + 1 + 2  # kimlik, izleme bayrağı, eylem kaydırması
    records = []
    while body[p] != 0:
        flags = body[p]
        p += 1
        rec = {"states": [bool(flags & 1), bool(flags & 2), bool(flags & 4), bool(flags & 8)],
               "char": struct.unpack_from("<H", body, p)[0], "depth": struct.unpack_from("<H", body, p + 2)[0]}
        p += 4
        b = Bits(body, p)
        rec["matrix"] = read_matrix(b)
        rec["cxform"] = read_cxform(b)
        p = b.pos
        if flags & 0x10:
            rec["filters"], p = read_filters(body, p)
        if flags & 0x20:
            rec["blend"] = BLEND_MODES.get(body[p], "normal")
            p += 1
        records.append(rec)
    return bid, records


class Movie:
    """Bütün SWF: sahne, karakterler, zaman çizelgeleri, dışa aktarılan adlar."""

    def __init__(self, path):
        self.version, self.width, self.height, self.rate, data, pos = load(path)
        self.background = None
        self.shapes = set()
        self.morphs = set()
        self.bitmaps = set()
        self.texts = set()
        self.edit_texts = set()
        self.fonts = set()
        self.sounds = set()
        self.sprites = {}
        self.buttons = {}
        self.exports = {}
        self.root = Timeline()
        self.tag_counts = {}
        self.sprite_tag_counts = {}
        self.text_bodies = {}
        self.edit_text_bodies = {}
        self.font_bodies = {}
        self.csm = {}
        self.sound_bodies = {}
        self.morph_bodies = {}
        self.init_actions = []  # sınıf kodlarının (DoInitAction) sprite kimlikleri, SWF'deki sırayla
        self.shape_bodies = {}
        self.other = []  # sahne bilgisi etiketleri: (kod, gövde)
        for code, body in tags(data, pos):
            self.tag_counts[code] = self.tag_counts.get(code, 0) + 1
            cid = struct.unpack_from("<H", body, 0)[0] if len(body) >= 2 else None
            if code == 9:
                self.background = "#%02X%02X%02X" % tuple(body[:3])
            elif code in SHAPE_TAGS:
                self.shapes.add(cid)
                self.shape_bodies[cid] = (code, body)
            elif code in MORPH_TAGS:
                self.morphs.add(cid)
                self.morph_bodies[cid] = (code, body)
            elif code in BITMAP_TAGS:
                self.bitmaps.add(cid)
            elif code in TEXT_TAGS:
                self.texts.add(cid)
                self.text_bodies[cid] = (code, body)
            elif code == 37:
                self.edit_texts.add(cid)
                self.edit_text_bodies[cid] = body
            elif code in FONT_TAGS:
                self.fonts.add(cid)
                self.font_bodies[cid] = (code, body)
            elif code == 74:
                self.csm[cid] = read_csm(body)
            elif code == 14:
                self.sounds.add(cid)
                self.sound_bodies[cid] = body
            elif code == 59:
                self.init_actions.append(cid)
                self.root.add_tag(code, body)
            elif code == 34:
                bid, records = read_button(body)
                self.buttons[bid] = records
            elif code == 39:
                t = Timeline()
                for c2, b2 in tags(body, 4):
                    self.sprite_tag_counts[c2] = self.sprite_tag_counts.get(c2, 0) + 1
                    t.add_tag(c2, b2)
                self.sprites[cid] = t.finish()
            elif code == 56:
                n = cid
                p = 2
                for _ in range(n):
                    char = struct.unpack_from("<H", body, p)[0]
                    p += 2
                    e = body.index(b"\0", p)
                    self.exports[body[p:e].decode("latin1")] = char
                    p = e + 1
            else:
                if code in (69, 77, 41, 24, 58, 64, 65, 8):
                    self.other.append((code, body))
                self.root.add_tag(code, body)
        self.root.finish()

    def kind(self, cid):
        """Karakterin türü: shape, morph, bitmap, text, edit_text, font, sound, sprite, button ya da None."""
        for name, ids in (("shape", self.shapes), ("morph", self.morphs), ("bitmap", self.bitmaps),
                          ("text", self.texts), ("edit_text", self.edit_texts), ("font", self.fonts),
                          ("sound", self.sounds)):
            if cid in ids:
                return name
        if cid in self.sprites:
            return "sprite"
        if cid in self.buttons:
            return "button"
        return None

    def children(self, cid):
        """Bir karakterin doğrudan kullandığı karakterler."""
        if cid in self.sprites:
            return self.sprites[cid].characters()
        if cid in self.buttons:
            return {r["char"] for r in self.buttons[cid]}
        return set()

    def reachable(self, roots, blocked=frozenset()):
        """Köklerden (karakter kimlikleri) ulaşılan bütün karakterler. `blocked` içindeki karakterlere
        girilmez (kök olarak verilmedikçe): ne kendileri ne de altları sayılır."""
        seen = set()
        stack = list(roots)
        while stack:
            cid = stack.pop()
            if cid in seen:
                continue
            seen.add(cid)
            stack.extend(self.children(cid) - seen - set(blocked))
        return seen


# --- Döküm için ayrıntılar (ses, yazı tipi, yazı, resim) ---------------------------------------

SOUND_FORMATS = {0: "sıkıştırmasız", 1: "ADPCM", 2: "MP3", 3: "sıkıştırmasız", 4: "Nellymoser", 5: "Nellymoser",
                 6: "Nellymoser", 11: "Speex"}
SOUND_RATES = {0: 5512.5, 1: 11025, 2: 22050, 3: 44100}


def read_sound_info(body, p):
    """SOUNDINFO (StartSound, düğme sesleri) → yalnız varsayılandan farklı alanlar: stop (sesi durdur),
    no_multiple (çalıyorsa yeniden başlatma), in / out (44 kHz örnek olarak giriş ve çıkış noktası),
    loops (tekrar sayısı), envelope ([[44 kHz konum, sol düzey, sağ düzey]], düzey 0–32768)."""
    flags = body[p]
    p += 1
    info = {}
    if flags & 0x20:
        info["stop"] = True
    if flags & 0x10:
        info["no_multiple"] = True
    if flags & 0x01:
        info["in"] = struct.unpack_from("<I", body, p)[0]
        p += 4
    if flags & 0x02:
        info["out"] = struct.unpack_from("<I", body, p)[0]
        p += 4
    if flags & 0x04:
        info["loops"] = struct.unpack_from("<H", body, p)[0]
        p += 2
    if flags & 0x08:
        count = body[p]
        p += 1
        info["envelope"] = [list(struct.unpack_from("<IHH", body, p + 8 * i)) for i in range(count)]
    return info


def sound_file_data(body):
    """DefineSound → ses dosyasının baytları. MP3 verisi iki baytlık başlangıç gecikmesiyle (SeekSamples)
    başlar; o alan dosyaya girmez, `read_sound` onu "seek" olarak verir."""
    data = body[7:]
    return data[2:] if body[2] >> 4 == 2 else data


def read_sound(body):
    """DefineSound → {id, format, rate, stereo, samples, seconds, bytes, [seek]}. samples: ses başına örnek
    sayısı; bytes: ses dosyasının boyutu; seek: MP3'te baştan atlanacak örnek sayısı (kodlayıcı gecikmesi)."""
    sid = struct.unpack_from("<H", body, 0)[0]
    f = body[2]
    rate = SOUND_RATES[(f >> 2) & 3]
    samples = struct.unpack_from("<I", body, 3)[0]
    out = {"id": sid, "format": SOUND_FORMATS.get(f >> 4, str(f >> 4)), "rate": rate, "stereo": bool(f & 1),
           "samples": samples, "seconds": samples / rate, "bytes": len(sound_file_data(body))}
    if f >> 4 == 2:
        out["seek"] = struct.unpack_from("<h", body, 7)[0]
    return out


def read_font(body):
    """DefineFont2/3 → (kimlik, ad, kalın, italik, glif kodları)."""
    fid = struct.unpack_from("<H", body, 0)[0]
    flags = body[2]
    nlen = body[4]
    name = body[5:5 + nlen].decode("latin1").rstrip("\0")
    p = 5 + nlen
    count = struct.unpack_from("<H", body, p)[0]
    p += 2
    codes = []
    if count:
        wide_offsets = bool(flags & 0x08)
        table = p
        size = 4 if wide_offsets else 2
        fmt = "<I" if wide_offsets else "<H"
        code_offset = struct.unpack_from(fmt, body, table + count * size)[0]
        q = table + code_offset
        if flags & 0x04:
            codes = list(struct.unpack_from(f"<{count}H", body, q))
        else:
            codes = list(body[q:q + count])
    return fid, name, bool(flags & 1), bool(flags & 2), codes


def read_text(body, rgba):
    """DefineText(2) → (kimlik, [(yazı tipi, satır yazısı glif sırasıyla)]). Glif sıraları yazı
    tipinin kod tablosuyla harfe çevrilir (bkz. decode_text)."""
    tid = struct.unpack_from("<H", body, 0)[0]
    b = Bits(body, 2)
    n = b.ub(5)
    for _ in range(4):
        b.sb(n)
    b.align()
    read_matrix(b)
    glyph_bits = b.u8()
    advance_bits = b.u8()
    lines = []
    font = None
    while True:
        flags = b.u8()
        if flags == 0:
            break
        if flags & 0x08:
            font = b.u16()
        if flags & 0x04:
            for _ in range(4 if rgba else 3):
                b.u8()
        new_line = False
        if flags & 0x01:
            b.s16()
        if flags & 0x02:
            b.s16()
            new_line = True
        if flags & 0x08:
            b.u16()
        count = b.u8()
        glyphs = []
        for _ in range(count):
            glyphs.append(b.ub(glyph_bits))
            b.sb(advance_bits)
        b.align()
        if new_line or not lines:
            lines.append((font, glyphs))
        else:
            lines[-1] = (lines[-1][0], lines[-1][1] + glyphs)
    return tid, lines


def decode_text(lines, fonts):
    """Satırları yazıya çevirir; yazı tipinde kodu olmayan glif '?' olur."""
    out = []
    for font, glyphs in lines:
        codes = fonts.get(font, [])
        out.append("".join(chr(codes[g]) if g < len(codes) else "?" for g in glyphs))
    return "\n".join(out)


def read_edit_text(body):
    """DefineEditText → {id, variable, text, font_height}."""
    tid = struct.unpack_from("<H", body, 0)[0]
    b = Bits(body, 2)
    n = b.ub(5)
    for _ in range(4):
        b.sb(n)
    b.align()
    f1, f2 = b.u8(), b.u8()
    p = b.pos
    out = {"id": tid}
    if f1 & 0x01:
        p += 2
    if f2 & 0x80:
        p = body.index(b"\0", p) + 1
    if f1 & 0x01 or f2 & 0x80:
        out["font_height"] = struct.unpack_from("<H", body, p)[0] / 20
        p += 2
    if f1 & 0x04:
        p += 4
    if f1 & 0x02:
        p += 2
    if f2 & 0x20:
        p += 9
    e = body.index(b"\0", p)
    out["variable"] = body[p:e].decode("latin1")
    p = e + 1
    if f1 & 0x80:
        e = body.index(b"\0", p)
        out["text"] = body[p:e].decode("utf-8", "replace")
    return out


def jpeg_size(data):
    """JPEG verisinden (genişlik, yükseklik); bulunamazsa None."""
    p = 0
    while p + 9 <= len(data):
        if data[p] != 0xFF:
            p += 1
            continue
        marker = data[p + 1]
        if marker in (0xC0, 0xC1, 0xC2):
            h, w = struct.unpack_from(">HH", data, p + 5)
            return w, h
        if marker in (0xD8, 0xD9, 0x01) or 0xD0 <= marker <= 0xD7 or marker == 0xFF:
            p += 2 if marker != 0xFF else 1
            continue
        p += 2 + struct.unpack_from(">H", data, p + 2)[0]
    return None


def read_text_full(body, rgba):
    """DefineText(2) → yerleşimiyle bütün yazı: sınır, matris, kayıtlar (yazı tipi, renk, konum, boy,
    glifler ve aralıkları)."""
    tid = struct.unpack_from("<H", body, 0)[0]
    b = Bits(body, 2)
    n = b.ub(5)
    xmin, xmax, ymin, ymax = (b.sb(n) / 20 for _ in range(4))
    b.align()
    matrix = read_matrix(b)
    glyph_bits = b.u8()
    advance_bits = b.u8()
    records = []
    while True:
        flags = b.u8()
        if flags == 0:
            break
        rec = {}
        if flags & 0x08:
            rec["font"] = b.u16()
        if flags & 0x04:
            rec["color"] = "#" + "".join("%02X" % b.u8() for _ in range(3))
            if rgba:
                rec["alpha"] = round(b.u8() / 255, 4)
        if flags & 0x01:
            rec["x"] = b.s16() / 20
        if flags & 0x02:
            rec["y"] = b.s16() / 20
        if flags & 0x08:
            rec["height"] = b.u16() / 20
        count = b.u8()
        glyphs = []
        for _ in range(count):
            g = b.ub(glyph_bits)
            glyphs.append([g, b.sb(advance_bits) / 20])
        b.align()
        rec["glyphs"] = glyphs
        records.append(rec)
    return {"id": tid, "bounds": [xmin, ymin, xmax, ymax], "matrix": matrix, "records": records}


def read_edit_text_full(body):
    """DefineEditText → bütün özellikleriyle yazı alanı."""
    tid = struct.unpack_from("<H", body, 0)[0]
    b = Bits(body, 2)
    n = b.ub(5)
    xmin, xmax, ymin, ymax = (b.sb(n) / 20 for _ in range(4))
    b.align()
    f1, f2 = b.u8(), b.u8()
    p = b.pos
    out = {"id": tid, "bounds": [xmin, ymin, xmax, ymax]}
    names = [("word_wrap", f1 & 0x40), ("multiline", f1 & 0x20), ("password", f1 & 0x10), ("read_only", f1 & 0x08),
             ("auto_size", f2 & 0x40), ("no_select", f2 & 0x10), ("border", f2 & 0x08), ("was_static", f2 & 0x04),
             ("html", f2 & 0x02), ("use_outlines", f2 & 0x01)]
    out["flags"] = [k for k, on in names if on]
    if f1 & 0x01:
        out["font"] = struct.unpack_from("<H", body, p)[0]
        p += 2
    if f2 & 0x80:
        e = body.index(b"\0", p)
        out["font_class"] = body[p:e].decode("latin1")
        p = e + 1
    if f1 & 0x01 or f2 & 0x80:
        out["font_height"] = struct.unpack_from("<H", body, p)[0] / 20
        p += 2
    if f1 & 0x04:
        out["color"] = "#" + "".join("%02X" % v for v in body[p:p + 3])
        out["alpha"] = round(body[p + 3] / 255, 4)
        p += 4
    if f1 & 0x02:
        out["max_length"] = struct.unpack_from("<H", body, p)[0]
        p += 2
    if f2 & 0x20:
        align, left, right, indent, leading = struct.unpack_from("<BHHHh", body, p)
        out["layout"] = {"align": ["left", "right", "center", "justify"][align] if align < 4 else str(align),
                         "left_margin": left / 20, "right_margin": right / 20, "indent": indent / 20,
                         "leading": leading / 20}
        p += 9
    e = body.index(b"\0", p)
    out["variable"] = body[p:e].decode("latin1")
    p = e + 1
    if f1 & 0x80:
        e = body.index(b"\0", p)
        out["text"] = body[p:e].decode("utf-8", "replace")
    return out


def read_csm(body):
    """CSMTextSettings → yazının kenar yumuşatma ayarı."""
    tid = struct.unpack_from("<H", body, 0)[0]
    flags = body[2]
    thickness, sharpness = struct.unpack_from("<ff", body, 3)
    return {"text": tid, "flash_type": bool(flags >> 6 & 3), "grid_fit": ["none", "pixel", "subpixel"][(flags >> 3) & 3]
            if (flags >> 3) & 3 < 3 else "?", "thickness": round(thickness, 4), "sharpness": round(sharpness, 4)}


# --- Morph şekillerin stilleri ---------------------------------------------------------------------

def _rgba(b):
    return [b.u8(), b.u8(), b.u8(), b.u8()]


def _rect(b):
    b.align()
    n = b.ub(5)
    r = [b.sb(n) / 20 for _ in range(4)]
    b.align()
    return r


def read_morph_fill(b):
    """MORPHFILLSTYLE → {type, start, end}. Düz renk: start/end [r, g, b, a]. Degrade: start/end
    {matrix, stops: [[oran 0–255, [r, g, b, a]]], focal}, spread, interpolation. Resim: bitmap, start/end
    {matrix}. Degrade matrisi twip biriminde değil SVG'deki gibi pikseldir (öteleme / 20)."""
    kind = b.u8()
    if kind == 0x00:
        return {"type": "solid", "start": _rgba(b), "end": _rgba(b)}
    if kind in (0x10, 0x12, 0x13):
        m0, m1 = read_matrix(b), read_matrix(b)
        b.align()
        spread = b.ub(2)
        interp = b.ub(2)
        n = b.ub(4)
        s0, s1 = [], []
        for _ in range(n):
            s0.append([b.u8(), _rgba(b)])
            s1.append([b.u8(), _rgba(b)])
        out = {"type": {0x10: "linear", 0x12: "radial", 0x13: "focal"}[kind], "spread": spread,
               "interpolation": interp, "start": {"matrix": m0, "stops": s0}, "end": {"matrix": m1, "stops": s1}}
        if kind == 0x13:
            out["start"]["focal"] = b.s16() / 256
            out["end"]["focal"] = b.s16() / 256
        return out
    if 0x40 <= kind <= 0x43:
        bid = b.u16()
        return {"type": "bitmap", "bitmap": bid, "start": {"matrix": read_matrix(b)}, "end": {"matrix": read_matrix(b)}}
    raise ValueError(f"bilinmeyen morph dolgu türü: {kind:#x}")


def read_morph_styles(body, code):
    """DefineMorphShape (46) / DefineMorphShape2 (84) → {id, bounds: {start, end}, fills, lines}.
    Çizgi: {start: {width, color}, end: {width, color}}; DefineMorphShape2'de color yerine fill olabilir
    (dolgulu çizgi) ve uç, birleşim, ölçeklenmeme bayrakları vardır."""
    mid = struct.unpack_from("<H", body, 0)[0]
    b = Bits(body, 2)
    bounds = {"start": _rect(b), "end": _rect(b)}
    if code == 84:
        _rect(b)
        _rect(b)
        b.u8()
    b.align()
    b.pos += 4  # bitiş kenarlarının yeri (offset)
    count = b.u8()
    if count == 0xFF:
        count = b.u16()
    fills = [read_morph_fill(b) for _ in range(count)]
    count = b.u8()
    if count == 0xFF:
        count = b.u16()
    lines = []
    for _ in range(count):
        w0, w1 = b.u16() / 20, b.u16() / 20
        line = {"start": {"width": w0}, "end": {"width": w1}}
        if code == 84:
            start_cap, join, has_fill = b.ub(2), b.ub(2), b.ub(1)
            no_h, no_v, hinting = b.ub(1), b.ub(1), b.ub(1)
            b.ub(5)
            no_close, end_cap = b.ub(1), b.ub(2)
            line.update({"start_cap": start_cap, "end_cap": end_cap, "join": join, "no_hscale": bool(no_h),
                         "no_vscale": bool(no_v), "pixel_hinting": bool(hinting), "no_close": bool(no_close)})
            if join == 2:
                line["miter"] = b.u16() / 256
            if has_fill:
                line["fill"] = read_morph_fill(b)
                lines.append(line)
                continue
        line["start"]["color"] = _rgba(b)
        line["end"]["color"] = _rgba(b)
        lines.append(line)
    return {"id": mid, "bounds": bounds, "fills": fills, "lines": lines}


# --- AVM1 bayt kodundaki dizeler ---------------------------------------------------------------------

PUSH_SIZES = {1: 4, 2: 0, 3: 0, 4: 1, 5: 1, 6: 8, 7: 4, 8: 1, 9: 2}


def _cstring(data, p):
    e = data.index(b"\0", p)
    return data[p:e].decode("utf-8", "replace"), e + 1


def action_strings(data, start=0, end=None):
    """Eylem kayıtları dizisindeki bütün dize sabitleri: sabit havuzu, Push, GetURL, GotoLabel, SetTarget,
    işlev ve parametre adları. İşlev gövdeleri, With ve Try blokları kayıt dizisinin içinde sırayla
    durduğu için doğrusal tarama hepsini görür."""
    end = len(data) if end is None else end
    out = []
    p = start
    while p < end:
        code = data[p]
        p += 1
        if code < 0x80:
            continue
        length = struct.unpack_from("<H", data, p)[0]
        q, stop = p + 2, p + 2 + length
        p = stop
        if code == 0x88:  # ConstantPool
            count = struct.unpack_from("<H", data, q)[0]
            q += 2
            for _ in range(count):
                text, q = _cstring(data, q)
                out.append(text)
        elif code == 0x96:  # Push
            while q < stop:
                kind = data[q]
                q += 1
                if kind == 0:
                    text, q = _cstring(data, q)
                    out.append(text)
                else:
                    q += PUSH_SIZES.get(kind, 0)
        elif code == 0x83:  # GetURL
            url, q = _cstring(data, q)
            target, q = _cstring(data, q)
            out += [url, target]
        elif code in (0x8C, 0x8B):  # GotoLabel, SetTarget
            out.append(_cstring(data, q)[0])
        elif code == 0x9B:  # DefineFunction
            name, q = _cstring(data, q)
            out.append(name)
            count = struct.unpack_from("<H", data, q)[0]
            q += 2
            for _ in range(count):
                param, q = _cstring(data, q)
                out.append(param)
        elif code == 0x8E:  # DefineFunction2
            name, q = _cstring(data, q)
            out.append(name)
            count = struct.unpack_from("<H", data, q)[0]
            q += 2 + 1 + 2
            for _ in range(count):
                param, q = _cstring(data, q + 1)
                out.append(param)
        elif code == 0x8F and not data[q] & 0x04:  # Try (yakalanan ad bir dizeyse)
            out.append(_cstring(data, q + 7)[0])
    return out


def clip_action_strings(body, p):
    """PlaceObject2/3'ün klip eylemleri (onClipEvent) içindeki dizeler; p: klip eylemlerinin başı."""
    out = []
    p += 2 + 4  # ayrılmış, bütün olayların bayrakları
    while True:
        flags = struct.unpack_from("<I", body, p)[0]
        if flags == 0:
            return out
        size = struct.unpack_from("<I", body, p + 4)[0]
        start = p + 8
        if body[p + 2] & 0x02:  # tuşa basma olayı: önce tuş kodu
            start += 1
        out += action_strings(body, start, p + 8 + size)
        p += 8 + size


def button_action_strings(body):
    """DefineButton2'nin koşullu eylemleri içindeki dizeler."""
    out = []
    offset = struct.unpack_from("<H", body, 3)[0]
    if offset == 0:
        return out
    p = 3 + offset
    while True:
        size = struct.unpack_from("<H", body, p)[0]
        end = p + size if size else len(body)
        out += action_strings(body, p + 4, end)
        if size == 0:
            return out
        p = end


def movie_strings(path):
    """SWF'deki bütün AVM1 kodunun dize sabitleri (kare kodu, sınıf kodu, düğme ve klip eylemleri)."""
    _, _, _, _, data, pos = load(path)
    out = []

    def walk(d, p):
        for code, body in tags(d, p):
            if code == 12:
                out.extend(action_strings(body))
            elif code == 59:
                out.extend(action_strings(body, 2))
            elif code == 34:
                out.extend(button_action_strings(body))
            elif code in (26, 70):
                at = read_place(body, code).get("_clip_actions_at")
                if at is not None:
                    out.extend(clip_action_strings(body, at))
            elif code == 39:
                walk(body, 4)
    walk(data, pos)
    return out
