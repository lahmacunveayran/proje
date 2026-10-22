"""Vektör çizim takımı: sanat rehberinin (docs/SANAT.md) kurallarını kendiliğinden uygular.

- Renkler yalnızca paletten, adıyla verilir: `"kırmızı"`. Paletin dışında renk yazılamaz.
- Doğrusal degradeler yatay ya da dikeydir; 2 durak (metal ve silindir için 3) kullanılır.
- Kontur yoktur: her şey dolgulu şekildir.
- Şekiller `egri` ile kurulur: noktalardan akıcı eğriyle geçer, istenen noktada sivri köşe yapar.
"""
import math
import os
import subprocess
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from palet import PALET, r  # noqa: E402

KOK = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))


def f(v):
    """Sayıyı kısa yazar."""
    s = f"{v:.2f}".rstrip("0").rstrip(".")
    return "0" if s in ("-0", "") else s


# --- Renk ölçümü (CIELAB) -------------------------------------------------------------------


def _lin(c):
    return c / 12.92 if c <= 0.04045 else ((c + 0.055) / 1.055) ** 2.4


def lab(hexrenk):
    """sRGB renginin CIELAB değerleri (L*, a*, b*)."""
    rr, gg, bb = (_lin(int(hexrenk[i:i + 2], 16) / 255) for i in (1, 3, 5))
    x = (0.4124 * rr + 0.3576 * gg + 0.1805 * bb) / 0.95047
    y = 0.2126 * rr + 0.7152 * gg + 0.0722 * bb
    z = (0.0193 * rr + 0.1192 * gg + 0.9505 * bb) / 1.08883

    def g(t):
        return t ** (1 / 3) if t > 0.008856 else 7.787 * t + 16 / 116

    fx, fy, fz = g(x), g(y), g(z)
    return 116 * fy - 16, 500 * (fx - fy), 200 * (fy - fz)


def L(ad):
    """Palet renginin açıklığı (L*)."""
    return lab(r(ad))[0]


def C(ad):
    """Palet renginin doygunluğu (C*)."""
    _, a, b = lab(r(ad))
    return math.hypot(a, b)


# --- Yollar ------------------------------------------------------------------------------------


DUZ_ESIK = 0.035  # kontrol noktasının kirişe uzaklığı / kiriş boyu; altı düz sayılır


def _neredeyse_duz(a, c1, c2, b):
    dx, dy = b[0] - a[0], b[1] - a[1]
    uz = math.hypot(dx, dy)
    if uz < 1e-9:
        return False

    def uzak(p):
        return abs((p[0] - a[0]) * dy - (p[1] - a[1]) * dx) / uz

    return max(uzak(c1), uzak(c2)) / uz < DUZ_ESIK


def egri(noktalar, sivri=(), kapali=True, gerginlik=1.0):
    """Noktalardan akıcı eğriyle geçen yol.

    `sivri` içindeki sıralarda yol kırılır (sivri köşe). İki sivri nokta arasındaki parça düz
    çizgi olur; böylece yol hem eğri hem keskin köşeli olur (esin kaynağındaki gibi).
    Bir nokta `(x, y, k)` biçiminde verilirse `k`, o noktanın teğetini ölçekler (0: sivri).
    """
    pts = [(p[0], p[1]) for p in noktalar]
    olcek = [p[2] if len(p) > 2 else 1.0 for p in noktalar]
    n = len(pts)
    sivri = {i % n for i in sivri}

    def teget(i):
        if i in sivri or olcek[i] == 0 or (not kapali and i in (0, n - 1)):
            return None
        a = pts[(i - 1) % n]
        b = pts[(i + 1) % n]
        k = gerginlik * olcek[i] / 6
        return ((b[0] - a[0]) * k, (b[1] - a[1]) * k)

    d = [f"M{f(pts[0][0])} {f(pts[0][1])}"]
    for i in range(n if kapali else n - 1):
        a, b = pts[i], pts[(i + 1) % n]
        ta, tb = teget(i), teget((i + 1) % n)
        if ta is None and tb is None:
            d.append(f"L{f(b[0])} {f(b[1])}")
            continue
        ta = ta or (0.0, 0.0)
        tb = tb or (0.0, 0.0)
        # Teğeti olmayan uçta kontrol noktası öbür ucun yönünde üçte bire konur: sivri ama eğri.
        c1 = (a[0] + ta[0], a[1] + ta[1]) if ta != (0.0, 0.0) else (a[0] + (b[0] - a[0]) / 3 - tb[0] / 2, a[1] + (b[1] - a[1]) / 3 - tb[1] / 2)
        c2 = (b[0] - tb[0], b[1] - tb[1]) if tb != (0.0, 0.0) else (b[0] - (b[0] - a[0]) / 3 + ta[0] / 2, b[1] - (b[1] - a[1]) / 3 + ta[1] / 2)
        if _neredeyse_duz(a, c1, c2, b):
            # Kontrol noktaları kirişe çok yakınsa parça gözle düzdür; düz çizgi yazılır (esindeki gibi)
            d.append(f"L{f(b[0])} {f(b[1])}")
            continue
        d.append(f"C{f(c1[0])} {f(c1[1])} {f(c2[0])} {f(c2[1])} {f(b[0])} {f(b[1])}")
    if kapali:
        d.append("Z")
    return " ".join(d)


