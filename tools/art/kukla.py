"""Parçalı karakter kuklası: esin kaynağının ölçülen kukla yapısına göre kurulur.

Yapı (docs/KARAKTER_OLCULERI.md): 12 parça, aynı çizim sırası, eklemden ekleme aynı uzunluklar,
aynı enine kesit profilleri, aynı duruş açıları. Parçaların görünüşü (giysi, yüz, silah) bizim
tasarımımızdır. Bütün ölçüler baş yüksekliği (B) cinsindendir; çizimde B = 64 birim.

Parça adları ve yönleri (esin kaynağındaki gibi):
- Her parça kendi ekseninde çizilir; dönme noktası (0, 0) eklemdir, uzuv +y yönünde uzanır.
- Yüz ve ayak ucu −x yönüne bakar (karakter sola bakar; sahnede gerekirse aynalanır).
- `ust_kol_*` omuzdan dirseğe, `on_kol_*` dirsekten parmak ucuna (el dahil), `uyluk_*` kalçadan
  dize, `baldir_*` dizden tabana (çizme dahil). `_on` izleyiciye yakın taraf, `_arka` uzak taraf.
- Silahın dönme noktası tutuş yeridir; ön kol ve el silahın ÜSTÜNE çizilir, parmaklar sapı sarar.
"""
import math
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from cizim import Cizim, daire, egri  # noqa: E402

B = 64.0  # baş yüksekliği (birim)

# Çizim sırası (arkadan öne): esin kaynağının kuklasıyla aynı.
SIRA = ["ust_kol_arka", "on_kol_arka", "silah_arka", "uyluk_arka", "baldir_arka", "uyluk_on", "baldir_on",
        "govde", "bas", "silah_on", "ust_kol_on", "on_kol_on"]

# Duruşlar: her parçanın eklem yeri (kalçaya göre, baş biriminde) ve açısı (derece).
# Esin kaynağının savaş kuklası animasyonlarından ölçüldü (araclar/olcum/durus.py).
DURUSLAR = {
    # Kılıç yukarıda, kalkan arka kolda (esin: "sword" animasyonu, 11. kare)
    "kilic": {
        "ust_kol_arka": (-0.07, -1.44, 40.4), "on_kol_arka": (-1.02, -0.56, 97.1), "silah_arka": (-1.72, -0.36, 1.0),
        "uyluk_arka": (-0.22, -0.04, 43.3), "baldir_arka": (-1.17, 1.09, 12.8), "uyluk_on": (0.0, 0.0, 5.0),
        "baldir_on": (-0.06, 1.42, -32.4), "govde": (0.0, -0.07, 4.0), "bas": (0.25, -1.97, 0.0),
        "silah_on": (-0.87, -3.07, 52.9), "ust_kol_on": (0.43, -1.56, 103.0), "on_kol_on": (-0.71, -1.96, 177.7),
    },
    # Mızrakla ileri hamle, iki elle (esin: "spear" animasyonu, 17. kare)
    "mizrak": {
        "ust_kol_arka": (-0.80, -1.33, 57.7), "on_kol_arka": (-1.96, -0.68, 88.5), "silah_arka": (0.09, -1.31, -98.6),
        "uyluk_arka": (-0.17, 0.07, 57.9), "baldir_arka": (-1.36, 0.90, -2.3), "uyluk_on": (0.0, 0.0, -19.3),
        "baldir_on": (0.57, 1.40, -54.2), "govde": (-0.09, -0.10, -19.3), "bas": (-0.61, -1.88, -16.8),
        "silah_on": (-1.04, -0.40, -85.5), "ust_kol_on": (-0.18, -1.62, -18.6), "on_kol_on": (0.08, -0.48, 89.2),
    },
    # Yay tam gerili: uzak kol yayı tutar, yakın kol kirişi yüze çeker (esin: "bow" animasyonu, 17. kare)
    "yay": {
        "ust_kol_arka": (-0.16, -1.44, 91.2), "on_kol_arka": (-1.50, -1.52, 112.3), "silah_arka": (0.71, -2.05, -158.4),
        "uyluk_arka": (-0.18, 0.15, 27.0), "baldir_arka": (-0.79, 1.47, 19.9), "uyluk_on": (0.0, 0.0, -8.8),
        "baldir_on": (0.29, 1.55, -14.6), "govde": (-0.01, -0.08, 4.1), "bas": (0.25, -1.94, 16.3),
        "silah_on": (-2.64, -1.88, 98.3), "ust_kol_on": (0.44, -1.58, -66.3), "on_kol_on": (1.46, -1.04, 111.8),
    },
}


