"""Çizim ölçüm aracı: aynı ölçütleri esin kaynağının çizimlerine ve bizim çizimlerimize uygular.

Her çalıştırmada aynı sonucu verir (sıralı, yuvarlanmış çıktı; aynı çizici). Çıktı: JSON ve Markdown.

Alt komutlar:
  svg <dosya.svg ...>        SVG ölçüleri (dolgu grubu, kontur, degrade, palet ve alanları)
  png <dosya.svg ...>        Çizilmiş resmin piksel ölçüleri (doygunluk, parlaklık, renk alanları)
  cetvel <dosya.svg> <çıktı.png>
                             %5'lik cetvel çizgileriyle büyütülmüş görüntü (işaret koymak için)
  isaret                     olcum/isaretler.json'daki işaretlerden oranları hesaplar
  rapor                      referans kümelerini ölçer: olcum/sonuclar.json ve olcum/sonuclar.md
  karsilastir <bizim.svg> [küme] [iskelet.json]
                             bizim çizimi kümenin aralıklarıyla karşılaştırır (geçti/kaldı tablosu);
                             iskelet verilirse oranlar ve poz özgünlüğü de denetlenir
  ortusme <iskelet.json> [çizim.png]
                             pozun en yakın 10 referansı (kahraman çizimleri ve bütün kukla kareleri);
                             çizim verilirse en yakın 3 poz bizimkiyle üst üste çizilir
  levha <çıktı.png> <öğe>... yan yana levha, figürler aynı boyda, %5'lik cetvel çizgileriyle;
                             öğe: referans adı (f1/1112) ya da cizim.svg:iskelet.json

SVG'ler motorun kendi çizicisiyle (engine/examples/svg-png) çizilir; referans da bizim çizim de aynı
çiziciden geçer. Referans dosyaları referans/ klasöründedir (git dışı, bkz. cikar.sh).
"""
import colorsys
import json
import math
import os
import re
import statistics
import subprocess
import sys
import tempfile
import xml.etree.ElementTree as ET
from collections import Counter

from PIL import Image, ImageDraw, ImageFont

KOK = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
CIZICI = os.path.join(KOK, "target", "release", "examples", "svg-png")
SVGNS = "{http://www.w3.org/2000/svg}"
XLINK = "{http://www.w3.org/1999/xlink}href"
OLCUM_BOYU = 800  # ölçüm çiziminin uzun kenarı (piksel)
YAZI = os.path.join(KOK, "content", "fonts", "AlegreyaSans-Bold.ttf")


# --- Yardımcılar ------------------------------------------------------------------------------

def hsv(hexr):
    r, g, b = (int(hexr[i:i + 2], 16) / 255 for i in (1, 3, 5))
    return colorsys.rgb_to_hsv(r, g, b)


def y4(v):
    return None if v is None else round(v, 4)


def carp(m1, m2):
    a1, b1, c1, d1, e1, f1 = m1
    a2, b2, c2, d2, e2, f2 = m2
    return (a1 * a2 + c1 * b2, b1 * a2 + d1 * b2, a1 * c2 + c1 * d2, b1 * c2 + d1 * d2,
            a1 * e2 + c1 * f2 + e1, b1 * e2 + d1 * f2 + f1)


BIRIM = (1.0, 0.0, 0.0, 1.0, 0.0, 0.0)


def donusum(s):
    """SVG transform yazısı → matris."""
    m = BIRIM
    if not s:
        return m
    for ad, arg in re.findall(r"(\w+)\s*\(([^)]*)\)", s):
        v = [float(x) for x in re.split(r"[\s,]+", arg.strip()) if x]
        if ad == "matrix":
            t = tuple(v)
        elif ad == "translate":
            t = (1, 0, 0, 1, v[0], v[1] if len(v) > 1 else 0)
        elif ad == "scale":
            t = (v[0], 0, 0, v[1] if len(v) > 1 else v[0], 0, 0)
        elif ad == "rotate":
            a = math.radians(v[0])
            t = (math.cos(a), math.sin(a), -math.sin(a), math.cos(a), 0, 0)
        else:
            continue
        m = carp(m, t)
    return m


def uygula(m, x, y):
    a, b, c, d, e, f = m
    return (a * x + c * y + e, b * x + d * y + f)


def olcek(m):
    return math.sqrt(abs(m[0] * m[3] - m[1] * m[2]))


def ciz(svg_yolu, png_yolu, olcek_=None, zemin=None):
    """SVG'yi motorun çizicisiyle PNG'ye çevirir; ölçek verilmezse uzun kenar OLCUM_BOYU olur."""
    if olcek_ is None:
        w, h = svg_boyu(svg_yolu)
        olcek_ = OLCUM_BOYU / max(w, h)
    komut = [CIZICI, svg_yolu, png_yolu, f"{olcek_:.6f}"]
    if zemin:
        komut.append(zemin)
    subprocess.run(komut, check=True, capture_output=True)
    return olcek_


def svg_boyu(yol):
    kok = ET.parse(yol).getroot()
    vb = kok.get("viewBox")
    if vb:
        v = [float(x) for x in vb.split()]
        return v[2], v[3]
    return float(kok.get("width").replace("px", "")), float(kok.get("height").replace("px", ""))


# --- SVG ölçümü ------------------------------------------------------------------------------

class Degrade:
    def __init__(self, el, hepsi):
        self.tur = "doğrusal" if el.tag.endswith("linearGradient") else "dairesel"
        self.el = el
        ust = el.get(XLINK)
        self.miras = hepsi.get(ust[1:]) if ust else None
        self.duraklar = []
        for s in el.findall(SVGNS + "stop"):
            renk = s.get("stop-color") or re.search(r"stop-color:\s*(#[0-9a-fA-F]{6})", s.get("style", "")).group(1)
            self.duraklar.append((float(s.get("offset", "0").rstrip("%")) / (100 if "%" in s.get("offset", "") else 1),
                                  renk.upper(), float(s.get("stop-opacity", "1"))))
        if not self.duraklar and self.miras is not None:
            self.duraklar = self.miras.duraklar
        self.donusum = donusum(el.get("gradientTransform"))
        self.birim = el.get("gradientUnits", "objectBoundingBox")

    def yon(self, ctm):
        """Açıktan koyuya yön (ekran koordinatında birim vektör); doğrusal değilse None."""
        if self.tur != "doğrusal" or len(self.duraklar) < 2:
            return None
        x1, y1 = float(self.el.get("x1", "0").rstrip("%")), float(self.el.get("y1", "0").rstrip("%"))
        x2 = float(self.el.get("x2", "100%" if self.birim != "userSpaceOnUse" else "1").rstrip("%"))
        y2 = float(self.el.get("y2", "0").rstrip("%"))
        m = carp(ctm, self.donusum)
        p1, p2 = uygula(m, x1, y1), uygula(m, x2, y2)
        dx, dy = p2[0] - p1[0], p2[1] - p1[1]
        uz = math.hypot(dx, dy) or 1
        v0, v1 = hsv(self.duraklar[0][1])[2], hsv(self.duraklar[-1][1])[2]
        if v0 < v1:
            dx, dy = -dx, -dy
        return dx / uz, dy / uz

    def uc_farki(self):
        """İki uç arasındaki parlaklık (V) ve doygunluk (S) farkı."""
        a, b = hsv(self.duraklar[0][1]), hsv(self.duraklar[-1][1])
        return abs(a[2] - b[2]), abs(a[1] - b[1])


