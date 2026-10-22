"""SVG dosyalarındaki bütün renklerin palette olup olmadığını denetler.

Kullanım: python3 tools/art/palet_denetle.py content/art/samples/**/*.svg
Paletin dışında renk varsa hangi dosyada, kaç kez geçtiğini yazar ve 1 ile çıkar.
Aynı denetimi (ve daha fazlasını) `cargo test -p game --test art_rules` da yapar.
"""
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from palet import RENKLER  # noqa: E402

RENK = re.compile(r'(?:fill|stroke|stop-color)="(#[0-9A-Fa-f]{6})"')


def denetle(yol):
    with open(yol, encoding="utf-8") as dosya:
        metin = dosya.read()
    hatalar = {}
    for renk in RENK.findall(metin):
        renk = renk.upper()
        if renk not in RENKLER:
            hatalar[renk] = hatalar.get(renk, 0) + 1
    return hatalar


def main(yollar):
    kotu = 0
    for yol in yollar:
        h = denetle(yol)
        if h:
            kotu += 1
            print(f"{yol}: paletin dışında {len(h)} renk: " + ", ".join(f"{k} ({v})" for k, v in sorted(h.items())))
        else:
            print(f"{yol}: tamam")
    return 1 if kotu else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