def K(pts):
    """Baş birimindeki noktaları çizim birimine çevirir (üçüncü öğe teğet ölçeğidir)."""
    return [(p[0] * B, p[1] * B) + tuple(p[2:]) for p in pts]


def Y(pts, sivri=(), kapali=True):
    """Baş biriminde noktalardan yol."""
    return egri(K(pts), sivri=sivri, kapali=kapali)


class Parca:
    """Bir kukla parçası: kendi ekseninde (dönme noktası 0, 0) şekiller."""

    def __init__(self):
        self.sekiller = []  # (yol, renk)

    def ekle(self, yol, renk):
        self.sekiller.append((yol, renk))
        return self


# --- Parçalar ------------------------------------------------------------------------------
# Profiller (sol/sağ kenar, baş biriminde) docs/KARAKTER_OLCULERI.md'deki ölçümlerden.

def bas(k):
    """Baş: yüz −x yönüne bakar; dönme noktası boyun-çene birleşimi."""
    p = Parca()
    ten, ten_g = k["ten"], k["ten-gölge"]
    # Yüz: alın, burun ucu, dudak, köşeli çene (esin profili: −0,55 burun, −0,40 çene)
    yuz = [(-0.36, -0.60), (-0.47, -0.47), (-0.49, -0.36), (-0.51, -0.29), (-0.58, -0.20), (-0.50, -0.165),
           (-0.51, -0.10), (-0.48, -0.065), (-0.50, -0.02), (-0.47, 0.08), (-0.41, 0.19), (-0.16, 0.15), (-0.01, 0.01),
           (0.04, -0.18), (0.10, -0.42), (-0.10, -0.62)]
    p.ekle(Y(yuz, sivri=(4, 10, 11, 12)), ten)
    # Burun altı ve elmacık altı gölgesi: tek düz gölge şekli
    p.ekle(Y([(-0.505, -0.17), (-0.45, -0.205), (-0.44, -0.16), (-0.49, -0.145)], sivri=(0, 1, 3)), ten_g)
    p.ekle(Y([(-0.20, 0.13), (-0.04, -0.02), (-0.02, 0.03), (-0.16, 0.16)], sivri=(0, 1, 2, 3)), ten_g)
    # Kulak
    p.ekle(Y([(0.0, -0.31), (0.08, -0.33), (0.10, -0.22), (0.04, -0.15), (-0.01, -0.18)], sivri=(0, 4)), ten)
    p.ekle(Y([(0.03, -0.28), (0.07, -0.29), (0.07, -0.21), (0.03, -0.19)], sivri=(0, 3)), ten_g)
    # Saç: tepe ve ense tek siyah kütle; favori kulağın önüne iner
    sac = [(-0.44, -0.50), (-0.40, -0.63), (-0.16, -0.72), (0.12, -0.67), (0.27, -0.52), (0.31, -0.32), (0.27, -0.12),
           (0.15, 0.04), (0.08, -0.06), (0.06, -0.30), (-0.03, -0.38), (-0.06, -0.20), (-0.11, -0.22), (-0.12, -0.42),
           (-0.26, -0.49)]
    p.ekle(Y(sac, sivri=(0, 7, 8, 10, 11, 12)), k["saç"])
    # Göz: badem göz akı, öne bakan siyah iris, kalın üst kapak
    p.ekle(Y([(-0.475, -0.333), (-0.41, -0.372), (-0.315, -0.35), (-0.40, -0.307)], sivri=(0, 2)), "beyaz")
    p.ekle(daire(-0.438 * B, -0.338 * B, 0.031 * B), "siyah")
    p.ekle(Y([(-0.49, -0.327), (-0.41, -0.385), (-0.31, -0.36), (-0.31, -0.345), (-0.41, -0.368), (-0.475, -0.322)],
             sivri=(0, 2, 3, 5)), "siyah")
    # Kaş: kalın, buruna doğru iner (kararlı bakış)
    p.ekle(Y([(-0.51, -0.415), (-0.41, -0.465), (-0.28, -0.455), (-0.28, -0.425), (-0.41, -0.43), (-0.50, -0.39)],
             sivri=(0, 2, 3, 5)), k["kaş"])
    # Dudak
    p.ekle(Y([(-0.505, -0.085), (-0.455, -0.095), (-0.45, -0.06), (-0.49, -0.05)], sivri=(0, 1, 2, 3)), "dudak-açık")
    p.ekle(Y([(-0.505, -0.075), (-0.44, -0.08), (-0.44, -0.07), (-0.50, -0.068)], sivri=(0, 1, 2, 3)), "ağız")
    if k.get("sakal"):
        # Kısa, köşeli sakal ve bıyık (imza öğe: beyin sakalı)
        p.ekle(Y([(-0.06, -0.20), (-0.02, 0.02), (-0.16, 0.17), (-0.40, 0.25), (-0.49, 0.10), (-0.50, -0.02),
                  (-0.45, -0.04), (-0.44, 0.07), (-0.37, 0.12), (-0.18, 0.08), (-0.10, -0.06)], sivri=(0, 3, 5, 6)), k["saç"])
    if k.get("bıyık"):
        uzun = k["bıyık"] == "uzun"
        p.ekle(Y([(-0.52, -0.135), (-0.42, -0.15), (-0.36, -0.12), (-0.34, 0.06 if uzun else -0.05),
                  (-0.40, -0.09), (-0.50, -0.10)], sivri=(0, 3, 5)), k["saç"])
    return p


