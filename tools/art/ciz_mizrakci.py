"""Bozkır mızrakçısı: iskeletten kurulan ilk karakter (sanat rehberinin "Çizim yöntemi").

Sıra: iskelet (eklem noktaları) → hacimler → renk → gölge (aynı renkte 2 duraklı yatay degrade,
ışık sol üstten) → yüz → el ve silah (avuç → sap → parmaklar). Her parça ayrı bir kukla grubudur;
grupların eklem noktaları ve çizim sırası iskelet dosyasına yazılır.

Çıktılar:
- content/art/characters/steppe-spearman.svg
- tools/art/iskelet/bozkir-mizrakcisi.json: eklemler, gruplar ve ölçüm aracının okuduğu işaretler
  (olcum.py karsilastir ... kahraman tools/art/iskelet/bozkir-mizrakcisi.json)

Birim: baş = 64. Koordinatlar gövde koordinatıdır: baş tepesi y = 0, kasık (0, 286).
"""
import json
import math
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from cizim import KOK, Cizim, egri, f  # noqa: E402

BAS = 64.0

# --- İskelet --------------------------------------------------------------------------------
# Kendi pozumuz: 3/4 görünüş, yüz sola dönük. Ağırlık sağdaki (yakın) bacakta; soldaki (uzak) bacak
# öne ve dışa adım atmış, ayak ucu sola bakar; yakın ayak sağa döner. Mızrak iki elle, bel-göğüs
# hizasında, gövdenin önünden çapraz geçer. Değerler olcum/sonuclar.md'deki orta yarıdan seçildi.
E = {
    "bas_tepesi": (-14, 0), "cene": (-26, 64), "boyun": (-20, 80),
    "omuz_uzak": (-48, 100), "omuz_yakin": (42, 108),
    "dirsek_uzak": (-84, 140), "dirsek_yakin": (74, 166),
    "el_uzak": (-46, 160), "el_yakin": (30, 232),
    "bel": (-8, 202), "kasik": (0, 286),
    "kalca_uzak": (-18, 278), "kalca_yakin": (16, 274),
    "diz_uzak": (-62, 340), "diz_yakin": (24, 366),
    "bilek_uzak": (-74, 448), "bilek_yakin": (34, 462),
    "ayak_uzak": (-96, 474), "ayak_yakin": (46, 490),
}
OMUZ_DIS = {"uzak": (-62, 94), "yakin": (54, 104)}  # omuz hattının dış noktaları (işaret için)
MIZRAK_BOY = 8.5 * BAS  # esinde mızrak 8–9 baş
MIZRAK_UC_ORANI = 0.45  # uçtan öndeki ele


def nokta(a, b, t):
    return (a[0] + (b[0] - a[0]) * t, a[1] + (b[1] - a[1]) * t)


def birim(a, b):
    dx, dy = b[0] - a[0], b[1] - a[1]
    u = math.hypot(dx, dy) or 1.0
    return dx / u, dy / u


def hacim(p0, p1, istasyonlar):
    """Kemik boyunca organik hacim. `istasyonlar`: [(t, sol, sag)]; sol, p0→p1 yönünün solundaki
    (aşağı inen kemikte görüntünün solu) yarı genişliktir. Dönen noktalar kapalı bir çevre çizer."""
    ux, uy = birim(p0, p1)
    nx, ny = uy, -ux  # aşağı inen kemikte n = (1, 0): sol yan p − n·s, sağ yan p + n·s
    a = [(p[0] - nx * s, p[1] - ny * s) for p, s in ((nokta(p0, p1, t), s) for t, s, _ in istasyonlar)]
    b = [(p[0] + nx * s, p[1] + ny * s) for p, s in ((nokta(p0, p1, t), s) for t, _, s in istasyonlar)]
    return a + b[::-1]


def yerel(merkez, aci, noktalar):
    """Yerel çerçevede verilen noktaları `aci` derece döndürüp merkeze taşır."""
    ca, sa = math.cos(math.radians(aci)), math.sin(math.radians(aci))
    return [(merkez[0] + x * ca - y * sa, merkez[1] + x * sa + y * ca) + tuple(p[2:]) for p in noktalar for x, y in [p[:2]]]


