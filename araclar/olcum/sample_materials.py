"""Referans karakterlerde malzeme başına renk ölçümü: ana renk (en sık), en açık ve en koyu uç.

Kutular 800×600 sahne koordinatındadır (birinci oyunun kahraman seçimi, 4× ölçekte alınmış
`shots/f1_hero_4x.png`). Kullanım: python3 araclar/olcum/sample_materials.py <görüntü klasörü>
"""
import json
import sys
from collections import Counter

from PIL import Image

S = sys.argv[1]
im = Image.open(S + "/shots/f1_hero_4x.png").convert("RGB")
sc = im.width / 800

BOXES = {
    "ten (kırmızı kahraman yüzü)": (38, 126, 48, 134),
    "ten (yaşlı kol)": (306, 180, 316, 215),
    "ten (kadın bacak)": (104, 256, 112, 268),
    "saç siyah": (36, 115, 48, 120),
    "saç kızıl (kadın)": (206, 130, 212, 140),
    "saç sarı": (338, 128, 352, 140),
    "saç ak (yaşlı)": (274, 128, 292, 138),
    "sakal turuncu (şövalye)": (154, 128, 170, 135),
    "kumaş kırmızı (kahraman)": (18, 155, 34, 178),
    "kumaş beyaz yen": (14, 163, 28, 170),
    "kumaş beyaz (şövalye)": (142, 150, 188, 182),
    "kumaş yeşil (kadın)": (84, 200, 108, 225),
    "kumaş zeytin (yaşlı üst)": (262, 140, 300, 195),
    "kumaş zeytin koyu (yaşlı şort)": (256, 225, 300, 250),
    "pantolon zeytin açık (kahraman)": (10, 228, 30, 265),
    "pantolon gri (şövalye)": (136, 222, 160, 275),
    "kumaş siyah (ninja)": (376, 160, 410, 225),
    "altın kemer": (26, 200, 38, 204),
    "altın çizme ağzı": (6, 269, 24, 276),
    "çizme kahve": (8, 282, 20, 310),
    "çizme kırmızı": (342, 270, 352, 295),
    "ayakkabı sarı": (246, 294, 262, 302),
    "çorap beyaz": (252, 280, 264, 292),
    "çelik miğfer": (152, 111, 172, 120),
}


def lum(c):
    return 0.2126 * c[0] + 0.7152 * c[1] + 0.0722 * c[2]


def dist(a, b):
    return sum((x - y) ** 2 for x, y in zip(a, b)) ** 0.5


def hexc(c):
    return "#%02X%02X%02X" % tuple(int(round(v)) for v in c)


out = {}
for name, (x0, y0, x1, y1) in BOXES.items():
    px = list(im.crop((int(x0 * sc), int(y0 * sc), int(x1 * sc), int(y1 * sc))).getdata())
    mode = Counter(px).most_common(1)[0][0]
    near = [p for p in px if dist(p, mode) < 95]
    near.sort(key=lum)
    k = max(1, len(near) // 20)
    dark = [sum(p[i] for p in near[:k]) / k for i in range(3)]
    light = [sum(p[i] for p in near[-k:]) / k for i in range(3)]
    out[name] = {"ana": hexc(mode), "açık": hexc(light), "koyu": hexc(dark),
                 "ton_farkı": round((lum(light) - lum(dark)) / 255 * 100)}
    print(f"{name:34s} ana {hexc(mode)}  açık {hexc(light)}  koyu {hexc(dark)}  fark %{out[name]['ton_farkı']}")
json.dump(out, open(S + "/malzeme-renkleri.json", "w"), ensure_ascii=False, indent=1)
