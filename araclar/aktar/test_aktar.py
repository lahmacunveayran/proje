"""Aktarım aracının birim testleri. SWF dosyası gerektirmez: girdiler elle kurulur.

Çalıştırma (depo kökünden):  python3 -m unittest discover -s araclar/aktar -p 'test_*.py'
"""
import os
import re
import struct
import sys
import tempfile
import types
import unittest

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import aktar  # noqa: E402
import envanter  # noqa: E402
import swf  # noqa: E402
from swfstats import Bits  # noqa: E402


class BitWriter:
    """SWF bit alanlarını yazmak için (testlerde girdi kurmak)."""

    def __init__(self):
        self.bits = []

    def ub(self, n, v):
        self.bits += [(v >> (n - 1 - i)) & 1 for i in range(n)]

    def sb(self, n, v):
        self.ub(n, v & ((1 << n) - 1))

    def bytes(self):
        bits = self.bits + [0] * (-len(self.bits) % 8)
        return bytes(int("".join(map(str, bits[i:i + 8])), 2) for i in range(0, len(bits), 8))


def matrix_bytes(scale=None, rotate=None, tx=0, ty=0):
    w = BitWriter()
    for pair in (scale, rotate):
        if pair is None:
            w.ub(1, 0)
        else:
            w.ub(1, 1)
            w.ub(5, 20)
            for v in pair:
                w.sb(20, round(v * 65536))
    w.ub(5, 16)
    w.sb(16, round(tx * 20))
    w.sb(16, round(ty * 20))
    return w.bytes()


def cxform_bytes(mul, add):
    w = BitWriter()
    w.ub(1, 1)
    w.ub(1, 1)
    w.ub(4, 10)
    for v in mul:
        w.sb(10, round(v * 256))
    for v in add:
        w.sb(10, v)
    return w.bytes()


class Records(unittest.TestCase):
    def test_matrix(self):
        m = swf.read_matrix(Bits(matrix_bytes(scale=(2, 0.5), rotate=(0.25, -0.25), tx=10.5, ty=-3)))
        self.assertEqual(m, [2.0, 0.25, -0.25, 0.5, 10.5, -3.0])

    def test_identity_matrix(self):
        self.assertEqual(swf.read_matrix(Bits(matrix_bytes())), [1.0, 0.0, 0.0, 1.0, 0.0, 0.0])

    def test_cxform(self):
        c = swf.read_cxform(Bits(cxform_bytes([0.5, 1, 1, 0.25], [255, 0, -255, 0])))
        self.assertEqual(c, [[0.5, 1.0, 1.0, 0.25], [1.0, 0.0, -1.0, 0.0]])

    def test_place_object2(self):
        # Bayraklar: karakter, matris, ad, kırpma derinliği
        flags = 0x02 | 0x04 | 0x20 | 0x40
        body = bytes([flags]) + struct.pack("<HH", 7, 42) + matrix_bytes(tx=5, ty=6) + b"arm\0" + struct.pack("<H", 9)
        op = swf.read_place(body, 26)
        self.assertEqual(op, {"depth": 7, "char": 42, "matrix": [1.0, 0.0, 0.0, 1.0, 5.0, 6.0], "name": "arm",
                              "clip": 9})

    def test_place_move_with_ratio_and_cxform(self):
        body = bytes([0x01 | 0x08 | 0x10]) + struct.pack("<H", 3) + cxform_bytes([1, 1, 1, 0.5], [0, 0, 0, 0]) \
            + struct.pack("<H", 65535)
        op = swf.read_place(body, 26)
        self.assertTrue(op["move"])
        self.assertEqual(op["cxform"][0][3], 0.5)
        self.assertEqual(op["ratio"], 1.0)

    def test_place_object3_glow_and_blend(self):
        glow = bytes([1, 2]) + bytes([255, 200, 0, 255]) + struct.pack("<iih", 4 * 65536, 4 * 65536, 512) + bytes([0x80])
        body = bytes([0x02, 0x01 | 0x02]) + struct.pack("<HH", 1, 5) + glow + bytes([3])
        op = swf.read_place(body, 70)
        self.assertEqual(op["char"], 5)
        self.assertEqual(op["filters"][0]["type"], "glow")
        self.assertEqual(op["filters"][0]["blur"], [4.0, 4.0])
        self.assertTrue(op["filters"][0]["inner"])
        self.assertEqual(op["blend"], "multiply")

    def test_timeline_frames_labels_and_remove(self):
        t = swf.Timeline()
        place = bytes([0x02]) + struct.pack("<HH", 1, 10)
        t.add_tag(26, place)
        t.add_tag(43, b"walk\0")
        t.add_tag(1, b"")
        t.add_tag(28, struct.pack("<H", 1))
        t.add_tag(1, b"")
        t.finish()
        self.assertEqual(t.frames, [[{"depth": 1, "char": 10}], [{"remove": 1}]])
        self.assertEqual(t.labels, {"walk": 0})
        self.assertEqual(t.characters(), {10})

    def test_start_sound_keeps_stop_loops_points_and_envelope(self):
        t = swf.Timeline()
        # Yalnız ses kimliği: varsayılan çalma
        t.add_tag(15, struct.pack("<H", 530) + b"\0")
        # Sesi durdur (SyncStop)
        t.add_tag(15, struct.pack("<H", 930) + bytes([0x20]))
        t.add_tag(1, b"")
        # Üst üste çalma yok, giriş/çıkış noktası, 3 tekrar, iki noktalı zarf
        info = bytes([0x10 | 0x08 | 0x04 | 0x02 | 0x01]) + struct.pack("<IIH", 441, 8820, 3) + bytes([2]) \
            + struct.pack("<IHH", 0, 0, 32768) + struct.pack("<IHH", 4410, 32768, 0)
        t.add_tag(15, struct.pack("<H", 531) + info)
        t.add_tag(1, b"")
        t.finish()
        self.assertEqual(t.sounds, {
            0: [{"id": 530}, {"id": 930, "stop": True}],
            1: [{"id": 531, "no_multiple": True, "in": 441, "out": 8820, "loops": 3,
                 "envelope": [[0, 0, 32768], [4410, 32768, 0]]}],
        })

    def test_button_records(self):
        rec = bytes([0x01 | 0x08]) + struct.pack("<HH", 12, 1) + matrix_bytes(tx=2) + cxform_bytes([1, 1, 1, 1], [0] * 4)
        body = struct.pack("<H", 99) + b"\0" + struct.pack("<H", 0) + rec + b"\0"
        bid, records = swf.read_button(body)
        self.assertEqual(bid, 99)
        self.assertEqual(records[0]["states"], [True, False, False, True])
        self.assertEqual(records[0]["char"], 12)
        self.assertEqual(records[0]["matrix"][4], 2.0)


