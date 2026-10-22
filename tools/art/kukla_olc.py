"""Kendi kuklamızı esin kaynağının ölçüleriyle sayıyla karşılaştırır.

Aynı ölçüm yöntemi (araclar/olcum/olc.py) kendi parçalarımıza uygulanır: her parça kendi ekseninde
maskelenir, enleri ve boyları baş yüksekliğine bölünür. Esinin değerleri
`referans/olcumler.json` dosyasından okunur (bkz. araclar/olcum/cikar.sh). Sonuç
`docs/KARAKTER_KARSILASTIRMA.md` dosyasına yazılır.

Kullanım: python3 tools/art/kukla_olc.py
"""
import json
import math
import os
import statistics
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "araclar", "olcum"))
import ciz_birlikler  # noqa: E402
import kukla  # noqa: E402
from cizim import KOK  # noqa: E402
from olc import Maske, duzlestir  # noqa: E402

B = kukla.B
SINIR = 0.15  # esin ortancasından en fazla %15 sapma kabul edilir


class _BasMaske:
    """Maske çizim biriminde kurulur (çözünürlük için); ölçüler baş birimine çevrilerek verilir."""

    def __init__(self, cok):
        self.m = Maske(cok)

    def kutu(self):
        k = self.m.kutu()
        return tuple(v / B for v in k)

    def satir_gen(self, y):
        return self.m.satir_gen(y * B) / B


def maske(parca, suz=None):
    cok = []
    for yol, renk in parca.sekiller:
        if suz and not suz(renk):
            continue
        cok.extend(duzlestir(yol))
    return _BasMaske(cok)


def satir_max(mk, y0, y1, adim=40):
    return max(mk.satir_gen(y0 + (y1 - y0) * i / adim) for i in range(adim + 1))


def olc(kostum, durus):
    o = {}
    bas_m = maske(kukla.bas(kostum))
    kb = bas_m.kutu()
    o["bas_yuk"] = kb[3] - kb[1]
    o["bas_gen"] = kb[2] - kb[0]
    gv = maske(kukla.govde(kostum)).kutu()
    o["govde_gen"] = gv[2] - gv[0]
    poz = kukla.DURUSLAR[durus]
    kalca = ((poz["uyluk_on"][0] + poz["uyluk_arka"][0]) / 2, (poz["uyluk_on"][1] + poz["uyluk_arka"][1]) / 2)
    boyun = poz["bas"][:2]
    o["govde_boy"] = math.dist(boyun, kalca)
    o["uyluk"] = math.dist(poz["uyluk_on"][:2], poz["baldir_on"][:2])
    ust = maske(kukla.ust_kol(kostum))
    ku = ust.kutu()
    o["ust_kol_gen"] = satir_max(ust, ku[1], ku[3])
    o["ust_kol"] = math.dist(poz["ust_kol_on"][:2], poz["on_kol_on"][:2])
    on = maske(kukla.on_kol(kostum))
    ok = on.kutu()
    o["on_kol_el"] = ok[3]
    ys = [ok[1] + (ok[3] - ok[1]) * f / 100 for f in range(40, 71)]
    bilek_gen, bilek_y = min((on.satir_gen(y), y) for y in ys)
    o["bilek_gen"] = bilek_gen
    o["el_boy"] = ok[3] - bilek_y
    o["el_gen"] = satir_max(on, bilek_y + 0.02, ok[3] - 0.02)
    o["on_kol_gen"] = satir_max(on, ok[1] + (ok[3] - ok[1]) * 0.05, ok[1] + (ok[3] - ok[1]) * 0.45)
    bal = maske(kukla.baldir(kostum))
    kb2 = bal.kutu()
    o["baldir_taban"] = kb2[3]
    o["ayak_boy"] = max(bal.satir_gen(kb2[3] - (kb2[3] - kb2[1]) * f) for f in (0.02, 0.05, 0.08, 0.11, 0.14))
    uy = maske(kukla.uyluk(kostum))
    ky = uy.kutu()
    o["uyluk_gen"] = satir_max(uy, ky[1], ky[3])
    o["ayakta_boy"] = -kb[1] + o["govde_boy"] + o["uyluk"] + o["baldir_taban"]
    if kostum.get("silah_on"):
        s = maske(kostum["silah_on"](kostum))
        ks = s.kutu()
        if ks[3] - ks[1] >= ks[2] - ks[0]:
            o["silah_boy"] = ks[3] - ks[1]
            o["tutus_orani"] = -ks[1] / o["silah_boy"]
        else:
            o["silah_boy"] = ks[2] - ks[0]
            o["tutus_orani"] = -ks[0] / o["silah_boy"]
    return o


