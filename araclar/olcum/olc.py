"""Esin kaynağının birleştirilmiş birliklerinden karakter stil sayfasını ölçer.

Her birlik `birlikler.py` ile oyundaki donanım ve duruşla birleştirilir; sonra parçalar tek tek
ölçülür. Uzunluklar eklemden ekleme (dönme noktasından dönme noktasına) ölçüldüğü için duruştan
bağımsızdır. Sonuç `docs/KARAKTER_OLCULERI.md` dosyasına yazılır (yalnızca sayılar; esinin
çizimleri depoya girmez).

Kullanım: araclar/olcum/cikar.sh (FFDec çıkarımı, birleştirme ve bu ölçüm birlikte çalışır).
"""
import json
import math
import os
import re
import statistics
import sys
from collections import Counter

from PIL import Image, ImageDraw

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import birlikler as B  # noqa: E402
from swf_kukla import Birlestirici, Swf  # noqa: E402

_SWF_KOK = os.environ.get("SWF_KOK", os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "..", "swf-oyunlar"))
SWF = {
    "f1": os.path.join(_SWF_KOK, "oyunlar", "feudalism", "feudalism-orijinal.swf"),
    "f2": os.path.join(_SWF_KOK, "oyunlar", "feudalism-2", "feudalism-2-orijinal.swf"),
}
OLCEK = 8  # maske çözünürlüğü (birim başına piksel)

_ALT = re.compile(r"[MLQCZ]|-?\d*\.?\d+(?:e-?\d+)?")


def duzlestir(d):
    """SVG yolunu (M, L, Q, C) çokgenlere çevirir."""
    cok, cur, last = [], [], (0.0, 0.0)
    tok = _ALT.findall(d)
    i, cmd = 0, "M"
    sayi = []

    def al(n):
        nonlocal i
        v = [float(tok[i + k]) for k in range(n)]
        i += n
        return v

    while i < len(tok):
        t = tok[i]
        if t in "MLQCZ":
            cmd = t
            i += 1
            if t == "Z":
                if cur:
                    cok.append(cur)
                cur = []
            continue
        if cmd == "M":
            if cur:
                cok.append(cur)
            x, y = al(2)
            cur = [(x, y)]
            last = (x, y)
            cmd = "L"
        elif cmd == "L":
            x, y = al(2)
            cur.append((x, y))
            last = (x, y)
        elif cmd == "Q":
            cx, cy, x, y = al(4)
            for s in range(1, 9):
                u = s / 8
                cur.append(((1 - u) ** 2 * last[0] + 2 * (1 - u) * u * cx + u * u * x,
                            (1 - u) ** 2 * last[1] + 2 * (1 - u) * u * cy + u * u * y))
            last = (x, y)
        elif cmd == "C":
            c1x, c1y, c2x, c2y, x, y = al(6)
            for s in range(1, 11):
                u = s / 10
                a, b2, c2, d2 = (1 - u) ** 3, 3 * (1 - u) ** 2 * u, 3 * (1 - u) * u * u, u ** 3
                cur.append((a * last[0] + b2 * c1x + c2 * c2x + d2 * x, a * last[1] + b2 * c1y + c2 * c2y + d2 * y))
            last = (x, y)
        else:
            i += 1
    if cur:
        cok.append(cur)
    del sayi
    return cok


def ters(m):
    a, b, c, d, e, f = m
    det = a * d - b * c
    return (d / det, -b / det, -c / det, a / det, (c * f - d * e) / det, (b * e - a * f) / det)


def uygula(m, x, y):
    a, b, c, d, e, f = m
    return (a * x + c * y + e, b * x + d * y + f)


def eksen_cercevesi(m):
    """Parçanın kendi eksenlerinde, birleşik çizimin ölçeğinde koordinat: (yerel x × sx, yerel y × sy)."""
    sx = math.hypot(m[0], m[1])
    sy = math.hypot(m[2], m[3])
    inv = ters(m)

    def cevir(x, y):
        lx, ly = uygula(inv, x, y)
        return (lx * sx, ly * sy)
    return cevir