class Karakter:
    """Gruplara ayrılmış çizim; her grubun eklem noktası kaydedilir."""

    def __init__(self):
        self.c = Cizim(0, 0, "sm")
        self.gruplar = []
        self.kutular = {}

    def grup(self, kimlik, eklem):
        self.gruplar.append({"kimlik": kimlik, "eklem": [round(eklem[0], 1), round(eklem[1], 1)]})
        return self.c.grup(kimlik)

    def sekil(self, d, dolgu, ad=None):
        """Şekli ekler; `ad` verilirse şeklin kutusu (kontrol noktaları dahil) o ada eklenir (el, ayak)."""
        self.c.sekil(d, dolgu)
        if ad:
            xs, ys = sayilar(d)
            k = self.kutular.get(ad)
            yeni = [min(xs), min(ys), max(xs), max(ys)]
            self.kutular[ad] = yeni if k is None else [min(k[0], yeni[0]), min(k[1], yeni[1]),
                                                        max(k[2], yeni[2]), max(k[3], yeni[3])]


def sayilar(d):
    v = [float(x) for x in re.findall(r"-?\d+(?:\.\d+)?", d)]
    return v[0::2], v[1::2]


def yatay(k, pts, sol, sag):
    """Noktaların yatay genişliğinde, soldan sağa koyulaşan degrade (ışık sol üstten)."""
    xs = [p[0] for p in pts]
    return k.c.yatay(min(xs), max(xs), sol, sag)


# --- Parçalar --------------------------------------------------------------------------------

def mizrak_ekseni():
    ux, uy = birim(E["el_uzak"], E["el_yakin"])
    el_arasi = math.dist(E["el_uzak"], E["el_yakin"])
    uc = (E["el_uzak"][0] - ux * MIZRAK_BOY * MIZRAK_UC_ORANI, E["el_uzak"][1] - uy * MIZRAK_BOY * MIZRAK_UC_ORANI)
    dip_uz = MIZRAK_BOY * (1 - MIZRAK_UC_ORANI) - el_arasi
    dip = (E["el_yakin"][0] + ux * dip_uz, E["el_yakin"][1] + uy * dip_uz)
    return uc, dip


def bas(k):
    """Baş: 3/4, yüz sola dönük. Yerel çerçevede kurulur (tepe (0, 0), çene (0, 64)), sonra eğilir."""
    tepe, cene = E["bas_tepesi"], E["cene"]
    aci = math.degrees(math.atan2(cene[1] - tepe[1], cene[0] - tepe[0])) - 90  # dikeyden sapma

    def y(pts):
        return yerel(tepe, aci, pts)
    with k.grup("head", E["boyun"]):
        # Saç: kulak arkasından enseye uzun, uçları sivri
        sac = y([(8, 14), (26, 16), (33, 30), (34, 48), (30, 66), (24, 76), (21, 62), (18, 48), (14, 30)])
        # Yüz ve kulak (ten, düz). Uzak yanak sol kenarda; çene köşeli
        yuz = y([(-23, 18), (-26, 29), (-23.5, 36, 0.5), (-26.5, 42), (-23, 51), (-15, 60.5), (-6, 64.5),
                 (9, 59), (17, 50), (20, 46), (27, 46.5), (29, 39), (26, 31), (20, 33), (17, 18)])
        k.sekil(egri(sac, sivri=(0, 5, 6)), "kahve-siyah")
        k.sekil(egri(yuz, sivri=(0, 14, 9)), "ten-buğday", "yuz")
        # Kaşlar ve sarkık bıyık: saçla aynı renk, tek yol
        kas_uzak = y([(-25, 28.5), (-16, 25.8), (-11.5, 27.6), (-16, 29.6), (-24, 31.4)])
        kas_yakin = y([(-6.5, 27.4), (2, 24.6), (12, 26.8), (12, 29.4), (2, 28), (-6.5, 30.4)])
        biyik = y([(-19, 50.5), (-11, 48.6), (-5, 50), (1, 52), (4, 58), (1, 65), (-3, 56.5), (-9, 54),
                   (-16, 55), (-22, 61), (-22.5, 55)])
        k.sekil(" ".join([egri(kas_uzak, sivri=(0, 2)), egri(kas_yakin, sivri=(0, 2)), egri(biyik, sivri=(6, 9))]),
                "kahve-siyah")
        # Gözler: badem göz akı, küçük iris (sola bakar). 3/4'te uzak göz dar
        goz_uzak = y([(-24, 35.8), (-19.5, 33.4), (-13.5, 35), (-18.5, 37.8)])
        goz_yakin = y([(-6.5, 35), (0.5, 32.4), (9, 34.4), (2, 38)])
        k.sekil(egri(goz_uzak, sivri=(0, 2)) + " " + egri(goz_yakin, sivri=(0, 2)), "beyaz")
        iris_uzak = y([(-22.5, 34.2), (-19.2, 33.4), (-18.6, 37.2), (-21.6, 37.4)])
        iris_yakin = y([(-5.2, 33.6), (-0.8, 32.6), (-0.2, 37.6), (-4.6, 37.8)])
        k.sekil(egri(iris_uzak) + " " + egri(iris_yakin), "kahve-koyu")
        # Burun: tek gölge şekli; ışık sol üstten geldiği için sağ yanda, ucu sola çıkar
        burun = y([(-12, 34), (-14.5, 42), (-21, 48.6), (-14.5, 50), (-9, 47.6), (-9.6, 41)])
        k.sekil(egri(burun, sivri=(0, 2)), "ten-gölge")
        # Ağız: küçük, yumuşak renkli dudak (bıyığın altında)
        agiz = y([(-15, 56.8), (-9, 55.6), (-3.5, 57), (-9.5, 59.6)])
        k.sekil(egri(agiz, sivri=(0, 2)), "dudak-açık")
        # Kalpak: kırmızı keçe tepe ve kürk gövde; kürkün alt kenarı dalgalı, yanları hafif açılır
        tepe_k = y([(-22, -4), (-10, -18), (10, -19), (24, -8), (2, -2)])
        k.sekil(egri(tepe_k, sivri=(0, 3)), yatay(k, tepe_k, "kiremit", "kiremit-koyu"))
        kurk = y([(-31, 26), (-33, 8), (-30, -4, 0.8), (-10, -9), (14, -10), (32, -3, 0.8), (34, 12), (31, 24),
                  (24, 20), (14, 23), (2, 19.5), (-9, 23), (-20, 20)])
        k.sekil(egri(kurk, sivri=(0, 7, 8, 10)), yatay(k, kurk, "deri", "kahve-koyu"), "kalpak")


