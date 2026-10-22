"""Oyunun renk paleti: `palet.txt` dosyasını okur.

Çizim betikleri renkleri adıyla ister: `r("kırmızı")`. Yanlış yazılan ad hata verir; böylece
paletin dışında renk kullanılamaz. Paletin kendisi `palet.txt` içindedir (bkz. docs/SANAT.md).
"""
import os
import re

_SATIR = re.compile(r"^(\S+)\s+(#[0-9A-F]{6})$")


def _oku():
    palet = {}
    yol = os.path.join(os.path.dirname(os.path.abspath(__file__)), "palet.txt")
    with open(yol, encoding="utf-8") as dosya:
        for no, satir in enumerate(dosya, 1):
            satir = satir.strip()
            if not satir or satir.startswith("#"):
                continue
            m = _SATIR.match(satir)
            if not m:
                raise ValueError(f"palet.txt:{no}: anlaşılamayan satır: {satir!r}")
            ad, renk = m.groups()
            if ad in palet:
                raise ValueError(f"palet.txt:{no}: aynı ad iki kez: {ad}")
            palet[ad] = renk
    return palet


PALET = _oku()
RENKLER = set(PALET.values())


def r(ad):
    """Palet renginin hex kodu; yanlış ad yazılırsa hata verir."""
    return PALET[ad]
