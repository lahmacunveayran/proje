<!-- Bağımsız denetçinin raporu (16 Ekim 2026), değiştirilmeden alındı; yalnız geçici klasör yolları
kısaltıldı. Bulguların durumu: docs/gunluk/2026-10-16.md, "Yarım kalanlar". -->

# Feudalism 1 ve 2 ayıklamasının bağımsız denetimi (Denetim 2)

Denetlenen sürüm: depo `/home/user/proje`, commit `e991808` ("Sesleri eksiksiz aktar, Türkçe çeviriyi ve
yazı tiplerini ekle"), çalışma ağacı temiz. Kaynaklar: `feudalism-orijinal.swf`
(SHA-256 `751766…a6c8`), `feudalism-2-orijinal.swf` (`94cdf5…1061`), Türkçe sürümler
`feudalism-tr.swf` (`38c1b2…9301`) ve `feudalism-2-tr.swf` (`fe3f44…ef33`).
Denetim sırasında ekip içeriği yeniden aktardı; bu rapor güncel içerik üzerinedir. İlk incelemede bulunup
yeniden aktarımda düzelen şeyler ayrı bir bölümde yazılıdır. Denetçinin betikleri ve çıktıları geçici çalışma klasöründeydi (aşağıda `$D`); depoda değiller.

## Sade özet

Ayıklama büyük ölçüde gerçekten eksiksiz ve doğru. SWF dosyalarını kendi yazdığım, ekibin kodundan
bağımsız bir okuyucuyla baştan okudum ve oyuna aktarılan her şeyi onunla karşılaştırdım:

- Hiçbir karakter kaybolmamış; etiket sayıları, zaman çizelgelerinin 76 580 işleminin hepsi, düğmeler,
  sesler (bayt bayt), resimler (piksel piksel), şekillerin 306 823 kenar parçası (twip twip), yazılar
  (glif glif) ve kodun 1 748 parçası birebir tutuyor.
- Türkçe çeviri doğru aktarılmış: tablolar sahibinin tablolarıyla aynı, her girdinin hedefi oyunda var,
  sonuç sahibinin Türkçe SWF'siyle aynı, Türkçe harflerin hepsi seçilen yazı tiplerinde var.

Ama "0 sorun" iddiası doğru değil. Bulduklarım:

1. **Sponsor logosu oyuna girmiş (önemli).** "Sponsor logoları aktarılmaz" deniyor, ama ArcadeTown logosu
   iki oyunda da ana menüde ve başka ekranlarda kullanıldığı için içeriğe (ve .exe'ye) girmiş. Feudalism 2
   için belge "sponsor parçası 0" diyor; oysa açılıştaki ArcadeTown animasyonu da aktarılmış.
2. **Bir efektte degrade ters dönmüş (önemli).** Feudalism 2'deki güneş ışını efektinin (morph 3058 ve
   3060) bir ışını, aktarılan başlangıç ve bitiş çizimlerinde ters yönde parlıyor. Ekibin piksel denetimi
   bunu kaçırmış.
3. **Ekibin denetim aracı güvenilir bir "0" vermiyor (önemli).** Eşikleri gevşek ve bazı satırları
   kendini kendisiyle karşılaştırıyor; yukarıdaki iki hatayı ve aşağıdaki küçük hataları yakalamadı.
4. Küçük şeyler: morph bitiş renklerinde gözle görülmeyecek kadar küçük (1/255) bir kayma; Adobe ve
   reklam şirketlerinin kodu `kaynak/` altında depoya girmiş; ana menüdeki "The Age of..." yazısı resim
   olarak çizildiği için Türkçeye çevrilmemiş ve belge bunu saymıyor; bir yazı alanı belgede yanlış
   sınıflandırılmış; TeX Gyre yazı tiplerinin lisansında dikkat edilecek bir koşul var; birkaç sayısal
   değer 4 basamağa yuvarlanmış (etkisi 0,05 pikselin altında).

İlk incelemede bulduğum üç ses hatası (kök filmdeki "sesi durdur" komutunun "çal" diye kaydedilmesi, MP3
gecikmesinin kaybolması, yanlış bayt sayısı) ekibin yeniden aktarımında düzeltilmiş; doğruladım.

## Bulgular

Önem dereceleri: kritik / önemli / küçük / bilgi. Komutlardaki `$D`,
denetçinin geçici çalışma klasörüdür (depoda yok); betikler `python3 -I $D/<betik>.py` ile çalışıyordu
ve depoya yazmıyordu.

### B1. ArcadeTown sponsor logosu içeriğe aktarılmış — önemli

**Ne bulundu.** Ekip yalnız F1'deki sprite 140'ın ağacını sponsor diye dışarıda bırakıyor; F2'de sponsor
parçası olmadığını söylüyor. Oysa:

- **F1:** ArcadeTown logosu sprite 54'tür (şekil 52 = logo, şekil 53 = pencere). Sponsorun yükleme
  ekranında (sprite 58) ve **oyunun ana menüsünde** (sprite 1494, derinlik 367, konum 47,4 / 586,6,
  ölçek 0,29) kullanılır. Ana menü aktarıldığı için ekibin "oyunun da kullandığı karakterler hariç" kuralı
  logoyu içeriğe almış: `content/feudalism/f1/shapes/52.svg`, `53.svg`, `library.json → sprites.54`.
- **F2:** sprite 1763 (100 karelik ArcadeTown açılış animasyonu; çocukları 1745–1762) kök filmin
  3. karesindeki sprite 1935'in içinde; sprite 1962 (ArcadeTown logosu; çocukları 1746, 1961) kök filmin
  113. ve 115. karelerinde ve ana menüde (sprite 2342). Şekil 1745, 1746, 1761, 1762, F1'deki sponsor
  şekilleri 59, 53, 76, 77 ile (kimlik dışında) bayt bayt aynıdır. Hepsi `content/feudalism/f2/` altında
  ve `library.json`'da var; `excluded` boş.
- `crates/game/build.rs` `content/` altındaki her dosyayı gömdüğü için bunlar `.exe`'ye de giriyor.
- Belgeler çelişiyor: `docs/LISANSLAR.md` "açılıştaki sponsor logoları (ArcadeTown, Newgrounds)
  aktarılmaz" der; `docs/FEUDALISM_ICERIK.md` F1 için "Sponsor parçası: 1 sembol", F2 için "0 sembol"
  der, ama aynı belge F2 kök kareleri 1–3 için "sponsor logoları" yazar.

**Kanıt.**

```
$ python3 -I $D/b5_sponsor.py
F1: sprite 140'tan ulasilip aktarilanlar: [49, 52, 53, 54, 60, 92] [(49, 'font'), (52, 'shape'), (53, 'shape'), (54, 'sprite'), (60, 'shape'), (92, 'shape')]
F1: sprite 54'u kullananlar: [58, 1494]
   sprite 1494 kare 1 derinlik 367 matris [0.29, 0.0, 0.0, 0.29, 47.4, 586.6]
F1 aktarilmis mi: sprite 54 True sekil 52 True sekil 53 True
F2: F1 sponsor sekillerinin birebir kopyalari (F1, F2, aktarilmis): [(53, 1746, True), (59, 1745, True), (60, 1764, True), (76, 1761, True), (77, 1762, True)]
F2: 1763 ebeveyn [1935] 1935 kok kareleri [3] 1962 kok kareleri [113, 115] 1962 ebeveyn [2342]
F2 aktarilmis mi: 1763 True 1962 True excluded'da sponsor: []
```

(Şekil 60/1764 düğmelerin genel tıklama alanıdır, 49 bir sistem yazı tipi, 92 başka bir oyun şekli;
bunlar sponsorun değildir.)

Görsel kanıt (FFDec'in çizimleri): `$D/f1_sekil_52_53_995_1019.png` (soldaki ArcadeTown),
`$D/f2_logo.png` (sprite 1763'ün 30., 70., 100. kareleri ve sprite 1962), `$D/f2_ekranlar.png` (ana menü,
oyun bitti ve korsan kopya ekranlarının sol/sağ alt köşesindeki logo). Sahibinin Türkçe SWF'sinde de logo
duruyor (`$D/tr_f1_kare4.png`, sol alt).

**Yeniden üretme.** `python3 -I $D/b5_sponsor.py` (çıktı `$D/b5_sponsor.txt`). FFDec ile:
`java -Djava.awt.headless=true -jar /home/user/proje/referans/.araclar/ffdec/ffdec-cli.jar -format sprite:png -selectid 1763,1962 -export sprite <klasör> feudalism-2-orijinal.swf`.

**Öneri.** `aktar.py`'deki `EXCLUDED` listesine F1 için 54, 52, 53; F2 için 1763 (ve yalnız onun
kullandığı 1745, 1747–1762), 1962, 1961 eklensin; kural "sponsor ağacından ulaşılan ama oyunun da
kullandığı" karakterleri yine dışarıda bırakacak biçimde değiştirilsin (logo, oyun sembolünün içinde de
olsa sponsorundur). Oynatıcı, yerleştirilen ama tanımı olmayan karakteri atlamalı (bkz. B5). Belgeler
düzeltilsin. Ayrıca sponsor şekillerinin içerik özetiyle (kimlik dışındaki baytlar) aranması denetime
eklensin; F2'deki kopyalar ancak böyle bulunur.