def govde(k):
    """Gövde: boyun, kaftan (etek ve üst), gölge şekilleri, keçe şerit, kuşak."""
    with k.grup("torso", E["kasik"]):
        boyun = [(-32, 56), (-9, 52), (-6, 84), (-33, 84)]
        k.sekil(egri(boyun, sivri=(0, 1)), "ten-buğday")
        # Kaftanın eteği: belden diz üstüne açılır; uzak yanı adım atan bacakla sola savrulur,
        # ortada yırtmaç (şalvar görünür). Etek uçları sivri
        etek = [(-46, 206), (-62, 250, 1.2), (-98, 322), (-72, 328, 0.7), (-40, 332), (-14, 266), (0, 336), (32, 346),
                (62, 338), (56, 286, 0.8), (42, 206)]
        k.sekil(egri(etek, sivri=(2, 3, 5, 6, 7, 8)), yatay(k, etek, "zeytin-gri", "zeytin"))
        # Kaftanın üstü: göğüs dolgun, bel kuşağa doğru daralır; sol omuz yüksek
        ust = [(-38, 78), (-62, 92), (-65, 122, 0.8), (-54, 164), (-48, 210), (-4, 216), (42, 210), (48, 166),
               (56, 128, 0.8), (58, 102), (30, 86), (-1, 80)]
        k.sekil(egri(ust, sivri=(0, 1, 3, 4, 6, 7, 9, 10, 11)), yatay(k, ust, "zeytin-gri", "zeytin"))
        # Gölge şekilleri (keskin kenarlı): yakın kolun altında gövde yanı ve yırtmaç içi
        golge_yan = [(34, 128), (52, 120), (46, 170), (40, 196), (26, 196), (30, 160)]
        golge_etek = [(-10, 224), (40, 222), (44, 250), (8, 238), (-12, 252)]
        k.sekil(egri(golge_yan, sivri=(0, 3, 4)) + " " + egri(golge_etek, sivri=(0, 1, 4)), "zeytin-koyu")
        # Keçe şerit: yakadan kuşağa ve yırtmacın kenarı; uçlara doğru incelir
        yaka = [(-40, 74), (-20, 70), (2, 74), (6, 84), (-2, 120, 0.8), (-22, 170), (-34, 204), (-41, 204),
                (-31, 166), (-12, 118, 0.8), (-6, 84), (-20, 80), (-38, 82)]
        yirtmac = [(-16, 224), (-10, 224), (-16, 268), (-36, 330), (-43, 331), (-24, 270)]
        k.sekil(egri(yaka, sivri=(0, 6, 7, 12)) + " " + egri(yirtmac, sivri=(0, 3, 4)), "beyaz-gölge")
        # Kuşak: 3/4 dönen bele sarılır (ön yüzü sola bakar); yakın yanda düğüm ve sarkan uçlar
        kusak = [(-52, 188), (-16, 194), (44, 188), (48, 212), (-8, 222), (-50, 216)]
        k.sekil(egri(kusak, sivri=(0, 2, 3, 5)), yatay(k, kusak, "kırmızı-degrade-açık", "kırmızı-koyu"))
        ucler = [(22, 196), (38, 198), (42, 226), (50, 266), (40, 264), (33, 234), (27, 258), (18, 254), (24, 222)]
        k.sekil(egri(ucler, sivri=(3, 4, 6, 7)), "kiremit-koyu")