def yon_adi(v):
    if v is None:
        return None
    dx, dy = v
    if abs(dx) >= abs(dy):
        return "sağa koyulaşır" if dx > 0 else "sola koyulaşır"
    return "aşağı koyulaşır" if dy > 0 else "yukarı koyulaşır"


def ogeler(yol):
    """SVG'deki çizilen öğeler: (öğe, birikmiş dönüşüm, birikmiş saydamlık); çizim sırasıyla."""
    agac = ET.parse(yol)
    kok = agac.getroot()
    degradeler = {}
    for el in kok.iter():
        if el.tag in (SVGNS + "linearGradient", SVGNS + "radialGradient"):
            degradeler[el.get("id")] = el
    nesne = {}
    for k, el in degradeler.items():
        nesne[k] = None
    # Miras sırası önemli değil: iki geçişte kur
    for _ in range(2):
        for k, el in degradeler.items():
            nesne[k] = Degrade(el, nesne)
    out = []

    def gez(el, ctm, saydam):
        if el.tag in (SVGNS + "defs", SVGNS + "linearGradient", SVGNS + "radialGradient"):
            return
        ctm = carp(ctm, donusum(el.get("transform")))
        saydam *= float(el.get("opacity", "1"))
        if el.tag == SVGNS + "path":
            out.append((el, ctm, saydam))
        for c in el:
            gez(c, ctm, saydam)

    gez(kok, BIRIM, 1.0)
    return kok, out, nesne


def egri_orani(liste):
    """Dolgulu yolların kenarlarında eğri payı: eğri (Q, C, S, T) / bütün kenarlar (L, H, V dahil)."""
    egri = duz = 0
    adim = {"Q": 4, "T": 2, "C": 6, "S": 4, "L": 2, "H": 1, "V": 1}
    for el, _, _ in liste:
        if el.get("fill", "#000000") == "none":
            continue
        for komut, arg in re.findall(r"([MLHVQTCSZmlhvqtcsz])([^MLHVQTCSZmlhvqtcsz]*)", el.get("d", "")):
            k = komut.upper()
            if k not in adim:
                continue
            n = len(re.findall(r"-?\d*\.?\d+(?:[eE][-+]?\d+)?", arg)) // adim[k]
            if k in "QTCS":
                egri += n
            else:
                duz += n
    return egri / (egri + duz) if egri + duz else None


def svg_olc(yol):
    kok, liste, degradeler = ogeler(yol)
    dolgu = kontur = 0
    kalinliklar = []
    deg_say = Counter()
    durak_say = Counter()
    farklar_v, farklar_s = [], []
    yonler = Counter()
    for el, ctm, _ in liste:
        f = el.get("fill", "#000000")
        s = el.get("stroke", "none")
        if f != "none":
            dolgu += 1
            m = re.match(r"url\(#([^)]+)\)", f)
            if m and m.group(1) in degradeler:
                d = degradeler[m.group(1)]
                deg_say[d.tur] += 1
                durak_say[len(d.duraklar)] += 1
                dv, ds = d.uc_farki()
                farklar_v.append(dv)
                farklar_s.append(ds)
                y = yon_adi(d.yon(ctm))
                if y:
                    yonler[y] += 1
        if s != "none":
            kontur += 1
            kalinliklar.append(round(float(el.get("stroke-width", "1")) * olcek(ctm), 3))
    alan = palet_alanlari(yol, liste, degradeler)
    toplam_deg = sum(deg_say.values())
    return {
        "dolgu_grubu": dolgu,
        "kontur": kontur,
        "kontur_kalinliklari": sorted(Counter(kalinliklar).items()),
        "egri_orani": y4(egri_orani(liste)),
        "degrade": toplam_deg,
        "degrade_orani": y4(toplam_deg / dolgu) if dolgu else 0,
        "degrade_turleri": dict(sorted(deg_say.items())),
        "durak_sayilari": dict(sorted(durak_say.items())),
        "degrade_v_farki_medyan": y4(statistics.median(farklar_v)) if farklar_v else None,
        "degrade_v_farki_ceyrek": [y4(x) for x in statistics.quantiles(farklar_v, n=4)] if len(farklar_v) > 1 else None,
        "degrade_s_farki_medyan": y4(statistics.median(farklar_s)) if farklar_s else None,
        "degrade_yonleri": dict(sorted(yonler.items())),
        "degrade_v_farklari": [y4(x) for x in farklar_v],
        "palet": alan,
    }


def palet_alanlari(yol, liste, degradeler):
    """Her dolgu ve konturun görünen alanı (öndekiler arkadakini örter): her öğe tek bir kimlik
    rengiyle boyanıp motorla çizilir, pikseller sayılır. Renk kodu → görünen alan oranı."""
    kok = ET.parse(yol).getroot()
    sira = []
    kimlik = {}
    sayac = 0
    yollar = list(kok.iter(SVGNS + "path"))
    for el in yollar:
        for ozellik in ("fill", "stroke"):
            v = el.get(ozellik, "#000000" if ozellik == "fill" else "none")
            if v == "none":
                continue
            sayac += 1
            renk = "#%06X" % (sayac * 2654435761 % 0xFFFFFF)
            while renk in kimlik:
                sayac += 1
                renk = "#%06X" % (sayac * 2654435761 % 0xFFFFFF)
            kimlik[renk] = v
            el.set(ozellik, renk)
            for k in ("fill-opacity", "stroke-opacity", "opacity"):
                if k in el.attrib:
                    del el.attrib[k]
            sira.append(renk)
    for g in kok.iter(SVGNS + "g"):
        if "opacity" in g.attrib:
            del g.attrib["opacity"]
    with tempfile.TemporaryDirectory() as td:
        sv = os.path.join(td, "k.svg")
        ET.register_namespace("", "http://www.w3.org/2000/svg")
        ET.register_namespace("xlink", "http://www.w3.org/1999/xlink")
        ET.ElementTree(kok).write(sv)
        pn = os.path.join(td, "k.png")
        ciz(sv, pn)
        im = Image.open(pn).convert("RGBA")
    say = Counter()
    for n, (r, g, b, a) in im.getcolors(maxcolors=im.width * im.height):
        if a == 255:
            say["#%02X%02X%02X" % (r, g, b)] += n
    toplam = sum(n for k, n in say.items() if k in kimlik) or 1
    alanlar = Counter()
    for k, n in say.items():
        if k in kimlik:
            v = kimlik[k]
            m = re.match(r"url\(#([^)]+)\)", v)
            if m and m.group(1) in degradeler:
                d = degradeler[m.group(1)]
                v = "degrade " + "→".join(x[1] for x in d.duraklar)
            alanlar[v.upper() if not v.startswith("degrade") else v] += n
    return [[k, y4(n / toplam)] for k, n in sorted(alanlar.items(), key=lambda x: (-x[1], x[0]))]


