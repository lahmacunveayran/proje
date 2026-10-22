"""Esin kaynağının parçalı karakter kuklasını birleştirip SVG olarak yazar (yalnızca ölçüm için).

Oyunun kuklası (`Human` → `body`) kol, el, bacak, ayak, gövde, baş ve silah parçalarından oluşur.
Her parça sprite'ının kareleri ulus ve cinsiyete göre görünüşü, içindeki `armor` sprite'ı zırhı,
`weapL` / `weapR` sprite'ları silahı seçer. Oyun bunları kodla seçer (`gotoAndStop`); bu araç aynı
seçimi yapıp karakteri tek SVG'de birleştirir ve her parçanın kutusunu ölçer.

Şekillerin kendisi FFDec'in dışa aktardığı SVG'lerden okunur (bkz. `cikar.sh`). Çıktılar
`referans/` klasörüne yazılır; bu klasör git'e girmez. Esin kaynağının çizimleri oyunda
kullanılmaz; yalnızca ölçülür.

Kullanım (kütüphane olarak): bkz. `olc.py`.
"""
import math
import os
import re
import struct
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from swfstats import Bits, load, tags  # noqa: E402

SEKIL_ETIKETLERI = {2, 22, 32, 83}


# --- SWF okuma -------------------------------------------------------------------------------

def _sb(b, n):
    if n == 0:
        return 0
    v = b.ub(n)
    if v & (1 << (n - 1)):
        v -= 1 << n
    return v


def _matris(b):
    """SWF MATRIX → (a, b, c, d, tx, ty); öteleme piksel."""
    sx, sy, r0, r1 = 1.0, 1.0, 0.0, 0.0
    if b.ub(1):
        n = b.ub(5)
        sx = _sb(b, n) / 65536
        sy = _sb(b, n) / 65536
    if b.ub(1):
        n = b.ub(5)
        r0 = _sb(b, n) / 65536
        r1 = _sb(b, n) / 65536
    n = b.ub(5)
    tx = _sb(b, n) / 20
    ty = _sb(b, n) / 20
    b.align()
    return (sx, r0, r1, sy, tx, ty)


def _renk_donusumu(b):
    """CXFORMWITHALPHA → (çarpanlar, ekler); çarpan 1.0 = değişmez."""
    ekli = b.ub(1)
    carpli = b.ub(1)
    n = b.ub(4)
    mul = [1.0, 1.0, 1.0, 1.0]
    add = [0, 0, 0, 0]
    if carpli:
        mul = [_sb(b, n) / 256 for _ in range(4)]
    if ekli:
        add = [_sb(b, n) for _ in range(4)]
    b.align()
    return (tuple(mul), tuple(add))


def _yerlestir(govde, kod):
    """PlaceObject2/3 → sözlük."""
    fl = govde[0]
    p = 1
    fl2 = 0
    if kod == 70:
        fl2 = govde[1]
        p = 2
    derinlik = struct.unpack_from("<H", govde, p)[0]
    p += 2
    if kod == 70 and fl2 & 0x08:  # sınıf adı
        p = govde.index(b"\0", p) + 1
    kayit = {"derinlik": derinlik, "tasi": bool(fl & 1)}
    if fl & 2:
        kayit["kimlik"] = struct.unpack_from("<H", govde, p)[0]
        p += 2
    if fl & 4:
        b = Bits(govde, p)
        kayit["matris"] = _matris(b)
        p = b.pos
    if fl & 8:
        b = Bits(govde, p)
        kayit["renk"] = _renk_donusumu(b)
        p = b.pos
    if fl & 0x10:
        p += 2
    if fl & 0x20:
        e = govde.index(b"\0", p)
        kayit["ad"] = govde[p:e].decode("latin1")
        p = e + 1
    if fl & 0x40:
        kayit["kirpma"] = struct.unpack_from("<H", govde, p)[0]
    return kayit


class Sprite:
    def __init__(self, kimlik):
        self.kimlik = kimlik
        self.kareler = []  # her kare: {derinlik: kayıt}
        self.etiketler = {}  # ad → kare sırası (0'dan)

    def kare(self, secim):
        """Kare sırası: sayı (1'den) ya da etiket adı."""
        if secim is None:
            return 0
        if isinstance(secim, int):
            return max(0, min(len(self.kareler) - 1, secim - 1))
        if secim not in self.etiketler:
            raise KeyError(f"sprite {self.kimlik}: '{secim}' etiketi yok ({sorted(self.etiketler)[:20]}...)")
        return self.etiketler[secim]


