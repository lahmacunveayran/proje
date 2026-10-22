"""Çeviri aktarımının birim testleri. swf-oyunlar deposu gerektirmez: girdiler elle kurulur.

Çalıştırma (depo kökünden):  python3 -m unittest discover -s araclar/aktar -p 'test_*.py'
"""
import json
import os
import sys
import tempfile
import unittest

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import aktar  # noqa: E402
import ceviri  # noqa: E402


def write(path, content, binary=False):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "wb" if binary else "w", **({} if binary else {"encoding": "utf-8"})) as f:
        f.write(content)


class Tables(unittest.TestCase):
    def test_entries_drop_only_notes_and_keep_package_paths(self):
        table = {"_aciklama": "not", "_anahtar_adlar": ["Dagger"], "__Packages/Unit.as": [["a", "b"]], "12": "x"}
        self.assertEqual(ceviri.entries(table), {"__Packages/Unit.as": [["a", "b"]], "12": "x"})

    def test_text_parts_follow_the_translation_tool(self):
        # Ayar blokları atlanır; tırnak içindeki ']' bloğu bitirmez; kaçırılmış '\[' metne dahildir
        formatted = '[\nxmin 0\n][\nfont 1\nspacing "]" 3\n]Hold \\[Home\\][\nx 0\ny 440\n]second line'
        self.assertEqual(ceviri.text_parts(formatted), ["Hold \\[Home\\]", "second line"])
        self.assertEqual(ceviri.text_parts("[\nfont 1\n]"), [])
        self.assertEqual(ceviri.block_end('[a "]" b]', 0), 8)

    def test_font_file_prefers_translation_table_then_liberation_by_style(self):
        table = {"_aciklama": "", "45": {"ad": "Arial Kalın", "kaynak": "yazitipleri/LiberationSans-Bold.ttf"},
                 "1038": {"ad": "Book Antiqua Kalın", "kaynak": "araclar/yazitipleri/texgyrepagella-bold.otf"}}
        self.assertEqual(ceviri.font_file(1038, {"name": "Book Antiqua", "bold": True}, table),
                         "araclar/yazitipleri/texgyrepagella-bold.otf")
        self.assertEqual(ceviri.font_file(49, {"name": "_sans", "bold": True, "italic": False}, table),
                         "yazitipleri/LiberationSans-Bold.ttf")
        self.assertEqual(ceviri.font_file(156, {"name": "Times New Roman", "bold": True, "italic": True}, table),
                         "yazitipleri/LiberationSerif-BoldItalic.ttf")
        self.assertEqual(ceviri.font_file(176, {"name": "_serif", "bold": False, "italic": False}, table),
                         "yazitipleri/LiberationSerif-Regular.ttf")
        self.assertIsNone(ceviri.font_file(7, {"name": "Comic Sans", "bold": False, "italic": False}, table))

    def test_check_finds_every_kind_of_mismatch(self):
        tables = {"sabit": {"_aciklama": "", "160": {"parcalar": ["Yerini Koru", "ikinci"]},
                            "161": {"parcalar": ["tek"]}, "999": {"parcalar": ["yok"]}},
                  "kutular": {"46": "ıska", "47": "yok"}, "yazitipleri": {"45": {"kaynak": "x"}, "46": {"kaynak": "y"}},
                  "sekiller": {"2019": {}, "2020": {}}}
        texts = {"texts": {"160": {"records": [{}, {}]}, "161": {"records": [{}, {}]}},
                 "edit_texts": {"46": {}}, "fonts": {"45": {}}}
        lib = {"shapes": {"2019": [0, 0]}}
        with tempfile.TemporaryDirectory() as td:
            write(os.path.join(td, "160.txt"), "[\nfont 1\n]Hold Position[\ny 440\n]second")
            write(os.path.join(td, "161.txt"), "[\nfont 1\n]one[\ny 440\n]two")
            probs = ceviri.check(tables, texts, lib, td)
        self.assertEqual(probs, [
            "sabit yazı 161: çeviride 1 parça, orijinalde 2 parça ve 2 kayıt",
            "sabit yazı 999: oyunda yok",
            "ekran kutusu 47: oyunda yok",
            "yazı tipi 46: oyunda yok",
            "çizilmiş yazı 2020: oyunda şekil olarak yok",
        ])
        # Bilerek dışarıda bırakılan kutunun (ör. sponsor yazısı) çevirisi hata değildir, kullanılmaz
        lib["excluded"] = {"47": "sponsor: reklam yazısı", "999": "sponsor: reklam yazısı"}
        with tempfile.TemporaryDirectory() as td:
            write(os.path.join(td, "160.txt"), "[\nfont 1\n]Hold Position[\ny 440\n]second")
            write(os.path.join(td, "161.txt"), "[\nfont 1\n]one[\ny 440\n]two")
            probs = ceviri.check(tables, texts, lib, td)
        self.assertNotIn("ekran kutusu 47: oyunda yok", probs)
        self.assertNotIn("sabit yazı 999: oyunda yok", probs)
        self.assertEqual(ceviri.unused_entries(tables, lib), {"sabit": ["999"], "kutular": ["47"]})