class Details(unittest.TestCase):
    def test_sound(self):
        # MP3 (2), 11 kHz (1), 16 bit, mono; 11025 örnek = 1 saniye
        body = struct.pack("<H", 530) + bytes([(2 << 4) | (1 << 2) | 0b10]) + struct.pack("<I", 11025) + b"x" * 100
        snd = swf.read_sound(body)
        self.assertEqual((snd["id"], snd["format"], snd["rate"], snd["stereo"]), (530, "MP3", 11025, False))
        self.assertAlmostEqual(snd["seconds"], 1.0)
        self.assertEqual(snd["samples"], 11025)

    def test_mp3_sound_keeps_seek_and_counts_only_file_bytes(self):
        # MP3 verisi iki baytlık başlangıç gecikmesiyle (SeekSamples, işaretli) başlar; dosyaya girmez
        body = struct.pack("<H", 530) + bytes([(2 << 4) | (1 << 2) | 0b10]) + struct.pack("<I", 15763) \
            + struct.pack("<h", -12) + b"\xff\xfb" + b"x" * 98
        snd = swf.read_sound(body)
        self.assertEqual(snd["seek"], -12)
        self.assertEqual(snd["bytes"], 100)
        self.assertEqual(swf.sound_file_data(body), b"\xff\xfb" + b"x" * 98)
        # MP3 olmayan seste gecikme alanı yoktur, veri olduğu gibi kalır
        pcm = struct.pack("<H", 7) + bytes([(3 << 4) | (1 << 2) | 0b10]) + struct.pack("<I", 2) + b"abcd"
        self.assertNotIn("seek", swf.read_sound(pcm))
        self.assertEqual(swf.read_sound(pcm)["bytes"], 4)
        self.assertEqual(swf.sound_file_data(pcm), b"abcd")

    def test_font_codes(self):
        # DefineFont3, dar ofsetler, geniş kodlar; iki glif ('A', 'b'), boş glif şekilleri
        name = b"Arial"
        offsets = struct.pack("<HH", 6, 6) + struct.pack("<H", 6)  # 2 glif ofseti + kod tablosu ofseti
        body = struct.pack("<H", 45) + bytes([0x04 | 0x01, 1, len(name)]) + name + struct.pack("<H", 2) + offsets \
            + struct.pack("<HH", ord("A"), ord("b"))
        fid, fname, bold, italic, codes = swf.read_font(body)
        self.assertEqual((fid, fname, bold, italic, codes), (45, "Arial", True, False, [65, 98]))

    def test_text_records_decode(self):
        w = BitWriter()
        w.ub(5, 1)
        for _ in range(4):
            w.sb(1, 0)
        rect = w.bytes()
        glyphs = BitWriter()
        for g in (0, 1):
            glyphs.ub(4, g)
            glyphs.sb(8, 10)
        record = bytes([0x80 | 0x08 | 0x02]) + struct.pack("<Hh", 45, 20) + struct.pack("<H", 240) + bytes([2]) + glyphs.bytes()
        body = struct.pack("<H", 160) + rect + matrix_bytes() + bytes([4, 8]) + record + b"\0"
        tid, lines = swf.read_text(body, False)
        self.assertEqual(tid, 160)
        self.assertEqual(swf.decode_text(lines, {45: [ord("O"), ord("K")]}), "OK")

    def test_edit_text_initial_value(self):
        w = BitWriter()
        w.ub(5, 1)
        for _ in range(4):
            w.sb(1, 0)
        body = struct.pack("<H", 799) + w.bytes() + bytes([0x80 | 0x01, 0]) + struct.pack("<HH", 2, 360) + b"\0" + b"OK\0"
        self.assertEqual(swf.read_edit_text(body), {"id": 799, "font_height": 18.0, "variable": "", "text": "OK"})

    def test_jpeg_size(self):
        jpeg = b"\xff\xd8" + b"\xff\xe0" + struct.pack(">H", 4) + b"ab" + b"\xff\xc0" + struct.pack(">HBHH", 17, 8, 200, 800)
        self.assertEqual(swf.jpeg_size(jpeg), (800, 200))
        self.assertIsNone(swf.jpeg_size(b"\xff\xd8\xff\xd9"))


class Reachability(unittest.TestCase):
    def test_children_and_reachable(self):
        m = swf.Movie.__new__(swf.Movie)
        m.shapes, m.morphs, m.bitmaps, m.texts, m.edit_texts, m.fonts, m.sounds = {1, 2}, set(), set(), set(), set(), set(), set()
        a, b = swf.Timeline(), swf.Timeline()
        a.frames = [[{"depth": 1, "char": 1}, {"depth": 2, "char": 11}]]
        b.frames = [[{"depth": 1, "char": 2}]]
        m.sprites = {10: a, 11: b}
        m.buttons = {}
        self.assertEqual(m.reachable({10}), {10, 11, 1, 2})
        self.assertEqual(m.kind(11), "sprite")
        self.assertIsNone(m.kind(99))


def fake_movie(shapes, sprites, root, exports=None):
    """Elle kurulmuş küçük film: sprites = {kimlik: [karakterler]}, root = [karakterler]."""
    m = swf.Movie.__new__(swf.Movie)
    m.shapes, m.morphs, m.bitmaps, m.texts, m.edit_texts, m.fonts, m.sounds = set(shapes), set(), set(), set(), set(), set(), set()
    m.sprites = {}
    for sid, chars in sprites.items():
        t = swf.Timeline()
        t.frames = [[{"depth": i + 1, "char": c} for i, c in enumerate(chars)]]
        m.sprites[sid] = t
    m.root = swf.Timeline()
    m.root.frames = [[{"depth": 1, "char": c}] for c in root]
    m.buttons = {}
    m.exports = exports or {}
    return m