def _zaman_cizelgesi(govde_iter, sprite):
    liste = {}
    for kod, g in govde_iter:
        if kod in (26, 70):
            k = _yerlestir(g, kod)
            d = k["derinlik"]
            if k["tasi"] and d in liste:
                eski = dict(liste[d])
                if "kimlik" in k:
                    # Karakter değişir; ad ve öbür bilgiler korunur
                    eski = {"derinlik": d}
                    if "ad" in liste[d]:
                        eski["ad"] = liste[d]["ad"]
                eski.update({x: v for x, v in k.items() if x != "tasi"})
                liste[d] = eski
            else:
                liste[d] = {x: v for x, v in k.items() if x != "tasi"}
        elif kod == 28:  # RemoveObject2
            d = struct.unpack_from("<H", g, 0)[0]
            liste.pop(d, None)
        elif kod == 5:  # RemoveObject
            d = struct.unpack_from("<H", g, 2)[0]
            liste.pop(d, None)
        elif kod == 43:  # FrameLabel
            e = g.index(b"\0")
            sprite.etiketler[g[:e].decode("latin1")] = len(sprite.kareler)
        elif kod == 1:  # ShowFrame
            sprite.kareler.append({d: dict(v) for d, v in liste.items()})


class Swf:
    def __init__(self, yol, sekil_klasoru):
        _, _, veri, pos = load(yol)
        self.spritelar = {}
        self.sekiller = set()
        self.disari = {}
        for kod, g in tags(veri, pos):
            if kod == 39:
                sid = struct.unpack_from("<H", g, 0)[0]
                s = Sprite(sid)
                _zaman_cizelgesi(tags(g, 4), s)
                self.spritelar[sid] = s
            elif kod in SEKIL_ETIKETLERI:
                self.sekiller.add(struct.unpack_from("<H", g, 0)[0])
            elif kod == 56:
                n = struct.unpack_from("<H", g, 0)[0]
                p = 2
                for _ in range(n):
                    cid = struct.unpack_from("<H", g, p)[0]
                    p += 2
                    e = g.index(b"\0", p)
                    self.disari[g[p:e].decode("latin1")] = cid
                    p = e + 1
        self.sekil_klasoru = sekil_klasoru
        self._sekil_onbellek = {}

    def sekil_svg(self, sid):
        """FFDec çıktısından şeklin yolları (kendi koordinatlarında) ve degrade tanımları."""
        if sid in self._sekil_onbellek:
            return self._sekil_onbellek[sid]
        with open(os.path.join(self.sekil_klasoru, f"{sid}.svg"), encoding="utf-8") as f:
            metin = f.read()
        ic = re.search(r"<g transform=\"[^\"]*\">(.*?)</g>", metin, re.S)
        govde = ic.group(1) if ic else ""
        tanim = re.search(r"<defs>(.*?)</defs>", metin, re.S)
        tanim = tanim.group(1) if tanim else ""
        onek = f"s{sid}_"
        govde = re.sub(r"url\(#([\w-]+)\)", lambda m: f"url(#{onek}{m.group(1)})", govde)
        tanim = re.sub(r'id="([\w-]+)"', lambda m: f'id="{onek}{m.group(1)}"', tanim)
        tanim = re.sub(r'xlink:href="#([\w-]+)"', lambda m: f'xlink:href="#{onek}{m.group(1)}"', tanim)
        yollar = re.findall(r'<path d="([^"]*)"([^>]*)/>', govde)
        self._sekil_onbellek[sid] = (govde, tanim, yollar)
        return self._sekil_onbellek[sid]


# --- Geometri ------------------------------------------------------------------------------

def carp(m1, m2):
    """m1 ∘ m2 (önce m2, sonra m1)."""
    a1, b1, c1, d1, e1, f1 = m1
    a2, b2, c2, d2, e2, f2 = m2
    return (a1 * a2 + c1 * b2, b1 * a2 + d1 * b2, a1 * c2 + c1 * d2, b1 * c2 + d1 * d2,
            a1 * e2 + c1 * f2 + e1, b1 * e2 + d1 * f2 + f1)


BIRIM = (1.0, 0.0, 0.0, 1.0, 0.0, 0.0)


def uygula(m, x, y):
    a, b, c, d, e, f = m
    return (a * x + c * y + e, b * x + d * y + f)


_SAYI = re.compile(r"[MLQCZ]|-?\d*\.?\d+(?:e-?\d+)?")


def yol_noktalari(d):
    """Yolun bütün uç ve kontrol noktaları (kutu hesabı için yeterli)."""
    sayilar = []
    for t in _SAYI.findall(d):
        if t in "MLQCZ":
            continue
        sayilar.append(float(t))
    return list(zip(sayilar[0::2], sayilar[1::2]))