def cokgen(noktalar):
    """Düz kenarlı kapalı yol (yalnızca gerçekten düz şeyler için: bıçak ağzı, tahta kenarı)."""
    return "M" + " L".join(f"{f(x)} {f(y)}" for x, y in noktalar) + " Z"


def elips(cx, cy, rx, ry):
    k = 0.5523
    return (f"M{f(cx - rx)} {f(cy)} C{f(cx - rx)} {f(cy - ry * k)} {f(cx - rx * k)} {f(cy - ry)} {f(cx)} {f(cy - ry)} "
            f"C{f(cx + rx * k)} {f(cy - ry)} {f(cx + rx)} {f(cy - ry * k)} {f(cx + rx)} {f(cy)} "
            f"C{f(cx + rx)} {f(cy + ry * k)} {f(cx + rx * k)} {f(cy + ry)} {f(cx)} {f(cy + ry)} "
            f"C{f(cx - rx * k)} {f(cy + ry)} {f(cx - rx)} {f(cy + ry * k)} {f(cx - rx)} {f(cy)} Z")


def daire(cx, cy, rr):
    return elips(cx, cy, rr, rr)


def don(noktalar, aci, merkez=(0, 0)):
    """Noktaları merkez çevresinde `aci` derece döndürür (üçüncü öğe korunur)."""
    a = math.radians(aci)
    ca, sa = math.cos(a), math.sin(a)
    out = []
    for p in noktalar:
        x, y = p[0] - merkez[0], p[1] - merkez[1]
        q = (merkez[0] + x * ca - y * sa, merkez[1] + x * sa + y * ca)
        out.append(q + tuple(p[2:]))
    return out


def tas(noktalar, dx, dy):
    return [(p[0] + dx, p[1] + dy) + tuple(p[2:]) for p in noktalar]


def ayna(noktalar, eksen_x):
    """Noktaları dikey bir eksene göre aynalar ve sırayı ters çevirir (yön korunur)."""
    return [(2 * eksen_x - p[0], p[1]) + tuple(p[2:]) for p in reversed(noktalar)]


def ara(a, b, t):
    return (a[0] + (b[0] - a[0]) * t, a[1] + (b[1] - a[1]) * t)


def uzuv(p0, p1, w0, w1, sis=0.0, sis_yer=0.45, sis_yan=1, w_orta=None):
    """İki eklem arasında daralan uzuv: bir kenarı düze yakın, öbür kenarı şişkin.

    `sis`: şişkin yandaki kas çıkıntısı (birim). `sis_yan`: +1 sol, -1 sağ (p0→p1 yönüne göre).
    Uçlar düzdür; eklemlerde başka parçanın altına girer. Kapsül biçimi bilerek kullanılmaz."""
    dx, dy = p1[0] - p0[0], p1[1] - p0[1]
    uz = math.hypot(dx, dy) or 1
    ux, uy = dx / uz, dy / uz
    nx, ny = -uy, ux
    wm = w_orta if w_orta is not None else (w0 + w1) / 2
    m = (p0[0] + dx * sis_yer, p0[1] + dy * sis_yer)
    sol_sis = sis if sis_yan > 0 else sis * 0.25
    sag_sis = sis if sis_yan < 0 else sis * 0.25
    a0 = (p0[0] + nx * w0 / 2, p0[1] + ny * w0 / 2)
    am = (m[0] + nx * (wm / 2 + sol_sis), m[1] + ny * (wm / 2 + sol_sis))
    a1 = (p1[0] + nx * w1 / 2, p1[1] + ny * w1 / 2)
    b1 = (p1[0] - nx * w1 / 2, p1[1] - ny * w1 / 2)
    bm = (m[0] - nx * (wm / 2 + sag_sis), m[1] - ny * (wm / 2 + sag_sis))
    b0 = (p0[0] - nx * w0 / 2, p0[1] - ny * w0 / 2)
    return [a0, am, a1, b1, bm, b0]


# --- Belge ---------------------------------------------------------------------------------------