### B2. F2 morph 3058 ve 3060: bir doğrusal degrade başlangıç ve bitiş SVG'lerinde ters — önemli

**Ne bulundu.** SWF'de bu iki morph'un ilk dolgu stili doğrusal degradedir; başlangıç ve bitiş matrisi
`(-0,1379; 0; 0; -0,0883; -167,3; 0,15)`, yani 180° döndürülmüş. Aktarılan `3058.start.svg`,
`3058.end.svg`, `3060.start.svg`, `3060.end.svg` dosyalarında matris `(0,1379; 0; 0; 0,0883; …)`: işaret
kaybolmuş, degrade ters yönde. Neden: FFDec'in morph SVG'sinde degrade matrisi `animateTransform`
dizisine (ölçek, öteleme, dönme, ölçek, eğme) ayrıştırılıyor ve bu ayrıştırmada dönme 0 çıkıyor;
`aktar.apply_animates` doğru olan durağan `gradientTransform` değerini bu yanlış ayrıştırmayla
değiştiriyor. FFDec'in XML dökümü de SWF'deki işareti doğruluyor
(`startGradientMatrix ... scaleX="-0.13790894" scaleY="-0.08834839"`).

Görünür etkisi: güneş ışını efektinin sol ışını içte koyu, uçta parlak çiziliyor (doğrusu tersi).
3058'in başlangıç ucunda, aktarılan SVG'nin motor çizimi ile matrisi düzeltilmiş SVG'nin motor çizimi
arasında piksellerin %5,6'sı belirgin farklı. Ekibin morph piksel denetimi F2'de en kötü farkı %1,73
bulup geçmiş.

**Kanıt.**