def bacak(k, yan, on):
    """Bir bacak: uyluk (şalvar), baldır (çizme konçu), ayak (çizme ucu)."""
    kalca, diz, bilek, ayak = (E[f"{a}_{yan}"] for a in ("kalca", "diz", "bilek", "ayak"))
    yon = -1 if yan == "uzak" else 1  # ayak ucunun baktığı yan
    # Uyluk: kalçadan dizin altına (şalvar çizme konçunun üstüne bol düşer)
    alt = nokta(diz, bilek, 0.36)
    uyluk = hacim(kalca, alt, [(0, 26, 26), (0.35, 28, 24), (0.66, 21, 19), (0.84, 23, 22), (1, 17, 17)])
    with k.grup(f"thigh-{'front' if on else 'back'}", kalca):
        dolgu = yatay(k, uyluk, "gece-ufuk", "lacivert-zemin") if on else "lacivert-zemin"
        k.sekil(egri(uyluk, sivri=(4, 5)), dolgu)
    # Baldır: çizme konçu; ağzı geniş ve eğik, baldır şişkinliği arkada, bilekte daralır
    ust = nokta(diz, bilek, 0.3)
    arka, on_ = (18, 15) if yon > 0 else (15, 18)  # baldırın arkası ayağın tersi yanda
    kon = hacim(ust, bilek, [(-0.06, on_ + 3, arka + 1), (0.22, on_ + 1, arka + 3), (0.6, 13, 14), (0.9, 10, 10),
                             (1.04, 11, 11)])
    with k.grup(f"shin-{'front' if on else 'back'}", diz):
        k.sekil(egri(kon, sivri=(0, 4, 5, 9)), yatay(k, kon, "deri-gölge", "kahve-koyu"))
    # Ayak: topuklu çizme ucu, burnu ayağın baktığı yana ve hafif yukarı kalkık (0,61 baş)
    bx, by = bilek
    taban = ayak[1]
    uc = [(-12, by - 8), (11, by - 6), (18, taban - 15), (36, taban - 10), (44, taban - 12), (39, taban - 1),
          (16, taban + 1), (-7, taban + 1), (-13, taban - 2), (-14, taban - 13)]
    uc = [(bx + x * yon, yy) for x, yy in uc]
    if yon < 0:
        uc = uc[::-1]
    with k.grup(f"foot-{'front' if on else 'back'}", bilek):
        # Taban düz kenar (sivri köşeler arası düz çizgi); burun sivri ve kalkık
        sivri = (0, 1, 4, 6, 7, 9)
        k.sekil(egri(uc, sivri=sivri if yon > 0 else tuple(9 - i for i in sivri)), "kahve-koyu", f"ayak_{yan}")


def kol_ust(k, yan, on):
    omuz, dirsek = E[f"omuz_{yan}"], E[f"dirsek_{yan}"]
    if on:
        # Öndeki kolda omuz başı görünür: yuvarlak
        kol = hacim(omuz, dirsek, [(-0.2, 9, 9), (-0.06, 19, 19), (0.3, 23, 19), (0.75, 18, 16), (1.06, 15, 15),
                                   (1.16, 9, 9)])
        sivri = ()
    else:
        # Arkadaki kolda omuz ucu gövdenin altında kalır (sivri); dirsek ucu yuvarlak
        kol = hacim(omuz, dirsek, [(-0.06, 19, 19), (0.3, 23, 19), (0.75, 18, 16), (1.06, 15, 15), (1.16, 9, 9)])
        sivri = (0, 9)
    with k.grup(f"upper-arm-{'front' if on else 'back'}", omuz):
        k.sekil(egri(kol, sivri=sivri), yatay(k, kol, "zeytin-gri", "zeytin") if on else "zeytin")