def bork(k):
    """Ak keçe börk: tepe arkaya yatık, kıvrık kenarlı."""
    p = Parca()
    p.ekle(Y([(-0.47, -0.47), (-0.40, -0.70), (-0.18, -0.86), (0.10, -0.98), (0.20, -0.92), (0.24, -0.62), (0.30, -0.40),
              (-0.10, -0.46)], sivri=(0, 3, 6)), "beyaz")
    p.ekle(Y([(0.10, -0.98), (0.20, -0.92), (0.24, -0.62), (0.30, -0.40), (0.06, -0.43), (0.08, -0.70)], sivri=(0, 3, 4)),
           "beyaz-gölge")
    p.ekle(Y([(-0.50, -0.52), (-0.10, -0.50), (0.32, -0.45), (0.33, -0.36), (-0.10, -0.41), (-0.50, -0.44)],
             sivri=(0, 2, 3, 5)), k.get("börk-kenar", "kahve"))
    return p


def migfer(k):
    """Sivri tepeli çelik miğfer: ortadan bölünmüş iki ton, altın kenar, kırmızı püskül."""
    p = Parca()
    p.ekle(Y([(-0.06, -0.94), (0.0, -1.10), (0.12, -1.02), (0.05, -0.92)], sivri=(0, 1, 2, 3)), "kırmızı")
    p.ekle(Y([(-0.49, -0.46), (-0.43, -0.70), (-0.22, -0.87), (-0.04, -0.96), (0.14, -0.84), (0.28, -0.64), (0.33, -0.42)],
             sivri=(0, 3, 6)), "çelik-parlak")
    p.ekle(Y([(-0.04, -0.96), (0.14, -0.84), (0.28, -0.64), (0.33, -0.42), (-0.04, -0.44)], sivri=(0, 3, 4)), "çelik-gölge")
    p.ekle(Y([(-0.51, -0.50), (-0.05, -0.47), (0.35, -0.45), (0.35, -0.37), (-0.05, -0.39), (-0.51, -0.42)],
             sivri=(0, 2, 3, 5)), "altın")
    return p


def kurk_kalpak(k):
    """Kürk kalpak: yuvarlak tepe, kalın kürk kenar."""
    p = Parca()
    p.ekle(Y([(-0.40, -0.50), (-0.36, -0.74), (-0.10, -0.86), (0.16, -0.80), (0.28, -0.56), (0.30, -0.42)], sivri=(0, 5)),
           "kırmızı-koyu")
    p.ekle(Y([(-0.52, -0.56), (-0.44, -0.62), (-0.30, -0.58), (-0.12, -0.63), (0.06, -0.58), (0.24, -0.62), (0.36, -0.52),
              (0.36, -0.36), (0.20, -0.40), (0.04, -0.36), (-0.14, -0.41), (-0.32, -0.37), (-0.50, -0.42)],
             sivri=(0, 2, 4, 6, 7, 9, 11, 12)), "kahve")
    return p