# --- PNG ölçümü ------------------------------------------------------------------------------

def png_olc(svg_yolu):
    with tempfile.TemporaryDirectory() as td:
        pn = os.path.join(td, "c.png")
        ciz(svg_yolu, pn)
        im = Image.open(pn).convert("RGBA")
    s_top = v_top = 0.0
    n = 0
    cok_doygun = 0
    kutular = Counter()
    for say, (r, g, b, a) in im.getcolors(maxcolors=im.width * im.height):
        if a != 255:
            continue
        h, s, v = colorsys.rgb_to_hsv(r / 255, g / 255, b / 255)
        n += say
        s_top += s * say
        v_top += v * say
        if s > 0.85 and v > 0.6:
            cok_doygun += say
        kutular[(r >> 3, g >> 3, b >> 3)] += say
    en_buyuk = []
    for (r, g, b), say in kutular.most_common(5):
        rr, gg, bb = (r << 3) + 4, (g << 3) + 4, (b << 3) + 4
        h, s, v = colorsys.rgb_to_hsv(rr / 255, gg / 255, bb / 255)
        en_buyuk.append({"renk": "#%02X%02X%02X" % (rr, gg, bb), "alan": y4(say / n), "doygunluk": y4(s)})
    return {
        "opak_piksel": n,
        "ortalama_doygunluk": y4(s_top / n) if n else None,
        "ortalama_parlaklik": y4(v_top / n) if n else None,
        "cok_doygun_orani": y4(cok_doygun / n) if n else None,
        "en_buyuk_5_renk": en_buyuk,
    }


# --- Cetvel (işaret koymak için) -------------------------------------------------------------

def cetvel(svg_yolu, cikti, boy=1400):
    """Figürü `boy` piksel yüksekliğe büyütür; %5'lik yatay ve dikey cetvel çizgileri ekler.
    Koordinatlar görüntü yüksekliğinin yüzdesidir (sol üst 0, 0)."""
    w, h = svg_boyu(svg_yolu)
    s = boy / h
    with tempfile.TemporaryDirectory() as td:
        pn = os.path.join(td, "c.png")
        ciz(svg_yolu, pn, s, "#FFFFFF")
        im = Image.open(pn).convert("RGB")
    kenar = 60
    tuval = Image.new("RGB", (im.width + 2 * kenar, im.height + 2 * kenar), (255, 255, 255))
    tuval.paste(im, (kenar, kenar))
    d = ImageDraw.Draw(tuval)
    font = ImageFont.truetype(YAZI, 18)
    adim = im.height / 20
    for i in range(0, 21):
        y = kenar + i * adim
        d.line([(kenar, y), (kenar + im.width, y)], fill=(255, 0, 0) if i % 2 == 0 else (255, 150, 150), width=1)
        d.text((4, y - 10), f"{i * 5}", font=font, fill=(200, 0, 0))
    i = 0
    while kenar + i * adim <= kenar + im.width + 0.5:
        x = kenar + i * adim
        d.line([(x, kenar), (x, kenar + im.height)], fill=(0, 0, 255) if i % 2 == 0 else (150, 150, 255), width=1)
        d.text((x - 8, 4), f"{i * 5}", font=font, fill=(0, 0, 200))
        i += 1
    tuval.save(cikti)
    return cikti


def levha(cikti, figurler, boy=900):
    """Yan yana karşılaştırma levhası. `figurler`: [(etiket, svg yolu, (tepe_y, taban_y) svg biriminde)].
    Her figür, baş tepesinden tabana `boy` piksel olacak biçimde çizilir; tepeler ve tabanlar aynı
    hizaya gelir. Figür boyunun %5'i aralıklarla yatay (kırmızı) ve dikey (mavi) cetvel çizgileri."""
    resimler = []
    with tempfile.TemporaryDirectory() as td:
        for i, (etiket, yol, (tepe, taban)) in enumerate(figurler):
            olc = boy / (taban - tepe)
            pn = os.path.join(td, f"{i}.png")
            ciz(yol, pn, olc, "#FFFFFF")
            resimler.append((etiket, Image.open(pn).convert("RGB"), tepe * olc))
    ust_pay = max(t for _, _, t in resimler) + 50
    alt_pay = max(im.height - t - boy for _, im, t in resimler) + 40
    kenar, ara_ = 60, 40
    gen = kenar + sum(im.width for _, im, _ in resimler) + ara_ * (len(resimler) - 1) + 20
    tuval = Image.new("RGB", (int(gen), int(ust_pay + boy + alt_pay)), (255, 255, 255))
    d = ImageDraw.Draw(tuval)
    font = ImageFont.truetype(YAZI, 20)
    x = kenar
    for etiket, im, tepe in resimler:
        tuval.paste(im, (int(x), int(ust_pay - tepe)))
        d.text((x, 8), etiket, font=font, fill=(0, 0, 0))
        x += im.width + ara_
    adim = boy / 20
    for i in range(21):
        yy = ust_pay + i * adim
        d.line([(kenar, yy), (gen - 10, yy)], fill=(255, 0, 0) if i % 2 == 0 else (255, 160, 160), width=1)
        d.text((6, yy - 11), f"{i * 5}", font=font, fill=(200, 0, 0))
    i = 0
    while kenar + i * adim < gen - 10:
        xx = kenar + i * adim
        d.line([(xx, ust_pay), (xx, ust_pay + boy)], fill=(0, 0, 255) if i % 2 == 0 else (170, 170, 255), width=1)
        i += 1
    tuval.save(cikti)
    return cikti


def referans_boyu(ad):
    """Referans figürün baş tepesi ve tabanı (SVG biriminde), isaretler.json'dan."""
    with open(os.path.join(KOK, "olcum", "isaretler.json"), encoding="utf-8") as f:
        isaret = json.load(f)["figurler"][ad]
    oyun, no = ad.split("/")
    yol = os.path.join(KOK, "referans", oyun, "svg", f"{no}.svg")
    h = svg_boyu(yol)[1]
    return yol, (isaret["bas_tepesi"][1] / 100 * h, isaret["taban"][1] / 100 * h)


def iskelet_boyu(iskelet_yolu):
    """Bizim çizimin baş tepesi ve tabanı (SVG biriminde): iskeletteki işaretler + kaydırma."""
    with open(iskelet_yolu, encoding="utf-8") as f:
        isk = json.load(f)
    dy = isk.get("kaydirma", [0, 0])[1]
    return isk["isaret"]["bas_tepesi"][1] + dy, isk["isaret"]["taban"][1] + dy


