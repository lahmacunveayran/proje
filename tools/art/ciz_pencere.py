"""Örnek arayüz penceresi: demircinin dükkânı.

Kurallar docs/SANAT.md "Arayüz": kalın altın pervaz (3 duraklı silindir degrade, içte koyu
çizgi), parşömen zemin (radyal), koyu yeşil panelde koyu kabartmalı yuvalar, yuvaların içinde
parşömen kartlar (üstü rulo kıvrımlı), kartlarda iri simgeler ve parıltı çizgileri, tomar
düğmeler, kırmızı kurdele başlık ve mühür düğme. Yazıları motor çizer (bkz. scenes/demo.ron).

Çalıştır: python3 tools/art/ciz_pencere.py  →  content/art/samples/ui/window.svg
"""
import math
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from cizim import KOK, Cizim, cokgen, daire, egri, elips  # noqa: E402

GEN, YUK = 800, 560
c = Cizim(GEN, YUK, "p")

# Yuvaların yerleri (sol üst köşe) ve boyu; demo.ron'daki yazılar bunlara göre konur
YUVA_W, YUVA_H = 96, 136
YUVALAR = [(76, 116), (188, 116), (300, 116), (76, 268), (188, 268), (300, 268)]


def dikdortgen(x, y, w, h, r=0):
    if r == 0:
        return cokgen([(x, y), (x + w, y), (x + w, y + h), (x, y + h)])
    k = r * 0.45
    return (f"M{x + r} {y} L{x + w - r} {y} C{x + w - k} {y} {x + w} {y + k} {x + w} {y + r} "
            f"L{x + w} {y + h - r} C{x + w} {y + h - k} {x + w - k} {y + h} {x + w - r} {y + h} "
            f"L{x + r} {y + h} C{x + k} {y + h} {x} {y + h - k} {x} {y + h - r} "
            f"L{x} {y + r} C{x} {y + k} {x + k} {y} {x + r} {y} Z")


def yay_bandi(cx, cy, r, w, a0, a1, n=6):
    """Çember yayı biçiminde ince bant (parıltı çizgisi): uçları kesik."""
    dis = [(cx + math.cos(math.radians(a0 + (a1 - a0) * i / n)) * (r + w / 2),
            cy + math.sin(math.radians(a0 + (a1 - a0) * i / n)) * (r + w / 2)) for i in range(n + 1)]
    ic = [(cx + math.cos(math.radians(a1 - (a1 - a0) * i / n)) * (r - w / 2),
           cy + math.sin(math.radians(a1 - (a1 - a0) * i / n)) * (r - w / 2)) for i in range(n + 1)]
    return egri(dis + ic, sivri=(0, n, n + 1, 2 * n + 1))


def pervaz():
    """Kalın altın pervaz: her kenarda silindir degrade (koyu–açık–koyu); içte koyu çizgi."""
    x0, y0, x1, y1, k = 20, 44, 780, 540, 18
    c.sekil(dikdortgen(x0 + 6, y0 + 8, x1 - x0, y1 - y0, 10), "siyah", saydam=0.35)  # düşen gölge
    c.sekil(dikdortgen(x0, y0, x1 - x0, y1 - y0, 10), "altın-derin")
    # Dört kenar: yamuk şeritler, köşelerde 45° birleşir
    kenarlar = [
        ([(x0, y0), (x1, y0), (x1 - k, y0 + k), (x0 + k, y0 + k)], (0, y0, 0, y0 + k)),
        ([(x0 + k, y1 - k), (x1 - k, y1 - k), (x1, y1), (x0, y1)], (0, y1 - k, 0, y1)),
        ([(x0, y0), (x0 + k, y0 + k), (x0 + k, y1 - k), (x0, y1)], (x0, 0, x0 + k, 0)),
        ([(x1 - k, y0 + k), (x1, y0), (x1, y1), (x1 - k, y1 - k)], (x1 - k, 0, x1, 0)),
    ]
    for pts, (ax, ay, bx, by) in kenarlar:
        renk = c.dogrusal(ax, ay, bx, by, [(0, "altın-derin"), (0.45, "altın-çerçeve"), (1, "altın-derin")])
        c.sekil(cokgen(pts), renk)
    # İçteki koyu çizgi
    c.sekil(dikdortgen(x0 + k - 3, y0 + k - 3, x1 - x0 - 2 * k + 6, y1 - y0 - 2 * k + 6), "parşömen-derin")
    # Köşebentler: koyu altın plaka, ortasında topuz
    for cx, cy in [(x0 + 9, y0 + 9), (x1 - 9, y0 + 9), (x0 + 9, y1 - 9), (x1 - 9, y1 - 9)]:
        c.sekil(egri([(cx, cy - 22), (cx + 22, cy), (cx, cy + 22), (cx - 22, cy)], sivri=(0, 1, 2, 3)), "altın-koyu")
        c.sekil(egri([(cx, cy - 22), (cx + 22, cy), (cx, cy), (cx - 22, cy)], sivri=(0, 1, 2, 3)), "altın-gölge")
        c.sekil(daire(cx, cy, 6), "altın")
        c.sekil(daire(cx - 1.5, cy - 1.5, 2.2), "altın-parlama")
    return x0 + k, y0 + k, x1 - k, y1 - k


