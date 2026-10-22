"""Örnek manzara: bozkır kıyısı, altı katman (gök, uzak, orta, yakın, zemin, ön plan).

Kurallar docs/SANAT.md "Manzara": gök koyu kobalt, 2 duraklı dikey degrade ve büyük güneş
parıltısı; uzaklık soluklaştırarak değil koyu siluetle verilir (orta katman koyu ağaç dizisi);
ağaçlar 3–4 düz yeşil, tümsekli lekeler; ufukta sivri ot saçağı; zeminde az sayıda büyük leke;
kontur yok; yarı saydamlık yalnızca siyah gölge ve beyaz parıltıda.

Çalıştır: python3 tools/art/ciz_manzara.py  →  content/art/samples/landscape/*.svg
"""
import math
import os
import random
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from cizim import KOK, Cizim, cokgen, daire, egri, elips  # noqa: E402

GEN, YUK = 2560, 1080
UFUK = 700  # zemin katmanının üst kenarı (ortalama)
KLASOR = os.path.join(KOK, "content", "art", "samples", "landscape")


def tac(cx, cy, rx, ry, n, girinti=0.18, tohum=0, sivri_tepe=False):
    """Tümsekli leke: kenarı n tümsekten oluşur; tümsekler arası sivri girintidir."""
    rnd = random.Random(tohum)
    pts, sivri = [], []
    for i in range(n * 2):
        a = -math.pi / 2 + i * math.pi / n
        if i % 2 == 0:
            k = 1.0 + rnd.uniform(-0.05, 0.07)
        else:
            k = 1.0 - girinti * rnd.uniform(0.7, 1.2)
            sivri.append(i)
        x = cx + math.cos(a) * rx * k
        y = cy + math.sin(a) * ry * k
        if sivri_tepe and i == 0:
            y = cy - ry * 1.18
            sivri.append(0)
        pts.append((x, y))
    return egri(pts, sivri=sivri, gerginlik=1.25)


