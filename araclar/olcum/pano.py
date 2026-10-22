"""PNG'leri ayak çizgisi hizalı, adlarıyla bir panoya dizer. Kullanım: pano.py çıktı.png a.png b.png ..."""
import os
import sys

from PIL import Image, ImageDraw

cikti, yollar = sys.argv[1], sys.argv[2:]
ims = [(Image.open(p).convert("RGB"), os.path.splitext(os.path.basename(p))[0]) for p in yollar]
H = max(i.height for i, _ in ims) + 30
W = sum(i.width for i, _ in ims)
pano = Image.new("RGB", (W, H), (76, 143, 64))
d = ImageDraw.Draw(pano)
x = 0
for im, ad in ims:
    pano.paste(im, (x, H - 30 - im.height))
    d.text((x + 6, H - 24), ad, fill=(255, 255, 255))
    x += im.width
pano.save(cikti)
print(cikti, pano.size)