def zemin(x0, y0, x1, y1):
    c.sekil(dikdortgen(x0, y0, x1 - x0, y1 - y0), c.radyal((x0 + x1) / 2, (y0 + y1) / 2 - 20, 430,
                                                            [(0, "parşömen-açık"), (0.6, "parşömen"), (1, "parşömen-koyu")]))


def panel():
    """Koyu yeşil eşya paneli: ince altın kenarlı."""
    c.sekil(dikdortgen(56, 96, 360, 324, 10), "altın-derin")
    c.sekil(dikdortgen(60, 100, 352, 316, 8), c.radyal(236, 258, 240, [(0, "panel-yeşil-derin"), (1, "panel-yeşil-koyu")]))


def yuva(x, y, secili=False):
    """Koyu, kabartmalı yuva: dış çerçeve dikey silindir degrade; içi koyu yeşil.

    Seçili yuvanın dış çerçevesi altın ışıltıyla parlar."""
    if secili:
        c.sekil(dikdortgen(x - 4, y - 4, YUVA_W + 8, YUVA_H + 8, 8) + " " + dikdortgen(x + 1, y + 1, YUVA_W - 2, YUVA_H - 2, 6),
                "altın-ışıltı", delikli=True)
    c.sekil(dikdortgen(x, y, YUVA_W, YUVA_H, 6), c.dikey(y, y + YUVA_H, "yuva-gri", "yuva-gri", "yuva-siyah"))
    c.sekil(dikdortgen(x + 4, y + 4, YUVA_W - 8, YUVA_H - 8, 4), c.yatay(x, x + YUVA_W, "yuva-siyah", "yuva-siyah", "yuva-gri"))
    c.sekil(dikdortgen(x + 8, y + 8, YUVA_W - 16, YUVA_H - 16, 3),
            c.radyal(x + YUVA_W / 2, y + YUVA_H / 2, 70, [(0, "panel-yeşil-derin"), (1, "panel-yeşil-koyu")]))


