"""Savaş kuklasının yapısını ölçer: kaç parça, çizim sırası, eklem (dönme) noktaları, animasyonlar.

Çıktılar:
- `olcum/kukla-<oyun>.json` (depoya girer): yalnızca sayılar. Parça adları, sırası, kare sayıları,
  dinlenme duruşundaki eklem yerleri ve parça kutuları (baş birimi), animasyon etiketleri.
- `referans/<oyun>/pozlar.json` (git'e girmez): bütün animasyon karelerinin eklem yerleri. Yalnızca
  "bizim duruş hiçbir orijinal kareyle örtüşmesin" denetiminde kullanılır.

Kullanım: python3 araclar/olcum/kukla_yapisi.py <f1|f2>
"""
import json
import math
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import birlikler as B  # noqa: E402
import olc  # noqa: E402
from swf_kukla import Birlestirici, Swf  # noqa: E402

KOK = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
PARCA_ADLARI = ["hand_r", "arm_r", "weapR", "legR", "footR", "legL", "footL", "body", "head", "weapL", "hand_l", "arm_l"]
TURKCE = {"hand_r": "ust_kol_arka", "arm_r": "on_kol_arka", "weapR": "silah_arka", "legR": "uyluk_arka",
          "footR": "baldir_arka", "legL": "uyluk_on", "footL": "baldir_on", "body": "govde", "head": "bas",
          "weapL": "silah_on", "hand_l": "ust_kol_on", "arm_l": "on_kol_on"}


def yuvarla(v, n=3):
    return round(v, n)


def y_ekseni(m):
    n = math.hypot(m[2], m[3]) or 1.0
    return [yuvarla(m[2] / n), yuvarla(m[3] / n)]


def main(oyun):
    swf = Swf(olc.SWF[oyun], os.path.join(KOK, "referans", oyun, "svg"))
    insan = swf.spritelar[swf.disari["Human"]]
    govde_id = [k["kimlik"] for k in insan.kareler[0].values() if k.get("ad") == "body"][0]
    govde = swf.spritelar[govde_id]
    ilk = govde.kareler[0]
    parcalar = []
    # Baş yüksekliği: tipik bir birlikte baş parçasının boyu (saç dahil)
    ad0, *t0 = B.PROFILLER[oyun]["birlikler"][0]
    b = Birlestirici(swf, B.secim(oyun, *t0))
    b.birlestir(swf.disari["Human"])
    bas_px = olc.Maske(olc.parca_cokgenleri(b, "body.head")).kutu()
    bas_px = bas_px[3] - bas_px[1]
    kalca = olc.pivot(b, "body.legL")
    for d, k in sorted(ilk.items()):
        ad = k.get("ad")
        if ad not in PARCA_ADLARI:
            continue
        sp = swf.spritelar.get(k["kimlik"])
        pv = olc.pivot(b, "body." + ad)
        m = b.matrisler["body." + ad]
        kayit = {
            "ad": ad, "ad_tr": TURKCE[ad], "derinlik": d, "sprite": k["kimlik"],
            "kare_sayisi": len(sp.kareler) if sp else 0,
            "eklem_bas": [yuvarla((pv[0] - kalca[0]) / bas_px), yuvarla((pv[1] - kalca[1]) / bas_px)],
            "aci": yuvarla(math.degrees(math.atan2(m[1], m[0])), 1),
        }
        if any(kk == "body." + ad for kk, *_ in b.sekil_kayitlari):
            kk = olc.Maske(olc.parca_cokgenleri(b, "body." + ad, alt_dahil=True)).kutu()
            kayit["yerel_kutu_bas"] = [yuvarla(v / bas_px) for v in kk]
        parcalar.append(kayit)
    etiketler = sorted(govde.etiketler.items(), key=lambda x: x[1])
    animasyon = []
    for i, (ad, bas) in enumerate(etiketler):
        son = etiketler[i + 1][1] if i + 1 < len(etiketler) else len(govde.kareler)
        animasyon.append({"ad": ad, "ilk_kare": bas + 1, "kare_sayisi": son - bas})
    yapi = {
        "oyun": oyun, "kukla_sprite": swf.disari["Human"], "govde_sprite": govde_id,
        "parca_sayisi": len(parcalar), "bas_yuksekligi_px": yuvarla(bas_px, 2),
        "cizim_sirasi": [p["ad"] for p in parcalar], "parcalar": parcalar,
        "toplam_kare": len(govde.kareler), "animasyonlar": animasyon,
    }
    os.makedirs(os.path.join(KOK, "olcum"), exist_ok=True)
    with open(os.path.join(KOK, "olcum", f"kukla-{oyun}.json"), "w", encoding="utf-8") as f:
        json.dump(yapi, f, ensure_ascii=False, indent=1)
    # Bütün karelerin eklemleri (yalnızca örtüşme denetimi için; git dışı)
    def etiket_bul(i):
        ad = None
        for e, bas in etiketler:
            if bas <= i:
                ad = e
        return ad

    pozlar = []
    for i, kare in enumerate(govde.kareler):
        mats = {v["ad"]: v.get("matris", (1, 0, 0, 1, 0, 0)) for v in kare.values() if v.get("ad") in PARCA_ADLARI}
        if "legL" not in mats:
            continue
        kx, ky = mats["legL"][4], mats["legL"][5]
        # Her parça: [x, y, açı, yerel y ekseninin yönü (birim vektör x, y)]. Kol ve baldırın ucu (el,
        # ayak) eklemden bu yönde parçanın boyu kadar ileridedir (bkz. olcum.py poz).
        pozlar.append({"kare": i + 1, "etiket": etiket_bul(i), "eklem": {
            TURKCE[a]: [yuvarla((m[4] - kx) / bas_px), yuvarla((m[5] - ky) / bas_px),
                        yuvarla(math.degrees(math.atan2(m[1], m[0])), 1)] + y_ekseni(m)
            for a, m in mats.items()}})
    with open(os.path.join(KOK, "referans", oyun, "pozlar.json"), "w", encoding="utf-8") as f:
        json.dump(pozlar, f)
    print(f"{oyun}: {len(parcalar)} parça, {len(govde.kareler)} kare, {len(animasyon)} animasyon; baş {bas_px:.1f} px")


if __name__ == "__main__":
    main(sys.argv[1])