def govde(k):
    """Gövde: kaftan; dönme noktası kalça. Profil: göğüs önde −0,60, bel −0,49…0,22, etek dizin üstüne."""
    p = Parca()
    ana = k["kaftan"]
    # Boyun (ten)
    p.ekle(Y([(-0.16, -2.00), (0.12, -2.02), (0.14, -1.74), (-0.10, -1.70)], sivri=(0, 1)), k["ten"])
    kaftan = [(-0.12, -1.86), (0.14, -1.88), (0.32, -1.76), (0.52, -1.56), (0.46, -1.30), (0.36, -1.02), (0.25, -0.62),
              (0.22, -0.32), (0.36, -0.06), (0.48, 0.30), (0.55, 0.88), (-0.64, 0.92), (-0.55, 0.40), (-0.50, 0.04),
              (-0.49, -0.30), (-0.57, -0.62), (-0.61, -0.98), (-0.56, -1.30), (-0.38, -1.62), (-0.22, -1.78)]
    p.ekle(Y(kaftan, sivri=(0, 1, 3, 10, 11)), ana)
    # Etek ucunda şerit
    p.ekle(Y([(-0.64, 0.92), (-0.62, 0.80), (0.0, 0.79, 0.5), (0.53, 0.77), (0.55, 0.88), (0.0, 0.90, 0.5)],
             sivri=(0, 1, 3, 4)), k["şerit"])
    # Kaftanın önü: boyundan bele inen ve eteğin önünden süren şerit
    p.ekle(Y([(-0.12, -1.86), (-0.04, -1.84), (-0.24, -1.20), (-0.38, -0.60), (-0.41, -0.30), (-0.46, 0.20), (-0.55, 0.80),
              (-0.62, 0.80), (-0.53, 0.20), (-0.49, -0.30), (-0.46, -0.62), (-0.32, -1.22)], sivri=(0, 1, 6, 7)), k["şerit"])
    # Kuşak: belde, önde düğümlü; uçları sarkar
    p.ekle(Y([(-0.52, -0.40), (0.24, -0.36), (0.30, -0.16), (-0.50, -0.16)], sivri=(0, 1, 2, 3)), k["kuşak"])
    p.ekle(Y([(-0.44, -0.20), (-0.30, -0.20), (-0.26, 0.22), (-0.34, 0.16), (-0.42, 0.24)], sivri=(0, 1, 2, 3, 4)), k["kuşak"])
    p.ekle(Y([(-0.46, -0.42), (-0.30, -0.42), (-0.28, -0.14), (-0.46, -0.14)], sivri=(0, 1, 2, 3)), k["kuşak-düğüm"])
    if k.get("yelek"):
        # Deri yelek: göğüs ve sırt, belde biter
        p.ekle(Y([(-0.20, -1.74), (0.12, -1.80), (0.44, -1.50), (0.38, -1.10), (0.26, -0.70), (0.22, -0.40), (-0.47, -0.40),
                  (-0.58, -0.70), (-0.60, -1.00), (-0.54, -1.30), (-0.38, -1.58)], sivri=(0, 1, 5, 6)), k["yelek"])
        p.ekle(Y([(-0.20, -1.74), (-0.10, -1.76), (-0.30, -1.10), (-0.40, -0.40), (-0.47, -0.40), (-0.38, -1.12)],
                 sivri=(0, 1, 3, 4)), k["yelek-kenar"])
    if k.get("sadak"):
        # Sırtta sadak (okluk): omzun arkasından kalçaya çapraz
        p.ekle(Y([(0.18, -1.62), (0.34, -1.70), (0.62, -0.30), (0.46, -0.24)], sivri=(0, 1, 2, 3)), "deri")
        p.ekle(Y([(0.17, -1.66), (0.35, -1.74), (0.37, -1.62), (0.19, -1.55)], sivri=(0, 1, 2, 3)), "altın")
        for i, dx in enumerate((0.20, 0.26, 0.32)):
            p.ekle(Y([(dx - 0.01, -1.66), (dx + 0.02, -1.66), (dx + 0.06, -1.92), (dx - 0.03, -1.86)], sivri=(0, 1, 2, 3)),
                   "kırmızı" if i != 1 else "beyaz")
    return p


def ust_kol(k, arka=False):
    """Üst kol: kolluk + altın yen; dirsekte ten. Profil: en geniş 0,57 (y 0,3–0,45), dirsekte 0,26."""
    p = Parca()
    kol = [(-0.04, -0.20), (-0.25, -0.08), (-0.34, 0.16), (-0.36, 0.42), (-0.31, 0.76), (-0.27, 1.06), (-0.15, 1.32),
           (0.08, 1.31), (0.13, 1.02), (0.17, 0.70), (0.23, 0.42), (0.20, 0.12), (0.12, -0.12)]
    p.ekle(Y(kol, sivri=(6, 7)), k["ten"])
    yen = [(-0.04, -0.20), (-0.25, -0.08), (-0.34, 0.16), (-0.36, 0.42), (-0.33, 0.66), (-0.31, 0.84), (0.16, 0.74),
           (0.20, 0.55), (0.23, 0.42), (0.20, 0.12), (0.12, -0.12)]
    p.ekle(Y(yen, sivri=(5, 6)), k["kaftan"])
    p.ekle(Y([(-0.34, 0.68), (0.18, 0.60), (0.16, 0.74), (-0.31, 0.84)], sivri=(0, 1, 2, 3)), k["şerit"])
    return p