def kol_on(k, yan, on):
    """Ön kol: bilekte genişleyen kaftan yeni ve uçlara doğru incelen keçe kol ağzı."""
    dirsek, el_ = E[f"dirsek_{yan}"], E[f"el_{yan}"]
    bilek = nokta(dirsek, el_, 0.62)
    kol = hacim(dirsek, bilek, [(-0.3, 8, 8), (-0.14, 14, 14), (0.4, 17, 15), (1, 19, 19)])
    yen = hacim(nokta(dirsek, bilek, 0.84), nokta(dirsek, bilek, 1.14), [(0, 17, 19), (0.5, 21, 22), (1, 15, 17)])
    with k.grup(f"forearm-{'front' if on else 'back'}", dirsek):
        k.sekil(egri(kol, sivri=(3, 4)), yatay(k, kol, "zeytin-gri", "zeytin") if on else "zeytin")
        k.sekil(egri(yen, sivri=(0, 2, 3, 5)), "beyaz-gölge")


def el(k, yan, parca):
    """Yumruk: avuç sapın arkasında, parmaklar sapın önünde. Yerel çerçevede x sap boyunca.

    Avuç bir ton koyudur; parmakların arasındaki çentiklerden görünür ve parmakları ayırır."""
    merkez = E[f"el_{yan}"]
    ux, uy = birim(E["el_uzak"], E["el_yakin"])
    aci = math.degrees(math.atan2(uy, ux))
    o = 1.12  # yumruk ölçeği: el / boy orta yarıda (0,075–0,09)

    def y(pts):
        return yerel(merkez, aci, [(x * o, yy * o) + tuple(p[2:]) for p in pts for x, yy in [p[:2]]])
    if parca == "avuc":
        # Avuç (sapın arkasında): parmakların arkasında kalır, yalnızca parmak aralarından görünür
        avuc = y([(-12, -9.5, 0.6), (0, -10.5), (12, -9.5, 0.6), (13, 0), (12, 9.5, 0.6), (0, 10.5), (-12, 9.5, 0.6),
                  (-13, 0)])
        with k.grup(f"hand-{yan_ad(yan)}-palm", merkez):
            k.sekil(egri(avuc), "ten-derin", f"el_{yan}")
    else:
        # Dört parmak yan yana sapı sarar: üstte boğum, altta kıvrık uç. Aralarındaki dar boşluktan koyu
        # avuç görünür. Başparmak sapın üstünden çapraz geçer.
        yollar = []
        for i, cx in enumerate((-9.6, -3.2, 3.2, 9.6)):
            ust = -12 + (0, 1.2, 0.6, 1.6)[i]
            alt = 10.8 - (0, 0.6, 0.4, 1.6)[i]
            w = 2.8
            yollar.append(egri(y([(cx - w, ust + 2.6), (cx, ust), (cx + w, ust + 2.6), (cx + w + 0.2, alt - 2.4),
                                  (cx, alt), (cx - w - 0.2, alt - 2.4)])))
        yollar.append(egri(y([(-16, -6), (-15.5, -12.5), (-4, -16), (7, -14.6), (9.6, -11.6), (-3, -10.2),
                              (-12, -3.6)]), sivri=(0, 4)))
        with k.grup(f"hand-{yan_ad(yan)}-fingers", merkez):
            k.sekil(" ".join(yollar), "ten-buğday", f"el_{yan}")


def yan_ad(yan):
    return "back" if yan == "uzak" else "front"


def mizrak(k):
    uc, dip = mizrak_ekseni()
    ux, uy = birim(uc, dip)
    nx, ny = -uy, ux

    def p(t, s):
        q = nokta(uc, dip, t)
        return (q[0] + nx * s, q[1] + ny * s)
    temren = 0.11  # uç demirinin boyu (mızrağın payı)
    with k.grup("spear", E["el_yakin"]):
        sap = [p(temren - 0.01, -3.4), p(1, -3), p(1, 3), p(temren - 0.01, 3.4)]
        k.sekil(egri(sap, sivri=(0, 1, 2, 3)), yatay(k, sap, "deri-açık", "deri"))
        demir = [p(0, 0), p(0.04, -7.5), p(0.075, -6), p(temren, -2.5), p(temren, 2.5), p(0.075, 6), p(0.04, 7.5)]
        k.sekil(egri(demir, sivri=(0, 3, 4)), yatay(k, demir, "çelik-parlak", "çelik-açık"))
        puskul = [p(temren + 0.015, -4), (p(temren + 0.02, -4)[0] - 6, p(temren + 0.02, -4)[1] + 20),
                  (p(temren + 0.03, 0)[0] - 2, p(temren + 0.03, 0)[1] + 30), (p(temren + 0.05, 2)[0] + 4, p(temren + 0.05, 2)[1] + 22),
                  p(temren + 0.03, 4)]
        k.sekil(egri(puskul, sivri=(0, 2, 4)), "kırmızı-degrade-açık")