```
$ python3 -I $D/a12c_morphdegrade.py
===== f1 degrade ucu 8 hatali 0
===== f2 degrade ucu 64 hatali 4
    ('3058', 'start', 'dolgu 0 (0x10)', [-0.1379, 0.0, 0.0, -0.0883, -167.3, 0.15], [0.1379, 0.0, 0.0, 0.0883, -167.3, 0.15], "ozgun SVG'nin duragan degeri:", [-0.1379, 0.0, 0.0, -0.0883, -167.3, 0.15])
    ('3058', 'end', ...)  ('3060', 'start', ...)  ('3060', 'end', ...)   (aynı)
$ grep -n 'DefineMorphShapeTag[^>]*characterId="3058"' referans/f2/tam/swf.xml   → startGradientMatrix scaleX="-0.13790894" ...
farkli piksel orani (>16): 0.0563
```

Görsel: `$D/morph3058/levha_kucuk.png` (soldan: aktarılan, matrisi düzeltilmiş, FFDec'in PNG'si).

**Öneri.** Morph uçlarının degrade matrisleri `animateTransform`'dan değil, başlangıç için durağan
`gradientTransform`'dan, bitiş için doğrudan SWF'den (ya da FFDec XML'indeki `endGradientMatrix`'ten)
alınsın. Denetime, morph uçlarındaki her degrade matrisinin ve rengin SWF'deki değerle sayısal
karşılaştırması eklensin.

### B3. Morph bitiş SVG'lerinde bütün renklerin mavi kanalı 1 fazla — küçük

**Ne bulundu.** FFDec morph SVG'sinde bitiş rengini başlangıçtan ayırmak için mavi kanala 1 ekliyor
(`values="#990000;#990001"`); aktarım bu değeri olduğu gibi `.end.svg`'ye yazıyor. 36 morph'un tamamında,
bitiş ucundaki her düz dolgu, çizgi ve degrade durağı SWF'dekinden 1/255 farklı (ör. 552: SWF
`(153,0,0)`, SVG `(153,0,1)`; 3060: `(253,159,19)` → `(253,159,20)`). Gözle görülmez, ama veri yanlış ve
mavi kanalı 255 olan bir renkte taşma yapabilir.

**Kanıt.** `python3 -I $D/a12b_morphstil.py` → F1 `{'uc': 22, 'duz renk farkli': 7, 'cizgi farkli': 11, 'degrade farkli': 4}`,
F2 `{'uc': 50, 'duz renk farkli': 10, 'cizgi farkli': 25, 'degrade farkli': 32}`; bütün farklar yalnız bitiş
ucunda ve yalnız mavi kanalda +1.

**Öneri.** Bitiş renkleri SWF'den (ya da XML'deki `endColor`) yazılsın.

### B4. Üçüncü tarafların kodu `kaynak/` altında depoya girmiş — küçük

**Ne bulundu.** Belgeler sponsor ve Macromedia/Adobe parçalarının "yalnız yerel arşivde" kaldığını
söylüyor; ama `kaynak/feudalism/<oyun>/kod/` git'te ve şunları içeriyor:

- F2: Adobe v2 bileşenlerinin 43 sınıfı (`kod/__Packages/mx/...`) ve bileşen sprite'larının betikleri
  (`kod/Button.as`, `kod/DefineSprite_100_NumericStepper/...` vb.); MochiAds reklam kütüphanesi
  (`kod/__Packages/MochiAd.as`).
- F1: sponsorun yükleme ekranlarının kodu (`kod/DefineSprite_140`, `_58`, `_78`, `_129`, `_139`;
  Newgrounds ön yükleyicisi dahil) ve MochiBot izleme kodu (`kod/frame_1/DoAction_2.as`).
- F2 `library.json`'da mx sınıflarının 43 boş tutucu sprite'ı (ör. 49, 50, 51, 101–124, 205–220) duruyor.

`.exe`'ye girmiyorlar ama depo dağıtılıyorsa bu kod da dağıtılıyor.

**Kanıt.** `git ls-files kaynak | grep -c "__Packages/mx"` → 43; `git ls-files kaynak | grep -i mochi` →
`kaynak/feudalism/f2/kod/__Packages/MochiAd.as`.

**Öneri.** Bu dosyalar `kaynak/`'tan çıkarılıp `referans/` arşivinde bırakılsın (ya da belgeler
"kodları depoda" diye düzeltilsin ve lisans durumları yazılsın).

### B5. Aktarılan kök zaman çizelgesi, aktarılmayan bir karakteri yerleştiriyor — küçük

**Ne bulundu.** F1 `library.json → root.frames[0]` derinlik 1'e sprite 140'ı yerleştirir; 140
aktarılmadı. `library.json`'da tanımı olmayan karaktere başka başvuru yok (F2'de hiç yok). B1 düzeltilince
54, 1763, 1962 için de aynı durum doğacak. Belgeler oynatıcının bunu nasıl ele alacağını söylemiyor.

**Kanıt.** `python3 -I $D/b5_sponsor.py` → `f1 tanimsiz karaktere basvuru: [('kok', 0, 140)]`,
`f2 tanimsiz karaktere basvuru: []`.

**Öneri.** Oynatıcı tanımsız karakteri sessizce atlasın ve bunun testi yazılsın; ya da aktarım bu
yerleştirmeleri `excluded` işaretiyle yazsın.

### B6. "The Age of..." yazısı resim olarak çizilmiş ve çevrilmemiş; belge çizilmiş yazıyı 1 sayıyor — küçük

**Ne bulundu.** F1 ana menüsündeki "The Age of..." alt başlığı yazı değil, şekil 995'tir. Çeviri
tablolarında yok; sahibinin Türkçe SWF'sinde de İngilizce kalmış. `docs/FEUDALISM_ICERIK.md` F1 için
"Resim olarak çizilmiş yazı: çevrilen 1, toplam 1" diyor; toplam en az 2'dir ("FEUDALISM" başlığı da
çizimdir, ama özel ad). Çizilmiş yazıları kendiliğinden arayan bir yöntem yok; ben ekranlara bakarak
buldum, başkaları da olabilir.