def leke(cx, cy, rx, ry, tohum):
    """Yassı, düzensiz zemin lekesi: akıcı kenarlı, iki ucu sivri."""
    rnd = random.Random(tohum)
    pts = []
    n = 10
    for i in range(n):
        a = math.pi * 2 * i / n
        k = rnd.uniform(0.7, 1.15)
        pts.append((cx + math.cos(a) * rx * k, cy + math.sin(a) * ry * k * (0.6 if math.sin(a) < 0 else 1)))
    return egri(pts, sivri=(0, n // 2))


def ot(x, y, gen, boy, egim):
    """Sivri, alev biçimli ot yaprağı."""
    return egri([(x - gen / 2, y), (x - gen * 0.15 + egim * 0.45, y - boy * 0.55), (x + egim, y - boy),
                 (x + gen * 0.25 + egim * 0.4, y - boy * 0.5), (x + gen / 2, y)], sivri=(0, 2, 4))


# --- 1. Gök --------------------------------------------------------------------------------------

def gok():
    c = Cizim(GEN, YUK, "g")
    c.sekil(cokgen([(0, 0), (GEN, 0), (GEN, YUK), (0, YUK)]), c.dikey(0, 720, "gök-tepe", "gök-ufuk"))
    # Güneş parıltısı (beyaz, saydamlığa söner) ve güneş kursu
    gx, gy = 840, 250
    c.sekil(daire(gx, gy, 420), c.radyal(gx, gy, 420, [(0, "beyaz", 0.55), (0.3, "beyaz", 0.18), (1, "beyaz", 0)]))
    c.sekil(daire(gx, gy, 70), "altın-parlama")
    c.sekil(daire(gx - 8, gy - 8, 52), "badana")
    # Uzun, ince, keskin kenarlı bulut şeritleri: iki ton
    for (x, y, g, h) in [(1500, 190, 520, 26), (1680, 232, 300, 16), (180, 330, 420, 20), (2150, 420, 360, 18)]:
        c.sekil(egri([(x, y + h), (x + g * 0.18, y + 2), (x + g * 0.45, y - h * 0.3), (x + g * 0.7, y + 4), (x + g, y + h)],
                     sivri=(0, 4)), "mavi-açık")
        c.sekil(egri([(x + g * 0.12, y + h * 0.55), (x + g * 0.3, y + 1), (x + g * 0.48, y - h * 0.18), (x + g * 0.6, y + h * 0.35)],
                     sivri=(0, 3)), "beyaz")
    return c


# --- 2. Uzak: karlı dağlar ve soluk tepeler ----------------------------------------------------

def uzak():
    c = Cizim(GEN, YUK, "u")
    zirveler = [(-40, 650), (180, 530), (420, 620), (700, 500), (980, 615), (1260, 545), (1540, 625),
                (1820, 510), (2100, 620), (2360, 535), (2600, 640)]
    taban = UFUK - 20
    # Dağ gövdesi (aydınlık) ve gölge yüzleri (her zirvenin sağı)
    pts = [(-40, taban)] + zirveler + [(2600, taban)]
    c.sekil(egri(pts, sivri=list(range(len(pts)))), "mavi-açık")
    for i in range(1, len(zirveler) - 1, 2):
        (x0, y0), (x1, y1), (x2, y2) = zirveler[i - 1], zirveler[i], zirveler[i + 1]
        c.sekil(egri([(x1, y1), (x2, y2), (x2 - 30, taban), (x1 + (x2 - x1) * 0.35, y1 + 110, 0.6)], sivri=(0, 1, 2)), "çelik-gölge")
        # Kar başlığı: dişli alt kenar
        kx = x1 - (x1 - x0) * 0.25
        c.sekil(egri([(x1, y1), (x1 + (x2 - x1) * 0.22, y1 + 48), (x1 + 18, y1 + 36), (x1 + 4, y1 + 58),
                      (x1 - 14, y1 + 38), (kx, y1 + 52)], sivri=(0, 1, 2, 3, 4, 5)), "beyaz")
        c.sekil(egri([(x1, y1), (x1 + (x2 - x1) * 0.22, y1 + 48), (x1 + 18, y1 + 36), (x1 + 4, y1 + 58)],
                     sivri=(0, 1, 2, 3)), "beyaz-gölge")
    # Önde yuvarlak soluk tepeler: iki ton
    tepe = [(-40, 660), (240, 610), (520, 650), (860, 600), (1180, 640), (1500, 595), (1860, 640), (2200, 600),
            (2600, 650), (2600, 760), (-40, 760)]
    c.sekil(egri(tepe, sivri=(0, 8, 9, 10), gerginlik=1.1), "yeşil-soluk")
    for (x, y, g) in [(240, 612, 260), (860, 602, 300), (1500, 597, 280), (2200, 602, 300)]:
        c.sekil(egri([(x - g * 0.45, y + 30), (x - g * 0.2, y + 4), (x + g * 0.1, y + 2), (x - g * 0.05, y + 22)],
                     sivri=(0, 3)), "çimen-soluk")
    return c


# --- 3. Orta: koyu ağaç dizisi ve otağlar -----------------------------------------------------

def kavak(c, x, taban, boy, gen, tohum):
    c.sekil(cokgen([(x - 4, taban), (x + 4, taban), (x + 2, taban - boy * 0.3), (x - 2, taban - boy * 0.3)]), "gövde-koyu")
    cy = taban - boy * 0.58
    c.sekil(tac(x, cy, gen / 2, boy * 0.45, 7, 0.12, tohum, sivri_tepe=True), "yaprak-koyu")
    c.sekil(tac(x - gen * 0.14, cy - boy * 0.06, gen * 0.26, boy * 0.33, 5, 0.15, tohum + 1, sivri_tepe=True), "çam-açık")
    c.sekil(tac(x + gen * 0.18, cy + boy * 0.12, gen * 0.22, boy * 0.28, 5, 0.15, tohum + 2), "yaprak-derin")


def yuvarlak_agac(c, x, taban, r, tohum):
    c.sekil(cokgen([(x - 7, taban), (x + 7, taban), (x + 4, taban - r), (x - 4, taban - r)]), "gövde-koyu")
    cy = taban - r * 1.6
    c.sekil(tac(x, cy, r * 1.1, r * 0.9, 8, 0.16, tohum), "yaprak-koyu")
    c.sekil(tac(x - r * 0.3, cy - r * 0.25, r * 0.55, r * 0.45, 6, 0.18, tohum + 1), "çam-açık")
    c.sekil(tac(x + r * 0.35, cy + r * 0.3, r * 0.55, r * 0.4, 6, 0.18, tohum + 2), "yaprak-derin")


def otag(c, x, taban, gen):
    """Keçe otağ: duvar, kubbe, kırmızı kapı ve kuşak; sağ yan gölgede."""
    h = gen * 0.42
    c.sekil(egri([(x - gen / 2, taban), (x - gen / 2, taban - h), (x + gen / 2, taban - h), (x + gen / 2, taban)],
                 sivri=(0, 1, 2, 3)), "badana")
    c.sekil(egri([(x + gen * 0.18, taban), (x + gen * 0.18, taban - h), (x + gen / 2, taban - h), (x + gen / 2, taban)],
                 sivri=(0, 1, 2, 3)), "badana-sarı")
    c.sekil(egri([(x - gen / 2 - 4, taban - h + 2), (x - gen * 0.3, taban - h - gen * 0.32), (x, taban - h - gen * 0.42),
                  (x + gen * 0.3, taban - h - gen * 0.32), (x + gen / 2 + 4, taban - h + 2)], sivri=(0, 4)), "badana-açık")
    c.sekil(egri([(x + gen * 0.08, taban - h - gen * 0.41), (x + gen * 0.3, taban - h - gen * 0.32), (x + gen / 2 + 4, taban - h + 2),
                  (x + gen * 0.18, taban - h + 2)], sivri=(0, 2, 3)), "badana-sarı")
    c.sekil(egri([(x - gen / 2, taban - h), (x + gen / 2, taban - h), (x + gen / 2, taban - h + 7), (x - gen / 2, taban - h + 7)],
                 sivri=(0, 1, 2, 3)), "kırmızı")
    c.sekil(egri([(x - gen * 0.1, taban), (x - gen * 0.1, taban - h * 0.7), (x + gen * 0.1, taban - h * 0.7), (x + gen * 0.1, taban)],
                 sivri=(0, 1, 2, 3)), "kırmızı-koyu")
    c.sekil(elips(x, taban - h - gen * 0.41, gen * 0.08, 4), "kahve-koyu")


def orta():
    c = Cizim(GEN, YUK, "o")
    taban = UFUK + 10
    # Ağaç kümeleri: aralarında boşluk kalır, arkadaki tepeler görünür
    kumeler = [(-60, 260), (330, 560), (760, 960), (1320, 1560), (1700, 2000), (2240, 2620)]
    rnd = random.Random(11)
    for k, (x0, x1) in enumerate(kumeler):
        # Kümenin arkasındaki koyu kütle
        pts = [(x0 - 20, taban + 30)]
        x = x0
        while x < x1:
            pts.append((x, taban - rnd.uniform(50, 90)))
            x += rnd.uniform(50, 80)
        pts.append((x1 + 20, taban + 30))
        c.sekil(egri(pts, sivri=[0, len(pts) - 1]), "yaprak-derin")
        x = x0 + 20
        while x < x1 - 10:
            if rnd.random() < 0.45:
                kavak(c, x, taban, rnd.uniform(150, 230), rnd.uniform(42, 56), int(x))
                x += rnd.uniform(40, 60)
            else:
                yuvarlak_agac(c, x + 10, taban, rnd.uniform(40, 58), int(x))
                x += rnd.uniform(70, 100)
    # Otağlar: koyu dizinin önünde açık renkli (bozkır kimliği)
    for x, g in [(1040, 96), (1150, 120), (1250, 84)]:
        otag(c, x, taban - 8, g)
    return c


# --- 4. Yakın: kenarlarda iri, parlak taçlı ağaçlar --------------------------------------------

def iri_agac(c, x, taban, olcek, tohum):
    s = olcek
    # Gövde ve dallar: iki ton, sivri uçlu
    govde = [(x - 26 * s, taban), (x - 14 * s, taban - 120 * s), (x - 40 * s, taban - 230 * s), (x - 30 * s, taban - 236 * s),
             (x - 4 * s, taban - 150 * s), (x + 6 * s, taban - 250 * s), (x + 18 * s, taban - 250 * s), (x + 14 * s, taban - 140 * s),
             (x + 46 * s, taban - 210 * s), (x + 54 * s, taban - 204 * s), (x + 18 * s, taban - 100 * s), (x + 26 * s, taban)]
    c.sekil(egri(govde, sivri=(0, 2, 3, 4, 5, 6, 7, 8, 9, 11)), "gövde-gri")
    c.sekil(egri([(x + 4 * s, taban), (x + 10 * s, taban - 130 * s), (x + 14 * s, taban - 140 * s), (x + 18 * s, taban - 100 * s),
                  (x + 26 * s, taban)], sivri=(0, 1, 2, 4)), "gövde-koyu")
    # Taç: 4 düz yeşil, tümsekli lekeler (koyu arka, ana, açık, parlak)
    cy = taban - 300 * s
    c.sekil(tac(x + 20 * s, cy + 20 * s, 210 * s, 150 * s, 11, 0.13, tohum), "yaprak-koyu")
    for i, (dx, dy, rx, ry) in enumerate([(-90, 10, 110, 90), (60, -40, 130, 100), (-10, -90, 120, 80), (110, 60, 100, 70)]):
        c.sekil(tac(x + dx * s, cy + dy * s, rx * s, ry * s, 8, 0.15, tohum + i + 1), "yaprak")
    for i, (dx, dy, rx, ry) in enumerate([(-110, -10, 60, 48), (-30, -110, 70, 44), (40, -70, 56, 40)]):
        c.sekil(tac(x + dx * s, cy + dy * s, rx * s, ry * s, 6, 0.18, tohum + 10 + i), "yaprak-açık")
    for i, (dx, dy, rx, ry) in enumerate([(120, 80, 70, 46), (10, 60, 80, 40), (-120, 70, 50, 34)]):
        c.sekil(tac(x + dx * s, cy + dy * s, rx * s, ry * s, 6, 0.18, tohum + 20 + i), "yaprak-canlı")
    # Ayak altı gölgesi
    c.sekil(elips(x + 30 * s, taban + 4, 160 * s, 22 * s), "siyah", saydam=0.25)


def balbal(c, x, taban):
    """Taş yontu (balbal): iki ton taş, oyma yüz tek gölge şekilleriyle."""
    c.sekil(egri([(x - 26, taban), (x - 28, taban - 90), (x - 18, taban - 120), (x + 18, taban - 122), (x + 28, taban - 92), (x + 26, taban)],
                 sivri=(0, 5)), "gri")
    c.sekil(egri([(x + 8, taban), (x + 10, taban - 100), (x + 18, taban - 122), (x + 28, taban - 92), (x + 26, taban)], sivri=(0, 4)), "gri-koyu")
    c.sekil(egri([(x - 16, taban - 98), (x - 4, taban - 96), (x - 6, taban - 92), (x - 15, taban - 93)], sivri=(0, 1, 2, 3)), "gri-koyu")
    c.sekil(egri([(x + 2, taban - 96), (x + 14, taban - 98), (x + 13, taban - 93), (x + 4, taban - 92)], sivri=(0, 1, 2, 3)), "taş-gri")
    c.sekil(egri([(x - 12, taban - 72), (x + 10, taban - 72), (x + 8, taban - 68), (x - 10, taban - 68)], sivri=(0, 1, 2, 3)), "gri-koyu")
    c.sekil(egri([(x - 20, taban - 50), (x - 6, taban - 44), (x - 14, taban - 30), (x - 22, taban - 36)], sivri=(1, 2)), "gri-koyu")
    c.sekil(elips(x + 6, taban + 2, 44, 8), "siyah", saydam=0.25)


def yakin():
    c = Cizim(GEN, YUK, "y")
    iri_agac(c, 240, UFUK + 40, 1.25, 100)
    iri_agac(c, 2440, UFUK + 50, 1.15, 200)
    iri_agac(c, 2080, UFUK + 20, 0.72, 300)
    balbal(c, 1580, UFUK + 30)
    return c


# --- 5. Zemin: ot saçağı, büyük lekeler, okra yol ---------------------------------------------

def zemin():
    c = Cizim(GEN, YUK, "z")
    ust = [(-40, UFUK), (400, UFUK - 12), (900, UFUK + 6), (1500, UFUK - 10), (2100, UFUK + 4), (2600, UFUK - 8)]
    pts = ust + [(2600, YUK), (-40, YUK)]
    c.sekil(egri(pts, sivri=(0, 5, 6, 7)), c.dikey(UFUK, YUK, "zemin", "zemin-koyu"))
    # Büyük lekeler: üç ton, düz, yassı (uzaktakiler ince)
    for (x, y, rx, ry, renk, s) in [(560, 790, 380, 22, "zemin-açık", 1), (1880, 770, 420, 18, "kara-açık", 2),
                                     (1300, 900, 520, 46, "zemin-açık", 3), (300, 1000, 520, 60, "zemin-derin", 4),
                                     (2250, 960, 460, 56, "zemin-derin", 5), (380, 870, 300, 30, "kara-açık", 6),
                                     (2050, 860, 300, 28, "zemin-açık", 7), (1150, 740, 260, 12, "zemin-koyu", 8)]:
        c.sekil(leke(x, y, rx, ry, s), renk)
    # Yol: sol alttan ufka kıvrılan okra şerit; kenarında koyu bant
    yol_sol = [(560, YUK), (760, 940), (980, 860), (1240, 800), (1520, 760), (1900, 728), (2300, UFUK + 4)]
    yol_sag = [(2300, UFUK + 12), (1920, 742), (1560, 782), (1300, 830), (1080, 900), (900, 990), (820, YUK)]
    c.sekil(egri(yol_sol + yol_sag, sivri=(0, 6, 7, 13)), "toprak")
    kenar = [(2300, UFUK + 12), (1920, 742), (1560, 782), (1300, 830), (1080, 900), (900, 990), (820, YUK),
             (860, YUK), (950, 990), (1120, 908), (1330, 840), (1580, 794), (1930, 752), (2300, UFUK + 16)]
    c.sekil(egri(kenar, sivri=(0, 6, 7, 13)), "toprak-koyu")
    # Ufuk çizgisinde sivri ot saçağı: iki sarımsı yeşil
    rnd = random.Random(3)
    x = -40
    while x < 2600:
        boy = rnd.uniform(26, 56)
        renk = "kuru-ot" if rnd.random() < 0.5 else "zeytin"
        y = UFUK + 6 - 6 * math.sin(x / 300)
        c.sekil(ot(x, y, rnd.uniform(16, 26), boy, rnd.uniform(-14, 14)), renk)
        x += rnd.uniform(10, 18)
    # Küçük kümeler: çalı, çiçek, taş (az sayıda, kümeli)
    for (x, y, t) in [(140, 900, 1), (1180, 1000, 2), (2420, 880, 3)]:
        c.sekil(tac(x, y, 70, 40, 7, 0.2, t), "yaprak-koyu")
        c.sekil(tac(x - 18, y - 12, 40, 22, 5, 0.2, t + 9), "çam-açık")
        for i in range(3):
            c.sekil(daire(x - 30 + i * 26, y - 30 + (i % 2) * 10, 6), "kırmızı" if i != 1 else "altın")
        c.sekil(egri([(x + 60, y + 30), (x + 70, y + 6), (x + 96, y + 2), (x + 106, y + 30)], sivri=(0, 3)), "gri")
        c.sekil(egri([(x + 86, y + 30), (x + 92, y + 4), (x + 96, y + 2), (x + 106, y + 30)], sivri=(0, 3)), "gri-koyu")
    return c


# --- 6. Ön plan: köşelerde koyu ot öbekleri ---------------------------------------------------

def on():
    c = Cizim(GEN, YUK, "n")
    rnd = random.Random(5)
    for (x0, x1, yon) in [(240, 620, 1), (1960, 2400, -1)]:
        x = x0
        while x < x1:
            boy = rnd.uniform(70, 170) * (1.2 - abs((x - (x0 + x1) / 2) / (x1 - x0)))
            renk = rnd.choice(["yaprak-koyu", "çam-koyu", "yaprak-derin"])
            c.sekil(ot(x, YUK + 4, rnd.uniform(22, 36), boy, rnd.uniform(-30, 30) + yon * 10), renk)
            x += rnd.uniform(12, 22)
        cx = x0 if yon > 0 else x1
        c.sekil(tac(cx, YUK - 30, 130, 80, 9, 0.18, int(cx)), "yaprak-derin")
        c.sekil(tac(cx - 30, YUK - 60, 70, 40, 7, 0.2, int(cx) + 1), "yaprak-koyu")
    return c


def ciz():
    yollar = []
    for ad, f in [("1-gok", gok), ("2-uzak", uzak), ("3-orta", orta), ("4-yakin", yakin), ("5-zemin", zemin), ("6-on", on)]:
        yol = os.path.join(KLASOR, f"{ad}.svg")
        f().kaydet(yol, f"Örnek manzara katmanı {ad}. tools/art/ciz_manzara.py ile üretildi; elle düzenleme.")
        yollar.append(yol)
    return yollar


if __name__ == "__main__":
    for y in ciz():
        print(y)