class Sponsor(unittest.TestCase):
    def test_sponsor_logo_used_by_game_menu_is_still_excluded(self):
        # F1'in yapısı: kök kare 1 sponsorun yükleme ekranı (140 → 58 → logo 54 → şekil 52, 53; 58 genel tıklama
        # alanı 60'ı da kullanır); kök kare 2 oyunun ana menüsü (1494), köşesinde aynı logo 54 ve tıklama alanı 60.
        m = fake_movie(shapes={52, 53, 60}, sprites={140: [58], 58: [54, 60], 54: [52, 53], 1494: [54, 60]},
                       root=[140, 1494])
        old = aktar.EXCLUDED.get("test")
        aktar.EXCLUDED["test"] = {140: "yükleme ekranı (sponsor)", 54: "ArcadeTown logosu (sponsor)"}
        try:
            out = aktar.third_party("test", m)
        finally:
            if old is None:
                del aktar.EXCLUDED["test"]
        # Logo ve yalnız logonun kullandığı şekiller oyunun menüsünde de olsa dışarıda kalır
        self.assertEqual(set(out), {140, 58, 54, 52, 53})
        # Oyunun kendi parçası (menü) ve sponsor dışında da kullanılan tıklama alanı aktarılır
        self.assertNotIn(1494, out)
        self.assertNotIn(60, out)
        self.assertIn("ArcadeTown", out[52])
        self.assertIn("yükleme ekranı", out[58])

    def test_every_excluded_root_is_reported_with_its_own_reason(self):
        m = fake_movie(shapes={1, 2}, sprites={10: [1], 20: [2]}, root=[10, 20])
        aktar.EXCLUDED["test"] = {10: "a", 20: "b"}
        try:
            out = aktar.third_party("test", m)
        finally:
            del aktar.EXCLUDED["test"]
        self.assertEqual(out, {10: "sponsor: a", 1: "sponsor: a", 20: "sponsor: b", 2: "sponsor: b"})


class ThirdPartyCode(unittest.TestCase):
    """Dışarıda bırakılan karakterlere bağlı kod, Adobe mx sınıfları ve reklam/izleme kütüphaneleri
    kaynak/ altına girmez (yalnız yerel arşivde kalır); oyunun kendi kodu girer."""
    TP = {140: "sponsor: yükleme ekranı", 1962: "sponsor: logo", 205: "Macromedia/Adobe arayüz bileşeni",
          300: "MochiAds reklam kütüphanesi"}
    EXPORTS = {"__Packages.mx.core.View": 205, "Button": 205, "__Packages.MochiAd": 300,
               "__Packages.WorldMap": 400, "Human": 547}

    def reason(self, rel, game="f2"):
        return aktar.third_party_code(game, rel, self.TP, self.EXPORTS)

    def test_code_of_excluded_characters_and_classes_is_left_out(self):
        self.assertIn("sponsor", self.reason("DefineSprite_140/frame_1/DoAction.as"))
        self.assertIn("logo", self.reason("frame_115/PlaceObject2_1962_12/CLIPACTIONRECORD on(release).as"))
        self.assertIn("logo", self.reason("DefineSprite_2342/frame_1/PlaceObject2_1962_480/CLIPACTIONRECORD on(release).as"))
        # FFDec, karakterin dışa aktarılan adını klasör adına ekler: PlaceObject2_<karakter>_<ad>_<derinlik>
        self.assertIn("Adobe", self.reason("DefineSprite_190/frame_2/PlaceObject2_205_HScrollBar_1/CLIPACTIONRECORD on(load).as"))
        self.assertIn("Adobe", self.reason("__Packages/mx/core/View.as"))
        self.assertIn("Adobe", self.reason("Button.as"))
        self.assertIn("Mochi", self.reason("__Packages/MochiAd.as"))
        self.assertIn("MochiBot", self.reason("frame_1/DoAction_2.as", "f1"))

    def test_unnamed_class_code_is_matched_to_its_sprite_by_order(self):
        # FFDec, dışa aktarılmamış sprite'ın sınıf kodunu (DoInitAction) kimliksiz yazar: DoInitAction.as,
        # DoInitAction_2.as ... SWF'deki sırayla. F2'de ilki Adobe FocusManager'ın kodu (sprite 71).
        tp = {**self.TP, 71: "Macromedia/Adobe arayüz bileşeni"}
        self.assertIn("Adobe", aktar.third_party_code("f2", "DoInitAction.as", tp, self.EXPORTS, [71, 600]))
        self.assertIsNone(aktar.third_party_code("f2", "DoInitAction_2.as", tp, self.EXPORTS, [71, 600]))

    def test_the_games_own_code_stays(self):
        for rel in ("frame_1/DoAction.as", "__Packages/WorldMap.as", "Human.as",
                    "DefineSprite_547_Human/frame_3/DoAction.as", "DefineButton2_1765/BUTTONCONDACTION on(release).as",
                    "DefineSprite_1494/frame_6/PlaceObject2_1485_337/CLIPACTIONRECORD onClipEvent(keyDown).as"):
            self.assertIsNone(self.reason(rel), rel)

    def test_prune_removes_files_and_empty_folders(self):
        with tempfile.TemporaryDirectory() as d:
            for rel in ("frame_1/DoAction.as", "__Packages/mx/core/View.as", "DefineSprite_140/frame_1/DoAction.as"):
                os.makedirs(os.path.dirname(os.path.join(d, rel)), exist_ok=True)
                with open(os.path.join(d, rel), "w", encoding="utf-8") as f:
                    f.write("x")
            removed = aktar.prune_code(d, lambda rel: self.reason(rel))
            self.assertEqual(sorted(removed), ["DefineSprite_140/frame_1/DoAction.as", "__Packages/mx/core/View.as"])
            self.assertEqual(sorted(os.listdir(d)), ["frame_1"])