def ciz():
    k = Karakter()
    # Çizim sırası (arkadan öne); el ve parmak ayrı gruplar: avuç → sap → parmaklar
    kol_ust(k, "uzak", False)
    bacak(k, "uzak", False)
    bacak(k, "yakin", True)
    govde(k)
    bas(k)
    kol_on(k, "uzak", False)
    el(k, "uzak", "avuc")
    kol_ust(k, "yakin", True)
    kol_on(k, "yakin", True)
    el(k, "yakin", "avuc")
    mizrak(k)
    el(k, "uzak", "parmak")
    el(k, "yakin", "parmak")
    return k


def isaretler(k):
    """Ölçüm aracının okuduğu işaretler (olcum/isaretler.json biçimi), çizimin kendisinden."""
    uc, dip = mizrak_ekseni()
    taban = max(k.kutular["ayak_uzak"][3], k.kutular["ayak_yakin"][3])
    return {
        "tam_boy": True, "bas_tepesi": list(E["bas_tepesi"]), "cene": list(E["cene"]),
        "omuz_sol": list(OMUZ_DIS["uzak"]), "omuz_sag": list(OMUZ_DIS["yakin"]),
        "dirsekler": [list(E["dirsek_uzak"]), list(E["dirsek_yakin"])], "bel": list(E["bel"]),
        "kasik": list(E["kasik"]), "dizler": [list(E["diz_uzak"]), list(E["diz_yakin"])],
        "ayaklar": [list(E["ayak_uzak"]), list(E["ayak_yakin"])], "taban": [0, round(taban, 1)],
        "el_kutulari": [[round(v, 1) for v in k.kutular["el_uzak"]], [round(v, 1) for v in k.kutular["el_yakin"]]],
        "silah_turu": "mızrak", "silah_ekseni": [[round(v, 1) for v in uc], [round(v, 1) for v in dip]],
    }


def main():
    k = ciz()
    # Görüntü sınırları: bütün yolların noktalarından (kontrol noktaları dahil, 4 birim pay)
    xs, ys = [], []
    for satir in k.c.govde:
        m = re.search(r' d="([^"]+)"', satir)
        if m:
            a, b = sayilar(m.group(1))
            xs += a
            ys += b
    x0, y0, x1, y1 = min(xs) - 4, min(ys) - 4, max(xs) + 4, max(ys) + 4
    k.c.gen, k.c.yuk = x1 - x0, y1 - y0
    k.c.govde.insert(0, f'<g id="steppe-spearman" transform="translate({f(-x0)} {f(-y0)})">')
    k.c.govde.append("</g>")
    svg = os.path.join(KOK, "content", "art", "characters", "steppe-spearman.svg")
    k.c.kaydet(svg, "Bozkır mızrakçısı. tools/art/ciz_mizrakci.py ile üretilir; elle değiştirmeyin.")
    iskelet = {
        "ad": "bozkır mızrakçısı",
        "aciklama": "tools/art/ciz_mizrakci.py üretir. Birim: baş = 64; gövde koordinatı (baş tepesi y = 0). "
                    "SVG'de bütün çizim 'kaydirma' kadar kaydırılır. 'gruplar' çizim sırasıyladır (arkadan öne); "
                    "her grubun 'eklem'i dönme noktasıdır. 'isaret' ölçüm aracının okuduğu işaretlerdir.",
        "kaydirma": [round(-x0, 2), round(-y0, 2)],
        "eklemler": {a: list(v) for a, v in E.items()},
        "gruplar": k.gruplar,
        "isaret": isaretler(k),
    }
    yol = os.path.join(KOK, "tools", "art", "iskelet", "bozkir-mizrakcisi.json")
    os.makedirs(os.path.dirname(yol), exist_ok=True)
    with open(yol, "w", encoding="utf-8") as dosya:
        json.dump(iskelet, dosya, ensure_ascii=False, indent=1)
        dosya.write("\n")
    print(svg)
    print(yol)


if __name__ == "__main__":
    main()
