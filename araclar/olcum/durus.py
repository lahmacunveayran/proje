"""Esin kaynağının kukla animasyonundan bir karenin duruşunu ölçer (eklem yeri ve açısı).

Çıktı, `tools/art/kukla.py` içindeki DURUSLAR sözlüğünün biçimindedir: her parça için ön uyluğun
eklemine (kalça) göre yer (baş biriminde) ve açı (derece).
Kullanım: python3 araclar/olcum/durus.py <etiket> <kare> [<etiket> <kare> ...]  (ör. sword 11)
"""
import math
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import olc  # noqa: E402
from swf_kukla import Swf  # noqa: E402

AD = {"hand_r": "ust_kol_arka", "arm_r": "on_kol_arka", "weapR": "silah_arka", "legR": "uyluk_arka",
      "footR": "baldir_arka", "legL": "uyluk_on", "footL": "baldir_on", "body": "govde", "head": "bas",
      "weapL": "silah_on", "hand_l": "ust_kol_on", "arm_l": "on_kol_on"}
BAS = 28.1  # esin kuklasında baş yüksekliği (piksel), bkz. docs/KARAKTER_OLCULERI.md


def durus(swf, etiket, kare):
    body = swf.spritelar[[k["kimlik"] for k in swf.spritelar[swf.disari["Human"]].kareler[0].values()
                          if k.get("ad") == "body"][0]]
    liste = body.kareler[body.etiketler[etiket] + kare - 1]
    m = {v["ad"]: v.get("matris", (1, 0, 0, 1, 0, 0)) for v in liste.values() if v.get("ad") in AD}
    kx, ky = m["legL"][4], m["legL"][5]
    out = {}
    for ad, yeni in AD.items():
        if ad in m:
            a, b, _c, _d, e, f = m[ad]
            out[yeni] = (round((e - kx) / BAS, 2), round((f - ky) / BAS, 2), round(math.degrees(math.atan2(b, a)), 1))
    return out


if __name__ == "__main__":
    swf = Swf(olc.SWF["f1"], os.path.join(os.path.dirname(olc.__file__), "..", "..", "referans", "f1", "svg"))
    args = sys.argv[1:]
    for etiket, kare in zip(args[0::2], args[1::2]):
        print(f'    # esin: "{etiket}" animasyonu, {kare}. kare')
        print(f'    "{etiket}-{kare}": {{')
        d = durus(swf, etiket, int(kare))
        satir = ", ".join(f'"{k}": {v}' for k, v in d.items())
        print("        " + satir)
        print("    },")