class Kutu:
    def __init__(self):
        self.x0 = self.y0 = math.inf
        self.x1 = self.y1 = -math.inf

    def ekle(self, x, y):
        self.x0, self.y0 = min(self.x0, x), min(self.y0, y)
        self.x1, self.y1 = max(self.x1, x), max(self.y1, y)

    def birlestir(self, k):
        if k.bos():
            return
        self.ekle(k.x0, k.y0)
        self.ekle(k.x1, k.y1)

    def bos(self):
        return self.x0 > self.x1

    @property
    def gen(self):
        return self.x1 - self.x0

    @property
    def yuk(self):
        return self.y1 - self.y0

    def __repr__(self):
        return f"Kutu({self.x0:.1f},{self.y0:.1f} {self.gen:.1f}×{self.yuk:.1f})"


# --- Birleştirme ---------------------------------------------------------------------------

class Birlestirici:
    """Kuklayı seçilen karelerle birleştirir; SVG metni ve parça kutularını üretir.

    `secim`: ad yolu → kare. Ad yolu noktalı yer adlarıdır ("body.head.armor"). Kare: sayı (1'den),
    etiket adı ya da None (gizli). Seçilmeyen sprite'lar 1. karede durur."""

    def __init__(self, swf, secim):
        self.swf = swf
        self.secim = secim
        self.tanimlar = {}
        self.parcalar = {}  # ad yolu → (Kutu, son matris)
        self.matrisler = {}  # ad yolu → yer adlı örneğin matrisi (dönme noktası: matris × (0, 0))
        self.sekil_kayitlari = []  # (ad yolu, şekil kimliği, matris, renkler)

    def birlestir(self, kok_id, kare=1):
        govde = self._ciz(kok_id, kare, BIRIM, "", 0)
        return govde

    def _ciz(self, cid, kare, m, yol, derin):
        if derin > 12:
            return ""
        if cid in self.swf.sekiller:
            return self._sekil(cid, m, yol)
        s = self.swf.spritelar.get(cid)
        if s is None or not s.kareler:
            return ""
        liste = s.kareler[s.kare(kare)]
        parca = []
        for d in sorted(liste):
            k = liste[d]
            if "kimlik" not in k or "kirpma" in k:
                continue
            ad = k.get("ad")
            alt_yol = f"{yol}.{ad}" if (yol and ad) else (ad or yol)
            secim = self.secim.get(alt_yol, 1) if ad else 1
            if ad and alt_yol in self.secim and self.secim[alt_yol] is None:
                continue
            mm = carp(m, k.get("matris", BIRIM))
            if ad:
                self.matrisler[alt_yol] = mm
            parca.append(self._ciz(k["kimlik"], secim, mm, alt_yol, derin + 1))
        return "".join(parca)

    def _sekil(self, sid, m, yol):
        govde, tanim, yollar = self.swf.sekil_svg(sid)
        if tanim:
            self.tanimlar[sid] = tanim
        kutu = self.parcalar.setdefault(yol, [Kutu(), m])[0]
        renkler = []
        for d, ozellik in yollar:
            for x, y in yol_noktalari(d):
                kutu.ekle(*uygula(m, x, y))
            renk = re.search(r'fill="(#[0-9a-fA-F]{6}|url\([^)]*\))"', ozellik)
            cizgi = re.search(r'stroke="(#[0-9a-fA-F]{6})"', ozellik)
            kalin = re.search(r'stroke-width="([0-9.]+)"', ozellik)
            renkler.append((renk.group(1) if renk else None, cizgi.group(1) if cizgi else None,
                            float(kalin.group(1)) if kalin else 0.0, d))
        self.sekil_kayitlari.append((yol, sid, m, renkler))
        a, b, c, dd, e, f = m
        return f'<g transform="matrix({a:.5f} {b:.5f} {c:.5f} {dd:.5f} {e:.3f} {f:.3f})">{govde}</g>'

    def svg(self, govde, kenar=10, olcek=1.0):
        kutu = Kutu()
        for k, _ in self.parcalar.values():
            kutu.birlestir(k)
        x0, y0 = kutu.x0 - kenar, kutu.y0 - kenar
        w, h = kutu.gen + 2 * kenar, kutu.yuk + 2 * kenar
        tanim = "".join(self.tanimlar.values())
        return (f'<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:ffdec="https://www.free-decompiler.com/flash" '
                f'width="{w * olcek:.1f}" height="{h * olcek:.1f}" viewBox="{x0:.2f} {y0:.2f} {w:.2f} {h:.2f}">'
                f"<defs>{tanim}</defs>{govde}</svg>")