**Kanıt.** `$D/f1_sekil_52_53_995_1019.png` (ortadaki), `$D/tr_f1_kare4.png` (Türkçe sürümün ana
menüsü, sol üstte "The Age of...").

**Öneri.** Sahibine sorulup `sekiller.json`'a eklensin; belgedeki "toplam" sütunu ya kaldırılsın ya da
ekranlar elle taranarak doldurulsun.

### B7. F2 çevrilmeyen kutuların sınıflandırmasında hata; korsan kopya ekranı İngilizce — küçük

**Ne bulundu.** `docs/FEUDALISM_ICERIK.md` F2'deki kutu 3127'yi ("ЭТУ ИГРУ СПЕРЛИ!!!", Rusça "bu oyun
çalındı") "yalnız sayı ve işaret (oyun doldurur)" sayıyor; bu bir metindir ve kod onu doldurmaz (kök kare
115'teki korsan kopya ekranında durur). Aynı ekrandaki 6 kutu (3125, 3126, 3128, 3129, 3130, 3132)
"oyunumuzda gösterilmez" gerekçesiyle çevrilmemiş; bu bir varsayım, belgede kararın sahibi yazılı değil.
Öbür sınıflar doğru: F1'in 107 çevrilmeyen kutusunun hepsi ve F2'nin "tasarım örneği" sayılan 10 kutusu
(223, 225, 242, 251, 252, 253, 257, 258, 338, 340) gerçekten kodla doldurulur (sprite 341'deki
`descr_txt`, `name_txt`, `cost_txt`, `type_txt`, `stats_txt` adlarına kod `.text =` ile yazar).

**Kanıt.** `python3 -I $D/b2_ceviri.py` → `(3127, 'harf disi yazi (Latin olmayan)', 'ЭТУ ИГРУ СПЕРЛИ!!!', '')`;
belgede `| yalnız sayı ve işaret (oyun doldurur) | 42 | ... 3127 (ЭТУ ИГРУ СПЕРЛИ!!!) |`.

**Öneri.** `envanter.py`'nin sınıflandırması Latin dışı harfleri metin saysın; korsan kopya ekranının
oyunda olup olmayacağı karara bağlanıp belgeye yazılsın.

### B8. TeX Gyre yazı tiplerinin lisansı (GUST / LPPL 1.3c): kısmi dağıtım koşulu — küçük

**Ne bulundu.** Proje kuralı (AGPL ve ticari kullanımı yasaklayan lisans yok) karşılanıyor: Liberation
2.1.5 SIL OFL 1.1 (dosyanın kendi `name` tablosu da öyle diyor), TeX Gyre GUST Font License (LPPL 1.3c
temelli; ticari kullanım serbest). Ancak:

- LPPL 1.3c madde 6: "Çalışmanın yalnız bir kısmının dağıtılması değişiklik sayılır". Projeye TeX Gyre
  ailelerinin yalnız 6 OTF dosyası alınmış (Pagella'nın 2, Bonum'un 2, Chorus'un 1, Adventor'un 1
  dosyası; ailelerin MANIFEST/README dosyaları yok). Sıkı okumada bu "değiştirilmiş çalışma" dağıtımıdır
  ve madde 7'nin koşulları (değiştirildiğinin belirtilmesi vb.) devreye girer.
- `content/fonts/GUST-Font-License.txt` 2006 tarihli "ön sürüm" metnidir ve LPPL'nin kendi metnine
  yalnız bağlantı verir; LPPL metni yok.
- Bonum ve Chorus dosyalarının `fsType` değeri 12 (gömme kısıtı bitleri); lisans değil, ama dosyayı
  belgelere gömen araçlarda uyarı çıkarabilir.

**Kanıt.** `python3 -I $D/b1_yazitipi.py` (çıktı `$D/b1_yazitipi.txt`); `head -30 content/fonts/GUST-Font-License.txt`.

**Öneri.** TeX Gyre ailelerinin dağıtım paketindeki MANIFEST/README ve LPPL 1.3c metni
`content/fonts/` altına eklensin ve `LISANSLAR.md`'ye kısmi dağıtım durumu yazılsın; ya da bu aileler için
OFL lisanslı benzerleri düşünülsün. Hukuki yorumu sahibinin onaylaması iyi olur.

### B9. Ekibin denetim aracının (`denetim.py`) kör noktaları ve gevşek eşikleri — önemli

**Ne bulundu.** Araç ve raporu (`docs/AYIKLAMA_DENETIMI.md`, "Toplam sorun: 0") B1, B2, B3, B5, B6, B7'yi
ve ilk incelemede bulunan ses hatalarını yakalamadı. Nedenleri:

- **Gevşek görsel eşik:** şekil ve morph karşılaştırması beyaz arka plan dahil bütün tuvalin ortalama
  farkına %2 sınır koyuyor; küçük ya da yerel bir hata ortalamada kaybolur. B2'deki ters degrade %1,73 ile
  geçti. Morph'larda ayrıca ±3 piksel "en iyi örtüşme" araması yapılıyor; kaymaları gizleyebilir.
- **Kendini kendisiyle karşılaştıran satırlar:** "Koddaki çeviriler" satırı, aynı aracı (`kod_cevir.py`)
  aynı FFDec dökümüne yeniden uygulayıp sonucu karşılaştırır; araç belirlenimci olduğu için her zaman
  geçer. "Kod parçaları" satırı yalnız toplam dosya sayısına bakar, hangi parçanın hangi dosyada olduğuna
  bakmaz.
- **Eksik alanlar:** süzgeçler yalnız türüyle karşılaştırılıyor; sabit yazıların sınırı, matrisi ve
  saydamlığı karşılaştırılmıyor; yazı alanlarının yalnız 4 alanı (değişken, yazı, yazı tipi, boy)
  karşılaştırılıyor, belge "bütün özellikleriyle" diyor; resimler yalnız "açılıyor ve boyutu doğru" diye
  sınanıyor (piksel karşılaştırması yok); morph renkleri ve degrade matrisleri sayısal karşılaştırılmıyor.
- **Hiç bakılmayanlar:** aktarılan bir zaman çizelgesinin dışarıda bırakılan karaktere başvurması;
  sponsor parçasının ağaç dışında (başka kimlikle) bulunması; çevrilmeden kalan ekran metni.
- **Şişirilmiş sayılar:** "Dışa aktarılan adlar 89 / 258" satırı bütün dışa aktarımları sayar, ama yalnız
  bileşen ve `__Packages` olmayanları (60 / 87) karşılaştırır. "İnce çizgi işaretleri 1178" çizgiyi değil
  şekli sayar (işaretli çizgi 35 / 48).
- **Tek dayanak FFDec:** şekiller, morph'lar, resimler ve sesler FFDec'in çıktısından aktarılıp yine
  FFDec'in çıktısıyla denetleniyor. FFDec'in morph SVG'sindeki hata (B2, B3) bu yüzden iki tarafta da
  görünmez kaldı. (Ben şekilleri ve morph'ları kendi okuyucumla ayrıca karşılaştırdım; şekillerde sorun
  yok, bkz. tablo.)

**Kanıt.** `araclar/aktar/denetim.py`: `PIXEL_LIMIT = 2.0`, `pixel_difference` (tuvalin tamamı),
`best_offset(... window=3)`, `translation_problems` (kod çevirisi için `ceviri.translate_code`'u
yeniden çağırır), `xml_place` (süzgeçlerde yalnız `type`), yazı alanı döngüsü (4 alan),
`row("Dışa aktarılan adlar", len(dump.exports), probs)`.

**Öneri.** Görsel karşılaştırmada "mürekkepli piksellerin yüzde kaçı belirgin farklı" gibi yerel bir ölçüt
ve şekil başına sınır kullanılsın (benim ölçtüğüm en kötü değer kenar yumuşatmadan gelen %8,3; gerçek
hatalar bundan büyük ve kümelenmiş çıkar). Kod çevirisi sahibinin Türkçe SWF'sinin bayt kodundaki
dizelerle karşılaştırılsın (bkz. tablo). Morph renk/matris, yazı sınır/matris/saydamlık, süzgeç
ayrıntıları, tanımsız karakter başvurusu ve içerik özetiyle sponsor araması eklensin. Satır sayıları
gerçekten karşılaştırılan kayıt sayısını göstersin.

### B10. Yuvarlanan ya da tutulmayan küçük ayrıntılar — küçük

- Zaman çizelgelerinde ölçek/dönme değerleri 4 basamağa yuvarlanıyor (`aktar.clean_op`); F1'de 18 969,
  F2'de 37 768 yerleştirmede SWF'deki ham 16.16 değer geri kurulamıyor. En büyük fark 5·10⁻⁵; 800
  piksellik bir nesnede 0,04 piksel.
- FFDec'in SVG'sinde degrade ve desen matrisleri de 4 basamak (en büyük fark 5·10⁻⁵; degrade kenarında en
  çok 0,041 piksel kayma; çok küçük degradelerde göreli hata %9,75'e çıkıyor, ama mutlak etki yine
  0,04 piksel).
- Süzgeçlerin kalite (geçiş sayısı) ve "composite" alanları tutulmuyor; bu dosyalarda hepsi 1 olduğu
  için oynatıcı 1 varsayarsa kayıp olmaz.
- F2'de 43 boş sprite'ın başlığında kare sayısı 1, `library.json`'da 0 kare; bunların tamamı mx
  sınıflarının boş tutucularıdır (B4). Oynatıcı 0 kareli sprite'ı 1 kare saymalı.

**Kanıt.** `python3 -I $D/a6b_zaman.py`, `python3 -I $D/a11_sekil.py` (çıktılar `$D/a6b_zaman.txt`,
`$D/a11_sekil_guncel.txt`).

**Öneri.** Matrisler 16.16 değerin tam karşılığıyla (6 basamak ya da ham tamsayı) yazılsın; süzgeçlerin
bütün alanları kaydedilsin.

### B11. Yazı tiplerinin yerine geçenler ve yazı yerleşimi — bilgi

- Eşleme makul: Arial ve `_sans` → Liberation Sans, Times New Roman ve `_serif` → Liberation Serif (ölçüleri
  aynı), Book Antiqua → TeX Gyre Pagella, Bookman Old Style → Bonum, Century Gothic → Adventor, Monotype
  Corsiva → Chorus. Kalınlık ve italiklik her yazı tipinde doğru eşlenmiş; yalnız Chorus'un tek biçemi
  olduğu için "Monotype Corsiva kalın" (F1 1983, F2 482) da normal Chorus'a gidiyor.
- TeX Gyre yazı tipleri asıllarıyla aynı ölçüde değil. Sabit yazıların glif aralıkları özgün yazı tipine
  göredir; İngilizce yazı bu aralıklarla ikame yazı tipiyle çizilirse harfler kayar. Türkçe metin zaten
  yeniden dizilecek, ama özgün yazı tiplerinin satır ölçüleri (ascent, descent, leading) `texts.json`'da
  yok.
- Sabit yazı (DefineText) ve yazı alanları için gömülü glif yok; oynatıcı bunları ikame yazı tipiyle
  dizecek. F2'de gömülü yazı tipi kullanan 151 yazı alanından yalnız 1'inde "gömülü glifle çiz"
  (UseOutlines) bayrağı var; özgün oyun öbürlerini sistem yazı tipiyle çiziyordu.

### B12. Düğme koşulları, tuş kodları ve klip eylemleri yalnız kod dökümünde — bilgi

`library.json` düğme kayıtlarını ve klip eylemi olduğunu (doğru/yanlış) tutuyor; hangi olayda hangi kodun
çalıştığı (release, rollOver, keyPress "1" … "6", Home, End, PageUp, Enter, Escape, Tab) yalnız
`kaynak/.../kod` dosya adlarında ve kodun içinde. Kendi okuyucumla saydığım 14 tuş koşulunun hepsi dosya
adlarıyla tutuyor. Oynatıcı bu bilgiye ihtiyaç duyacaksa ayrıca aktarılmalı.

### B13. Çevirideki sayı farkları bilinçli düzeltmeler — bilgi

Sayıları özgün metinle karşılaştırdım. F1 162 "Heals 50 HP" → "40 can yeniler": kod gerçekten
`makeThemHealHero(40)` çağırıyor; çeviri özgün metindeki yanlışı düzeltiyor. F2 2291 "hotkeys 1-6" →
"Z ve X tuşları": sahibinin README'si de F2'de iksirlerin Z ve X ile içildiğini söylüyor. Öbür farklar
("1/2" → "yarı", "1 vs 1" → "Tek başına", "0" → "sıfırlar") anlam korunarak yazılmış.

### B14. Ses akışı başlıkları — bilgi

İddia "kök filmdeki boş bir ses akışı dışında akış sesi yok". Kök filmde 1, sprite'ların içinde 217 (F1) /
266 (F2) SoundStreamHead2 var; hepsi aynı boş başlık (`06000000`: 0 örnek), SoundStreamBlock hiç yok. Yani
akış sesi gerçekten yok; yalnız ifade eksik.

### B15. Ekibin SWF okuyucusunda (`swf.py`) şimdilik etkisiz hatalar — bilgi

Bu dosyalarda karşılığı olmadığı için sonuca etkisi yok, ama başka bir SWF'de sorun çıkarır:

- Bevel süzgecinin boyu 31 bayt sayılıyor (`4 + 4 + 16 + 2 + 1 + 4`); doğrusu 27.
- Kare etiketleri ada göre sözlükte tutuluyor; aynı ad iki karede olursa biri kaybolur.
- DefineButton (1. sürüm), DefineButtonSound, DefineButtonCxform, PlaceObject (1. sürüm), StartSound2,
  DefineScalingGrid, DefineFontInfo okunmuyor ya da yalnız sayılıyor.
- PlaceObject3'ün görünürlük ve arka renk alanları okunmuyor.

## İlk incelemede bulunup yeniden aktarımda düzelenler

Doğruladım, artık sorun değiller:

- Kök filmin 2. karesindeki StartSound'un ses bilgisinde "durdur" (SyncStop) biti var (F1 ses 930, F2 ses
  1743); önceki `library.json` bunu "çal" diye yazıyordu. Şimdi `{"id": 930, "stop": true}`.