def on_kol(k, arka=False):
    """Ön kol + el: bilek 0,24 (y ≈ 0,77), el 0,31–0,38; el silahı sarar (tutuş ≈ (0,05, 1,13))."""
    p = Parca()
    ten = k["ten"]
    kol = [(-0.02, -0.18), (-0.18, -0.04), (-0.16, 0.25), (-0.10, 0.52), (-0.08, 0.78), (0.17, 0.76), (0.20, 0.48),
           (0.20, 0.20), (0.15, -0.06)]
    p.ekle(Y(kol, sivri=(4, 5)), ten)
    # Yumruk: parmaklar sapı sarar; başparmak üstte
    el = [(-0.08, 0.76), (-0.12, 0.92), (-0.12, 1.16), (-0.06, 1.36), (0.08, 1.43), (0.20, 1.34), (0.22, 1.10),
          (0.18, 0.92), (0.16, 0.76)]
    p.ekle(Y(el, sivri=(0, 8)), ten)
    # Bükülü parmaklar: koyu zemin üstünde dört ayrı boğum (araları ince koyu boşluk)
    p.ekle(Y([(-0.13, 1.00), (0.02, 0.98), (0.04, 1.42), (-0.07, 1.39), (-0.13, 1.20)], sivri=(1, 2)), k["ten-derin"])
    for i, y in enumerate((1.00, 1.105, 1.21, 1.315)):
        yuk = 0.095 if i < 3 else 0.085
        p.ekle(Y([(-0.125, y + 0.012), (-0.06, y), (0.02, y + 0.008), (0.03, y + yuk * 0.5), (0.02, y + yuk - 0.004),
                  (-0.06, y + yuk), (-0.125, y + yuk - 0.012), (-0.135, y + yuk * 0.5)], sivri=()), k["ten"])
        p.ekle(Y([(-0.125, y + yuk * 0.55), (-0.135, y + yuk * 0.5), (-0.125, y + yuk - 0.012), (-0.06, y + yuk),
                  (0.02, y + yuk - 0.004), (-0.02, y + yuk * 0.7)], sivri=(0, 5)), k["ten-gölge"])
    p.ekle(Y([(0.15, 0.86), (0.22, 0.98), (0.18, 1.12), (0.10, 1.08), (0.11, 0.96)], sivri=(0, 3)), ten)
    # Kolçak: deri, iki ton (ön ve kenar)
    p.ekle(Y([(-0.12, 0.44), (0.20, 0.40), (0.19, 0.70), (-0.09, 0.73)], sivri=(0, 1, 2, 3)), k["kolçak"])
    p.ekle(Y([(-0.12, 0.44), (0.20, 0.40), (0.20, 0.46), (-0.12, 0.50)], sivri=(0, 1, 2, 3)), k["kolçak-kenar"])
    return p


def uyluk(k, arka=False):
    """Uyluk: üstte 0,63–0,71, dizde 0,38 (y 1,39)."""
    p = Parca()
    pts = [(-0.10, -0.27), (-0.27, -0.12), (-0.31, 0.10), (-0.32, 0.45), (-0.28, 0.80), (-0.22, 1.10), (-0.15, 1.42),
           (-0.06, 1.55), (0.12, 1.55), (0.23, 1.40), (0.31, 1.08), (0.36, 0.70), (0.38, 0.32), (0.34, 0.02), (0.20, -0.20)]
    p.ekle(Y(pts, sivri=(7, 8)), k["şalvar"])
    return p