def kart(x, y):
    """Parşömen kart: dik, kenarları hafif dalgalı; üstü rulo kıvrımlı, altı rulo gölgeli."""
    w, h = YUVA_W - 28, YUVA_H - 30
    x, y = x + 14, y + 16
    govde = [(x + 2, y + 4), (x + w * 0.5, y + 1, 0.6), (x + w, y + 4), (x + w - 3, y + h * 0.35), (x + w + 1, y + h * 0.7),
             (x + w - 1, y + h), (x + w * 0.5, y + h - 2, 0.6), (x, y + h), (x + 3, y + h * 0.65), (x - 1, y + h * 0.3)]
    c.sekil(egri(govde, sivri=(0, 2, 5, 7)), c.dikey(y, y + h, "parşömen-kart", "parşömen-açık"))
    # Üst rulo: ince koyu bant ve sol uçta kıvrım
    c.sekil(egri([(x + 2, y + 4), (x + w * 0.5, y + 1, 0.6), (x + w, y + 4), (x + w - 1, y + 8), (x + w * 0.5, y + 5, 0.6), (x + 3, y + 8)],
                 sivri=(0, 2, 3, 5)), "parşömen-kenar")
    c.sekil(daire(x + 3, y + 6, 4.5), "parşömen-rulo")
    c.sekil(daire(x + 3.8, y + 5.2, 1.8), "parşömen-kart")
    # Alt rulo gölgesi
    c.sekil(egri([(x, y + h), (x + w * 0.5, y + h - 2, 0.6), (x + w - 1, y + h), (x + w - 2, y + h + 3), (x + w * 0.5, y + h + 1, 0.6), (x + 1, y + h + 3)],
                 sivri=(0, 2, 3, 5)), "parşömen-kenar")
    return x + w / 2, y + h / 2 + 2


def parilti(cx, cy, r0, renk, adim=6, sayi=3):
    """Simgenin çevresinde iç içe halkalar; her halka dört yaya bölünür (parlama hissi).

    Boşluklar halkadan halkaya kayar; böylece çizgiler dışa doğru ışıyormuş gibi durur."""
    for i in range(sayi):
        r = r0 + i * adim
        kay = 45 + (i % 2) * 22
        for a in (0, 90, 180, 270):
            orta = a + kay
            yari = 30 - i * 4
            c.sekil(yay_bandi(cx, cy, r, 2.4, orta - yari, orta + yari), renk)


def iksir(cx, cy):
    """Şifalı iksir: yuvarlak dipli şişe, kırmızı sıvı, mantar tıpa."""
    c.sekil(egri([(cx - 5, cy - 30), (cx + 5, cy - 30), (cx + 6, cy - 12), (cx + 20, cy + 2), (cx + 22, cy + 18), (cx, cy + 32, 0.8),
                  (cx - 22, cy + 18), (cx - 20, cy + 2), (cx - 6, cy - 12)], sivri=(0, 1, 2, 8)), "çelik-lavanta")
    c.sekil(egri([(cx - 19, cy + 4), (cx, cy - 2, 0.5), (cx + 19, cy + 4), (cx + 22, cy + 18), (cx, cy + 32, 0.8), (cx - 22, cy + 18)],
                 sivri=(0, 2)), "kırmızı")
    c.sekil(egri([(cx + 4, cy + 30), (cx + 18, cy + 22), (cx + 22, cy + 10), (cx + 22, cy + 18), (cx, cy + 32, 0.8)], sivri=(0, 2, 4)), "kırmızı-koyu")
    c.sekil(egri([(cx - 16, cy + 8), (cx - 10, cy + 4), (cx - 12, cy + 18), (cx - 17, cy + 16)], sivri=(1, 2)), "beyaz")
    c.sekil(egri([(cx - 6, cy - 40), (cx + 6, cy - 40), (cx + 5, cy - 30), (cx - 5, cy - 30)], sivri=(0, 1, 2, 3)), "deri-açık")
    c.sekil(egri([(cx + 1, cy - 40), (cx + 6, cy - 40), (cx + 5, cy - 30), (cx + 1, cy - 30)], sivri=(0, 1, 2, 3)), "deri")


def gunes(cx, cy):
    """Güneş tılsımı: altın kurs ve sivri ışınlar; çevresinde altın parıltı çizgileri."""
    parilti(cx, cy, 24, "altın-ışıltı")
    isinlar = []
    for i in range(16):
        a = math.radians(i * 22.5 - 90)
        r = 21 if i % 2 == 0 else 15
        isinlar.append((cx + math.cos(a) * r, cy + math.sin(a) * r))
        a2 = math.radians(i * 22.5 - 90 + 11.25)
        isinlar.append((cx + math.cos(a2) * 10, cy + math.sin(a2) * 10))
    c.sekil(egri(isinlar, sivri=range(len(isinlar))), "altın")
    c.sekil(daire(cx, cy, 10), "turuncu")
    c.sekil(daire(cx - 2, cy - 2, 7), "altın-açık")
    c.sekil(daire(cx - 3.5, cy - 3.5, 2.5), "beyaz")