class Actions(unittest.TestCase):
    def test_simple_commands(self):
        src = 'stop();\nthis._parent.directHit();\ngotoAndPlay(2);\ngotoAndStop("sword");\nplay();\n'
        self.assertEqual(aktar.parse_actions(src), [{"stop": True}, {"event": "directHit"},
                                                    {"goto": 2, "play": True}, {"goto": "sword", "play": False},
                                                    {"play": True}])

    def test_commands_inside_blocks_are_ignored(self):
        src = "if(play_count > 0)\n{\n   gotoAndPlay(2);\n}\nthis.onRelease = function()\n{\n   stop();\n};\n"
        self.assertEqual(aktar.parse_actions(src), [])

    def test_script_folder_ids(self):
        self.assertEqual(aktar.script_dir_id("DefineSprite_547_Human"), 547)
        self.assertEqual(aktar.script_dir_id("DefineSprite_12"), 12)
        self.assertIsNone(aktar.script_dir_id("frame_3"))

    def test_read_frame_actions(self):
        with tempfile.TemporaryDirectory() as d:
            os.makedirs(os.path.join(d, "frame_40"))
            with open(os.path.join(d, "frame_40", "DoAction.as"), "w", encoding="utf-8") as f:
                f.write("stop();\n")
            self.assertEqual(aktar.read_frame_actions(d), {39: [{"stop": True}]})


class Shapes(unittest.TestCase):
    def test_convert_shape_keeps_paths_and_finds_origin(self):
        svg = ('<?xml version="1.0"?>\n<svg xmlns:ffdec="https://www.free-decompiler.com/flash" ffdec:objectType="shape" '
               'width="10px" height="5px" xmlns="http://www.w3.org/2000/svg">\n  '
               '<g transform="matrix(1.0, 0.0, 0.0, 1.0, 49.55, -3.5)">\n    <path d="M0 0 L1 1" fill="#ff0000"/>\n  </g>\n</svg>')
        text, origin = aktar.convert_shape(svg)
        self.assertEqual(origin, (-49.55, 3.5))
        self.assertNotIn("ffdec", text)
        self.assertNotIn("<?xml", text)
        self.assertIn('<path d="M0 0 L1 1" fill="#ff0000"/>', text)

    def test_hairline_hints_are_kept_as_data_attributes(self):
        svg = ('<svg xmlns:ffdec="x"><g transform="matrix(1.0, 0.0, 0.0, 1.0, 0.0, 0.0)"><path d="M0 0" stroke="#000000" '
               'ffdec:has-small-stroke="true" ffdec:original-stroke-width="0.05"/></g></svg>')
        text = aktar.convert_shape(svg)[0]
        self.assertNotIn("ffdec", text)
        self.assertIn('data-hairline="true"', text)
        self.assertIn('data-original-stroke-width="0.05"', text)

    def test_hairline_paths_are_listed_by_document_order(self):
        svg = ('<svg><path d="M0 0" fill="#000000"/><path d="M0 0" stroke="#000000" data-hairline="true" '
               'data-original-stroke-width="0.05"/><path d="M1 1"/></svg>')
        self.assertEqual(aktar.hairlines(svg), [[1, 0.05]])

    def test_bitmap_filled_shape_is_skipped(self):
        self.assertIsNone(aktar.convert_shape('<svg><pattern><image href="x"/></pattern></svg>'))


class Morphs(unittest.TestCase):
    SVG = ('<svg xmlns="http://www.w3.org/2000/svg"><g><path d="M0 0" fill="url(#g)">'
           '<animate attributeName="d" values="M0 0 L1 1;M0 0 L2 2"/></path></g><defs>'
           '<linearGradient id="g" gradientTransform="matrix(2, 0, 0, 2, 10, 20)">'
           '<animateTransform additive="replace" attributeName="gradientTransform" from="1" to="1" type="scale"/>'
           '<animateTransform additive="sum" attributeName="gradientTransform" from="10 20" to="30 40" type="translate"/>'
           '<animateTransform additive="sum" attributeName="gradientTransform" from="0" to="90" type="rotate"/>'
           '<animateTransform additive="sum" attributeName="gradientTransform" from="2 2" to="1 1" type="scale"/>'
           '<stop offset="0" stop-color="#000000"><animate attributeName="stop-color" values="#000000;#FFFFFF"/></stop>'
           '</linearGradient></defs></svg>')

    def test_start_and_end(self):
        start = aktar.apply_animates(self.SVG, 0)
        end = aktar.apply_animates(self.SVG, 1)
        self.assertNotIn("animate", start + end)
        self.assertIn('d="M0 0 L1 1"', start)
        self.assertIn('d="M0 0 L2 2"', end)
        self.assertIn('gradientTransform="matrix(2, 0, 0, 2, 10, 20)"', start)
        self.assertIn('gradientTransform="matrix(0, 1, -1, 0, 30, 40)"', end)
        self.assertIn('stop-color="#FFFFFF"', end)

    def test_transform_matrix(self):
        self.assertEqual(aktar.transform_matrix("translate", "3 4"), (1.0, 0.0, 0.0, 1.0, 3.0, 4.0))
        self.assertEqual(aktar.transform_matrix("scale", "2"), (2.0, 0.0, 0.0, 2.0, 0.0, 0.0))
        a, b, c, d, e, f = aktar.transform_matrix("skewX", "45")
        self.assertAlmostEqual(c, 1.0)
        with self.assertRaises(ValueError):
            aktar.transform_matrix("wobble", "1")


