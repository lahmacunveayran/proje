# Karakter ölçüleri (esin kaynağından)

Bu sayfa `araclar/olcum/olc.py` ile **otomatik üretilir**; elle düzenlenmez. Esin kaynağı iki
oyunun savaş kuklaları, oyunun kendi kodundaki formüllerle (ulus, cinsiyet, zırh, miğfer, silah,
duruş) birleştirildi ve parça parça ölçüldü. Esinin çizimleri depoya girmez; yalnızca bu sayılar.

Uzunluklar eklemden ekleme ölçülür (duruştan bağımsız). Birim: oyun pikseli. Oranlar başın
yüksekliğine (`baş`: saç dahil, miğfer hariç) bölünmüştür.

## Oranlar (baş = 1)

| Ölçü | Ortanca | En az | En çok |
| --- | --- | --- | --- |
| Ayakta boy | 6,22 | 5,83 | 6,37 |
| Boyun–kalça | 2,05 | 1,96 | 2,19 |
| Uyluk | 1,51 | 1,38 | 1,56 |
| Diz–taban | 1,92 | 1,81 | 1,95 |
| Üst kol | 1,25 | 1,08 | 1,28 |
| Ön kol + el | 1,43 | 1,34 | 1,45 |
| El boyu | 0,68 | 0,57 | 0,82 |
| El eni | 0,38 | 0,36 | 0,52 |
| Ön kol eni | 0,40 | 0,36 | 0,44 |
| Bilek eni | 0,24 | 0,24 | 0,38 |
| Ayak boyu | 0,61 | 0,58 | 0,61 |
| Gövde eni | 1,14 | 1,12 | 1,38 |
| Baş eni | 0,88 | 0,80 | 0,88 |

Baş yüksekliği: ortanca 28,1 piksel (28,1–30,0).

## Parça kutuları (kendi eksenlerinde, baş = 1)

Her parça dönme noktası (0, 0) olan kendi ekseninde ölçüldü; uzuvlar +y yönünde uzanır. `Üst`:
parçanın eklemin üstüne taşan kısmı (bindirme payı). `Alt`: eklemden ucuna. `En`: en geniş yeri.

| Parça | Üst | Alt | Sol | Sağ | En |
| --- | --- | --- | --- | --- | --- |
| Baş (saç dahil) | 0,71 | 0,29 | -0,55 | 0,33 | 0,85 |
| Gövde | 1,95 | 1,08 | -0,77 | 0,81 | 1,42 |
| Üst kol | 0,21 | 1,32 | -0,36 | 0,22 | 0,57 |
| Ön kol + el | 0,18 | 1,43 | -0,18 | 0,29 | 0,41 |
| Uyluk | 0,27 | 1,53 | -0,33 | 0,38 | 0,71 |
| Baldır + çizme | 0,22 | 1,92 | -0,16 | 0,73 | 0,65 |

## Silah tutuşu

Silahın dönme noktası tutuş yeridir; ön kol + el parçası silahın **üstüne** çizilir ve parmaklar
sapın üstüne biner. `Tutuş`: silahın üst ucundan tutuş yerine oran. `Açı`: duruşta silahın yataydan
sapması (derece). `El–tutuş`: elin ortası ile tutuş noktası arası (baş = 1).