class Maske:
    """Bir parçanın (yerel eksenlerde) dolgu maskesi; satır genişlikleri ve kutusu."""

    def __init__(self, cokgenler):
        xs = [p[0] for c in cokgenler for p in c]
        ys = [p[1] for c in cokgenler for p in c]
        self.x0, self.y0 = min(xs) - 1, min(ys) - 1
        w = int((max(xs) - self.x0 + 1) * OLCEK) + 2
        h = int((max(ys) - self.y0 + 1) * OLCEK) + 2
        self.im = Image.new("L", (w, h), 0)
        dr = ImageDraw.Draw(self.im)
        for c in cokgenler:
            if len(c) >= 3:
                dr.polygon([((x - self.x0) * OLCEK, (y - self.y0) * OLCEK) for x, y in c], fill=255)
        self.px = self.im.load()
        self.w, self.h = w, h

    def kutu(self):
        bb = self.im.getbbox()
        if not bb:
            return None
        return (bb[0] / OLCEK + self.x0, bb[1] / OLCEK + self.y0, bb[2] / OLCEK + self.x0, bb[3] / OLCEK + self.y0)

    def satir_gen(self, y):
        r = int((y - self.y0) * OLCEK)
        if r < 0 or r >= self.h:
            return 0.0
        dolu = [x for x in range(self.w) if self.px[x, r]]
        return (dolu[-1] - dolu[0]) / OLCEK if dolu else 0.0

    def satir_aralik(self, y):
        r = int((y - self.y0) * OLCEK)
        if r < 0 or r >= self.h:
            return None
        dolu = [x for x in range(self.w) if self.px[x, r]]
        if not dolu:
            return None
        return (dolu[0] / OLCEK + self.x0, dolu[-1] / OLCEK + self.x0)


def parca_cokgenleri(b, yol, renk_suz=None, alt_dahil=False):
    m = b.matrisler[yol]
    cevir = eksen_cercevesi(m)
    out = []
    for kyol, _sid, sm, renkler in b.sekil_kayitlari:
        if not (kyol == yol or (alt_dahil and kyol.startswith(yol + "."))):
            continue
        for dolgu, _cizgi, _kal, d in renkler:
            if dolgu is None or (renk_suz and not renk_suz(dolgu)):
                continue
            for c in duzlestir(d):
                out.append([cevir(*uygula(sm, x, y)) for x, y in c])
    return out


def mesafe(p, q):
    return math.hypot(p[0] - q[0], p[1] - q[1])


def pivot(b, yol):
    m = b.matrisler[yol]
    return (m[4], m[5])


def lab_l(hexr):
    def lin(c):
        return c / 12.92 if c <= 0.04045 else ((c + 0.055) / 1.055) ** 2.4
    r, g, bb = (lin(int(hexr[i:i + 2], 16) / 255) for i in (1, 3, 5))
    y = 0.2126 * r + 0.7152 * g + 0.0722 * bb
    return 116 * (y ** (1 / 3) if y > 0.008856 else 7.787 * y + 16 / 116) - 16


TEN = {"#f3b58c", "#ffcc99", "#fed8b4", "#f3c98b", "#f5c4a3", "#f4d0a0", "#fed3ab", "#c69271", "#ffcc66", "#f2be8c"}


