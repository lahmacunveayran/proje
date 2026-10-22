#!/usr/bin/env bash
# Feudalism 1 ve 2'nin içeriğini eksiksiz çıkarır ve oyuna aktarır.
#
# Kullanım (depo kökünden):  araclar/olcum/cikar.sh [swf-oyunlar klasörü]
#
# Ham dökümler `referans/` klasörüne yazılır ve git'e GİRMEZ (.gitignore): yerel arşiv ve denetimin
# karşılaştırma kaynağıdır. Oyunun kullandığı içerik (sahibinin izniyle, bkz. docs/LISANSLAR.md)
# 8. adımda content/feudalism/ altına aktarılır; ölçüm sonuçları olcum/ ve docs/KARAKTER_OLCULERI.md'dir.
#
# Adımlar:
#   1. FFDec ile bütün şekiller SVG ve PNG (4×) olarak: referans/<oyun>/svg, referans/<oyun>/png
#   2. Savaş kuklasının sprite'ları (kukla ve parçaları) SVG olarak: referans/<oyun>/sprite
#   3. Oyunun kodu (kukla kare formülleri için): referans/<oyun>/kod
#   4. Birlikler oyunun formülleriyle birleştirilir: referans/<oyun>/birlikler
#   5. Kukla yapısı ve bütün karelerin eklemleri: olcum/kukla-<oyun>.json, referans/<oyun>/pozlar.json
#   6. Parça ölçüleri: docs/KARAKTER_OLCULERI.md
#   7. Tam döküm (her içerik türü, XML dökümü, Flash projesi): referans/<oyun>/tam (git dışı)
#   8. Oyuna aktarım: content/feudalism/<oyun> (Türkçe çeviri dahil, swf-oyunlar/oyunlar/<oyun>/ceviri),
#      kod ve liste kaynak/feudalism/<oyun>, açık lisanslı yazı tipleri content/fonts
#      (bkz. araclar/aktar/aktar.py), döküm belgesi docs/FEUDALISM_ICERIK.md
# Gerekenler: Java 17+, Python 3 + Pillow, curl, unzip, sha256sum, cargo.
set -euo pipefail

KOK="$(cd "$(dirname "$0")/../.." && pwd)"
SWF_KOK="${1:-$KOK/../swf-oyunlar}"
REF="$KOK/referans"
FFDEC_SURUM="24.1.1"
# İndirilen dosyanın değiştirilmediğini doğrulamak için SHA-256 özeti (swf-oyunlar/araclar/derle.sh ile aynı)
FFDEC_SHA256="dfa3a36575fd62bccc19750707a2f9d3a01bfc183763a061f07cb4f8cf1e38ed"
FFDEC="$REF/.araclar/ffdec"

if [ ! -f "$FFDEC/ffdec-cli.jar" ]; then
  echo "FFDec $FFDEC_SURUM indiriliyor..."
  mkdir -p "$FFDEC"
  curl -fsSL -o "$FFDEC/ffdec.zip" \
    "https://github.com/jindrapetrik/jpexs-decompiler/releases/download/version$FFDEC_SURUM/ffdec_$FFDEC_SURUM.zip"
  echo "$FFDEC_SHA256  $FFDEC/ffdec.zip" | sha256sum -c --quiet -
  unzip -q -o "$FFDEC/ffdec.zip" -d "$FFDEC"
  rm "$FFDEC/ffdec.zip"
fi

FF="java -Djava.awt.headless=true -jar $FFDEC/ffdec-cli.jar"
sessiz() { grep -v -e "JAVA_TOOL_OPTIONS" -e "^Exported" || true; }