| Birlik | Oyun | Silah | Silah boyu (baş) | Tutuş | Açı | El–tutuş |
| --- | --- | --- | --- | --- | --- | --- |
| kervan-muhafizi | f1 | OnehandedSword | 2,47 | 0,87 | 57 | 0,17 |
| hat-piyadesi-mizrakci | f1 | Spear | 9,03 | 0,66 | 6 | 0,11 |
| lejyoner | f1 | OnehandedSword | 3,18 | 0,88 | 57 | 0,17 |
| sehir-muhafizi-balta | f1 | TwohandedAxe | 5,12 | 0,90 | 58 | 0,12 |
| okcu-ger | f1 | Bow | 4,55 | 0,50 | 71 | 0,76 |
| mizrakci-rus | f1 | Spear | 9,22 | 0,67 | 6 | 0,11 |
| mizrakci-ger-kadin | f1 | Spear | 8,15 | 0,65 | 6 | 0,23 |
| kervan-muhafizi-viz | f2 | OnehandedSword | 2,47 | 0,87 | 57 | 0,17 |
| hafif-mizrakci-viz | f2 | Spear | 9,03 | 0,66 | 6 | 0,11 |
| okcu-viz | f2 | Bow | 4,55 | 0,50 | 71 | 0,68 |
| kilicli-mon | f2 | OnehandedSword | 2,83 | 0,89 | 57 | 0,17 |
| hafif-gozcu-mon | f2 | TwohandedSword | 5,26 | 0,86 | 64 | 0,16 |
| tuccar-muhafizi-mon | f2 | TwohandedSword | 4,89 | 0,86 | 64 | 0,16 |
| okcu-mon | f2 | Bow | 4,56 | 0,50 | 71 | 0,63 |
| han-muhafizi-mon | f2 | OnehandedSword | 3,81 | 0,91 | 57 | 0,17 |
| kadin-okcu-ger | f2 | Bow | 4,26 | 0,50 | 71 | 0,73 |

## Birlik başına ölçüler (baş = 1)

| Birlik | Oyun | Baş (px) | Boy | Gövde | Uyluk | Diz–taban | Üst kol | Ön kol+el | El boyu | El eni | Ayak |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| kervan-muhafizi | f1 | 28,1 | 6,10 | 1,96 | 1,51 | 1,92 | 1,25 | 1,44 | 0,68 | 0,38 | 0,61 |
| hat-piyadesi-mizrakci | f1 | 28,1 | 6,35 | 2,19 | 1,52 | 1,92 | 1,16 | 1,43 | 0,68 | 0,37 | 0,61 |
| lejyoner | f1 | 28,1 | 6,10 | 1,96 | 1,51 | 1,92 | 1,25 | 1,44 | 0,68 | 0,38 | 0,61 |
| sehir-muhafizi-balta | f1 | 28,1 | 6,19 | 2,04 | 1,51 | 1,92 | 1,28 | 1,44 | 0,74 | 0,38 | 0,61 |
| okcu-ger | f1 | 28,1 | 6,22 | 2,12 | 1,47 | 1,93 | 1,27 | 1,43 | 0,82 | 0,52 | 0,61 |
| mizrakci-rus | f1 | 28,1 | 6,37 | 2,19 | 1,52 | 1,95 | 1,16 | 1,43 | 0,68 | 0,37 | 0,58 |
| mizrakci-ger-kadin | f1 | 30,0 | 5,94 | 2,06 | 1,42 | 1,81 | 1,08 | 1,34 | 0,80 | 0,49 | 0,60 |
| koylu-yumruk | f1 | 28,1 | 6,37 | 2,18 | 1,56 | 1,92 | 1,17 | 1,42 | 0,61 | 0,36 | 0,61 |
| kervan-muhafizi-viz | f2 | 28,1 | 6,10 | 1,96 | 1,51 | 1,92 | 1,25 | 1,44 | 0,68 | 0,38 | 0,61 |
| hafif-mizrakci-viz | f2 | 28,1 | 6,35 | 2,19 | 1,52 | 1,92 | 1,16 | 1,43 | 0,68 | 0,37 | 0,61 |
| okcu-viz | f2 | 28,1 | 6,22 | 2,12 | 1,47 | 1,93 | 1,27 | 1,43 | 0,68 | 0,37 | 0,61 |
| kilicli-mon | f2 | 28,1 | 6,10 | 1,96 | 1,51 | 1,92 | 1,25 | 1,45 | 0,58 | 0,37 | 0,61 |
| hafif-gozcu-mon | f2 | 28,1 | 6,22 | 2,04 | 1,55 | 1,92 | 1,27 | 1,44 | 0,71 | 0,38 | 0,61 |
| tuccar-muhafizi-mon | f2 | 28,1 | 6,22 | 2,04 | 1,55 | 1,92 | 1,27 | 1,44 | 0,71 | 0,38 | 0,61 |
| okcu-mon | f2 | 28,1 | 6,22 | 2,12 | 1,47 | 1,93 | 1,27 | 1,43 | 0,57 | 0,37 | 0,61 |
| han-muhafizi-mon | f2 | 28,1 | 6,10 | 1,96 | 1,51 | 1,92 | 1,25 | 1,45 | 0,58 | 0,37 | 0,61 |
| koylu-yumruk-viz | f2 | 28,1 | 6,37 | 2,18 | 1,56 | 1,92 | 1,17 | 1,42 | 0,69 | 0,37 | 0,61 |
| kadin-okcu-ger | f2 | 30,0 | 5,83 | 1,99 | 1,38 | 1,81 | 1,19 | 1,34 | 0,80 | 0,49 | 0,60 |