def baldir(k, arka=False):
    """Baldır + çizme. Profil (esin): y 0,85'te 0,09…0,42; 1,21'de 0,14…0,50; topuk 1,57'de 0,72'ye
    uzanır; burun 1,75–1,93'te öne (−x) ve aşağı iner. Çizme ağzı y ≈ 0,62."""
    p = Parca()
    sal = [(-0.15, -0.22), (-0.17, 0.02), (-0.10, 0.34), (-0.02, 0.66), (0.44, 0.66), (0.44, 0.40), (0.37, 0.10), (0.24, -0.16)]
    p.ekle(Y(sal, sivri=(3, 4)), k["şalvar"])
    # Konç ince, bilekte daralır; ayak burnu sivri ve hafif kalkık; topuk ayrı basamak
    cizme = [(-0.02, 0.60), (0.06, 0.92), (0.13, 1.24), (0.12, 1.42), (0.05, 1.56), (-0.02, 1.70), (-0.07, 1.80),
             (-0.04, 1.87), (0.14, 1.89), (0.34, 1.80), (0.46, 1.72), (0.58, 1.62), (0.64, 1.50), (0.56, 1.36),
             (0.48, 1.18), (0.43, 0.90), (0.42, 0.60)]
    p.ekle(Y(cizme, sivri=(0, 6, 7, 12, 16)), k["çizme"])
    # Taban: burundan topuğa ince koyu şerit; topuk koyu basamak
    p.ekle(Y([(-0.07, 1.80), (-0.04, 1.87), (0.14, 1.89), (0.34, 1.80), (0.46, 1.72), (0.46, 1.77), (0.35, 1.85),
              (0.15, 1.94), (-0.06, 1.92)], sivri=(0, 4, 5, 8)), "kahve-siyah")
    p.ekle(Y([(0.46, 1.72), (0.58, 1.62), (0.64, 1.50), (0.67, 1.56), (0.62, 1.70), (0.48, 1.78)], sivri=(0, 2, 3, 5)),
           "kahve-siyah")
    # Çizme ağzı şeridi
    p.ekle(Y([(-0.04, 0.56), (0.44, 0.56), (0.43, 0.68), (-0.01, 0.70)], sivri=(0, 1, 2, 3)), k["çizme-ağzı"])
    return p


# --- Silahlar (dönme noktası tutuş yeri; uç −y yönünde) -------------------------------------

def pala(k):
    """Pala: ağız 2,0 baş, uca doğru hafif eğri; çelik ortadan bölünmüş iki ton; altın balçak."""
    p = Parca()
    sirt = [(0.07, -0.22), (0.10, -0.80), (0.06, -1.40), (-0.06, -1.95), (-0.22, -2.24)]
    agiz = [(-0.22, -2.24), (-0.16, -1.92), (-0.08, -1.40), (-0.06, -0.80), (-0.09, -0.22)]
    p.ekle(Y(sirt + agiz[1:], sivri=(0, 4, 8)), "çelik-parlak")
    orta = [(-0.01, -0.22), (0.02, -0.80), (-0.01, -1.40), (-0.11, -1.94), (-0.22, -2.24)]
    p.ekle(Y(orta + agiz[1:], sivri=(0, 4, 8)), "çelik-gölge")
    p.ekle(Y([(-0.26, -0.20), (0.24, -0.28), (0.26, -0.18), (-0.24, -0.11)], sivri=(0, 1, 2, 3)), "altın")
    p.ekle(Y([(-0.06, -0.16), (0.06, -0.17), (0.07, 0.24), (-0.06, 0.25)], sivri=(0, 1, 2, 3)), "kahve-koyu")
    p.ekle(daire(0.0, 0.30 * B, 0.075 * B), "altın")
    return p


def kalkan(k):
    """Yuvarlak kalkan (çap 2,4 baş): çelik kenar, boyalı yüz, altın damga ve göbek; düz renk."""
    p = Parca()
    p.ekle(daire(0, 0, 1.20 * B), "çelik-gölge")
    p.ekle(daire(0, 0, 1.08 * B), k["kalkan"])
    # Koçboynuzu damgası
    for yon in (-1, 1):
        b = [(yon * 0.06, -0.12), (yon * 0.16, -0.46), (yon * 0.46, -0.52), (yon * 0.62, -0.28), (yon * 0.48, -0.02),
             (yon * 0.30, -0.12), (yon * 0.40, -0.24), (yon * 0.42, -0.34), (yon * 0.28, -0.34), (yon * 0.18, -0.06)]
        if yon > 0:
            b = list(reversed(b))
        p.ekle(Y(b, sivri=(0, 5) if yon < 0 else (4, 9)), "altın")
    p.ekle(daire(0, 0, 0.22 * B), "altın-hardal")
    p.ekle(daire(-0.04 * B, -0.04 * B, 0.15 * B), "altın")
    return p