# --- İşaretler ve oranlar --------------------------------------------------------------------

def isaret_oranlari(f):
    """İşaretlerden oranlar. Koordinatlar görüntü yüksekliğinin yüzdesi (x, y). Yarım boy figürlerde
    (tam_boy: false) yalnızca baş, omuz, el ve silah oranları hesaplanır."""
    ust, cene = f["bas_tepesi"][1], f["cene"][1]
    bas = cene - ust
    o = {}
    omuz = abs(f["omuz_sag"][0] - f["omuz_sol"][0])
    o["omuz_bas"] = y4(omuz / bas)
    if f.get("tam_boy", True):
        taban = f["taban"][1]
        boy = taban - ust
        o["bas_sayisi"] = y4(boy / bas)
        o["bacak_boy"] = y4((taban - f["kasik"][1]) / boy)
        o["omuz_boy"] = y4(omuz / boy)
        o["bel_boy"] = y4((f["bel"][1] - ust) / boy)
        o["diz_boy"] = y4((statistics.mean(k[1] for k in f["dizler"]) - ust) / boy)
    eller = f.get("el_kutulari", [])
    if eller:
        el_boy = max(max(k[2] - k[0], k[3] - k[1]) for k in eller)
        if f.get("tam_boy", True):
            o["el_boy"] = y4(el_boy / boy)
        o["el_yuz"] = y4(el_boy / bas)
        poz = poz_isaretten(f)
        if poz:
            o["asimetri"] = y4(asimetri(poz))
    eks = f.get("silah_ekseni")
    if eks:
        (x1, y1), (x2, y2) = eks
        a = math.degrees(math.atan2(-(y2 - y1), x2 - x1)) % 180
        o["silah_acisi"] = y4(min(a, 180 - a))
        if eller:
            o["sap_elden_gecer"] = any(dogru_kutudan_gecer((x1, y1), (x2, y2), k) for k in eller)
    return o


def dogru_kutudan_gecer(p, q, kutu):
    """Sonsuz doğru (p, q) kutunun içinden geçiyor mu?"""
    x0, y0, x1, y1 = kutu
    koseler = [(x0, y0), (x1, y0), (x1, y1), (x0, y1)]
    dx, dy = q[0] - p[0], q[1] - p[1]
    isaretler = [math.copysign(1, dx * (c[1] - p[1]) - dy * (c[0] - p[0])) for c in koseler]
    return min(isaretler) != max(isaretler)


# --- Poz özgünlüğü ---------------------------------------------------------------------------
#
# Bir poz, uzuvlarının yönleriyle tanımlanır: gövde (kasık→boyun), iki kolun üst ve ön kolu, iki
# bacağın uyluk ve baldırı, silah. Yönler oranlardan bağımsızdır: bacakları uzun bir figür, esinin bir
# karesindeki açıları aynen kullanırsa yine "aynı poz" sayılır. İki poz karşılaştırılırken en elverişli
# eşleşme aranır (ayna, kolların ve bacakların yer değiştirmesi); yani uzaklık, iki poz üst üste en iyi
# nasıl oturuyorsa o hâliyle ölçülür.

def aci(p, q):
    return math.degrees(math.atan2(q[1] - p[1], q[0] - p[0]))


def kutu_merkezi(k):
    return ((k[0] + k[2]) / 2, (k[1] + k[3]) / 2)


def poz_isaretten(f):
    """İşaret kaydından (isaretler.json biçimi) uzuv yönleri. Yarım boy figürlerde None."""
    if not f.get("tam_boy", True):
        return None
    eller = [kutu_merkezi(k) for k in f.get("el_kutulari", [])]
    kollar = []
    for omuz, dirsek in zip(sorted([f["omuz_sol"], f["omuz_sag"]]), sorted(f["dirsekler"])):
        el = min(eller, key=lambda e: math.dist(e, dirsek)) if eller else None
        if el is not None and len(eller) < 2 and any(math.dist(el, d) < math.dist(el, dirsek) for d in f["dirsekler"] if d != dirsek):
            el = None
        kollar.append((aci(omuz, dirsek), aci(dirsek, el) if el else None))
    bacaklar = [(aci(f["kasik"], diz), aci(diz, ayak)) for diz, ayak in zip(sorted(f["dizler"]), sorted(f["ayaklar"]))]
    silah = None
    if f.get("silah_ekseni"):
        silah = aci(*f["silah_ekseni"]) % 180
    return {"govde": aci(f["kasik"], f["cene"]), "kol": kollar, "bacak": bacaklar, "silah": silah}


def poz_kukladan(kare, yapi):
    """Savaş kuklasının bir karesinden (pozlar.json) uzuv yönleri."""
    e = kare["eklem"]
    kutu = {p["ad_tr"]: p["yerel_kutu_bas"] for p in yapi["parcalar"] if "yerel_kutu_bas" in p}

    def nokta(ad):
        return (e[ad][0], e[ad][1])

    def uc(ad, geri):
        x, y, _a, ux, uy = e[ad]
        L = kutu[ad][3] - geri
        return (x + ux * L, y + uy * L)
    kalca = ((e["uyluk_on"][0] + e["uyluk_arka"][0]) / 2, (e["uyluk_on"][1] + e["uyluk_arka"][1]) / 2)
    kollar = [(aci(nokta(f"ust_kol_{t}"), nokta(f"on_kol_{t}")), aci(nokta(f"on_kol_{t}"), uc(f"on_kol_{t}", 0.3)))
              for t in ("on", "arka") if f"ust_kol_{t}" in e and f"on_kol_{t}" in e]
    bacaklar = [(aci(nokta(f"uyluk_{t}"), nokta(f"baldir_{t}")), aci(nokta(f"baldir_{t}"), uc(f"baldir_{t}", 0.15)))
                for t in ("on", "arka") if f"uyluk_{t}" in e and f"baldir_{t}" in e]
    return {"govde": aci(kalca, nokta("bas")) if "bas" in e else None, "kol": kollar, "bacak": bacaklar, "silah": None}


def aci_farki(a, b, yari=False):
    d = abs(a - b) % (180 if yari else 360)
    return min(d, (180 if yari else 360) - d)


def aynala(p):
    def m(a):
        return None if a is None else (180 - a) % 360
    return {"govde": m(p["govde"]), "kol": [(m(u), m(o)) for u, o in p["kol"]],
            "bacak": [(m(u), m(o)) for u, o in p["bacak"]],
            "silah": None if p["silah"] is None else (180 - p["silah"]) % 180}


