"""Örnek birlikler: bey (pala ve kalkan), mızrakçı, okçu. Kukla yapısı ve duruşlar esin
kaynağından ölçüldü (bkz. kukla.py, docs/KARAKTER_OLCULERI.md); giysi ve yüzler bizim tasarımımız.

Savaş kuklası kuralları (ölçülen): her parça düz renk, degrade yok, dış hat yok.

Çalıştır: python3 tools/art/ciz_birlikler.py  →  content/art/samples/characters/*.svg
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import kukla  # noqa: E402
from cizim import KOK, Cizim, elips  # noqa: E402

TEN = {"ten": "ten", "ten-gölge": "ten-gölge", "ten-derin": "ten-derin"}

KOSTUMLER = {
    "hero": ("kilic", dict(TEN, **{
        "saç": "saç-siyah", "kaş": "saç-siyah", "sakal": True, "bıyık": "kısa",
        "kaftan": "gök", "şerit": "altın", "kuşak": "kırmızı", "kuşak-düğüm": "kırmızı-koyu",
        "şalvar": "toprak", "çizme": "kırmızı-koyu", "çizme-ağzı": "altın",
        "kolçak": "kahve", "kolçak-kenar": "altın-hardal",
        "kalkan": "kırmızı-koyu", "başlık": kukla.migfer,
        "silah_on": kukla.pala, "silah_arka": kukla.kalkan,
    })),
    "soldier-1": ("mizrak", {
        "ten": "ten-buğday", "ten-gölge": "ten-sarı-gölge", "ten-derin": "ten-derin",
        "saç": "kahve-koyu", "kaş": "kahve-koyu",
        "kaftan": "gök", "şerit": "beyaz", "kuşak": "kahve-koyu", "kuşak-düğüm": "kahve-siyah",
        "yelek": "deri", "yelek-kenar": "deri-açık",
        "şalvar": "zeytin", "çizme": "kahve", "çizme-ağzı": "kahve-koyu",
        "kolçak": "deri", "kolçak-kenar": "deri-açık",
        "başlık": kukla.bork, "börk-kenar": "kahve",
        "silah_on": kukla.mizrak,
    }),
    "soldier-2": ("yay", {
        "ten": "ten-pembe", "ten-gölge": "ten-gölge", "ten-derin": "ten-derin",
        "saç": "saç-kızıl-gölge", "kaş": "saç-kızıl-gölge", "bıyık": "uzun",
        "kaftan": "zeytin", "şerit": "altın-hardal", "kuşak": "kırmızı-koyu", "kuşak-düğüm": "kırmızı-gölge",
        "şalvar": "kahve", "çizme": "kahve-koyu", "çizme-ağzı": "deri-açık",
        "kolçak": "kahve-koyu", "kolçak-kenar": "deri-açık",
        "başlık": kukla.kurk_kalpak, "sadak": True,
        "silah_on": kukla.yay, "ok": True,
    }),
}


def ciz():
    cikti = {}
    for ad, (durus, kostum) in KOSTUMLER.items():
        c, ayak = kukla.ciz_karakter(kostum, durus, ad[0] + ad[-1])
        yol = os.path.join(KOK, "content", "art", "samples", "characters", f"{ad}.svg")
        c.kaydet(yol, f"Örnek birlik ({ad}, duruş: {durus}); ayak noktası ({ayak[0]:.0f}, {ayak[1]:.0f}). "
                      "tools/art/ciz_birlikler.py ile üretildi; elle düzenleme.")
        cikti[ad] = (yol, ayak, (c.gen, c.yuk))
        print(ad, durus, f"{c.gen}×{c.yuk}", "ayak", tuple(round(v) for v in ayak))
    return cikti


def golge():
    """Ayak altı gölgesi: düz, keskin kenarlı, yarı saydam koyu elips (esinde #333333). Merkez (100, 20)."""
    c = Cizim(200, 40, "g")
    c.sekil(elips(100, 20, 100, 20), "siyah", saydam=0.35)
    yol = os.path.join(KOK, "content", "art", "samples", "shadow.svg")
    c.kaydet(yol, "Karakterlerin ayak altı gölgesi. tools/art/ciz_birlikler.py ile üretildi; elle düzenleme.")
    return yol


if __name__ == "__main__":
    ciz()
    golge()