class MorphStylesFromSwf(unittest.TestCase):
    """Morph uçlarının renkleri ve degrade matrisleri SWF'deki değerlerden yazılır (FFDec'in morph SVG'sindeki
    canlandırma değerlerinden değil): FFDec 180° dönmüş degrade matrisini dönmesiz ayrıştırır ve bitiş
    renklerinin mavi kanalına 1 ekler."""
    # F2 morph 3058'in ilk dolgusu ve çizgisi, FFDec'in yazdığı biçimde (kısaltılmış)
    SVG = ('<svg xmlns="http://www.w3.org/2000/svg"><g transform="matrix(1.0, 0.0, 0.0, 1.0, 280.0, 280.0)">'
           '<path d="M0 0" fill="url(#gradient0)" stroke="none">'
           '<animate attributeName="d" values="M0 0 L1 1;M0 0 L2 2"/></path>'
           '<path d="M0 0" fill="#990000" stroke="none">'
           '<animate attributeName="fill" values="#990000;#990001"/>'
           '<animate attributeName="fill-opacity" values="1.0;1.0"/></path>'
           '<path d="M0 0" fill="none" stroke="#000000" stroke-opacity="0.0" stroke-width="0.0">'
           '<animate attributeName="stroke" values="#000000;#000001"/>'
           '<animate attributeName="stroke-width" values="0.0;0.0"/></path></g><defs>'
           '<linearGradient gradientTransform="matrix(-0.1379, 0.0, 0.0, -0.0883, -167.3, 0.15)" id="gradient0" '
           'x1="-819.2" x2="819.2">'
           '<animateTransform additive="replace" attributeName="gradientTransform" from="1" to="1" type="scale"/>'
           '<animateTransform additive="sum" attributeName="gradientTransform" from="-167.3 0.15" to="-167.3 0.15" '
           'type="translate"/>'
           '<animateTransform additive="sum" attributeName="gradientTransform" from="0.0" to="0.0" type="rotate"/>'
           '<animateTransform additive="sum" attributeName="gradientTransform" from="0.1379 0.0883" to="0.1379 0.0883" '
           'type="scale"/>'
           '<animateTransform additive="sum" attributeName="gradientTransform" from="0.0" to="0.0" type="skewX"/>'
           '<stop offset="0.0" stop-color="#ffcc00" stop-opacity="0.5019608">'
           '<animate attributeName="offset" values="0.0;0.0"/>'
           '<animate attributeName="stop-color" values="#ffcc00;#ffcc01"/>'
           '<animate attributeName="stop-opacity" values="0.5019608;1.0"/></stop>'
           '<stop offset="1.0" stop-color="#feeba3" stop-opacity="0.0">'
           '<animate attributeName="offset" values="1.0;1.0"/>'
           '<animate attributeName="stop-color" values="#feeba3;#feeba4"/>'
           '<animate attributeName="stop-opacity" values="0.0;0.3019608"/></stop>'
           '</linearGradient></defs></svg>')
    M = [-0.137908935546875, 0.0, 0.0, -0.088348388671875, -167.3, 0.15]
    STYLES = {"fills": [
        {"type": "linear", "spread": 0, "interpolation": 0,
         "start": {"matrix": M, "stops": [[0, [255, 204, 0, 128]], [255, [254, 235, 163, 0]]]},
         "end": {"matrix": M, "stops": [[0, [255, 204, 0, 255]], [255, [254, 235, 163, 77]]]}},
        {"type": "solid", "start": [153, 0, 0, 255], "end": [153, 0, 0, 255]}],
        "lines": [{"start": {"width": 0.0, "color": [0, 0, 0, 0]}, "end": {"width": 0.0, "color": [0, 0, 0, 0]}}]}

    def ends(self):
        return aktar.apply_animates(self.SVG, 0, self.STYLES), aktar.apply_animates(self.SVG, 1, self.STYLES)

    def test_gradient_matrix_keeps_its_rotation_at_both_ends(self):
        for svg in self.ends():
            m = re.search(r'gradientTransform="matrix\(([^)]*)\)"', svg).group(1)
            self.assertEqual([float(v) for v in m.split(",")], [round(v, 6) for v in self.M])

    def test_end_colours_are_the_swf_colours(self):
        start, end = self.ends()
        self.assertIn('fill="#990000"', end)
        self.assertNotIn("#990001", end)
        self.assertIn('stroke="#000000"', end)
        self.assertNotIn("#ffcc01", end)
        self.assertNotIn("#feeba4", end)
        self.assertIn('stop-color="#feeba3" stop-opacity="0.3019608"', end)
        self.assertIn('stop-color="#ffcc00" stop-opacity="0.5019608"', start)

    def test_geometry_still_comes_from_the_animation(self):
        start, end = self.ends()
        self.assertIn('d="M0 0 L1 1"', start)
        self.assertIn('d="M0 0 L2 2"', end)

    def test_unmatched_style_is_an_error(self):
        styles = {"fills": self.STYLES["fills"][1:], "lines": self.STYLES["lines"]}
        with self.assertRaises(ValueError):
            aktar.apply_animates(self.SVG, 1, styles)

    def test_same_start_is_told_apart_by_ffdecs_end_values(self):
        # F2 morph 993: başlangıcı aynı iki dolgu, biri yarı saydamlığa (128) biri 26'ya gider. FFDec'in bitiş
        # saydamlığı doğrudur, bitiş renginin mavisi 1 fazladır; aday bunlarla seçilir.
        svg = self.SVG.replace('attributeName="fill-opacity" values="1.0;1.0"',
                               'attributeName="fill-opacity" values="1.0;0.1019608"')
        faded = {"type": "solid", "start": [153, 0, 0, 255], "end": [153, 0, 0, 26]}
        styles = {"fills": self.STYLES["fills"] + [faded], "lines": self.STYLES["lines"]}
        end = aktar.apply_animates(svg, 1, styles)
        self.assertRegex(end, r'fill="#990000"[^>]*fill-opacity="0.1019608"')
        self.assertRegex(aktar.apply_animates(self.SVG, 1, styles), r'fill="#990000"[^>]*fill-opacity="1.0"')

    def test_ambiguous_style_is_an_error(self):
        # Başlangıcı aynı, bitişleri FFDec'in değeriyle ayırt edilemeyecek kadar yakın iki düz dolgu
        other = {"type": "solid", "start": [153, 0, 0, 255], "end": [153, 0, 1, 255]}
        styles = {"fills": self.STYLES["fills"] + [other], "lines": self.STYLES["lines"]}
        with self.assertRaises(ValueError):
            aktar.apply_animates(self.SVG, 1, styles)