def mizrak(k):
    """Mızrak (esin ölçüsü): sap 9 baş, eni 0,14; tutuş üst uçtan 0,66'da. Uç 1,3 baş boyunda, en geniş
    yeri (0,6) dibine yakın; ortadan bölünmüş iki ton. Ucun altında kırmızı püskül (bizim)."""
    p = Parca()
    p.ekle(Y([(-0.07, -4.80), (0.07, -4.80), (0.07, 3.04), (-0.07, 3.04)], sivri=(0, 1, 2, 3)), "sap")
    p.ekle(Y([(0.0, -4.80), (0.07, -4.80), (0.07, 3.04), (0.0, 3.04)], sivri=(0, 1, 2, 3)), "sap-koyu")
    p.ekle(Y([(-0.11, -4.74), (0.11, -4.74), (0.13, -4.52), (0.0, -4.42), (-0.13, -4.52)], sivri=(0, 1)), "kırmızı")
    p.ekle(Y([(-0.08, -4.72), (-0.30, -4.96), (-0.22, -5.30), (0.0, -6.04), (0.0, -4.72)], sivri=(0, 1, 3, 4)), "çelik-parlak")
    p.ekle(Y([(0.0, -4.72), (0.0, -6.04), (0.22, -5.30), (0.30, -4.96), (0.08, -4.72)], sivri=(0, 1, 3, 4)), "çelik-gölge")
    return p


def yay(k):
    """Türk yayı (4,5 baş): kollar −y yönüne kavislenir, uçlar geri kıvrılır; kiriş ince çizgi."""
    p = Parca()
    ust = [(-2.26, -0.62), (-2.10, -0.62), (-1.70, -0.40), (-1.00, -0.18), (-0.30, -0.08), (0.0, -0.10)]
    alt = [(0.0, 0.06), (-0.30, 0.04), (-1.00, -0.06), (-1.70, -0.28), (-2.12, -0.52)]
    p.ekle(Y(ust + alt, sivri=(0, 5, 6, 10)), "sap")
    p.ekle(Y([(x * -1, y) for x, y in ust] + [(x * -1, y) for x, y in alt], sivri=(0, 5, 6, 10)), "sap")
    p.ekle(Y([(-1.90, -0.50), (-1.00, -0.13), (0.0, -0.04), (1.0, -0.13), (1.90, -0.50), (1.70, -0.32), (1.0, -0.04),
              (0.0, 0.06), (-1.0, -0.04), (-1.70, -0.32)], sivri=(0, 4, 5, 9)), "sap-koyu")
    for yon in (-1, 1):
        p.ekle(Y([(yon * 2.10, -0.62), (yon * 2.30, -0.70), (yon * 2.26, -0.58), (yon * 2.12, -0.52)], sivri=(0, 1, 2, 3)),
               "badana")
    p.ekle(Y([(-0.14, -0.12), (0.14, -0.12), (0.14, 0.10), (-0.14, 0.10)], sivri=(0, 1, 2, 3)), "kahve-koyu")
    return p


# --- Birleştirme -------------------------------------------------------------------------

def parcalari_kur(kostum):
    parcalar = {
        "ust_kol_arka": ust_kol(kostum, True), "on_kol_arka": on_kol(kostum, True),
        "uyluk_arka": uyluk(kostum, True), "baldir_arka": baldir(kostum, True),
        "uyluk_on": uyluk(kostum), "baldir_on": baldir(kostum), "govde": govde(kostum),
        "ust_kol_on": ust_kol(kostum), "on_kol_on": on_kol(kostum),
    }
    b = bas(kostum)
    if kostum.get("başlık"):
        for yol, renk in kostum["başlık"](kostum).sekiller:
            b.ekle(yol, renk)
    parcalar["bas"] = b
    for ad in ("silah_on", "silah_arka"):
        if kostum.get(ad):
            parcalar[ad] = kostum[ad](kostum)
    return parcalar


def matrisler(durus, x0=0.0, y0=0.0):
    """Her parçanın SVG matrisi (a, b, c, d, e, f); kalça (x0, y0)'da."""
    out = {}
    for ad, (x, y, aci) in DURUSLAR[durus].items():
        a = math.radians(aci)
        out[ad] = (math.cos(a), math.sin(a), -math.sin(a), math.cos(a), x0 + x * B, y0 + y * B)
    return out


def aynala(m, gen):
    """Matrisi dikey eksene göre aynalar: x → gen − x."""
    a, b, c, d, e, f2 = m
    return (-a, b, -c, d, gen - e, f2)