def en_iyi_eslesme(a, b):
    """İki poz en iyi nasıl üst üste oturuyor: (ortalama açı farkı, b'nin o eşleşmedeki hâli)."""
    en_iyi = None
    for bb in (b, aynala(b)):
        for kol_sira in ((0, 1), (1, 0)):
            for bacak_sira in ((0, 1), (1, 0)):
                farklar = []
                if a["govde"] is not None and bb["govde"] is not None:
                    farklar.append(aci_farki(a["govde"], bb["govde"]))
                for grup, sira in (("kol", kol_sira), ("bacak", bacak_sira)):
                    if len(a[grup]) == 2 and len(bb[grup]) == 2:
                        for i, j in zip((0, 1), sira):
                            for x, y in zip(a[grup][i], bb[grup][j]):
                                if x is not None and y is not None:
                                    farklar.append(aci_farki(x, y))
                if a["silah"] is not None and bb["silah"] is not None:
                    farklar.append(aci_farki(a["silah"], bb["silah"], yari=True))
                if farklar:
                    d = sum(farklar) / len(farklar)
                    if en_iyi is None or d < en_iyi[0]:
                        def sirala(g, sira):
                            return [bb[g][j] for j in sira] if len(bb[g]) == 2 else bb[g]
                        en_iyi = (d, {"govde": bb["govde"], "kol": sirala("kol", kol_sira),
                                      "bacak": sirala("bacak", bacak_sira), "silah": bb["silah"]})
    return en_iyi


def poz_uzakligi(a, b):
    """İki pozun uzuv yönleri arasındaki ortalama açı farkı (derece); en elverişli eşleşmeyle."""
    e = en_iyi_eslesme(a, b)
    return None if e is None else e[0]


def cop_adam(p, olcek=100.0, merkez=(0.0, 0.0)):
    """Pozun uzuv yönlerinden çöp adam çizgileri (kalça merkezde; gövde 1, üst kol 0,55, ön kol 0,5,
    uyluk ve baldır 0,75). Dönen: [(nokta1, nokta2)] piksel."""
    def ileri(q, aci_, uz):
        return (q[0] + math.cos(math.radians(aci_)) * uz * olcek, q[1] + math.sin(math.radians(aci_)) * uz * olcek)
    kalca = merkez
    boyun = ileri(kalca, p["govde"] if p["govde"] is not None else -90, 1.0)
    cizgiler = [(kalca, boyun)]
    eller = []
    for ust, alt in p["kol"]:
        dirsek = ileri(boyun, ust, 0.55)
        cizgiler.append((boyun, dirsek))
        if alt is not None:
            el_ = ileri(dirsek, alt, 0.5)
            cizgiler.append((dirsek, el_))
            eller.append(el_)
    for ust, alt in p["bacak"]:
        diz = ileri(kalca, ust, 0.75)
        cizgiler += [(kalca, diz), (diz, ileri(diz, alt, 0.75))]
    if p["silah"] is not None and eller:
        m = (sum(e[0] for e in eller) / len(eller), sum(e[1] for e in eller) / len(eller))
        a = -p["silah"]  # silah açısı yataydan yukarı; ekranda y aşağı
        cizgiler.append((ileri(m, a, -0.8), ileri(m, a, 0.8)))
    return cizgiler


def ortusme_cizimi(cikti, poz, adet=3):
    """Pozu en yakın `adet` referansla üst üste çizer: bizim (kırmızı) ve referans (mavi)."""
    yakinlar = sorted(((en_iyi_eslesme(poz, p), ad) for ad, p in referans_pozlar()), key=lambda x: x[0][0])[:adet]
    pan = 320
    tuval = Image.new("RGB", (pan * adet, pan + 40), (255, 255, 255))
    d = ImageDraw.Draw(tuval)
    font = ImageFont.truetype(YAZI, 16)
    for i, ((uz, eslesen), ad) in enumerate(yakinlar):
        m = (i * pan + pan / 2, pan * 0.55)
        for renk, q, kalin in (((60, 90, 230), eslesen, 7), ((220, 30, 30), poz, 3)):
            for a, b in cop_adam(q, 105, m):
                d.line([a, b], fill=renk, width=kalin)
        d.text((i * pan + 10, pan + 4), f"{ad}: {uz:.1f}°", font=font, fill=(0, 0, 0))
    d.text((10, 6), "kırmızı: bizim poz   mavi: esinin en yakın pozu", font=font, fill=(0, 0, 0))
    tuval.save(cikti)
    return cikti


def asimetri(p):
    """Pozun önden simetrik duruştan farkı (derece): sol uzuvlar sağdakilerin aynasıyla, gövde dikeyle
    karşılaştırılır. 0 = tam simetrik, önden duruş."""
    farklar = []
    if p["govde"] is not None:
        farklar.append(aci_farki(p["govde"], -90))
    for grup in ("kol", "bacak"):
        if len(p[grup]) == 2:
            for x, y in zip(p[grup][0], p[grup][1]):
                if x is not None and y is not None:
                    farklar.append(aci_farki(x, (180 - y) % 360))
    return sum(farklar) / len(farklar) if farklar else 0.0


def referans_pozlar():
    """Bütün referans pozlar: (ad, poz). Kahraman çizimleri (isaretler.json) ve iki oyunun bütün
    kukla kareleri (referans/<oyun>/pozlar.json; yoksa atlanır)."""
    out = []
    with open(os.path.join(KOK, "olcum", "isaretler.json"), encoding="utf-8") as f:
        for ad, isaret in json.load(f)["figurler"].items():
            p = poz_isaretten(isaret)
            if p:
                out.append((ad, p))
    for oyun in ("f1", "f2"):
        yol = os.path.join(KOK, "referans", oyun, "pozlar.json")
        if not os.path.exists(yol):
            continue
        with open(os.path.join(KOK, "olcum", f"kukla-{oyun}.json"), encoding="utf-8") as f:
            yapi = json.load(f)
        with open(yol, encoding="utf-8") as f:
            for kare in json.load(f):
                out.append((f"{oyun} kukla kare {kare['kare']} ({kare.get('etiket')})", poz_kukladan(kare, yapi)))
    return out


def ortusme_esigi():
    """Eşik: esinin kahraman çizimlerinde birbirine en çok benzeyen iki farklı pozun uzaklığı.
    Bizim pozumuz hiçbir referansa bundan daha yakın olmamalı."""
    with open(os.path.join(KOK, "olcum", "isaretler.json"), encoding="utf-8") as f:
        pozlar = [(ad, poz_isaretten(v)) for ad, v in json.load(f)["figurler"].items()]
    pozlar = [(a, p) for a, p in pozlar if p]
    en = None
    for i, (a, p) in enumerate(pozlar):
        for b, q in pozlar[i + 1:]:
            d = poz_uzakligi(p, q)
            if en is None or d < en[0]:
                en = (d, a, b)
    return en


def ortusme(poz, adet=5):
    """Bir pozun en yakın referansları ve eşiği geçip geçmediği."""
    esik, a, b = ortusme_esigi()
    yakinlar = sorted(((poz_uzakligi(poz, p), ad) for ad, p in referans_pozlar()), key=lambda x: x[0])
    return {"esik_derece": y4(esik), "esik_kaynagi": f"{a} ile {b}",
            "en_yakinlar": [[ad, y4(d)] for d, ad in yakinlar[:adet]],
            "gecti": yakinlar[0][0] >= esik}