def koc(cx, cy, renk="mavi-açık", golge="mavi-soluk", isik="mavi-açık"):
    """Gök tılsımı: mavi koçboynuzu; çevresinde beyaz parıltı çizgileri."""
    parilti(cx, cy + 3, 24, isik)
    for yon in (-1, 1):
        b = [(cx + yon * 2, cy - 2), (cx + yon * 5, cy - 14), (cx + yon * 14, cy - 18), (cx + yon * 21, cy - 9),
             (cx + yon * 16, cy + 1), (cx + yon * 9, cy - 3), (cx + yon * 13, cy - 8), (cx + yon * 14, cy - 12),
             (cx + yon * 9, cy - 12), (cx + yon * 6, cy + 2)]
        c.sekil(egri(b if yon < 0 else list(reversed(b)), sivri=(0, 5) if yon < 0 else (4, 9)), renk)
    c.sekil(egri([(cx - 3, cy), (cx + 3, cy), (cx + 4, cy + 20), (cx, cy + 25), (cx - 4, cy + 20)], sivri=(0, 1, 3)), renk)
    c.sekil(egri([(cx, cy), (cx + 3, cy), (cx + 4, cy + 20), (cx, cy + 25)], sivri=(0, 1, 3)), golge)


def pala(cx, cy):
    """Pala: çapraz; çelik ikiye bölünmüş, altın balçak."""
    sirt = [(cx - 14, cy + 22), (cx - 2, cy + 2), (cx + 10, cy - 20), (cx + 22, cy - 38)]
    agiz = [(cx + 22, cy - 38), (cx + 18, cy - 14), (cx + 6, cy + 10), (cx - 6, cy + 28)]
    c.sekil(egri(sirt + agiz, sivri=(0, 3, 7)), "çelik-lavanta")
    c.sekil(egri([(cx - 10, cy + 25), (cx + 2, cy + 5), (cx + 14, cy - 18), (cx + 22, cy - 38), (cx + 18, cy - 14), (cx + 6, cy + 10),
                  (cx - 6, cy + 28)], sivri=(0, 3, 6)), "gri")
    c.sekil(egri([(cx - 22, cy + 18), (cx - 4, cy + 30), (cx - 2, cy + 34), (cx - 24, cy + 22)], sivri=(0, 1, 2, 3)), "altın")
    c.sekil(egri([(cx - 13, cy + 28), (cx - 7, cy + 32), (cx - 18, cy + 46), (cx - 24, cy + 42)], sivri=(0, 1, 2, 3)), "kahve-koyu")
    c.sekil(daire(cx - 22, cy + 46, 4), "altın")


def yay(cx, cy):
    """Kısa bozkır yayı: kemik uçlu, koyu ağaç gövde; kiriş ince çizgi değil ince şekil."""
    c.sekil(egri([(cx + 4, cy - 40), (cx - 14, cy - 22), (cx - 18, cy), (cx - 14, cy + 22), (cx + 4, cy + 40), (cx - 6, cy + 22),
                  (cx - 10, cy), (cx - 6, cy - 22)], sivri=(0, 4)), "sap")
    c.sekil(egri([(cx + 4, cy + 40), (cx - 6, cy + 22), (cx - 10, cy), (cx - 6, cy - 22), (cx + 4, cy - 40), (cx - 3, cy - 22),
                  (cx - 6, cy), (cx - 3, cy + 22)], sivri=(0, 4)), "sap-koyu")
    for uy in (-1, 1):
        c.sekil(egri([(cx + 4, cy + uy * 40), (cx + 12, cy + uy * 46), (cx + 8, cy + uy * 36)], sivri=(0, 1, 2)), "badana")
    c.sekil(cokgen([(cx + 3, cy - 38), (cx + 5, cy - 38), (cx + 5, cy + 38), (cx + 3, cy + 38)]), "kahve-siyah")