- 16 MP3'ün hepsinde SeekSamples = 1661 (11 025 Hz'de 0,15 sn) kaybolmuştu; şimdi `"seek": 1661` ve
  `"samples"` var.
- `"bytes"` ses dosyasının boyutundan 2 fazlaydı; şimdi dosya boyutu.
- `docs/AYIKLAMA_DENETIMI.md` denetim sırasında yeniden üretiliyordu ve sürüm kontrolünde değildi; şimdi
  commit edilmiş.

## Doğrulanan ve sorunsuz bulunanlar

| Ne | Kaç kayıt (F1 / F2) | Yöntem | Sonuç |
|---|---|---|---|
| Başlık: imza, sürüm, sahne, kare hızı, arka plan, kare sayısı | 2 dosya | kendi okuyucum (CWS + zlib, RECT, 8.8 kare hızı) | CWS, sürüm 8, 800×600, 30 fps, #35567B, 92 / 116 kare; dosya sonunda artık bayt yok |
| Etiket türleri ve sayıları (en dış düzey ve sprite içi) | 37 538 / 66 068 etiket (End dahil) | kendi okuyucum ↔ `manifest.json` | tür tür aynı; tanınmayan etiket 0; aynı kimlik iki kez 0; okunmadan kalan bayt 0 |
| Karakter kimlikleri ve türleri, her birinin yeri | 2 093 / 3 183 | kendi okuyucum ↔ manifest, dosya varlığı | hepsi aynı; yeri olmayan 0 |
| Dışarıda bırakılanlar | 86 / 128 | ağaç taraması (zaman çizelgesi, düğme, düğme sesi, resim dolgusu, yazı tipi), bayt kodu dize taraması, FFDec çizimi | sprite 140 yalnız ArcadeTown ve Newgrounds yükleme ekranları; mx bileşenlerine oyunun zaman çizelgesi, düğmesi ya da kodu (attachMovie, registerClass, adlar) başvurmuyor; dışarıdakileri kullanan aktarılmış karakter yok (kök kare 1 hariç, B5). Eksik kalan: B1 |
| Zaman çizelgeleri | 27 161 / 49 419 işlem; 224 / 353 çizelge | kendi okuyucum ↔ `library.json`, alan alan | derinlik, karakter, taşıma, matris (≤5·10⁻⁵), renk dönüşümü, oran (tam), ad, maske derinliği, klip eylemi, süzgeç (tür, bulanıklık, renk, güç, iç/delme), karışım: 0 fark. Etiketler 210 / 356: aynı; aynı adlı ya da çapa etiket yok |
| Ses başlatmaları ve ses bilgisi | 29 / 28 | kendi okuyucum (SOUNDINFO bütün alanları) | id, durdurma, tekrar, giriş/çıkış, zarf: aynı (yalnız 2 durdurma var, döngü/zarf yok) |
| Düğmeler | 174 / 178 düğme, 411 / 387 kayıt | kendi okuyucum | durum, karakter, derinlik, matris, renk dönüşümü: aynı. DefineButtonSound ve DefineButtonCxform yok; menü gibi davranan düğme yok |
| Sesler | 16 / 16 | SWF gövdesi ↔ dosya baytları; MP3 çerçeve başlıkları | bayt bayt aynı; MP3, 11 025 Hz, 16 bit, mono, MPEG-2.5 Layer III 16 kbps; örnek sayısı ve gecikme `library.json`'la aynı; F1 ve F2 sesleri aynı; akış verisi yok |
| Resimler | 18 / 24 | JPEGTables + DefineBits'i kendim birleştirip çözdüm | dosyalarla bayt bayt aynı, piksel farkı 0; hepsi DefineBits (saydamlık yok), hatalı JPEG başlığı yok |
| Şekil sınırı, başlangıç noktası, SVG boyutu | 1 178 / 2 147 | kendi okuyucum ↔ SVG ve `library.json` | aynı |
| Şekil geometrisi | 114 219 / 192 604 kenar parçası | her kenarın her dolgu tarafı ve çizgisi, twip twip, stil bazında | 0 fark |
| Dolgu stilleri | 7 797 / 13 065 kullanılan dolgu | renk+saydamlık; 2 998 / 4 226 degrade (tür, durak oranı ve rengi, yayılma, odak, matris) | aynı (matris ≤5·10⁻⁵); linearRGB yok; 1 yansımalı degrade doğru |
| Çizgi stilleri | 243 / 579 | kalınlık, renk, uç, birleşim, ölçeklenmeyen çizgi | aynı; farklı uçlu, piksel ipuçlu, noClose çizgi yok |
| Resim dolguları | 21 / 34 dolgu, 19 / 31 şekil | desen matrisi, tür, kırpma taşması | matris ≤4·10⁻⁵; kırpılmış dolgular resmin dışına taşmıyor; delikli yol yok |
| İnce çizgi işaretleri | 35 / 48 yol, 26 / 37 şekil | yol sırası ve özgün kalınlık | aynı; 1 pikselden ince olup işaretsiz çizgi yok |
| Motorun şekil çizimi | 1 159 / 2 116 | `svg-batch` 4× ↔ FFDec PNG, mürekkepli piksel ölçütü | en kötü %8,3 (yalnız kenar yumuşatma; ör. şekil 576, `$D/sekil576_karsilastirma.png`) |
| Morph sınırları, geometri, başlangıç renkleri | 11 / 25 | kendi okuyucum | aynı (düz kenarın eğriye çevrilmesinde yarım twip yuvarlama dışında). Hatalar: B2, B3 |
| Sabit yazılar | 122 / 104 yazı, 226 / 131 kayıt, 3 694 / 2 124 glif | sınır, matris, yazı tipi, renk, saydamlık, x, y, boy, glif ve aralık, çözülmüş yazı | aynı |
| Yazı alanları | 250 / 193 | sınır, 10 bayrak, yazı tipi, sınıf, boy, renk, en büyük uzunluk, hizalama ve kenar boşlukları, değişken, başlangıç yazısı | aynı; CSM 132 / 122 aynı |
| Yazı tiplerinin kod tabloları ve karşılıkları | 15 / 16 | kendi okuyucum, `name`/`OS/2`/`cmap` tabloları | kodlar aynı; dosyalar kaynakla bayt bayt aynı; 19 SHA-256 özeti `LISANSLAR.md` ile aynı; Liberation 2.1.5 OFL |
| Kod parçaları | 622 / 1 126 (DoAction 257 / 520, DoInitAction 77 / 178, düğme 231 / 221, klip 57 / 207) | kendi saydığım parçalar ↔ dosyalar, kapsayıcı başına | birebir; 5 302 / 12 220 dize sabitinin hepsi `.as` dosyalarında (16 sınıf sözdizimi artığı hariç) |
| Çeviri tabloları | 6 / 6 | kaynakla bayt bayt (`cmp`) | aynı; kaynak sürüm `a679d21` |
| Sabit yazı çevirileri | 122 / 104 | hedef kimlik, parça = kayıt, sahibinin Türkçe SWF'sindeki yazı, harf kapsamı | hepsi tutuyor; çevrilmemiş sabit yazı 0 |
| Kutu çevirileri | 143 / 116 | hedef, Türkçe SWF'deki başlangıç yazısı, harf kapsamı | hepsi tutuyor |
| Kod çevirisi | 56 / 62 dosya, 280 / 543 ad, 189 / 437 çift | kuralları kendim uygulayıp `kod-tr` ile; yeni dizeleri Türkçe SWF'nin bayt koduyla | birebir; 417 / 949 yeni dizenin hepsi Türkçe SWF'de |
| Çizilmiş yazı | 2019 / 3094 | Türkçe SWF'deki şekil ↔ SVG, twip twip | aynı (399 kenar), başlangıç noktası doğru |
| Türkçe harfler | bütün çeviri metinleri | eşlenen yazı tipinin `cmap` tablosu | eksik harf yok |
| .exe'ye gömme | `content/` | `crates/game/build.rs` | her dosyayı (alt klasörler dahil) gömüyor; gömülmesi gerekip dışarıda kalan yok (`kod-tr` gömülmüyor, ama tablolar `content/` altında) |
| Belgelerdeki sayılar | 2 belge | kendi sayımım | şekil, sprite, düğme, morph, kare, resim, ses, yazı, alan, yazı tipi, kod, bileşen sayıları doğru. Yanlış olanlar: sponsor (B1), çizilmiş yazı (B6), 3127 (B7) |