# --- Rapor: referans kümeleri ---------------------------------------------------------------

# Referans kümeleri (dosya numaraları FFDec şekil kimlikleridir; bkz. cikar.sh). F2'deki 1991–2003 ve
# 2013 kahramanları F1'dekilerin kopyasıdır; sayılmaz. Kahraman ve kasaba
# figürleri tam boy çizimdir; portreler yalnızca baş-omuz; kukla savaştaki parçalı figürdür.
KUMELER = {
    "kahraman": [("f1", i) for i in (1104, 1106, 1108, 1110, 1112, 1114, 1116, 1118)]
    + [("f2", i) for i in (2005, 2007, 2011)],
    # F2'nin 2796, 2797, 2799, 2820 şekilleri F1'deki 1861, 1862, 1864, 1881'in kopyasıdır; sayılmaz.
    "kasaba": [("f1", i) for i in (1180, 1861, 1862, 1863, 1864, 1881)] + [("f2", 2800)],
    "portre": [("f1", i) for i in range(208, 215)] + [("f2", i) for i in (443, 444, 446)],
    "kukla": "birlikler",
}
KUME_ADLARI = {"kahraman": "Kahraman (tam boy)", "kasaba": "Kasaba figürü (tam boy)",
               "portre": "Portre (baş-omuz)", "kukla": "Savaş kuklası"}
# Rapor tablosundaki ölçütler: (anahtar, açıklama)
OLCUTLER = [
    ("dolgu_grubu", "Dolgu grubu sayısı"),
    ("kontur", "Kontur (çizgi) sayısı"),
    ("en_kalin_kontur", "En kalın kontur (çizim birimi)"),
    ("palet_boyu", "Ayrı dolgu rengi / degradesi"),
    ("egri_orani", "Kenarlarda eğri payı"),
    ("degrade_orani", "Degradeli dolgu oranı"),
    ("dairesel_degrade", "Dairesel degrade sayısı"),
    ("iki_durakli_orani", "Degradelerde 2 duraklı oranı"),
    ("degrade_v_farki_medyan", "Degrade uçları parlaklık farkı ΔV (ortanca)"),
    ("degrade_s_farki_medyan", "Degrade uçları doygunluk farkı ΔS (ortanca)"),
    ("ortalama_doygunluk", "Ortalama doygunluk (opak piksel)"),
    ("ortalama_parlaklik", "Ortalama parlaklık (opak piksel)"),
    ("cok_doygun_orani", "Çok doygun piksel oranı (S>0,85, V>0,6)"),
    ("genis_alan_doygunlugu", "Geniş alanların doygunluğu (alanı ≥%5 renkler, alan ağırlıklı)"),
    ("en_doygun_genis_alan", "En doygun geniş alan (alanı ≥%5)"),
    ("doygun_alan", "Doygun renklerin (S>0,7, V>0,4) toplam alanı"),
    ("doygun_aile", "Doygun renk ailesi sayısı (30°'lik ton dilimi, alanı ≥%2)"),
    ("saf_ana_renk_alani", "Saf ana renk alanı (S≥0,95, V≥0,95)"),
]


def kume_dosyalari(kume):
    tanim = KUMELER[kume]
    if tanim == "birlikler":
        out = []
        for oyun in ("f1", "f2"):
            d = os.path.join(KOK, "referans", oyun, "birlikler")
            out += [(f"{oyun}/{os.path.splitext(a)[0]}", os.path.join(d, a)) for a in sorted(os.listdir(d)) if a.endswith(".svg")]
        return out
    return [(f"{o}/{i}", os.path.join(KOK, "referans", o, "svg", f"{i}.svg")) for o, i in tanim]


def renk_doygunlugu(ad):
    """Palet girdisinin doygunluğu: düz renk ya da degrade uçlarının ortalaması."""
    renkler = re.findall(r"#[0-9A-Fa-f]{6}", ad)
    return statistics.mean(hsv(r)[1] for r in renkler) if renkler else 0.0


def renk_payi(palet):
    """Palet girdilerini tek tek renklere böler: [(renk, alan payı)]. Degradenin alanı uçlarına eşit
    bölünür."""
    out = []
    for ad, alan in palet:
        renkler = re.findall(r"#[0-9A-Fa-f]{6}", ad)
        out += [(r.upper(), alan / len(renkler)) for r in renkler]
    return out