ALANLAR = [("ayakta_boy", "Ayakta boy"), ("govde_boy", "Boyun–kalça"), ("uyluk", "Uyluk"), ("baldir_taban", "Diz–taban"),
           ("ust_kol", "Üst kol"), ("on_kol_el", "Ön kol + el"), ("el_boy", "El boyu"), ("el_gen", "El eni"),
           ("on_kol_gen", "Ön kol eni"), ("bilek_gen", "Bilek eni"), ("ayak_boy", "Ayak boyu"), ("bas_gen", "Baş eni")]

SILAH_ESIN = {"pala": "OnehandedSword", "mizrak": "Spear", "yay": "Bow"}


def main():
    ref_yol = os.path.join(KOK, "referans", "olcumler.json")
    with open(ref_yol, encoding="utf-8") as fh:
        esin = json.load(fh)
    ref = {}
    for k, _ in ALANLAR:
        ref[k] = statistics.median(o[k] / o["bas_yuk"] for o in esin if o.get(k))
    L = ["# Karakter ölçüleri: esin ile bizim kuklamız", "",
         "`tools/art/kukla_olc.py` ile otomatik üretilir. Esin değeri: esin kaynağının 18 birliğinin ortancası",
         "(docs/KARAKTER_OLCULERI.md). Bütün değerler baş yüksekliğine bölünmüştür. Sapma %15'i geçerse ✗.", ""]
    hatalar = 0
    for ad, (durus, kostum) in ciz_birlikler.KOSTUMLER.items():
        o = olc(kostum, durus)
        L.append(f"## {ad} (duruş: {durus})")
        L.append("")
        L.append("| Ölçü | Esin | Bizim | Fark | |")
        L.append("| --- | --- | --- | --- | --- |")
        for k, etiket in ALANLAR:
            v = o[k] / o["bas_yuk"]
            fark = (v - ref[k]) / ref[k]
            iyi = abs(fark) <= SINIR
            hatalar += 0 if iyi else 1
            L.append(f"| {etiket} | {ref[k]:.2f} | {v:.2f} | {fark * 100:+.0f}% | {'✓' if iyi else '✗'} |".replace(".", ","))
        if "silah_boy" in o:
            silah = kostum["silah_on"].__name__
            es = [e for e in esin if e.get("silah") == SILAH_ESIN.get(silah) and "silah_boy" in e]
            if es:
                rb = statistics.median(e["silah_boy"] / e["bas_yuk"] for e in es)
                rt = statistics.median(e["tutus_orani"] for e in es)
                L.append(f"| Silah boyu ({silah}) | {rb:.2f} | {o['silah_boy'] / o['bas_yuk']:.2f} | "
                         f"{(o['silah_boy'] / o['bas_yuk'] - rb) / rb * 100:+.0f}% | |".replace(".", ","))
                L.append(f"| Tutuş yeri (üstten) | {rt:.2f} | {o['tutus_orani']:.2f} | "
                         f"{(o['tutus_orani'] - rt) / rt * 100:+.0f}% | |".replace(".", ","))
        L.append("")
    yol = os.path.join(KOK, "docs", "KARAKTER_KARSILASTIRMA.md")
    with open(yol, "w", encoding="utf-8") as fh:
        fh.write("\n".join(L) + "\n")
    print("\n".join(L))
    print(f"\nsınır dışı ölçü: {hatalar}")


if __name__ == "__main__":
    main()