cd "$KOK"
cargo build -q --release -p engine --example svg-png
for oyun in f1 f2; do
  if [ "$oyun" = f1 ]; then
    swf="$SWF_KOK/oyunlar/feudalism/feudalism-orijinal.swf"
    kukla="547,205,529,486,495,279,309,478"
  else
    swf="$SWF_KOK/oyunlar/feudalism-2/feudalism-2-orijinal.swf"
    kukla="1038,432,989,914,927,562,903,849"
  fi
  echo "$oyun: şekiller (SVG, PNG), kukla sprite'ları ve kod çıkarılıyor..."
  rm -rf "$REF/$oyun/svg" "$REF/$oyun/png" "$REF/$oyun/sprite"
  $FF -format shape:svg -export shape "$REF/$oyun/svg" "$swf" 2>&1 | sessiz | tail -1
  $FF -format shape:png -zoom 4 -export shape "$REF/$oyun/png" "$swf" 2>&1 | sessiz | tail -1
  $FF -format sprite:svg -selectid "$kukla" -export sprite "$REF/$oyun/sprite" "$swf" 2>&1 | sessiz | tail -1
  $FF -export script "$REF/$oyun/kod" "$swf" 2>&1 | sessiz | tail -1
  echo "$oyun: birlikler birleştiriliyor..."
  python3 araclar/olcum/birlikler.py "$oyun" "$swf" "$REF/$oyun/svg" "$REF/$oyun/birlikler"
  mkdir -p "$REF/$oyun/birlikler-png"
  for f in "$REF/$oyun/birlikler"/*.svg; do
    ./target/release/examples/svg-png "$f" "$REF/$oyun/birlikler-png/$(basename "$f" .svg).png" 3 >/dev/null
  done
  SWF_KOK="$SWF_KOK" python3 araclar/olcum/kukla_yapisi.py "$oyun"
done
SWF_KOK="$SWF_KOK" python3 araclar/olcum/olc.py "$REF" docs/KARAKTER_OLCULERI.md
for oyun in f1 f2; do
  if [ "$oyun" = f1 ]; then swf="$SWF_KOK/oyunlar/feudalism/feudalism-orijinal.swf"; else swf="$SWF_KOK/oyunlar/feudalism-2/feudalism-2-orijinal.swf"; fi
  T="$REF/$oyun/tam"
  echo "$oyun: tam döküm (her içerik türü, XML dökümü, Flash projesi) → $T"
  rm -rf "$T"
  mkdir -p "$T"
  # Türler ayrı ayrı: FFDec'in bir türdeki hatası öbürlerini durdurmasın. FFDec tek tür dışa aktarırken
  # alt klasör açmaz; her tür kendi klasörüne yazılır (aktar.py ve denetim.py bu adları bekler).
  $FF -format shape:svg -export shape "$T/shapes" "$swf" 2>&1 | sessiz | tail -1
  $FF -format morphshape:svg -export morphshape "$T/morphshapes" "$swf" 2>&1 | sessiz | tail -1
  $FF -format morphshape:png_start_end -zoom 4 -export morphshape "$T/morph-png" "$swf" 2>&1 | sessiz | tail -1
  $FF -format image:png_gif_jpeg -export image "$T/images" "$swf" 2>&1 | sessiz | tail -1
  $FF -format sound:mp3_wav -export sound "$T/sounds" "$swf" 2>&1 | sessiz | tail -1
  $FF -format font:ttf -export font "$T/fonts" "$swf" 2>&1 | sessiz | tail -1
  $FF -format text:formatted -export text "$T/texts" "$swf" 2>&1 | sessiz | tail -1
  $FF -format frame:png -export frame "$T/frames" "$swf" 2>&1 | sessiz | tail -1
  $FF -format button:png -export button "$T/buttons-png" "$swf" 2>&1 | sessiz | tail -1
  $FF -format script:as -export script "$T" "$swf" 2>&1 | sessiz | tail -1
  $FF -format script:pcode -export script "$T/pcode" "$swf" 2>&1 | sessiz | tail -1
  $FF -export binaryData,symbolClass "$T" "$swf" 2>&1 | sessiz | tail -1
  metinler=$(python3 -c "import sys; sys.path.insert(0, 'araclar/aktar'); import swf; print(','.join(str(i) for i in sorted(swf.Movie('$swf').texts)))")
  $FF -format text:svg -selectid "$metinler" -export text "$T/text-svg" "$swf" 2>&1 | sessiz | tail -1
  $FF -format xfl:cs5 -export xfl "$T/xfl" "$swf" 2>&1 | sessiz | tail -1
  $FF -swf2xml "$swf" "$T/swf.xml" 2>&1 | sessiz | tail -1
  # Türkçe sürümden resim olarak çizilmiş yazıların Türkçe hâlleri (çeviri tablosu sekiller.json)
  if [ "$oyun" = f1 ]; then klasor="$SWF_KOK/oyunlar/feudalism"; tr="$klasor/feudalism-tr.swf"; else klasor="$SWF_KOK/oyunlar/feudalism-2"; tr="$klasor/feudalism-2-tr.swf"; fi
  cizimler=$(python3 -c "import json; print(','.join(k for k in json.load(open('$klasor/ceviri/sekiller.json', encoding='utf-8')) if not k.startswith('_')))")
  rm -rf "$REF/$oyun/tr"
  $FF -selectid "$cizimler" -format shape:svg -export shape "$REF/$oyun/tr/shapes" "$tr" 2>&1 | sessiz | tail -1
  $FF -selectid "$cizimler" -format shape:png -zoom 4 -export shape "$REF/$oyun/tr/png" "$tr" 2>&1 | sessiz | tail -1
done
echo "Görseller, sesler, yazılar ve Türkçe çeviri oyunun içerik klasörüne aktarılıyor (content/feudalism, kaynak/feudalism)..."
python3 araclar/aktar/aktar.py "$SWF_KOK"
python3 araclar/aktar/envanter.py "$SWF_KOK"