## Yöntem

**Kendi okuyucum (`$D/swfoku.py`).** SWF 19 spesifikasyonundan yazdım; ekibin `swf.py`, `aktar.py`,
`denetim.py` ve `olcum/swfstats.py` kodunu kullanmadım, kopyalamadım, içe aktarmadım (yalnız mantık hatası
aramak için okudum). Okuduğu:

- FWS/CWS/ZWS başlığı, zlib ve LZMA, kısa ve uzun etiket başlıkları, iç içe DefineSprite (kendi kare
  sayısı başlığıyla).
- PlaceObject 1/2/3 (sınıf adı, matris, renk dönüşümü, oran, ad, maske, bütün süzgeç türleri, karışım,
  önbellek, görünürlük, arka renk, klip eylemleri ve olay bayrakları), RemoveObject 1/2, FrameLabel (çapa
  dahil), ShowFrame.
- StartSound/StartSound2 ve SOUNDINFO, DefineSound (MP3 SeekSamples), SoundStreamHead/2, SoundStreamBlock.
- DefineButton 1/2 (kayıtlar, koşullu eylemler, tuş kodları), DefineButtonSound, DefineButtonCxform.
- DefineShape 1–4 (dolgu, çizgi ve LINESTYLE2, bütün kenarlar ve yeni stil dizileri), DefineMorphShape 1/2
  (iki uç, morph degrade ve odak), DefineBits/JPEGTables/JPEG2/3/4/Lossless/2 (gövde), DefineText 1/2,
  DefineEditText, DefineFont 1/2/3, DefineFontInfo 1/2, CSMTextSettings, ExportAssets, ImportAssets,
  DoAction, DoInitAction, DefineScalingGrid, SymbolClass.