## Yapı: katmanlar, dolgu, kontur

- **Çizim sırası (f1, arkadan öne):** `hand_r` → `arm_r` → `weapR` → `legR` → `footR` → `legL` → `footL` → `body` → `head` → `weapL` → `hand_l` → `arm_l`
- **Çizim sırası (f2, arkadan öne):** `hand_r` → `weapR` → `arm_r` → `legR` → `footR` → `legL` → `footL` → `body` → `head` → `weapL` → `hand_l` → `arm_l`
- Parça adları oyundaki gibidir: `hand_*` üst kol (omuz–dirsek), `arm_*` ön kol ve el, `leg*` uyluk,
  `foot*` baldır ve çizme. Her parça tek bir şekildir; içinde 1–10 düz renk dolgu vardır.
- **Degrade:** 0 / 890 dolgu (%0.0). Savaş kuklası düz renktir.
- **Kontur:** dış hat yok. İnce çizgi yalnızca şu parçalarda: `body` (0.25 birim), `head` (0.25 birim).

## Renkler (birleştirilen birliklerde geçen bütün düz renkler)

`#000000`, `#2B1A00`, `#2D2317`, `#3C2300`, `#660000`, `#33331A`, `#492B0C`, `#333333`, `#3F3216`, `#462F17`, `#423224`, `#3C362B`, `#4D331A`, `#543201`, `#7D0B0B`, `#503C1F`, `#533D0B`, `#593C1E`, `#8F0101`, `#653D01`, `#494825`, `#604020`, `#484848`, `#990000`, `#664422`, `#6D4201`, `#514E37`, `#505027`, `#793F06`, `#991E00`, `#6C4824`, `#515151`, `#764701`, `#694E0E`, `#7D4713`, `#734D26`, `#AD0E0E`, `#6A5140`, `#7E4B01`, `#4E576D`, `#744F36`, `#A92201`, `#795128`, `#695A38`, `#75572D`, `#4F6164`, `#505F74`, `#5E5E5E`, `#685F4A`, `#586174`, `#B13501`, `#7B5C2F`, `#86592D`, `#666633`, `#74633F`, `#626853`, `#666666`, `#536B71`, `#A35407`, `#876412`, `#CC3300`, `#BA4A01`, `#5A7271`, `#637172`, `#AC5806`, `#996600`, `#587885`, `#70775E`, `#966F14`, `#946F38`, `#6A7795`, `#857A50`, `#9A743A`, `#A66F37`, `#D25502`, `#8C7E0D`, `#9D7B48`, `#848484`, `#C27F6E`, `#BF8B15`, `#9F9382`, `#A49575`, `#EA792F`, `#999999`, `#AB9B10`, `#AE996A`, `#D79D17`, `#C1A479`, `#AAAAAA`, `#C2B012`, `#EF9C65`, `#D6AC07`, `#BBB099`, `#FF9900`, `#B3B979`, `#BBBBBB`, `#E4B381`, `#F3B58C`, `#E7C132`, `#E0CB16`, `#CCCCCC`, `#D0D0D0`, `#D0D1D9`, `#CED2DB`, `#FFCC00`, `#FFCC99`, `#D9D9D9`, `#FDD73E`, `#FEDB4E`, `#FCDC61`, `#DEDEE4`, `#EEDCCC`, `#FEDF67`, `#DDE1E6`, `#EAE2D9`, `#FDE99B`, `#FEE99A`, `#EAEAEA`, `#EEEEEE`, `#FEF5D6`, `#FFFF99`, `#FFFFCC`, `#FFFFFF`