def kalkan(cx, cy):
    c.sekil(daire(cx, cy, 26), "altın")
    c.sekil(daire(cx, cy, 21), "kırmızı")
    c.sekil(egri([(cx + 15, cy - 12), (cx + 20, cy + 2), (cx + 12, cy + 16), (cx - 4, cy + 20), (cx + 10, cy + 8)], sivri=(0, 3)), "kırmızı-koyu")
    c.sekil(daire(cx, cy, 7), "çelik-parlak")
    c.sekil(egri([(cx, cy - 7), (cx + 7, cy), (cx, cy + 7), (cx + 3, cy)], sivri=(0, 2)), "çelik-gölge")


def ayrac(x0, x1, y):
    """Altın ayraç: iki yana incelen çizgi ve ortada elmas."""
    m = (x0 + x1) / 2
    c.sekil(egri([(x0, y), (m - 10, y - 1.5), (m + 10, y - 1.5), (x1, y), (m + 10, y + 1.5), (m - 10, y + 1.5)], sivri=(0, 3)), "altın-koyu")
    c.sekil(egri([(m, y - 7), (m + 7, y), (m, y + 7), (m - 7, y)], sivri=(0, 1, 2, 3)), "altın")
    c.sekil(egri([(m, y - 7), (m + 7, y), (m, y)], sivri=(0, 1, 2)), "altın-hardal")


def sikke(cx, cy):
    c.sekil(daire(cx, cy, 13), "altın-hardal")
    c.sekil(daire(cx - 1.5, cy - 1.5, 11), "altın")
    c.sekil(egri([(cx - 1.5, cy - 7), (cx + 4, cy - 1.5), (cx - 1.5, cy + 4), (cx - 7, cy - 1.5)], sivri=(0, 1, 2, 3)), "altın-koyu")


def tomar(x, y, w, h):
    """Tomar düğme: yatay parşömen, iki ucu rulo kıvrımlı."""
    c.sekil(egri([(x + 10, y + 4), (x + w / 2, y + 1, 0.6), (x + w - 10, y + 4), (x + w - 12, y + h / 2), (x + w - 10, y + h - 4),
                  (x + w / 2, y + h - 1, 0.6), (x + 10, y + h - 4), (x + 12, y + h / 2)], sivri=(0, 2, 4, 6)),
            c.dikey(y, y + h, "parşömen-açık", "parşömen-kart"))
    for ux, yon in ((x + 10, -1), (x + w - 10, 1)):
        c.sekil(egri([(ux, y), (ux + yon * 9, y + 6), (ux + yon * 10, y + h - 6), (ux, y + h), (ux - yon * 5, y + h / 2)], sivri=(0, 3)),
                c.yatay(ux - 10, ux + 10, "parşömen-kart", "parşömen-koyu"))
        c.sekil(elips(ux + yon * 3, y + 6, 4, 3.5), "parşömen-rulo")


def canta(cx, cy):
    """Mürekkep simgesi: heybe (envanter)."""
    c.sekil(egri([(cx - 12, cy - 6), (cx - 6, cy - 12), (cx + 6, cy - 12), (cx + 12, cy - 6), (cx + 13, cy + 10), (cx, cy + 14, 0.6),
                  (cx - 13, cy + 10)], sivri=(0, 3)), "parşömen-mürekkep")
    c.sekil(egri([(cx - 13, cy - 6), (cx + 13, cy - 6), (cx + 10, cy + 1), (cx - 10, cy + 1)], sivri=(0, 1, 2, 3)), "parşömen-derin")
    c.sekil(daire(cx, cy + 1, 3), "parşömen-kart")


def ok_geri(cx, cy):
    """Mürekkep simgesi: sola dönen ok."""
    c.sekil(egri([(cx - 14, cy), (cx - 2, cy - 11), (cx - 2, cy - 5), (cx + 8, cy - 5, 0.5), (cx + 14, cy + 4), (cx + 10, cy + 12),
                  (cx + 7, cy + 4), (cx - 2, cy + 4), (cx - 2, cy + 11)], sivri=(0, 1, 2, 5, 6, 7, 8)), "parşömen-mürekkep")


