"""Esin kaynağının birlik tiplerini oyun kodundaki formüllerle birleştirip SVG ve PNG yazar.

Kare formülleri oyunun kodundan alındı (Item.getFrame, Creature.initUnit):
- Gövde parçaları: "<cinsiyet>_<ulus>" etiketi (m_viz, f_ger ...).
- Zırh (Clothes) ve miğfer (Helmet): ulus_no + 1 + (seviye − 1) × 4; ulus_no: viz 0, ger 1, rus 2, jap 3.
- Silah: tür formülü (ör. mızrak 112 + seviye + ulus_no × 3); boş el 169.
- Duruş: kukla zaman çizelgesinde silah türünün etiketi ("spear", "bow", "sword" ...).

Kullanım: python3 araclar/olcum/birlikler.py <f1|f2> <oyun.swf> <şekil klasörü> <çıktı klasörü>
Çıktılar git'e girmez (referans/ klasörü). Esinin çizimleri oyunda kullanılmaz; yalnızca ölçülür.
"""
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from swf_kukla import Birlestirici, Swf  # noqa: E402

ULUS = {"viz": 0, "ger": 1, "rus": 2, "jap": 3, "mon": 4, "ara": 5}


def silah_karesi_f1(tur, ulus, seviye):
    n = ULUS[ulus]
    return {
        "OnehandedSword": 2 + seviye + n * 5,
        "TwohandedSword": 19 + seviye + n * 5,
        "OnehandedAxe": 36 + seviye + n * 4,
        "TwohandedAxe": 50 + seviye + n * 4,
        "OnehandedMace": 64 + seviye + n * 4,
        "TwohandedMace": 78 + seviye + n * 4,
        "Staff": 90 + seviye,
        "Spear": 112 + seviye + n * 3,
        "Dagger": 121 + seviye,
        "Bow": 140 + seviye + n * 2,
        "Shield": 150 + seviye + n * 3,
        "Crossbow": 159 + seviye + n * 3,
        "Fists": 169,
    }[tur]


def silah_karesi_f2(tur, ulus, seviye):
    n = ULUS[ulus]
    bati = ulus in ("viz", "ger", "rus")
    if tur == "OnehandedSword":
        return 2 + seviye + n * 7 if bati else seviye + n * 7 - 5
    if tur == "TwohandedSword":
        return 39 + seviye + n * 7 if bati else 32 + seviye + n * 7
    if tur == "Shield":
        return 258 + seviye + n * 4 if bati else 270 + seviye
    return {
        "OnehandedAxe": 74 + 2 + seviye + n * 6,
        "TwohandedAxe": 94 + 2 + seviye + n * 6,
        "OnehandedMace": 114 + 2 + seviye + n * 6,
        "TwohandedMace": 134 + 2 + seviye + n * 6,
        "Staff": 154 + seviye,
        "Spear": 182 + seviye + n * 5,
        "Bow": 238 + seviye + n * 4,
        "Crossbow": 274 + seviye + n * 4,
        "Fists": 287,
    }[tur]


PROFILLER = {
    "f1": {
        "silah": silah_karesi_f1,
        "zirh_adim": 4,
        "durus": {"OnehandedSword": "sword", "TwohandedSword": "twohanded_sword", "TwohandedAxe": "twohanded_axe",
                  "Spear": "spear", "Bow": "bow", "Crossbow": "crossbow", "Dagger": "dagger", "Staff": "staff",
                  "Fists": "fists", "OnehandedAxe": "sword", "OnehandedMace": "sword"},
        "bos_el": 169,
        "depo": False,
        # Oyun kodundaki birlik tanımlarından: (ad, cinsiyet, ulus, birincil, ikincil, zırh, miğfer)
        "birlikler": [
            ("kervan-muhafizi", "m", "viz", ("OnehandedSword", 1), ("Shield", 1), None, None),
            ("hat-piyadesi-mizrakci", "m", "viz", ("Spear", 2), ("Crossbow", 1), 3, 1),
            ("lejyoner", "m", "viz", ("OnehandedSword", 2), ("Shield", 2), 3, 2),
            ("sehir-muhafizi-balta", "m", "viz", ("TwohandedAxe", 2), ("Bow", 1), 2, 1),
            ("okcu-ger", "m", "ger", ("Bow", 1), None, 1, None),
            ("mizrakci-rus", "m", "rus", ("Spear", 1), None, 1, 1),
            ("mizrakci-ger-kadin", "f", "ger", ("Spear", 1), None, 1, None),
            ("koylu-yumruk", "m", "ger", ("Fists", 1), None, None, None),
        ],
    },
    "f2": {
        "silah": silah_karesi_f2,
        "zirh_adim": 6,
        "durus": {"OnehandedSword": "dual", "TwohandedSword": "2H_sword", "TwohandedAxe": "2H_axe", "Spear": "spear",
                  "Bow": "bow", "Crossbow": "crossbow", "Dagger": "dagger", "Staff": "staff", "Fists": "fists"},
        "bos_el": "unarmed",
        "depo": True,
        "birlikler": [
            ("kervan-muhafizi-viz", "m", "viz", ("OnehandedSword", 1), ("Shield", 1), None, None),
            ("hafif-mizrakci-viz", "m", "viz", ("Spear", 2), ("Bow", 1), 1, 1),
            ("okcu-viz", "m", "viz", ("Bow", 1), ("OnehandedSword", 1), None, None),
            ("kilicli-mon", "m", "mon", ("OnehandedSword", 1), ("Shield", 1), 1, 1),
            ("hafif-gozcu-mon", "m", "mon", ("TwohandedSword", 2), ("Bow", 1), 2, 1),
            ("tuccar-muhafizi-mon", "m", "mon", ("TwohandedSword", 1), None, None, None),
            ("okcu-mon", "m", "mon", ("Bow", 2), ("OnehandedSword", 1), 1, 1),
            ("han-muhafizi-mon", "m", "mon", ("OnehandedSword", 6), ("Shield", 4), 7, 7),
            ("koylu-yumruk-viz", "m", "viz", ("Fists", 1), None, None, None),
            ("kadin-okcu-ger", "f", "ger", ("Bow", 1), ("OnehandedSword", 1), 1, None),
        ],
    },
}