def olc_birlik(swf, profil, ad, tanim, sekil_klasoru):
    cins, ulus, bir, iki, zirh, migfer = tanim
    b = Birlestirici(swf, B.secim(profil, cins, ulus, bir, iki, zirh, migfer))
    b.birlestir(swf.disari["Human"])
    o = {"ad": ad, "oyun": profil, "silah": bir[0]}

    bas = Maske(parca_cokgenleri(b, "body.head")).kutu()
    o["bas_yuk"] = bas[3] - bas[1]
    o["bas_gen"] = bas[2] - bas[0]
    bas_ust = -bas[1]  # dönme noktasından başın tepesine
    kalca = ((pivot(b, "body.legL")[0] + pivot(b, "body.legR")[0]) / 2, (pivot(b, "body.legL")[1] + pivot(b, "body.legR")[1]) / 2)
    boyun = pivot(b, "body.head")
    o["govde_boy"] = mesafe(boyun, kalca)
    gv = Maske(parca_cokgenleri(b, "body.body")).kutu()
    o["govde_gen"] = gv[2] - gv[0]
    o["uyluk"] = mesafe(pivot(b, "body.legL"), pivot(b, "body.footL"))
    alt = Maske(parca_cokgenleri(b, "body.footL"))
    ak = alt.kutu()
    o["baldir_taban"] = ak[3]  # dizden tabana
    # Ayak boyu: alt %15'lik bandın en geniş satırı
    o["ayak_boy"] = max(alt.satir_gen(ak[3] - (ak[3] - ak[1]) * f) for f in (0.02, 0.05, 0.08, 0.11, 0.14))
    o["ayakta_boy"] = bas_ust + o["govde_boy"] + o["uyluk"] + o["baldir_taban"]
    o["ust_kol"] = mesafe(pivot(b, "body.hand_l"), pivot(b, "body.arm_l"))
    on = Maske(parca_cokgenleri(b, "body.arm_l", alt_dahil=True))
    ok = on.kutu()
    o["on_kol_el"] = ok[3]
    # Bilek: ön kolun %40–70 arasındaki en dar satırı (parmak uçları da daraldığı için alt uç dışarıda)
    ys = [ok[1] + (ok[3] - ok[1]) * f / 100 for f in range(40, 71)]
    gen = [(on.satir_gen(y), y) for y in ys]
    bilek_gen, bilek_y = min(gen)
    o["bilek_gen"] = bilek_gen
    o["el_boy"] = ok[3] - bilek_y
    o["el_gen"] = max(on.satir_gen(ok[1] + (ok[3] - ok[1]) * f / 100) for f in range(int((bilek_y - ok[1]) / (ok[3] - ok[1]) * 100) + 1, 100))
    o["on_kol_gen"] = max(on.satir_gen(ok[1] + (ok[3] - ok[1]) * f / 100) for f in range(5, 45))
    # Silah: uzun eksen, tutuş yeri, açı, elin tutuş yerine uzaklığı
    if "body.weapL" in b.matrisler and any(k == "body.weapL" for k, *_ in b.sekil_kayitlari):
        sm = b.matrisler["body.weapL"]
        sil = Maske(parca_cokgenleri(b, "body.weapL")).kutu()
        uz_y = sil[3] - sil[1]
        uz_x = sil[2] - sil[0]
        if uz_y >= uz_x:
            o["silah_boy"] = uz_y
            o["tutus_orani"] = (0 - sil[1]) / uz_y  # üst uçtan tutuş yerine
            ex = (sm[2], sm[3])
        else:
            o["silah_boy"] = uz_x
            o["tutus_orani"] = (0 - sil[0]) / uz_x
            ex = (sm[0], sm[1])
        aci = math.degrees(math.atan2(-ex[1], ex[0])) % 180
        o["silah_aci"] = min(aci, 180 - aci)  # yataydan sapma
        # Elin merkezi (bilekten aşağısı), birleşik koordinatta
        am = b.matrisler["body.arm_l"]
        sx, sy = math.hypot(am[0], am[1]), math.hypot(am[2], am[3])
        el_merkez_yerel = ((on.satir_aralik((bilek_y + ok[3]) / 2) or (0, 0))[0] / sx * 0.5 + (on.satir_aralik((bilek_y + ok[3]) / 2) or (0, 0))[1] / sx * 0.5,
                           (bilek_y + ok[3]) / 2 / sy)
        el = uygula(am, *el_merkez_yerel)
        o["el_tutus_uzaklik"] = mesafe(el, (sm[4], sm[5]))
    # Parçaların kendi eksenlerindeki kutuları (baş = 1): üstte eklemin ne kadar üstüne taştığı,
    # altta ne kadar uzandığı, en geniş yeri
    o["parca_kutulari"] = {}
    for p in ("head", "body", "hand_l", "arm_l", "legL", "footL"):
        mk = Maske(parca_cokgenleri(b, "body." + p, alt_dahil=(p != "head")))
        kk = mk.kutu()
        en = max(mk.satir_gen(kk[1] + (kk[3] - kk[1]) * f / 50) for f in range(1, 50))
        o["parca_kutulari"][p] = [kk[0] / o["bas_yuk"], kk[1] / o["bas_yuk"], kk[2] / o["bas_yuk"], kk[3] / o["bas_yuk"], en / o["bas_yuk"]]
    # Katmanlar, renkler, çizgiler
    renk = Counter()
    cizgiler = Counter()
    sekil_say = Counter()
    for kyol, sid, sm, renkler in b.sekil_kayitlari:
        if not kyol.startswith("body"):
            continue
        sekil_say[kyol] += 1
        for dolgu, cizgi, kal, _ in renkler:
            if dolgu and dolgu.startswith("#"):
                renk[dolgu.upper()] += 1
            if cizgi:
                cizgiler[(kyol, cizgi.upper(), kal)] += 1
    o["renkler"] = sorted(renk)
    o["cizgiler"] = [f"{k[0]} {k[1]} {k[2]}" for k in cizgiler]
    o["degrade"] = sum(1 for k, *_r, renkler in b.sekil_kayitlari for r in renkler if r[0] and r[0].startswith("url"))
    o["dolgu"] = sum(len(r) for *_x, r in b.sekil_kayitlari)
    o["parca_sekil"] = dict(sekil_say)
    return o, b