class TextRecords(unittest.TestCase):
    def test_decode_records_lines_and_font_carry_over(self):
        records = [{"font": 1, "y": 10, "glyphs": [[0, 5], [1, 5]]}, {"glyphs": [[2, 5]]}, {"y": 30, "glyphs": [[1, 5]]}]
        self.assertEqual(aktar.decode_records(records, {1: [ord("O"), ord("K"), ord("!")]}), "OK!\nK")

    def test_csm(self):
        body = struct.pack("<H", 7) + bytes([(1 << 6) | (1 << 3)]) + struct.pack("<ff", 0.5, -1.0) + b"\0"
        self.assertEqual(swf.read_csm(body), {"text": 7, "flash_type": True, "grid_fit": "pixel", "thickness": 0.5,
                                              "sharpness": -1.0})

    def test_clip_actions_flag(self):
        body = bytes([0x02 | 0x80]) + struct.pack("<HH", 1, 9) + b"\0\0"
        self.assertTrue(swf.read_place(body, 26)["clip_actions"])


class Files(unittest.TestCase):
    def test_find_file_by_id_or_id_and_name(self):
        with tempfile.TemporaryDirectory() as d:
            for name in ("930_slash.wav.mp3", "93.mp3", "530.mp3"):
                open(os.path.join(d, name), "w").close()
            self.assertTrue(aktar.find_file(d, 930, {".mp3"}).endswith("930_slash.wav.mp3"))
            self.assertTrue(aktar.find_file(d, 93, {".mp3"}).endswith("93.mp3"))
            self.assertIsNone(aktar.find_file(d, 5, {".mp3"}))


class Inventory(unittest.TestCase):
    def test_instance_names_collect_names_given_to_each_character(self):
        lib = {"root": {"frames": [[{"depth": 1, "char": 5, "name": "menu"}]]},
               "sprites": {"7": {"frames": [[{"depth": 1, "char": 46, "name": "dmg_txt"}], [{"remove": 1}],
                                            [{"depth": 2, "char": 46, "name": "dmg2_txt"}, {"depth": 3, "char": 8}]]}}}
        self.assertEqual(envanter.instance_names(lib), {5: {"menu"}, 46: {"dmg_txt", "dmg2_txt"}})

    def test_untranslated_reason_sorts_every_kind_of_box(self):
        code = 'hp_txt.text = hero.HP;\ninfo_txt.htmlText= "x";'
        reason = envanter.untranslated_reason
        self.assertEqual(reason({"text": "<p></p>"}, set(), code), "boş")
        self.assertEqual(reason({"text": "2222/2222"}, set(), code), "yalnız sayı ve işaret (oyun doldurur)")
        self.assertEqual(reason({"text": "The game is playable at ArcadeTown"}, set(), code),
                         envanter.SPONSOR_REASON)
        self.assertEqual(reason({"text": "SP cost: 100"}, {"info_txt"}, code),
                         "tasarım örneği; oyun kodla doldurur (Türkçesi kod çevirisinde)")
        self.assertEqual(reason({"text": "Damage: 5", "variable": "dmg"}, set(), code),
                         "tasarım örneği; oyun kodla doldurur (Türkçesi kod çevirisinde)")
        self.assertEqual(reason({"text": "Wanderburg"}, set(), code), "tek kelime: özel ad ya da kodda anahtar (çevrilmez)")
        # Harfleri aralıklı yazılmış ad tek kelimedir
        self.assertEqual(reason({"text": "T i f l i s"}, set(), code), "tek kelime: özel ad ya da kodda anahtar (çevrilmez)")
        self.assertEqual(reason({"text": "v1.041k"}, set(), code), "sürüm numarası (çevrilmez)")
        self.assertEqual(reason({"text": "?"}, set(), code), "yalnız sayı ve işaret (oyun doldurur)")
        # Sponsor ekranındaki her kutu, kendisi sponsor adı geçirmese de sponsor metnidir
        self.assertEqual(reason({"text": "it is absolutely free and the game is the same."}, set(), code, sponsor=True),
                         envanter.SPONSOR_REASON)
        self.assertEqual(reason({"text": "Horseman Twohanded Sword"}, {"other_txt"}, code), "ELLE BAKILMALI")
        # Latin dışı harfler de metindir (F2 kutu 3127, Rusça "bu oyun çalındı"): "yalnız sayı ve işaret" değil
        self.assertEqual(reason({"text": "ЭТУ ИГРУ СПЕРЛИ!!!"}, set(), code), "ELLE BAKILMALI")
        self.assertEqual(reason({"text": "ЭТУ ИГРУ СПЕРЛИ!!!"}, set(), code, sponsor=True), envanter.SPONSOR_REASON)
        # Sponsor ekranının gösterilip gösterilmeyeceği bir varsayım değil, sahibinin kararıdır
        self.assertIn("sahibinin kararı", envanter.SPONSOR_REASON)

    def test_sponsor_sprites_are_those_holding_a_sponsor_text(self):
        # Sprite'ın tamamı bir ekrandır; kök filmde her kare ayrı bir ekrandır
        lib = {"sprites": {"9": {"frames": [[{"depth": 1, "char": 3125}], [{"depth": 2, "char": 3128}]]},
                           "10": {"frames": [[{"depth": 1, "char": 46}]]}},
               "root": {"frames": [[{"depth": 1, "char": 47}], [{"depth": 1, "char": 3130}, {"depth": 2, "char": 3129}]]}}
        edits = {"3125": {"text": "The game is playable at ArcadeTown"}, "3128": {"text": "it is absolutely free"},
                 "46": {"text": "Miss"}, "47": {"text": "Start"}, "3129": {"text": "And the last thing."},
                 "3130": {"text": "http://www.arcadetown.com/"}}
        self.assertEqual(envanter.sponsor_boxes(lib, edits), {3125, 3128, 3129, 3130})

    def test_sound_uses_list_root_and_sprites_and_mark_stops(self):
        movie = types.SimpleNamespace(root=swf.Timeline(), sprites={7: swf.Timeline()})
        movie.root.sounds = {1: [{"id": 930, "stop": True}]}
        movie.sprites[7].labels = {"attack": 2}
        movie.sprites[7].sounds = {0: [{"id": 530}], 3: [{"id": 531}, {"id": 530}]}
        self.assertEqual(envanter.sound_uses(movie, {7: "Unit"}), {
            930: ["kök film / kare 2 (durdurur)"],
            530: ["Unit / kare 1", "Unit / attack / kare 4"],
            531: ["Unit / attack / kare 4"],
        })

    def test_strip_html(self):
        html = '<p align="left"><font face="_sans"><b>Lv. 5</b><sbr />next</font></p>It&apos;s'
        self.assertEqual(envanter.strip_html(html), "Lv. 5\nnext\nIt's")