- AVM1 bayt kodu: eylem kayıtları, ConstantPool, Push (bütün türler), GetURL, GotoLabel, SetTarget,
  DefineFunction 1/2 adları; dize sabitlerini çıkarmak için.

Okumadığı: AVM1 kodunu çalıştırmıyor ve kaynak koda çevirmiyor (kodun doğruluğunu dize sabitleri ve parça
eşlemesiyle sınadım); yazı tiplerinin glif şekillerini çözmüyor; JPEG'leri Pillow çözüyor. Yazı tipi
dosyaları için kendi küçük `cmap`/`name`/`OS/2` okuyucumu yazdım (`$D/fontoku.py`).

**İkinci görüş.** FFDec 24.1.1'in XML dökümü (yalnız iki bulguyu doğrulamak için), FFDec'in PNG çizimleri
(sponsor parçalarını görmek ve motor çizimini karşılaştırmak için) ve sahibinin Türkçe SWF'leri (kendi
okuyucumla) kullanıldı. Bulguların hepsi kendi okuyucumda görüldü; B1 ve B2 ayrıca FFDec'in çiziminde ve
XML'inde, çeviri bulguları sahibinin Türkçe SWF'sinde de görüldü.

**Kapsam ve örneklem.** Bütün kayıtları denetledim; örneklem kullanmadım (sabit tohum gerekmedi; görsel
incelemelerde yalnız belirli ekranlara baktım: F1 kök kareleri 4, 85, 87, 89, 90, 91; F2 kök kareleri 1–4,
109, 111, 113–116).