class Files(unittest.TestCase):
    def fake_root(self, td, tool_body):
        """Çeviri deposunun küçük bir benzeri: tablolar, kod aracı, yazı tipleri."""
        root = os.path.join(td, "swf-oyunlar")
        tables = os.path.join(root, "oyunlar", "feudalism", "ceviri")
        for name, data in (("adlar", {"_aciklama": "", "silahlar": {"Sword": "Kılıç"}, "zirhlar": {}, "birlikler": {}}),
                           ("kod", {"_aciklama": ""}), ("sabit", {"160": {"parcalar": ["Yerini Koru"]}}),
                           ("kutular", {"46": "ıska"}), ("yazitipleri", {}),
                           ("sekiller", {"2019": {"metin": "Öldün..."}})):
            write(os.path.join(tables, f"{name}.json"), json.dumps(data, ensure_ascii=False))
        write(os.path.join(root, "araclar", "kod_cevir.py"), tool_body)
        write(os.path.join(root, "yazitipleri", "LiberationSans-Bold.ttf"), b"ttf", binary=True)
        write(os.path.join(root, "yazitipleri", "OFL-1.1.txt"), "OFL")
        write(os.path.join(root, "araclar", "yazitipleri", "texgyrepagella-bold.otf"), b"otf", binary=True)
        write(os.path.join(root, "araclar", "yazitipleri", "GUST-Font-License.txt"), "GUST")
        return root

    COPY_TOOL = ("import os, shutil, sys\n"
                 "src, tables, out = sys.argv[1:4]\n"
                 "os.makedirs(os.path.join(out, 'frame_1'))\n"
                 "shutil.copyfile(os.path.join(src, 'frame_1', 'DoAction.as'), os.path.join(out, 'frame_1', 'DoAction.as'))\n")

    def test_translate_code_runs_the_tool_and_stops_on_its_error(self):
        with tempfile.TemporaryDirectory() as td:
            root = self.fake_root(td, self.COPY_TOOL)
            code = os.path.join(td, "kod")
            write(os.path.join(code, "frame_1", "DoAction.as"), "stop();")
            out = os.path.join(td, "kod-tr")
            self.assertEqual(ceviri.translate_code(root, code, td, out), ["frame_1/DoAction.as"])
            write(os.path.join(root, "araclar", "kod_cevir.py"),
                  "import sys\nprint('bulunamadı: x', file=sys.stderr)\nsys.exit(1)\n")
            with self.assertRaises(ValueError) as e:
                ceviri.translate_code(root, code, td, out)
            self.assertIn("bulunamadı: x", str(e.exception))

    def test_copy_fonts_brings_each_file_once_with_its_licence(self):
        with tempfile.TemporaryDirectory() as td:
            root = self.fake_root(td, "")
            dst = os.path.join(td, "fonts")
            docs = os.path.join(td, "lisanslar")
            for name in ("LPPL-1.3c.txt", "MANIFEST-TeX-Gyre-Pagella.txt", "README-TeX-Gyre-Pagella.txt"):
                write(os.path.join(docs, name), name)
            copied = ceviri.copy_fonts(root, ["yazitipleri/LiberationSans-Bold.ttf",
                                              "araclar/yazitipleri/texgyrepagella-bold.otf",
                                              "yazitipleri/LiberationSans-Bold.ttf"], dst, docs)
            self.assertEqual(copied, ["texgyrepagella-bold.otf", "LiberationSans-Bold.ttf"])
            self.assertEqual(sorted(os.listdir(dst)), ["GUST-Font-License.txt", "LPPL-1.3c.txt",
                                                       "LiberationSans-Bold.ttf", "MANIFEST-TeX-Gyre-Pagella.txt",
                                                       "OFL-Liberation.txt", "README-TeX-Gyre-Pagella.txt",
                                                       "texgyrepagella-bold.otf"])
            # Aile belgeleri yoksa aktarım durur
            with self.assertRaises(FileNotFoundError):
                ceviri.copy_fonts(root, ["araclar/yazitipleri/texgyrepagella-bold.otf"], dst,
                                  os.path.join(td, "yok"))

    def test_tex_gyre_fonts_come_with_lppl_and_their_family_manifest_and_readme(self):
        # LPPL 1.3c (GUST yazı tipi lisansının temeli) ve ailenin MANIFEST/README dosyaları yazı tipiyle
        # birlikte dağıtılır: hangi dosyaların alındığı ve çalışmanın tamamının nerede olduğu belli olsun
        with tempfile.TemporaryDirectory() as td:
            root = self.fake_root(td, "")
            docs = os.path.join(td, "lisanslar")
            for name in ("LPPL-1.3c.txt", "MANIFEST-TeX-Gyre-Pagella.txt", "README-TeX-Gyre-Pagella.txt",
                         "MANIFEST-TeX-Gyre-Bonum.txt"):
                write(os.path.join(docs, name), name)
            dst = os.path.join(td, "fonts")
            ceviri.copy_fonts(root, ["araclar/yazitipleri/texgyrepagella-bold.otf"], dst, docs)
            self.assertEqual(sorted(os.listdir(dst)), ["GUST-Font-License.txt", "LPPL-1.3c.txt",
                                                       "MANIFEST-TeX-Gyre-Pagella.txt", "README-TeX-Gyre-Pagella.txt",
                                                       "texgyrepagella-bold.otf"])

    def test_import_translation_copies_tables_unchanged_and_converts_drawn_text(self):
        with tempfile.TemporaryDirectory() as td:
            root = self.fake_root(td, self.COPY_TOOL)
            archive, tr_archive = os.path.join(td, "tam"), os.path.join(td, "tr")
            write(os.path.join(archive, "texts", "160.txt"), "[\nfont 1\n]Hold Position")
            write(os.path.join(tr_archive, "shapes", "2019.svg"),
                  '<?xml version="1.0"?>\n<svg xmlns:ffdec="x" ffdec:objectType="shape">'
                  '<g transform="matrix(1.0, 0.0, 0.0, 1.0, 0.5, 0.5)"><path d="M0 0"/></g></svg>')
            out, code = os.path.join(td, "content"), os.path.join(td, "kaynak")
            write(os.path.join(code, "kod", "frame_1", "DoAction.as"), "stop();")
            texts = {"texts": {"160": {"records": [{}]}}, "edit_texts": {"46": {}}, "fonts": {}}
            got = ceviri.import_translation("f1", root, archive, tr_archive, out, code, {"shapes": {"2019": [0, 0]}},
                                            texts, aktar.convert_shape)
            for name in ceviri.TABLES:
                with open(os.path.join(root, "oyunlar", "feudalism", "ceviri", f"{name}.json"), "rb") as a, \
                        open(os.path.join(out, "ceviri", f"{name}.json"), "rb") as b:
                    self.assertEqual(a.read(), b.read(), name)
            with open(os.path.join(out, "ceviri", "sekiller", "2019.svg"), encoding="utf-8") as f:
                svg = f.read()
            self.assertNotIn("ffdec", svg)
            self.assertTrue(os.path.exists(os.path.join(code, "kod-tr", "frame_1", "DoAction.as")))
        self.assertEqual(got["drawn_texts"], {"2019": {"file": "ceviri/sekiller/2019.svg", "origin": [-0.5, -0.5]}})
        self.assertEqual(got["counts"], {"texts": 1, "edit_texts": 1, "code_files": 1, "names": 1, "drawn_texts": 1})
        self.assertEqual(got["tables"]["sabit"], "ceviri/sabit.json")

    def test_import_translation_stops_when_a_table_does_not_fit(self):
        with tempfile.TemporaryDirectory() as td:
            root = self.fake_root(td, self.COPY_TOOL)
            archive = os.path.join(td, "tam")
            write(os.path.join(archive, "texts", "160.txt"), "[\nfont 1\n]one[\ny 440\n]two")
            texts = {"texts": {"160": {"records": [{}, {}]}}, "edit_texts": {"46": {}}, "fonts": {}}
            with self.assertRaises(ValueError) as e:
                ceviri.import_translation("f1", root, archive, td, os.path.join(td, "c"), os.path.join(td, "k"),
                                          {"shapes": {"2019": [0, 0]}}, texts, aktar.convert_shape)
            self.assertIn("sabit yazı 160", str(e.exception))


if __name__ == "__main__":
    unittest.main()