class Filters(unittest.TestCase):
    def test_component_exports(self):
        for name in ("ScrollThumbTopUp", "Button", "UIObject", "__Packages.mx.core.View", "ComboBox"):
            self.assertTrue(aktar.is_component_export(name), name)
        for name in ("Human", "Tree_1", "WorldMap", "BarracksUnit"):
            self.assertFalse(aktar.is_component_export(name), name)

    def test_clean_op_drops_identity_values(self):
        op = {"depth": 1, "matrix": [1.0, 0.0, 0.0, 1.0, 0.0, 0.0], "cxform": [[1.0] * 4, [0.0] * 4],
              "ratio": 0.123456}
        self.assertEqual(aktar.clean_op(op), {"depth": 1, "ratio": 0.123456})


    def test_clean_op_keeps_identity_on_move(self):
        # D3-1: "taşı" işleminde birim matris ve birim renk dönüşümü "başlangıca dön" demektir; atılırsa
        # oynatıcı nesneyi eski yerinde bırakır. Yeni yerleştirmede ise birim değer yazılmayabilir.
        identity = [1.0, 0.0, 0.0, 1.0, 0.0, 0.0]
        unit = [[1.0] * 4, [0.0] * 4]
        moved = aktar.clean_op({"depth": 3, "move": True, "matrix": identity, "cxform": unit})
        self.assertEqual(moved, {"depth": 3, "move": True, "matrix": identity, "cxform": unit})
        placed = aktar.clean_op({"depth": 3, "char": 5, "matrix": identity, "cxform": unit})
        self.assertEqual(placed, {"depth": 3, "char": 5})

    def test_clean_op_keeps_16_16_values_recoverable(self):
        # 16.16 sabit noktalı ölçek: 6 ondalıkla yazılır; SWF'deki tamsayı geri kurulabilir
        raw = 9038 / 65536
        out = aktar.clean_op({"depth": 1, "matrix": [raw, 0.0, 0.0, raw, 1.0, 2.0],
                              "cxform": [[3 / 256, 1.0, 1.0, 1.0], [0.0, 0.0, 0.0, 0.0]]})
        self.assertEqual(round(out["matrix"][0] * 65536), 9038)
        self.assertAlmostEqual(out["matrix"][0], raw, places=6)
        self.assertEqual(round(out["cxform"][0][0] * 256), 3)


class FilterRecords(unittest.TestCase):
    """Süzgeçler bütün alanlarıyla okunur (geçiş sayısı ve bileşim dahil); uzunlukları doğru sayılır ki
    ardından gelen karışım kipi doğru okunsun."""

    def place3(self, filters):
        return bytes([0x02, 0x01 | 0x02]) + struct.pack("<HH", 1, 5) + bytes([len(filters)]) + b"".join(filters) \
            + bytes([3])

    def test_bevel_is_27_bytes_and_blend_after_it_is_read(self):
        bevel = bytes([3]) + bytes([0, 0, 0, 255]) + bytes([255, 255, 255, 255]) \
            + struct.pack("<iiiih", 2 * 65536, 3 * 65536, 65536, 4 * 65536, 256) + bytes([0x80 | 0x10 | 2])
        self.assertEqual(len(bevel), 1 + 27)
        op = swf.read_place(self.place3([bevel]), 70)
        self.assertEqual(op["blend"], "multiply")
        self.assertEqual(op["filters"], [{"type": "bevel", "shadow": [0, 0, 0, 255], "highlight": [255, 255, 255, 255],
                                          "blur": [2.0, 3.0], "angle": 1.0, "distance": 4.0, "strength": 1.0,
                                          "inner": True, "knockout": False, "composite": False, "on_top": True,
                                          "passes": 2}])

    def test_drop_shadow_glow_and_blur_keep_flags_and_passes(self):
        shadow = bytes([0]) + bytes([1, 2, 3, 4]) + struct.pack("<iiiih", 65536, 65536, 0, 2 * 65536, 512) \
            + bytes([0x40 | 0x20 | 3])
        glow = bytes([2]) + bytes([255, 0, 0, 255]) + struct.pack("<iih", 65536, 65536, 256) + bytes([0x80 | 1])
        blur = bytes([1]) + struct.pack("<ii", 5 * 65536, 6 * 65536) + bytes([2 << 3])
        f = swf.read_place(self.place3([shadow, glow, blur]), 70)["filters"]
        self.assertEqual(f[0], {"type": "drop_shadow", "color": [1, 2, 3, 4], "blur": [1.0, 1.0], "angle": 0.0,
                                "distance": 2.0, "strength": 2.0, "inner": False, "knockout": True,
                                "composite": True, "passes": 3})
        self.assertEqual(f[1], {"type": "glow", "color": [255, 0, 0, 255], "blur": [1.0, 1.0], "strength": 1.0,
                                "inner": True, "knockout": False, "composite": False, "passes": 1})
        self.assertEqual(f[2], {"type": "blur", "blur": [5.0, 6.0], "passes": 2})

    def test_place_object3_visibility_and_background(self):
        body = bytes([0x02, 0x20 | 0x40]) + struct.pack("<HH", 1, 5) + bytes([0]) + bytes([10, 20, 30, 255])
        op = swf.read_place(body, 70)
        self.assertEqual(op["visible"], False)
        self.assertEqual(op["background"], [10, 20, 30, 255])

    def test_duplicate_frame_label_is_an_error(self):
        t = swf.Timeline()
        t.add_tag(43, b"walk\0")
        t.add_tag(1, b"")
        with self.assertRaises(ValueError):
            t.add_tag(43, b"walk\0")