**Sınırlar.**

- Çizilmiş yazıları (resim olarak çizilmiş metin) kendiliğinden bulan bir yöntemim yok; B6'yı ekranlara
  bakarak buldum, başkaları kalmış olabilir.
- Kod içindeki ekranda görünen İngilizce metinleri dize taramasıyla aradım; kalanlar istatistik ve hata
  ayıklama dizeleriydi (ör. Kongregate "Max HP", "Attempt to get SP cost…"), ama kodu çalıştırmadan
  hangisinin ekrana çıktığını kesin bilemem.
- Motorun çizimini yalnız düz şekillerde karşılaştırdım; motor resim dolgusunu ve ince çizgi kuralını
  henüz uygulamadığı için onların görsel denetimi yapılmadı (sayısal denetim yapıldı).
- Lisans değerlendirmesi hukuki görüş değildir.
- Denetim sırasında içerik değişti (başlangıç ve son durumun SHA-256 listeleri:
  `$D/snapshot_baslangic.sha256`, `$D/snapshot_son.sha256`); raporun bütün sonuçları son durum
  (`e991808`) üzerinde yeniden çalıştırıldı.

**Betikler.** `a1_genel.py` (yapı), `a2_haric.py` (dışarıda bırakılanlar), `a4_kod.py`, `a5c_kodicerik.py`
(kod), `a6b_zaman.py` (zaman çizelgeleri ve sesler), `a7_ses.py`, `a8_resim.py`, `a9_dugme.py`,
`a10_yazi.py`, `a11_sekil.py`, `a11b_desen.py`, `a13_geometri.py`, `a13b_stilgeometri.py` (şekiller),
`a12_morph.py`, `a12b_morphstil.py`, `a12c_morphdegrade.py` (morph'lar), `a14_gorsel*.py` (motor çizimi),
`b1_yazitipi.py`, `b2_ceviri.py`, `b3_kodtr.py` (çeviri ve yazı tipleri). Her betiğin çıktısı aynı adla
`.txt` olarak yanında.