def katman_sirasi(swf):
    body = swf.spritelar[[k["kimlik"] for k in swf.spritelar[swf.disari["Human"]].kareler[0].values() if k.get("ad") == "body"][0]]
    return [k.get("ad") for _d, k in sorted(body.kareler[0].items()) if k.get("ad")]


def ozet(degerler):
    v = [x for x in degerler if x is not None]
    return (statistics.median(v), min(v), max(v)) if v else (None, None, None)


def main(ref, cikti_md):
    sonuc = []
    katmanlar = {}
    for profil in ("f1", "f2"):
        swf = Swf(SWF[profil], os.path.join(ref, profil, "svg"))
        katmanlar[profil] = katman_sirasi(swf)
        for ad, *tanim in B.PROFILLER[profil]["birlikler"]:
            o, _ = olc_birlik(swf, profil, ad, tanim, None)
            sonuc.append(o)
    with open(os.path.join(ref, "olcumler.json"), "w", encoding="utf-8") as f:
        json.dump(sonuc, f, ensure_ascii=False, indent=1)
    yaz_md(sonuc, katmanlar, cikti_md)


def f1d(v, n=2):
    return "—" if v is None else f"{v:.{n}f}".replace(".", ",")


def yaz_md(sonuc, katmanlar, yol):
    L = []
    L.append("# Karakter ölçüleri (esin kaynağından)")
    L.append("")
    L.append("Bu sayfa `araclar/olcum/olc.py` ile **otomatik üretilir**; elle düzenlenmez. Esin kaynağı iki")
    L.append("oyunun savaş kuklaları, oyunun kendi kodundaki formüllerle (ulus, cinsiyet, zırh, miğfer, silah,")
    L.append("duruş) birleştirildi ve parça parça ölçüldü. Esinin çizimleri depoya girmez; yalnızca bu sayılar.")
    L.append("")
    L.append("Uzunluklar eklemden ekleme ölçülür (duruştan bağımsız). Birim: oyun pikseli. Oranlar başın")
    L.append("yüksekliğine (`baş`: saç dahil, miğfer hariç) bölünmüştür.")
    L.append("")
    alanlar = [("ayakta_boy", "Ayakta boy"), ("govde_boy", "Boyun–kalça"), ("uyluk", "Uyluk"), ("baldir_taban", "Diz–taban"),
               ("ust_kol", "Üst kol"), ("on_kol_el", "Ön kol + el"), ("el_boy", "El boyu"), ("el_gen", "El eni"),
               ("on_kol_gen", "Ön kol eni"), ("bilek_gen", "Bilek eni"), ("ayak_boy", "Ayak boyu"), ("govde_gen", "Gövde eni"),
               ("bas_gen", "Baş eni")]
    L.append("## Oranlar (baş = 1)")
    L.append("")
    L.append("| Ölçü | Ortanca | En az | En çok |")
    L.append("| --- | --- | --- | --- |")
    for k, ad in alanlar:
        orn = [o[k] / o["bas_yuk"] for o in sonuc if o.get(k)]
        m, lo, hi = ozet(orn)
        L.append(f"| {ad} | {f1d(m)} | {f1d(lo)} | {f1d(hi)} |")
    bas = [o["bas_yuk"] for o in sonuc]
    L.append("")
    L.append(f"Baş yüksekliği: ortanca {f1d(statistics.median(bas), 1)} piksel ({f1d(min(bas), 1)}–{f1d(max(bas), 1)}).")
    L.append("")
    L.append("## Parça kutuları (kendi eksenlerinde, baş = 1)")
    L.append("")
    L.append("Her parça dönme noktası (0, 0) olan kendi ekseninde ölçüldü; uzuvlar +y yönünde uzanır. `Üst`:")
    L.append("parçanın eklemin üstüne taşan kısmı (bindirme payı). `Alt`: eklemden ucuna. `En`: en geniş yeri.")
    L.append("")
    L.append("| Parça | Üst | Alt | Sol | Sağ | En |")
    L.append("| --- | --- | --- | --- | --- | --- |")
    adlar = {"head": "Baş (saç dahil)", "body": "Gövde", "hand_l": "Üst kol", "arm_l": "Ön kol + el", "legL": "Uyluk", "footL": "Baldır + çizme"}
    for p, ad in adlar.items():
        v = [o["parca_kutulari"][p] for o in sonuc]
        med = [statistics.median(x[i] for x in v) for i in range(5)]
        L.append(f"| {ad} | {f1d(-med[1])} | {f1d(med[3])} | {f1d(med[0])} | {f1d(med[2])} | {f1d(med[4])} |")
    L.append("")
    L.append("## Silah tutuşu")
    L.append("")
    L.append("Silahın dönme noktası tutuş yeridir; ön kol + el parçası silahın **üstüne** çizilir ve parmaklar")
    L.append("sapın üstüne biner. `Tutuş`: silahın üst ucundan tutuş yerine oran. `Açı`: duruşta silahın yataydan")
    L.append("sapması (derece). `El–tutuş`: elin ortası ile tutuş noktası arası (baş = 1).")
    L.append("")
    L.append("| Birlik | Oyun | Silah | Silah boyu (baş) | Tutuş | Açı | El–tutuş |")
    L.append("| --- | --- | --- | --- | --- | --- | --- |")
    for o in sonuc:
        if "silah_boy" not in o:
            continue
        L.append(f"| {o['ad']} | {o['oyun']} | {o['silah']} | {f1d(o['silah_boy'] / o['bas_yuk'])} | {f1d(o['tutus_orani'])} | "
                 f"{f1d(o['silah_aci'], 0)} | {f1d(o['el_tutus_uzaklik'] / o['bas_yuk'])} |")
    L.append("")
    L.append("## Birlik başına ölçüler (baş = 1)")
    L.append("")
    L.append("| Birlik | Oyun | Baş (px) | Boy | Gövde | Uyluk | Diz–taban | Üst kol | Ön kol+el | El boyu | El eni | Ayak |")
    L.append("| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |")
    for o in sonuc:
        h = o["bas_yuk"]
        L.append(f"| {o['ad']} | {o['oyun']} | {f1d(h, 1)} | {f1d(o['ayakta_boy'] / h)} | {f1d(o['govde_boy'] / h)} | {f1d(o['uyluk'] / h)} | "
                 f"{f1d(o['baldir_taban'] / h)} | {f1d(o['ust_kol'] / h)} | {f1d(o['on_kol_el'] / h)} | {f1d(o['el_boy'] / h)} | "
                 f"{f1d(o['el_gen'] / h)} | {f1d(o['ayak_boy'] / h)} |")
    L.append("")
    L.append("## Yapı: katmanlar, dolgu, kontur")
    L.append("")
    for p, k in katmanlar.items():
        L.append(f"- **Çizim sırası ({p}, arkadan öne):** " + " → ".join(f"`{x}`" for x in k))
    L.append("- Parça adları oyundaki gibidir: `hand_*` üst kol (omuz–dirsek), `arm_*` ön kol ve el, `leg*` uyluk,")
    L.append("  `foot*` baldır ve çizme. Her parça tek bir şekildir; içinde 1–10 düz renk dolgu vardır.")
    deg = sum(o["degrade"] for o in sonuc)
    dol = sum(o["dolgu"] for o in sonuc)
    L.append(f"- **Degrade:** {deg} / {dol} dolgu (%{100 * deg / max(dol, 1):.1f}). Savaş kuklası düz renktir.")
    ciz = Counter()
    for o in sonuc:
        for c in o["cizgiler"]:
            pyol, _renk, kal = c.split(" ")
            ciz[(pyol.split(".")[1] if "." in pyol else pyol, kal)] += 1
    L.append("- **Kontur:** dış hat yok. İnce çizgi yalnızca şu parçalarda: " +
             ", ".join(f"`{p}` ({k} birim)" for (p, k), _ in sorted(ciz.items())) + ".")
    L.append("")
    L.append("## Renkler (birleştirilen birliklerde geçen bütün düz renkler)")
    L.append("")
    tum = Counter()
    for o in sonuc:
        for r in o["renkler"]:
            tum[r] += 1
    L.append(", ".join(f"`{r}`" for r, _ in sorted(tum.items(), key=lambda x: lab_l(x[0]))))
    L.append("")
    with open(yol, "w", encoding="utf-8") as f:
        f.write("\n".join(L) + "\n")
    print(yol)


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