def muhur(cx, cy, r):
    """Mühür düğme: dalgalı kenarlı kırmızı mum; ortası açık (yazı motordan)."""
    pts = []
    for i in range(28):
        a = math.radians(i * 360 / 28)
        rr = r * (1.0 if i % 2 == 0 else 0.9)
        pts.append((cx + math.cos(a) * rr, cy + math.sin(a) * rr))
    c.sekil(egri(pts, sivri=range(1, 28, 2)), "düğme-kırmızı-koyu")
    c.sekil(daire(cx, cy, r * 0.78), c.dikey(cy - r, cy + r, "kırmızı-degrade-açık", "kırmızı-degrade-koyu"))
    c.sekil(egri([(cx - r * 0.55, cy - r * 0.35), (cx - r * 0.2, cy - r * 0.62), (cx + r * 0.1, cy - r * 0.66), (cx - r * 0.25, cy - r * 0.5),
                  (cx - r * 0.5, cy - r * 0.2)], sivri=(0, 2)), "düğme-kırmızı-odak")
    # Mumun aşağı akan damlası
    c.sekil(egri([(cx + r * 0.5, cy + r * 0.7), (cx + r * 0.68, cy + r * 0.62), (cx + r * 0.64, cy + r * 1.2), (cx + r * 0.52, cy + r * 1.24)],
                 sivri=(0, 1)), "düğme-kırmızı-koyu")


def kurdele():
    """Başlık kurdelesi: kırmızı ön yüz, çatallı uçlar, kıvrımın arka yüzü koyu."""
    for yon in (-1, 1):
        u = 400 + yon * 230
        uc = [(u - yon * 10, 26), (u + yon * 70, 28), (u + yon * 52, 52), (u + yon * 74, 78), (u - yon * 4, 76)]
        c.sekil(egri(uc if yon < 0 else list(reversed(uc)), sivri=range(5)), "kırmızı-koyu")
        c.sekil(egri([(u - yon * 4, 76), (u - yon * 30, 64), (u - yon * 30, 52), (u - yon * 10, 26)] if yon < 0 else
                     [(u - yon * 10, 26), (u - yon * 30, 52), (u - yon * 30, 64), (u - yon * 4, 76)], sivri=range(4)), "kırmızı-gölge")
    c.sekil(egri([(170, 14), (400, 8, 0.6), (630, 14), (630, 64), (400, 58, 0.6), (170, 64)], sivri=(0, 2, 3, 5)),
            c.dikey(8, 64, "kırmızı-degrade-açık", "kırmızı-degrade-koyu"))
    c.sekil(egri([(176, 20), (400, 14, 0.6), (624, 20), (624, 24), (400, 18, 0.6), (176, 24)], sivri=(0, 2, 3, 5)), "altın-hardal")
    c.sekil(egri([(176, 54), (400, 48, 0.6), (624, 54), (624, 58), (400, 52, 0.6), (176, 58)], sivri=(0, 2, 3, 5)), "altın-hardal")


def ciz():
    x0, y0, x1, y1 = pervaz()
    zemin(x0, y0, x1, y1)
    panel()
    simgeler = [iksir, gunes, koc, pala, yay, kalkan]
    for i, ((x, y), simge) in enumerate(zip(YUVALAR, simgeler)):
        yuva(x, y, secili=(i == 0))
        cx, cy = kart(x, y)
        simge(cx, cy)
    # Bilgi alanı: ayraç ve fiyat sikkesi
    ayrac(440, 740, 172)
    ayrac(440, 740, 392)
    sikke(462, 426)
    # Alt sıra: tomar düğmeler ve mühür
    tomar(56, 446, 170, 54)
    canta(96, 473)
    tomar(244, 446, 170, 54)
    ok_geri(284, 473)
    muhur(676, 466, 46)
    kurdele()
    yol = os.path.join(KOK, "content", "art", "samples", "ui", "window.svg")
    c.kaydet(yol, "Örnek pencere: demirci. tools/art/ciz_pencere.py ile üretildi; elle düzenleme.")
    return yol


if __name__ == "__main__":
    print(ciz())