class Cizim:
    """Bir SVG çizimi. Şekiller eklendikleri sırayla (arkadan öne) çizilir."""

    def __init__(self, gen, yuk, onek):
        self.gen = gen
        self.yuk = yuk
        self.onek = onek
        self.tanimlar = []
        self.govde = []
        self.n = 0
        self.yigin = []

    def renk(self, ad):
        if ad.startswith("url("):
            return ad
        if ad not in PALET:
            raise KeyError(f"palette olmayan renk adı: {ad!r}")
        return r(ad)

    def _duraklar(self, duraklar):
        out = []
        for d in duraklar:
            konum, ad = d[0], d[1]
            saydam = d[2] if len(d) > 2 else 1
            s = f'<stop offset="{f(konum)}" stop-color="{self.renk(ad)}"'
            if saydam != 1:
                s += f' stop-opacity="{f(saydam)}"'
            out.append(s + "/>")
        return "".join(out)

    def dogrusal(self, x1, y1, x2, y2, duraklar):
        """Yatay ya da dikey doğrusal degrade. `duraklar`: [(konum, ad[, saydamlık])]."""
        if len(duraklar) > 3:
            raise ValueError("degradede en fazla 3 durak olur")
        aci = math.degrees(math.atan2(abs(y2 - y1), abs(x2 - x1)))
        if min(aci, 90 - aci) > 15:
            raise ValueError(f"degrade yatay ya da dikey olmalı (eksenden {min(aci, 90 - aci):.0f}° eğik)")
        self.n += 1
        kimlik = f"{self.onek}{self.n}"
        self.tanimlar.append(
            f'<linearGradient id="{kimlik}" gradientUnits="userSpaceOnUse" x1="{f(x1)}" y1="{f(y1)}" '
            f'x2="{f(x2)}" y2="{f(y2)}">{self._duraklar(duraklar)}</linearGradient>')
        return f"url(#{kimlik})"

    def dikey(self, y1, y2, ust, alt, orta=None):
        """Üstten alta degrade (x önemsiz)."""
        d = [(0, ust), (1, alt)] if orta is None else [(0, ust), (0.5, orta), (1, alt)]
        return self.dogrusal(0, y1, 0, y2, d)

    def yatay(self, x1, x2, sol, sag, orta=None):
        d = [(0, sol), (1, sag)] if orta is None else [(0, sol), (0.5, orta), (1, sag)]
        return self.dogrusal(x1, 0, x2, 0, d)

    def radyal(self, cx, cy, yaricap, duraklar, fx=None, fy=None):
        if len(duraklar) > 3:
            raise ValueError("degradede en fazla 3 durak olur")
        self.n += 1
        kimlik = f"{self.onek}{self.n}"
        odak = "" if fx is None else f' fx="{f(fx)}" fy="{f(fy)}"'
        self.tanimlar.append(
            f'<radialGradient id="{kimlik}" gradientUnits="userSpaceOnUse" cx="{f(cx)}" cy="{f(cy)}" '
            f'r="{f(yaricap)}"{odak}>{self._duraklar(duraklar)}</radialGradient>')
        return f"url(#{kimlik})"

    def sekil(self, d, dolgu, saydam=None, kimlik=None, delikli=False):
        """Dolgulu şekil ekler. `dolgu`: palet adı ya da degrade.

        `delikli`: iç içe yollarda içteki yol delik olur (çerçeve, halka)."""
        ek = "" if saydam is None else f' opacity="{f(saydam)}"'
        if delikli:
            ek += ' fill-rule="evenodd"'
        k = "" if kimlik is None else f' id="{kimlik}"'
        self.govde.append(f'<path{k} d="{d}" fill="{self.renk(dolgu)}"{ek}/>')

    def cizgi(self, d, ad, kalinlik):
        """İnce çizgi: yalnızca doğası çizgi olan şeyler için (yay kirişi, ip). En fazla 1,5 birim."""
        if kalinlik > 1.5:
            raise ValueError("ince çizgi en fazla 1,5 birim olur")
        self.govde.append(f'<path d="{d}" fill="none" stroke="{self.renk(ad)}" stroke-width="{f(kalinlik)}" '
                          f'stroke-linecap="round"/>')

    def grup(self, kimlik, donusum=None):
        """Şekil grubu; `donusum` verilirse (a, b, c, d, e, f) SVG matrisi uygulanır."""
        cizim = self
        ek = "" if donusum is None else ' transform="matrix(' + " ".join(f"{v:.5f}" for v in donusum) + ')"'

        class _Grup:
            def __enter__(self):
                cizim.govde.append(f'<g id="{kimlik}"{ek}>')

            def __exit__(self, *a):
                cizim.govde.append("</g>")

        return _Grup()

    def metin(self, aciklama=""):
        bas = (f'<svg xmlns="http://www.w3.org/2000/svg" width="{f(self.gen)}" height="{f(self.yuk)}" '
               f'viewBox="0 0 {f(self.gen)} {f(self.yuk)}">')
        yorum = f"<!-- {aciklama} -->\n" if aciklama else ""
        tanim = "<defs>" + "".join(self.tanimlar) + "</defs>\n" if self.tanimlar else ""
        return bas + "\n" + yorum + tanim + "\n".join(self.govde) + "\n</svg>\n"

    def kaydet(self, yol, aciklama=""):
        os.makedirs(os.path.dirname(yol), exist_ok=True)
        with open(yol, "w", encoding="utf-8") as dosya:
            dosya.write(self.metin(aciklama))


def png(svg_yolu, png_yolu, olcek=1.0, zemin=None):
    """SVG'yi motorun kendi çizicisiyle PNG'ye çevirir (önizleme ve denetim için)."""
    komut = ["cargo", "run", "-q", "--release", "-p", "engine", "--example", "svg-png", "--",
             svg_yolu, png_yolu, str(olcek)]
    if zemin:
        komut.append(r(zemin) if not zemin.startswith("#") else zemin)
    subprocess.run(komut, check=True, cwd=KOK)