_SAYI = __import__("re").compile(r"-?\d*\.?\d+")


def kutu(parcalar, mats):
    """Bütün şekillerin (kontrol noktaları dahil) kapsayan kutusu."""
    xs, ys = [], []
    for ad, parca in parcalar.items():
        a, b, c, d, e, f2 = mats[ad]
        for yol, _ in parca.sekiller:
            n = [float(v) for v in _SAYI.findall(yol)]
            for x, y in zip(n[0::2], n[1::2]):
                xs.append(a * x + c * y + e)
                ys.append(b * x + d * y + f2)
    return min(xs), min(ys), max(xs), max(ys)


def _nokta(m, x, y):
    a, b, c, d, e, f2 = m
    return (a * x + c * y + e, b * x + d * y + f2)


def ok_ciz(c, mats):
    """Gerili kiriş ve ok: kiriş yayın iki ucundan çeken ele (yakın kol), ok çeken elden yayın tutuşunun ötesine."""
    el = _nokta(mats["on_kol_on"], 0.04 * B, 1.12 * B)
    uc1 = _nokta(mats["silah_on"], -2.28 * B, -0.66 * B)
    uc2 = _nokta(mats["silah_on"], 2.28 * B, -0.66 * B)
    tutus = _nokta(mats["silah_on"], 0.0, 0.0)
    c.cizgi(f"M{uc1[0]:.2f} {uc1[1]:.2f} L{el[0]:.2f} {el[1]:.2f} L{uc2[0]:.2f} {uc2[1]:.2f}", "badana", 1.0)
    dx, dy = tutus[0] - el[0], tutus[1] - el[1]
    uz = (dx * dx + dy * dy) ** 0.5
    ux, uy = dx / uz, dy / uz
    nx, ny = -uy, ux
    bas_ = (tutus[0] + ux * 0.55 * B, tutus[1] + uy * 0.55 * B)
    w = 0.035 * B
    with c.grup("ok"):
        c.sekil(egri([(el[0] + nx * w, el[1] + ny * w), (bas_[0] + nx * w, bas_[1] + ny * w), (bas_[0] - nx * w, bas_[1] - ny * w),
                      (el[0] - nx * w, el[1] - ny * w)], sivri=(0, 1, 2, 3)), "sap")
        t0 = (bas_[0] + ux * 0.22 * B, bas_[1] + uy * 0.22 * B)
        c.sekil(egri([(bas_[0] + nx * 0.07 * B, bas_[1] + ny * 0.07 * B), t0, (bas_[0] - nx * 0.07 * B, bas_[1] - ny * 0.07 * B)],
                     sivri=(0, 1, 2)), "çelik-gölge")
        for s in (1, -1):
            c.sekil(egri([(el[0] + ux * 0.04 * B, el[1] + uy * 0.04 * B), (el[0] + ux * 0.32 * B, el[1] + uy * 0.32 * B),
                          (el[0] + ux * 0.26 * B + s * nx * 0.10 * B, el[1] + uy * 0.26 * B + s * ny * 0.10 * B),
                          (el[0] - ux * 0.02 * B + s * nx * 0.10 * B, el[1] - uy * 0.02 * B + s * ny * 0.10 * B)],
                         sivri=(0, 1, 2, 3)), "kırmızı" if s > 0 else "kırmızı-koyu")


def ciz_karakter(kostum, durus, onek, kenar=12, sola_bakar=False):
    """Karakteri kendi çiziminde kurar. Dönüş: (Cizim, ayak noktası (x, y))."""
    parcalar = parcalari_kur(kostum)
    m0 = matrisler(durus)
    x0, y0, x1, y1 = kutu(parcalar, m0)
    gen, yuk = x1 - x0 + 2 * kenar, y1 - y0 + 2 * kenar
    mats = matrisler(durus, kenar - x0, kenar - y0)
    if not sola_bakar:
        mats = {k: aynala(v, gen) for k, v in mats.items()}
    c = Cizim(round(gen), round(yuk), onek)
    for ad in SIRA:
        if ad not in parcalar:
            continue
        with c.grup(ad.replace("_", "-"), mats[ad]):
            for yol, renk in parcalar[ad].sekiller:
                c.sekil(yol, renk)
    if kostum.get("ok"):
        ok_ciz(c, mats)
    # Ayak noktası: kalçanın altında, en alt nokta hizasında
    kalca_x = kenar - x0 if sola_bakar else gen - (kenar - x0)
    return c, (kalca_x, yuk - kenar)