class BitmapFillModes(unittest.TestCase):
    """Resim dolgusunun türü (tekrarlı/kırpılmış, yumuşatmalı/yumuşatmasız) okunur ve desene yazılır;
    FFDec'in SVG'si bu ayrımı yazmaz (her deseni tekrarlar)."""

    def fill(self, kind):
        from swfstats import fillstyle
        return fillstyle(Bits(bytes([kind]) + struct.pack("<H", 7) + matrix_bytes(scale=(20, 20), tx=3, ty=4)), 3)

    def test_fill_style_keeps_clip_and_smoothing(self):
        self.assertEqual({k: self.fill(0x43)[k] for k in ("id", "clip", "smooth")}, {"id": 7, "clip": True, "smooth": False})
        self.assertEqual({k: self.fill(0x40)[k] for k in ("clip", "smooth")}, {"clip": False, "smooth": True})
        self.assertEqual({k: self.fill(0x42)[k] for k in ("clip", "smooth")}, {"clip": False, "smooth": False})

    def test_pattern_ids_carry_the_mode(self):
        svg = ('<svg><pattern id="PatternID_5_1" patternTransform="matrix(1.0, 0.0, 0.0, 1.0, 3.0, 4.0)"></pattern>'
               '<path style="fill:url(#PatternID_5_1)"/></svg>')
        fills = [{"type": "bitmap", "id": 7, "matrix": (20.0, 0.0, 0.0, 20.0, 60, 80), "clip": True, "smooth": False}]
        out = aktar.mark_bitmap_modes(svg, fills)
        self.assertIn('id="PatternID_5_1-kirp"', out)
        self.assertIn("url(#PatternID_5_1-kirp)", out)
        with self.assertRaises(ValueError):
            aktar.mark_bitmap_modes(svg.replace("3.0, 4.0", "9.0, 4.0"), fills)

class PreciseShapeMatrices(unittest.TestCase):
    """D3-2: şekil SVG'lerindeki degrade ve desen matrisleri SWF'deki 16.16 değerlerden 6 ondalıkla yazılır
    (FFDec 4 ondalığa yuvarlar; uzaktan başlayan tekrarlı dokular bu yüzden kayıyordu)."""

    def test_gradient_and_pattern_matrices_get_swf_precision(self):
        a = 9038 / 65536
        svg = ('<svg><linearGradient gradientTransform="matrix(0.1379, 0.0, 0.0, -0.0883, -167.3, 0.15)" id="g"/>'
               '<pattern id="p" patternTransform="matrix(1.0042, 0.0, -0.1525, 0.7624, -8777.15, -812.1)"/></svg>')
        fills = [{"type": "linear", "matrix": (a, 0.0, 0.0, -5790 / 65536, -3346, 3)},
                 {"type": "bitmap", "id": 7, "matrix": (20 * 65811 / 65536, 0.0, 20 * -9993 / 65536, 20 * 49963 / 65536,
                                                         -175543, -16242), "clip": False, "smooth": False}]
        out = aktar.precise_matrices(svg, fills)
        self.assertIn(f'gradientTransform="matrix({round(a, 6)!r}, 0.0, 0.0, {round(-5790 / 65536, 6)!r}, -167.3, 0.15)"', out)
        self.assertIn(f'patternTransform="matrix({round(65811 / 65536, 6)!r}, 0.0, {round(-9993 / 65536, 6)!r}, '
                      f'{round(49963 / 65536, 6)!r}, -8777.15, -812.1)"', out)

    def test_unmatched_matrix_is_an_error(self):
        with self.assertRaises(ValueError):
            aktar.precise_matrices('<svg><radialGradient gradientTransform="matrix(2.0, 0.0, 0.0, 2.0, 0.0, 0.0)"/></svg>', [])

class ActionStrings(unittest.TestCase):
    """AVM1 bayt kodundaki dizeler (kod çevirisinin Türkçe SWF'yle karşılaştırılması için)."""

    def test_constant_pool_push_and_function_names(self):
        pool = struct.pack("<H", 2) + "Kılıç\0".encode() + b"hp\0"
        push = b"\x00" + "Öldün...\0".encode() + b"\x07" + struct.pack("<i", 5) + b"\x08\x01"
        fn = b"heal\0" + struct.pack("<H", 1) + b"amount\0" + struct.pack("<H", 0)
        data = (b"\x88" + struct.pack("<H", len(pool)) + pool + b"\x96" + struct.pack("<H", len(push)) + push
                + b"\x9b" + struct.pack("<H", len(fn)) + fn + b"\x07\x00")
        self.assertEqual(swf.action_strings(data), ["Kılıç", "hp", "Öldün...", "heal", "amount"])

    def test_button_and_clip_actions(self):
        acts = b"\x96" + struct.pack("<H", 5) + b"\x00Yes\0" + b"\x00"
        # Düğme: kimlik, bayrak, eylem kaydırması (kayıtların sonuna), kayıt sonu, bir koşullu eylem (son)
        button = struct.pack("<HBH", 1, 0, 3) + b"\x00" + struct.pack("<HH", 0, 8) + acts
        self.assertEqual(swf.button_action_strings(button), ["Yes"])
        clip = struct.pack("<HI", 0, 1) + struct.pack("<II", 1, len(acts)) + acts + struct.pack("<I", 0)
        place = bytes([0x02 | 0x80]) + struct.pack("<HH", 1, 9) + clip
        op = swf.read_place(place, 26)
        self.assertEqual(swf.clip_action_strings(place, op["_clip_actions_at"]), ["Yes"])
        t = swf.Timeline()
        t.add_tag(26, place)
        self.assertNotIn("_clip_actions_at", t.frames[0][0])

if __name__ == "__main__":
    unittest.main()