PARCALAR = ["arm_l", "arm_r", "hand_l", "hand_r", "footL", "footR", "legL", "legR", "body", "head"]
DEPOLAR = {"OnehandedSword": "sword", "TwohandedSword": "sword", "TwohandedAxe": "axe", "Staff": "staff",
           "Spear": "spear", "Bow": "bow", "Crossbow": "bow", "Dagger": "dagger"}


def zirh_karesi(ulus, seviye, adim):
    return ULUS[ulus] + 1 + (seviye - 1) * adim


def secim(profil, cins, ulus, birincil, ikincil, zirh, migfer, durus=None):
    pr = PROFILLER[profil]
    etiket = f"{cins}_{ulus}"
    s = {}
    for p in PARCALAR:
        s[f"body.{p}"] = etiket
    for p in ("arm_l", "arm_r", "hand_l", "hand_r", "body"):
        s[f"body.{p}.armor"] = None if zirh is None else zirh_karesi(ulus, zirh, pr["zirh_adim"])
    s["body.head.armor"] = None if migfer is None else zirh_karesi(ulus, migfer, pr["zirh_adim"])
    s["body.weapL"] = pr["silah"](birincil[0], ulus, birincil[1])
    durus = durus or pr["durus"][birincil[0]]
    if profil == "f2" and birincil[0] == "OnehandedSword":
        durus = "shield" if ikincil and ikincil[0] == "Shield" else ("dual" if ikincil and ikincil[0] == "OnehandedSword" else "shield")
    iki_el = durus in ("dual", "shield", "sword")
    if ikincil is None or (profil == "f2" and not iki_el):
        s["body.weapR"] = pr["bos_el"]
    else:
        s["body.weapR"] = pr["silah"](ikincil[0], ulus, ikincil[1])
    if pr["depo"]:
        for d in ("spear", "bow", "axe", "staff", "sword", "katar", "dagger", "throwing"):
            s[f"body.body.storage_{d}"] = None
        if ikincil and not iki_el and ikincil[0] in DEPOLAR:
            s[f"body.body.storage_{DEPOLAR[ikincil[0]]}"] = pr["silah"](ikincil[0], ulus, ikincil[1])
    s["body"] = durus
    s["light_circle"] = None
    s["borders"] = None
    s["body.head.stun_anim"] = None
    return s


def main(profil, swf_yolu, sekil_klasoru, cikti):
    os.makedirs(cikti, exist_ok=True)
    swf = Swf(swf_yolu, sekil_klasoru)
    kok = swf.disari["Human"]
    ozet = {}
    for ad, cins, ulus, bir, iki, zirh, migfer in PROFILLER[profil]["birlikler"]:
        b = Birlestirici(swf, secim(profil, cins, ulus, bir, iki, zirh, migfer))
        govde = b.birlestir(kok)
        svg_yolu = os.path.join(cikti, f"{ad}.svg")
        with open(svg_yolu, "w", encoding="utf-8") as f:
            f.write(b.svg(govde, olcek=1.0))
        ozet[ad] = {yol: [round(k.x0, 2), round(k.y0, 2), round(k.gen, 2), round(k.yuk, 2)]
                    for yol, (k, _) in b.parcalar.items() if not k.bos()}
        print(ad, "parça:", len(ozet[ad]))
    with open(os.path.join(cikti, "parcalar.json"), "w", encoding="utf-8") as f:
        json.dump(ozet, f, ensure_ascii=False, indent=1)


if __name__ == "__main__":
    main(*sys.argv[1:5])