def doygunluk_olculeri(palet):
    """Doygun alan, doygun renk ailesi sayısı, saf ana renk alanı."""
    doygun = 0.0
    aileler = Counter()
    saf = 0.0
    for r, a in renk_payi(palet):
        h, s, v = hsv(r)
        if s > 0.7 and v > 0.4:
            doygun += a
            aileler[int((h * 360 + 15) // 30) % 12] += a
        if s >= 0.95 and v >= 0.95:
            saf += a
    return {"doygun_alan": y4(doygun), "doygun_aile": sum(1 for a in aileler.values() if a >= 0.02),
            "saf_ana_renk_alani": y4(saf)}


def ozet(yol):
    """Bir çizimin bütün ölçütleri (rapor ve karşılaştırma için düz sözlük)."""
    s = svg_olc(yol)
    p = png_olc(yol)
    deg = s["degrade"]
    genis = [(ad, a) for ad, a in s["palet"] if a >= 0.05]
    ga = sum(a for _, a in genis)
    return {
        "dolgu_grubu": s["dolgu_grubu"],
        "kontur": s["kontur"],
        "en_kalin_kontur": max((k for k, _ in s["kontur_kalinliklari"]), default=0),
        "palet_boyu": len(s["palet"]),
        "egri_orani": s["egri_orani"],
        "degrade_orani": s["degrade_orani"],
        "dairesel_degrade": s["degrade_turleri"].get("dairesel", 0),
        "iki_durakli_orani": y4(s["durak_sayilari"].get(2, 0) / deg) if deg else None,
        "degrade_v_farki_medyan": s["degrade_v_farki_medyan"],
        "degrade_s_farki_medyan": s["degrade_s_farki_medyan"],
        "ortalama_doygunluk": p["ortalama_doygunluk"],
        "ortalama_parlaklik": p["ortalama_parlaklik"],
        "cok_doygun_orani": p["cok_doygun_orani"],
        "genis_alan_doygunlugu": y4(sum(renk_doygunlugu(ad) * a for ad, a in genis) / ga) if ga else None,
        "en_doygun_genis_alan": y4(max((renk_doygunlugu(ad) for ad, _ in genis), default=0)),
        **doygunluk_olculeri(s["palet"]),
        "degrade_yonleri": s["degrade_yonleri"],
        "degrade_v_farklari": s.get("degrade_v_farklari", []),
        "palet": s["palet"],
        "en_buyuk_5_renk": p["en_buyuk_5_renk"],
    }


def dagilim(degerler):
    d = [v for v in degerler if v is not None]
    if not d:
        return None
    q = statistics.quantiles(d, n=4, method="inclusive") if len(d) > 1 else [d[0]] * 3
    return {"en_kucuk": y4(min(d)), "ceyrek_1": y4(q[0]), "ortanca": y4(statistics.median(d)), "ceyrek_3": y4(q[2]),
            "en_buyuk": y4(max(d)), "sayi": len(d)}


def rapor():
    sonuc = {"aciklama": "olcum.py rapor çıktısı; elle değiştirmeyin", "kumeler": {}}
    for kume in KUMELER:
        figurler = {ad: ozet(yol) for ad, yol in kume_dosyalari(kume)}
        yonler = Counter()
        v_farklari = []
        for f in figurler.values():
            yonler.update(f["degrade_yonleri"])
            v_farklari += f["degrade_v_farklari"]
        sonuc["kumeler"][kume] = {
            "ad": KUME_ADLARI[kume],
            "dagilim": {k: dagilim(f[k] for f in figurler.values()) for k, _ in OLCUTLER},
            "degrade_yonleri_toplam": dict(sorted(yonler.items())),
            "degrade_v_farki_tumu": {"ortanca": y4(statistics.median(v_farklari)),
                                     "ceyrekler": [y4(x) for x in statistics.quantiles(v_farklari, n=4)]}
            if len(v_farklari) > 1 else None,
            "figurler": {ad: {k: v for k, v in f.items() if k not in ("degrade_v_farklari",)} for ad, f in figurler.items()},
        }
    isaret_yolu = os.path.join(KOK, "olcum", "isaretler.json")
    if os.path.exists(isaret_yolu):
        with open(isaret_yolu, encoding="utf-8") as f:
            isaret = json.load(f)
        oranlar = {ad: isaret_oranlari(v) for ad, v in isaret["figurler"].items()}
        for kume, k in sonuc["kumeler"].items():
            kendi = {ad: o for ad, o in oranlar.items() if ad in k["figurler"]}
            if kendi:
                anahtarlar = sorted({a for o in kendi.values() for a, v in o.items() if isinstance(v, (int, float)) and not isinstance(v, bool)})
                k["isaret_oranlari"] = {"figurler": kendi, "dagilim": {a: dagilim(o.get(a) for o in kendi.values()) for a in anahtarlar}}
    os.makedirs(os.path.join(KOK, "olcum"), exist_ok=True)
    with open(os.path.join(KOK, "olcum", "sonuclar.json"), "w", encoding="utf-8") as f:
        json.dump(sonuc, f, ensure_ascii=False, indent=1)
        f.write("\n")
    with open(os.path.join(KOK, "olcum", "sonuclar.md"), "w", encoding="utf-8") as f:
        f.write(rapor_md(sonuc))
    return sonuc


ORAN_ADLARI = {
    "bas_sayisi": "Boy (baş sayısı)", "omuz_bas": "Omuz genişliği / baş yüksekliği", "bacak_boy": "Bacak / boy (kasıktan tabana)", "omuz_boy": "Omuz genişliği / boy",
    "bel_boy": "Bel yüksekliği / boy (tepeden)", "diz_boy": "Diz yüksekliği / boy (tepeden)", "el_boy": "El (uzun kenar) / boy",
    "el_yuz": "El / yüz (tepe–çene)", "silah_acisi": "Silah açısı (yataydan, derece)",
    "asimetri": "Asimetri (önden simetrik duruştan uzuv açısı farkı, derece)",
}


def sayi(v):
    if v is None:
        return "–"
    if isinstance(v, float):
        return f"{v:.3f}".rstrip("0").rstrip(".").replace(".", ",")
    return str(v)


def aralik_md(d):
    return " | ".join(sayi(d.get(k)) for k in ("en_kucuk", "ceyrek_1", "ortanca", "ceyrek_3", "en_buyuk"))


def rapor_md(sonuc):
    s = ["# Ölçüm sonuçları", "",
         "`python3 araclar/olcum/olcum.py rapor` ile üretilir; elle değiştirmeyin. Referans çizimler",
         "depoda yoktur; burada yalnızca sayılar ve renk kodları vardır. Her ölçüt için kümedeki en küçük,",
         "çeyrekler, ortanca ve en büyük değer verilir. Bizim çizimlerimiz için geçme aralığı 1. ile 3. çeyrek",
         "arasıdır (referansların orta yarısı): uç örneklere değil tipik figüre benzemek gerekir.", ""]
    for kume, k in sonuc["kumeler"].items():
        s += [f"## {k['ad']}", "", f"Figürler: {', '.join(k['figurler'])}", "",
              "| Ölçüt | En küçük | 1. çeyrek | Ortanca | 3. çeyrek | En büyük |", "|---|---|---|---|---|---|"]
        for anahtar, aciklama in OLCUTLER:
            d = k["dagilim"][anahtar]
            if d:
                s.append(f"| {aciklama} | {aralik_md(d)} |")
        s.append("")
        if k["degrade_yonleri_toplam"]:
            toplam = sum(k["degrade_yonleri_toplam"].values())
            yon = ", ".join(f"{a}: {n} (%{round(100 * n / toplam)})" for a, n in
                            sorted(k["degrade_yonleri_toplam"].items(), key=lambda x: -x[1]))
            s += [f"Doğrusal degrade yönleri (açıktan koyuya, toplam {toplam}): {yon}.", ""]
        if k["degrade_v_farki_tumu"]:
            q = k["degrade_v_farki_tumu"]["ceyrekler"]
            s += [f"Bütün degradelerde ΔV: ortanca {sayi(k['degrade_v_farki_tumu']['ortanca'])}, "
                  f"çeyrekler arası {sayi(q[0])}–{sayi(q[2])}.", ""]
        if "isaret_oranlari" in k:
            s += ["İşaretlerden oranlar (`olcum/isaretler.json`):", "",
                  "| Oran | En küçük | 1. çeyrek | Ortanca | 3. çeyrek | En büyük |", "|---|---|---|---|---|---|"]
            for a, d in k["isaret_oranlari"]["dagilim"].items():
                if d:
                    s.append(f"| {ORAN_ADLARI.get(a, a)} | {aralik_md(d)} |")
            gecen = [ad for ad, o in k["isaret_oranlari"]["figurler"].items() if o.get("sap_elden_gecer")]
            silahli = [ad for ad, o in k["isaret_oranlari"]["figurler"].items() if "sap_elden_gecer" in o]
            if silahli:
                s += ["", f"Silah sapının ekseni el kutusundan geçiyor: {len(gecen)} / {len(silahli)} silahlı figür."]
            s.append("")
        s += ["Figür başına:", "", "| Figür | Dolgu | Kontur | Degrade | ΔV | Ort. S | Çok doygun | Geniş alan S |",
              "|---|---|---|---|---|---|---|---|"]
        for ad, f in k["figurler"].items():
            s.append(f"| {ad} | {f['dolgu_grubu']} | {f['kontur']} | {sayi(f['degrade_orani'])} | {sayi(f['degrade_v_farki_medyan'])} | "
                     f"{sayi(f['ortalama_doygunluk'])} | {sayi(f['cok_doygun_orani'])} | {sayi(f['genis_alan_doygunlugu'])} |")
        s.append("")
    return "\n".join(s)


# --- Karşılaştırma: bizim çizim ↔ referans kümesi ----------------------------------------------

# Bilgi için gösterilen, geçti/kaldı sayılmayan ölçütler (her değer kabul: aralık yalnızca bilgi)
YALNIZ_BILGI = {"silah_acisi", "dairesel_degrade"}
# Oyunun sahibinin kuralı, ölçülen orta yarıdan dar olduğunda geçme aralığı bu olur (bkz. docs/SANAT.md):
# en fazla bir vurgu rengi ailesi; degrade uçlarının ΔV'si sahibin 0,10–0,20'si ile ölçülen orta yarının
# kesişimi.
SAHIP_SINIRLARI = {"doygun_aile": (0, 1), "degrade_v_farki_medyan": (0.10, 0.18)}


def gecme_araligi(anahtar, d):
    return SAHIP_SINIRLARI.get(anahtar, (d["ceyrek_1"], d["ceyrek_3"]))


def karsilastir(svg_yolu, kume="kahraman", isaret=None):
    """Bizim çizimimizi bir referans kümesinin aralıklarıyla karşılaştırır. `isaret`: bizim çizimin
    işaret kaydı (isaretler.json biçimi; iskelet dosyasından). Satırlar: (ölçüt, aralık, bizim, geçti)."""
    with open(os.path.join(KOK, "olcum", "sonuclar.json"), encoding="utf-8") as f:
        k = json.load(f)["kumeler"][kume]
    bizim = ozet(svg_yolu)
    satirlar = []
    for anahtar, aciklama in OLCUTLER:
        d = k["dagilim"].get(anahtar)
        if not d or bizim.get(anahtar) is None:
            continue
        v = bizim[anahtar]
        alt, ust = gecme_araligi(anahtar, d)
        gecti = None if anahtar in YALNIZ_BILGI else alt <= v <= ust
        if anahtar in SAHIP_SINIRLARI:
            aciklama += f" (sahibin kuralı: {sayi(alt)}–{sayi(ust)})"
        satirlar.append((aciklama, d, v, gecti))
    if isaret:
        o = isaret_oranlari(isaret)
        dag = k.get("isaret_oranlari", {}).get("dagilim", {})
        for anahtar, v in o.items():
            if anahtar == "sap_elden_gecer":
                satirlar.append(("Silah sapının ekseni el kutusundan geçer", None, v, bool(v)))
            elif anahtar in dag and dag[anahtar]:
                d = dag[anahtar]
                gecti = None if anahtar in YALNIZ_BILGI else d["ceyrek_1"] <= v <= d["ceyrek_3"]
                satirlar.append((ORAN_ADLARI.get(anahtar, anahtar), d, v, gecti))
        poz = poz_isaretten(isaret)
        if poz:
            ort = ortusme(poz)
            en = ort["en_yakinlar"][0]
            satirlar.append((f"Poz özgünlüğü: en yakın referansa uzuv açısı farkı (en yakın: {en[0]}; "
                             f"eşik {sayi(ort['esik_derece'])}°, {ort['esik_kaynagi']})",
                             {"en_kucuk": ort["esik_derece"]}, en[1], ort["gecti"]))
    return satirlar


def karsilastirma_md(ad, satirlar):
    s = [f"| Ölçüt | Ref. en küçük | 1. çeyrek | Ortanca | 3. çeyrek | En büyük | {ad} | Sonuç |",
         "|---|---|---|---|---|---|---|---|"]
    for aciklama, d, v, gecti in satirlar:
        d = d or {}
        sonuc = "bilgi" if gecti is None else ("GEÇTİ" if gecti else "KALDI")
        s.append(f"| {aciklama} | {aralik_md(d)} | "
                 f"{sayi(v) if not isinstance(v, bool) else ('evet' if v else 'hayır')} | {sonuc} |")
    gecen = sum(1 for *_, g in satirlar if g)
    sayilan = sum(1 for *_, g in satirlar if g is not None)
    s += ["", f"Geçen: {gecen} / {sayilan}. Geçme aralığı 1. ile 3. çeyrek arası (referansların orta yarısı);",
          "poz özgünlüğünde eşik ve üstü."]
    return "\n".join(s)


# --- Komut satırı ---------------------------------------------------------------------------

def main(argv):
    if not argv:
        print(__doc__)
        return 1
    komut = argv[0]
    if komut == "svg":
        print(json.dumps({os.path.basename(y): svg_olc(y) for y in argv[1:]}, ensure_ascii=False, indent=1))
    elif komut == "png":
        print(json.dumps({os.path.basename(y): png_olc(y) for y in argv[1:]}, ensure_ascii=False, indent=1))
    elif komut == "cetvel":
        print(cetvel(argv[1], argv[2]))
    elif komut == "rapor":
        rapor()
        print("olcum/sonuclar.json, olcum/sonuclar.md yazıldı")
    elif komut == "karsilastir":
        # karsilastir <bizim.svg> [kume] [isaret.json]
        kume = argv[2] if len(argv) > 2 else "kahraman"
        isaret = None
        if len(argv) > 3:
            with open(argv[3], encoding="utf-8") as f:
                isaret = json.load(f)["isaret"]
        print(karsilastirma_md(os.path.basename(argv[1]), karsilastir(argv[1], kume, isaret)))
    elif komut == "levha":
        # levha <çıktı.png> <öğe>...; öğe: f1/1112 (referans) ya da cizim.svg:iskelet.json (bizim)
        figurler = []
        for oge in argv[2:]:
            if oge.endswith(".json"):
                svg, isk = oge.split(":")
                figurler.append((os.path.basename(svg), svg, iskelet_boyu(isk)))
            else:
                yol, tt = referans_boyu(oge)
                figurler.append((oge, yol, tt))
        print(levha(argv[1], figurler))
    elif komut == "ortusme":
        # ortusme <iskelet.json> [çizim.png]: bir pozun en yakın referansları (isteğe bağlı çizimle)
        with open(argv[1], encoding="utf-8") as f:
            poz = poz_isaretten(json.load(f)["isaret"])
        print(json.dumps(ortusme(poz, 10), ensure_ascii=False, indent=1))
        if len(argv) > 2:
            print(ortusme_cizimi(argv[2], poz))
    elif komut == "isaret":
        with open(os.path.join(KOK, "olcum", "isaretler.json"), encoding="utf-8") as f:
            isaret = json.load(f)
        print(json.dumps({k: isaret_oranlari(v) for k, v in isaret["figurler"].items()}, ensure_ascii=False, indent=1))
    else:
        print(__doc__)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
