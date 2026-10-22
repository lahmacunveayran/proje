<!-- Bağımsız denetçinin raporu (16 Ekim 2026), değiştirilmeden alındı; yalnız geçici klasör yolları
kısaltıldı ($D). Bulguların durumu: docs/gunluk/2026-10-16.md. -->

# Feudalism 1 ve 2 ayıklamasının bağımsız denetimi (Denetim 3)

Denetlenen sürüm: depo `/home/user/proje`, dal `claude/brave-knuth-2he6ek`, commit
**`8bf1531`** ("Denetim aracının kör noktalarını kapat (B9)"; denetim başladığında dalın son commit'i).
Denetim sırasında dala iki commit daha geldi: `487471a` (yalnız `docs/gunluk/2026-10-16.md`; içerik ve
araçlar `8bf1531` ile aynı) ve `396b153` ("Sponsor yazılarını ve korsan kopya ekranını dışarıda bırak");
sonuncusu ayrı bir bölümde kısaca denetlendi. Depodaki çalışma ağacı denetim sırasında ekip tarafından
değiştirildiği için bütün okumalar `8bf1531`'in scratchpad'deki bir kopyasından (git worktree) yapıldı.
Kaynaklar: `feudalism-orijinal.swf` (SHA-256 `751766…a6c8`), `feudalism-2-orijinal.swf` (`94cdf5…1061`),
Türkçe sürümler `feudalism-tr.swf` (`38c1b2…9301`) ve `feudalism-2-tr.swf` (`fe3f44…ef33`).

Aşağıda `$D` = `$D`
(denetçinin klasörü; depoda değil). Betikler `python3 -I $D/<betik>.py` ile çalışır, depoya yazmaz.

## Sade özet

- **Önceki denetimin önemli bulguları gerçekten düzelmiş.** ArcadeTown ve Newgrounds logoları artık oyunun
  içeriğinde yok (iki oyunda, başka kimlikle kopyaları dahil); güneş ışını efektindeki ters degrade ve
  renklerdeki küçük kayma gitmiş; Adobe, MochiAds ve MochiBot kodu `kaynak/` altından çıkmış ve hepsi
  listede; oynatıcı dışarıda bırakılan logoyu atlıyor; lisans dosyaları tam ve dağıtım paketiyle bayt bayt
  aynı. Bunları ekibin araçlarını kullanmadan, SWF'yi kendi yazdığım okuyucuyla okuyarak doğruladım.
- **Yeni ve önemli bir hata buldum (D3-1).** Flash'ta bir nesne "yerinde değiştirilirken" (taşıma)
  konumunu açıkça sıfıra döndürmek mümkündür. Aktarım aracı bu "sıfıra döndür" bilgisini atıyor; motor da
  bilgi yoksa eski konumu koruyor. Sonuç: bazı oyun ekranlarında binalar ve parçalar yanlış yerde çiziliyor
  (ör. F1'in 13. ekranında evlerin yarısı yerinden kaymış; düzeltince fark %27'den %6,5'e iniyor). İki
  oyunda 157 işlem etkileniyor. Ekibin denetim aracı bunu "eşit" sayıyor; önceki denetim de kaçırmıştı.
- **Ekibin denetim aracı çok daha iyi, ama "0 sorun" hâlâ tam güvence değil (B9 kısmen).** Yukarıdaki hatayı,
  matrislerin yuvarlanmasını, renklerdeki küçük kaymaları ve resim dolgusunun türünü yakalamıyor
  (denemeyle gösterdim, bkz. B9).
- **Ekibin bildirdiği açık sorun (F2 şekil 1791): motor haklı, FFDec yanılıyor.** SWF'deki kenar ve dolgu
  türü, parke taşı şeridinin 489,75 pikselde bittiğini ve dokunun kenara kadar sürdüğünü söylüyor. Motor
  tam böyle çiziyor; FFDec dokuyu 1,35 piksel erken kesiyor; librsvg o dokuyu hiç çizmiyor. Bu bir
  ayıklama hatası değil; denetimde gerekçesiyle istisna olarak yazılmalı.
- Küçük şeyler: şekil SVG'lerindeki degrade ve desen matrisleri hâlâ 4 ondalık (tekrarlı zemin
  dokularında doku 0,1 piksel kayıyor); lisans belgesinde iki yazı tipinin sürüm numarası yanlış; birkaç
  sayı ve not tutarsızlığı.
- Yeni commit (`396b153`): korsan kopya ekranının ve "özel karakterler yalnız ArcadeTown'da" panelinin
  yazıları doğru ve yalnız onlar dışarıda bırakılmış; içerikte ArcadeTown, ArmorGames, AddictingGames adı
  geçen yazı kalmamış. Ekibin aracının sponsor sözcük listesinde ArmorGames ve AddictingGames yok.

## Bulguların durumu

| Bulgu | Önem (D2) | Durum |
|---|---|---|
| B1 sponsor logoları | önemli | **düzeldi** |
| B2 morph 3058/3060 ters degrade | önemli | **düzeldi** |
| B3 morph bitiş renklerinde mavi +1 | küçük | **düzeldi** |
| B4 üçüncü taraf kodu `kaynak/` altında | küçük | **düzeldi** |
| B5 tanımsız karakter başvurusu | küçük | **düzeldi** |
| B6 "The Age of..." ve çizilmiş yazı sayısı | küçük | **düzeldi** (belge) |
| B7 3127'nin sınıfı, korsan kopya ekranı | küçük | **düzeldi** |
| B8 TeX Gyre lisansı | küçük | **düzeldi** (belgede küçük sürüm hatası: D3-5) |
| B9 ekibin denetim aracı | önemli | **kısmen** (bkz. D3-3) |
| B10 yuvarlanan ayrıntılar | küçük | **kısmen** (zaman çizelgesi ve süzgeçler düzeldi; SVG matrisleri 4 ondalık: D3-2) |
| B15 ekibin SWF okuyucusu | bilgi | **kısmen** (4 maddeden 3'ü) |

(B11–B14 bilgi notlarıydı; bu denetimin kapsamında değil.)

## Önceki bulgular (B1–B10, B15)

### B1. Sponsor logoları — Durum: düzeldi

**İddia.** F1'de logo 54 (52, 53), F2'de açılış animasyonu 1763 ve logo 1962 altlarıyla dışarıda;
sponsor köklerine girilmiyor; içerik özetiyle arama denetimde.

**Yöntem.** Kendi okuyucumla (`$D/swfoku3.py`) her karakterin başvurularını çıkardım (zaman çizelgesi,
düğme kaydı, resim dolgusu, yazı tipi, düğme sesi). Sponsor ağacı: F1'de 140 ve 54'ten, F2'de 1763 ve
1962'den ulaşılanlar. Oyunun ağacı: kök zaman çizelgesi ve dışa aktarılanlar, sponsor köklerinde durarak.
"Yalnız sponsorun" = sponsor ağacı − oyunun ağacı. İçerikteki her kimlik `library.json` (şekil, resim
dolgulu şekil, morph, resim, ses, sprite, düğme, ince çizgi, dışa aktarım), `texts.json` ve dosya
adlarından toplandı. Kopya araması iki yolla: (a) kimlik dışındaki baytların özeti, (b) "derin" özet
(başvurulan karakterlerin kimliği yerine onların özeti; sprite ve düğme kopyalarını da bulur); iki oyunun
bütün dışarıda bırakılan sponsor karakterlerine karşı. Ayrıca baytları farklı ama görüntüsü aynı kopya
için FFDec PNG'lerini 24×24'e küçültüp desenli sponsor şekilleriyle karşılaştırdım.

**Kanıt** (`python3 -I $D/b1_sponsor.py`, `$D/b1b_mx.py`, `$D/b1c_gorsel.py`; çıktılar aynı adla `.txt`):

```
===== f1
sponsor ağacı 92 yalnız sponsor 89 ortak (oyun da kullanıyor) [49, 60, 92]
yalnız sponsor olup içerikte bulunan: []
ortak olup içerikte OLMAYAN: []
yalnız sponsor olup excluded'da olmayan: []
SWF karakteri 2093 içerikte 2004 excluded 89 ikisi de değil []
içerikteki tanımsız/dışlanmış başvurular: [(54, '1494', 1), (140, 'kok', 1)]
===== f2
sponsor ağacı 21 yalnız sponsor 21 ortak []
yalnız sponsor olup içerikte bulunan: []
SWF karakteri 3183 içerikte 2990 excluded 193 ikisi de değil []
içerikteki tanımsız/dışlanmış başvurular: [(1763, '1935', 1), (1962, '2342', 1), (1962, 'kok', 113), (1962, 'kok', 115)]
===== içerik özetiyle kopya araması
f1 içerikte sponsor kopyası: []      f2 içerikte sponsor kopyası: []
F1 53 == F2 [1746] excluded; F1 59 == F2 [1745] excluded; F1 76/77 == F2 1761/1762 excluded;
F1 morph 74 == F2 1759 excluded; F1 60 == F2 1764 içerikte (düğmelerin tıklama alanı; doğru)
görsel olarak sponsor şekline benzeyen içerik şekilleri: []   (41 desenli sponsor şekline karşı)
dışarıdakini kullanan aktarılmış karakterler: f1 [(54,[1494]), (140,['kok1'])]  f2 [(1763,[1935]), (1962,[2342,'kok113','kok115'])]
dışarıdaki 129 dışa aktarım adından oyunun kodunda dize olarak geçenler: []
```

- Sponsor olmayan ortak parçalar (F1 yazı tipi 49, tıklama alanı 60, şekil 92; F2'de kopyası 1764) içerikte
  duruyor; yanlışlıkla çıkarılan yok. Oyunun ağacında olup ne içerikte ne listede olan karakter yok (F2'deki
  65535, SWF'de "resim yok" anlamındaki boş resim dolgusu kimliğidir; karakter değildir).
- `excluded` nedenleri: F1'in 89 kaydının hepsi sponsor ağacında; F2'nin 193 kaydının 21'i sponsor ağacı,
  171'i mx bileşeni, 1'i MochiAd. mx ve MochiAd karakterlerine oyunun aktarılmış hiçbir karakteri ya da
  kodu (dışa aktarım adıyla) başvurmuyor.
- Motor ana menülerde logonun yerini boş bırakıyor (`$D/ekran/levha.png`: F1 kare 4, F2 kare 4 ve 113).
- Belgeler tutarlı: `LISANSLAR.md` logonun oyun ekranlarında da aktarılmadığını yazıyor;
  `FEUDALISM_ICERIK.md` F1 "2 kök sembol, altlarıyla 89", F2 "21" diyor; tür sayıları kendi sayımımla aynı
  (`$D/b10_sayilar.txt`).

### B2. Morph 3058/3060 ters degrade — Durum: düzeldi

### B3. Bitiş renklerinde mavi +1 — Durum: düzeldi

**Yöntem (ikisi için).** Her morph ucunun SVG'sindeki bütün stilleri SWF'deki *kullanılan* stillerle iki
yönde karşılaştırdım: düz dolgu (renk, saydamlık ×255 tam sayı), çizgi (renk, saydamlık, kalınlık ×20 tam
twip), degrade (tür, yayılma, durak oranı/rengi/saydamlığı ve matrisin her öğesinin 16.16 ham değere
`round(v·65536) == ham` ile, ötelemenin `round(v·20) == ham` ile geri kurulabilmesi). Geometri: SWF'deki
her uç noktasının (başlangıç kenarları ya da bitiş kenarları) SVG'de bulunması ve nokta sınırlarının
(kontrol noktaları dahil) 0,05 piksel içinde tutması. Ölçütün gerçekten yakaladığını görmek için aynı
betiği önceki denetimdeki hatalı dosyalara (`git archive f90b29e`) de uyguladım.

**Kanıt** (`python3 -I $D/b2_morph.py`):

```
===== f1 morph 11 uç 22 sorunlu uç 0 (SVG stil sayısı: degrade 8, düz 14, çizgi 22)
===== f2 morph 24 uç 48 sorunlu uç 0 (SVG stil sayısı: degrade 62, düz 34, çizgi 48)
f2 3058 SWF ilk dolgu 0x10 başlangıç matrisi (-0.137909, 0, 0, -0.088348, -167.3, 0.15)
SVG 3058.start.svg gradient0: matrix(-0.137909, 0.0, 0.0, -0.088348, -167.3, 0.15)   ← eksi işaretli
```

Eski dosyalarda aynı betik (`$D/b2_morph_eski.txt`): F1 15/22, F2 33/50 sorunlu uç; ör.
`f2 3058 start: eşsiz degrade ... ('matris', [0.1381, 0.0, 0.0, 0.0883, ...]`, `f1 552 end: düz dolgu: SWF
#990000 SVG #990001`. Yani ölçüt hatayı görüyor ve şimdiki dosyalarda hata yok. 3060 da aynı (ilk dolgu
matrisi iki uçta eksi işaretli). Bitiş renklerinde mavi +1 kalmadı (bütün bitiş renkleri SWF'deki
`endColor` ile birebir).

### B4. Üçüncü taraf kodu — Durum: düzeldi

**Yöntem.** SWF'deki her kod parçasını kendi okuyucumla saydım (kare DoAction, DoInitAction, düğme
koşulları, klip eylemleri) ve her birinin FFDec dosya yolunu konumundan çıkardım (sprite kimliği, kare,
DoAction sırası, düğme kimliği, klip eyleminin karakteri ve derinliği; DoInitAction için dışa aktarım
adından `__Packages/...` ya da `<ad>.as`). Her parça ya `kod/` altında ya da `code_excluded`'da olmalı, ikisinde
birden değil; fazladan dosya olmamalı. Parçanın dize sabitleri dosyasında aranarak içerik de sınandı.
Dışarıdakilerin sahibi dışarıda bırakılan bir karakter mi, değilse içeriği gerçekten üçüncü taraf mı diye
bakıldı.

**Kanıt** (`python3 -I $D/b4_kod.py`, `$D/b4b_doinit.py`):

```
f1 SWF kod parçası 622 {doaction 257, clip 57, button 231, doinit 77} | kod/ 612 | code_excluded 10 | toplam 622
  konum anahtarı farkı (SWF, dosya): 0     DoInitAction 77 / beklenen ad 77, eksik 0, fazla 0
f2 SWF kod parçası 1126 {doaction 520, clip 207, button 221, doinit 178} | kod/ 998 | code_excluded 128 | toplam 1126
  konum anahtarı farkı: 0                   DoInitAction 178 / beklenen ad 178, eksik 0, fazla 0
kod/ altında sahibi dışarıda bırakılmış parça: f1 [] f2 []
gerekçesi şüpheli dışarıdaki parça: yok (sahibi oyunda olan tek dışarıdaki: frame_1/DoAction_2.as, içeriği MochiBot)
git ls-tree 8bf1531 kaynak | grep -ci "__Packages/mx|mochi"  → 0
```

Dize karşılaştırmasında eksik görünen 7 + 4 parça FFDec'in yazım farkıdır (`FSCommand:trapallkeys` →
`fscommand("trapallkeys")`, `/:$version`, kesme işaretli uzun yazılar); oyunun kodu silinmemiş.

Bilgi: oyunun kendi `frame_1/DoAction.as` dosyasında (F2) MochiAds çağrısı ve oyun kimliği iki satır olarak
duruyor (`MochiAd.showPreGameAd(...)`; kütüphane artık yok); `kod-tr`'de sahibinin çevirisi bu satırı
yorum yapıyor. Oyunun kodundaki ArcadeTown adresleri ("More Games" vb.) oyunun koduna aittir.

### B5. Tanımsız karakter — Durum: düzeldi

**Yöntem.** `library.json`'daki bütün zaman çizelgeleri ve düğme kayıtları tarandı (B1 betiği); motorun
`crates/engine/src/movie.rs` kodu okundu ve testi çalıştırıldı; motorla iki oyunun ilgili kareleri çizildi.

**Kanıt.** Tanımsız başvurular yalnız dışarıdakilere ve hepsi `excluded`'da: F1 2 (kök 1 → 140, 1494 → 54),
F2 4 (1935 → 1763, 2342 → 1962, kök 113 ve 115 → 1962). `Clip::place` karakter tanımlı değilse örnek koymuyor
ve derinliği boşaltıyor; taşımada tanımsız karakterle örneği değiştirmiyor. `cargo test -p engine --lib movie`:
9 test geçti (`undefined_character_is_skipped` dahil). `movie-png` ile F1 kare 1 ve 4, F2 kare 3, 4, 113 hatasız
çizildi; logo yerleri boş.

### B6. "The Age of..." — Durum: düzeldi (belge)

`FEUDALISM_ICERIK.md` artık "toplam" sütununda sayı vermiyor ("kendiliğinden bulunamaz"), bilinenleri
listeliyor: 2019 "Öldün..." (çevrildi), 995 "The Age of..." ve 1019 "FEUDALISM". Yeni commit'te sahibinin
kararı yazılmış: "The Age of..." İngilizce kalır. Çizilmiş yazıları kendiliğinden bulan yöntem yine yok
(bu bir sınır olarak belgede yazılı).

### B7. 3127 ve korsan kopya ekranı — Durum: düzeldi

`8bf1531`'de 3127 artık "sponsor ya da site metni" sınıfında (3125–3132 ile); "yalnız sayı ve işaret"
sınıfında Latin dışı yazı kalmadı. Yeni commit'te sahibinin kararı (gösterilmez) uygulanmış (aşağıda).

### B8. TeX Gyre lisansı — Durum: düzeldi

**Yöntem.** `content/fonts/` dosyaları listelendi; `LISANSLAR.md`'deki 28 SHA-256 özeti hesaplandı; Ubuntu
paketleri kurulmadan indirildi ve kendi klasörüme açıldı (`apt-get download fonts-texgyre
texlive-latex-base-doc`, `dpkg-deb -x`).

**Kanıt.**

```
belgedeki özet 28 tutmayan 0   (özeti belgede olmayan: yalnız OFL-Alegreya*.txt, bu denetimin konusu değil)
texgyre{adventor-bold, bonum-bold, bonum-italic, chorus-mediumitalic, pagella-bold, pagella-bolditalic}.otf
    fonts-texgyre_20180621-6 paketindekilerle AYNI (cmp)
MANIFEST-TeX-Gyre-{Adventor,Bonum,Chorus,Pagella}.txt   paketteki /usr/share/texmf/doc/fonts/tex-gyre/ ile AYNI
README-TeX-Gyre-{...}.txt                               paketteki README'lerle AYNI
LPPL-1.3c.txt  texlive-latex-base-doc 2023.20240207-1 → lppl.txt.gz açılmış hâli ile AYNI (sha256 ca3227…e8)
GUST-Font-License.txt  paketteki GUST-FONT-LICENSE.txt ile aynı metin; yalnız satır başlarındaki "% " yok
```

Kısmi dağıtım durumu `LISANSLAR.md`'de yazılı. Küçük bir belge hatası: D3-5.

### B9. Ekibin denetim aracı — Durum: kısmen

**Kapananlar (kodu okuyarak ve çalıştırarak).** Yerel görsel ölçüt (iç piksel oranı + katı fark bölgesi,
şekil başına sınır) var; resim dolgulu şekiller de çiziliyor; kod çevirisi Türkçe SWF'nin bayt kodundaki
dizelerle karşılaştırılıyor; süzgeçlerin bütün alanları, sabit yazıların sınır/matris/saydamlığı, yazı
alanlarının bütün alanları, resimlerin piksel karşılaştırması, morph stillerinin sayısal karşılaştırması,
tanımsız başvuru ve içerik özetiyle sponsor araması eklenmiş; satır sayıları karşılaştırılan kayıtları
gösteriyor (ör. "Dışa aktarılan adlar 60 / 87").

**Deneme (aracı bir kopyada çalıştırarak).** `8bf1531`'in ayrı bir kopyasında (`git worktree add $D/wt2`;
`referans/` ve `svg-batch` salt okunur bağlantı; `TMPDIR=$D/tmp`, `SWF_KOK=/home/user/swf-oyunlar`)
`python3 araclar/aktar/denetim.py --gorsel` iki kez çalıştı (her biri ~10,5 dk):

1. **Dokunulmamış kopya:** üretilen rapor depodaki `docs/AYIKLAMA_DENETIMI.md` ile bayt bayt aynı
   (`$D/b9_temel_rapor.md`; "Toplam sorun: 1", f2 şekil 1791). Ekibin raporu yeniden üretilebiliyor.
2. **Altı bilinen hata konmuş kopya** (`python3 -I $D/b9_enjekte.py`; rapor `$D/b9_enjekte_rapor.md`,
   "Toplam sorun: 16"):

| Konan hata | Araç yakaladı mı | Benim betiğim |
|---|---|---|
| H1: Denetim 2'nin B2'si: eski `3058.start.svg` (ters degrade, `git show f90b29e:...`) | **evet**: morph stilleri 13 sorun; görsel %13,86, katı 433 752 piksel | evet (`b2_morph.py`) |
| H2: F1 kök kare 9'da bir yerleştirmenin ölçeği 0,716171 → 0,716 (3 ondalık) | **hayır** (`TOL = 1e-3` göreli pay) | evet (`b10_zaman.py`: "matris geri kurulamıyor") |
| H3: bir renk dönüşümünde saydamlık 0,960938 → 0,9605 | hayır | hayır, çünkü 0,9605×256 yine 246'ya yuvarlanıyor: bilgi kaybı yok (geçersiz deneme) |
| H4: F1 şekil 1495'in rengi #006600 → #1e6600 (kırmızıda +30/255) | **hayır** (görsel eşik 32/255; şekil renklerinin sayısal denetimi yok) | şekiller bu denetimde sayısal karşılaştırılmadı (bkz. Sınırlar); Denetim 2'nin yöntemi yakalar |
| H5: F2 1791'in kırpılmış deseninin `-kirp` eki silinmiş (tür: tekrarlı) | **hayır** (dolgu türü karşılaştırılmıyor; dikdörtgen resmin içinde olduğundan çizim de aynı) | evet (`a10_desen.py`: `('1791', 'PatternID_1791_1', 'SWF türü 0x43')`) |
| H6: F1 şekil 2001'in bir parçası 1,5 piksel sağa kaymış | **evet**: katı 16 793 piksel | – |
| (kendiliğinden) D3-1: taşımada kaybolan birim matrisler (157 işlem) | **hayır** (`same_op` eksik matrisi birim sayıyor) | evet (`b10_zaman.py`) |

**Değerlendirme.** Görsel ölçüt mantıklı ve B2'deki ters degradeyi açıkça yakalıyor (%13,86; katı
433 752 > 16). INK_LIMIT %12 tek başına gevşek (doğru çizimlerde en çok %8,9), ama asıl koruma SOLID_LIMIT:
16 katı piksel 4× çizimde yaklaşık 1 kaynak pikseli; kümelenmiş hataları güvenle yakalıyor (H1, H6). Kenar
boyu ince kaymalar ve 32/255'ten küçük renk farkları ise görsel ölçütün dışında; bunlar için sayısal
karşılaştırma gerekir ve şekillerde, zaman çizelgesi hassasiyetinde ve resim dolgusu türünde yok. Ayrıca:

- `TOL = 1e-3` bütün sayısal satırlarda göreli pay; yorumu hâlâ "JSON'da 4 basamağa yuvarlanır" diyor. 6
  ondalık düzeltmesinin (B10) gerilemesini araç göremez.
- `same_op`: eksik matris/renk dönüşümü her işlemde birim sayılıyor (D3-1'i saklıyor).
- Morph stil denetimi tek yönlü (her SVG stili XML'de bir stile uyuyor mu); XML'de olup SVG'de olmayan stil
  ve degradenin yayılma türü denetlenmiyor.
- Sponsor sözcükleri `arcadetown|newgrounds|mochibot|mochiad|mochimedia`; ArmorGames ve AddictingGames yok.
- 1791 "sorun"u FFDec'in hatası (aşağıda); araç bunu ayırt edemiyor.


### B10. Yuvarlanan ayrıntılar — Durum: kısmen

**Yöntem.** Bütün zaman çizelgelerinde (F1 223, F2 307 çizelge) her yerleştirme ve kaldırmayı kendi
okuyucumdaki ham değerlerle karşılaştırdım: matris öğeleri `round(v·65536) == ham`, öteleme
`round(v·20) == ham`, renk dönüşümü çarpanı ×256, oran ×65535, süzgeçlerin bütün alanları (tür, bulanıklık
16.16, güç 8.8, renk, iç, delme, bileşim, geçiş sayısı).

**Kanıt** (`python3 -I $D/b10_zaman.py`):

```
f1 işlem 27152: matris 22668 (en büyük fark 5·10⁻⁷, hepsi geri kurulabiliyor), oran 1078, renk dönüşümü 144, süzgeç 9
f2 işlem 49080: matris 42697 (en büyük fark 5·10⁻⁷), oran 1281, renk dönüşümü 431, süzgeç 711
süzgeç türleri: f1 glow 9; f2 blur 565, glow 146; hepsinin bütün alanları SWF ile aynı (geçiş 1, bileşim 1)
sorun: f1 45, f2 112 → hepsi "taşımada birim matris/renk dönüşümü yazılmamış" (D3-1)
```

- Zaman çizelgesi matrisleri ve süzgeçler: düzeldi.
- Şekil SVG'lerindeki degrade ve desen matrisleri hâlâ 4 ondalık (`gradientTransform="matrix(0.1436, ...)"`,
  `patternTransform`); önceki raporun 2. maddesi değişmemiş. Etkisi: D3-2.
- 0 kareli sprite: motor 1 boş kare sayıyor (testli).

### B15. Ekibin SWF okuyucusu — Durum: kısmen

`swf.py`: Bevel süzgeci 27 bayt; aynı adlı kare etiketi hata veriyor; PlaceObject3'ün görünürlük ve arka
renk alanları okunuyor. PlaceObject (1. sürüm), RemoveObject (1. sürüm), DefineButton (1. sürüm),
DefineButtonSound/Cxform hâlâ okunmuyor. Bu dosyalarda bu etiketler yok (kendi okuyucumla etiket sayıları:
yalnız PlaceObject2/3 ve RemoveObject2); etkisi yok.

## Yeniden üretilebilirlik (madde 9) — doğrulandı (arşivden sonrası)

- `git worktree add $D/wt3 8bf1531`, arşivi bağlantıyla verip `python3 araclar/aktar/aktar.py
  /home/user/swf-oyunlar` (6,8 sn): `git status` boş (yalnız `referans` bağlantısı). Yani depodaki araçlar,
  yerel arşivden içeriği ve `kaynak/`'ı bayt bayt aynı üretiyor.
- FFDec'in betik dökümünü F2 için yeniden aldım (`-format script:as -export script`): arşivdekiyle tek fark
  `__Packages/WeaponClass.as` içindeki üye bildirimleri (`var LEVEL; var NATION; ...` sırası/varlığı). İddia
  doğru.
- Sınır: `cikar.sh`'ın bütün FFDec dökümünü (şekil PNG'leri, XML) yeniden üretmedim.

## Gerileme taraması (madde 10) — gerileme yok (D3-1 hariç)

| Ne | Kayıt (F1 / F2) | Yöntem | Sonuç |
|---|---|---|---|
| Etiket türleri ve sayıları | bütün etiketler | kendi okuyucum ↔ `manifest.json` | aynı (en dış düzey ve sprite içi) |
| Karakter türleri ve sayıları | 2093 / 3183 | kendi okuyucum ↔ içerik + `excluded` | her karakter ya içerikte ya listede; belgedeki bütün sayılar (şekil 1157+19+58 / 2098+31+55, sprite 222/306, düğme 174/178, morph 11/24, yazı alanı 250/193, ...) doğru |
| Zaman çizelgeleri | 27 152 / 49 080 işlem | bkz. B10 | D3-1 dışında 0 fark; etiketler aynı |
| Sesler | 16 / 16 | SWF gövdesi ↔ dosya, örnek sayısı, gecikme, boyut | aynı |
| Resimler | 18 / 24 | JPEGTables + DefineBits'i kendim birleştirip çözdüm | piksel farkı 0 |
| Resim dolgulu şekillerin desen eki | 21 / 34 dolgu, 19 / 31 şekil | her desen SWF'deki dolguya matrisle eşlendi; tür ↔ ek | 17+29 kırpılmış (`-kirp`), 4+5 tekrarlı; hepsi yumuşatmasız (ek yok); hepsi doğru; desen resimleri SWF'dekiyle aynı |
| Resim dolgulu şekillerin çizimi | 19 / 31 | SWF'den Flash kuralıyla kendi çizimim ↔ motor ↔ FFDec (2×) | kapsama farkı 0; doku farkları D3-2 |
| Morph'lar | 11 / 24 | bkz. B2 | 0 fark |
| Çeviri tabloları ve hedefleri | 6 / 6 tablo | kaynakla bayt bayt; her hedef içerikte, dışarıdakine giden yok | aynı |

## Ekibin açık sorunu: F2 şekil 1791 (parke taşı şeridi)

**SWF ne diyor** (kendi okuyucum, `python3 -I $D/x1791_dump.py`):

- DefineShape2, sınır x −7060…29832, y 5356…14579 twip.
- 1. stil kümesi: dolgu 2 = tür 0x43 (yumuşatmasız, **kırpılmış**) resim 1790 (800×200), matris
  (46,1148; 0; 0; 46,1148; −353 px; 267,8 px). Dikdörtgen tam resmin üstünde; resim dışına taşmıyor.
  (Dolgu 1 = resim 65535, hiçbir kenar kullanmıyor.)
- 2. stil kümesi: dolgu 1 düz renk #5E584D (şeridin üstündeki koyu bant), dolgu 2 = tür 0x42 (yumuşatmasız,
  **tekrarlı**) resim 1789 (70×71), matris a = 20,0841, c = −3,0494, d = 15,2473 (twip/piksel, yani
  1,00421; −0,15247; 0,76237 piksel), öteleme (−8777,15; −812,1) px.
- Parke bölgesinin kenarları: üstte eğri (dolgu 1 | dolgu 2), sağda x = 11175, solda x = −6340 ve **altta
  düz kenar y = 9795 twip = 489,75 piksel** (sol 0, sağ dolgu 2).

**Flash'ın kuralı** (SWF 19, resim dolguları): dolgu bölgenin tamamını kaplar; tekrarlı türde resim her
yönde tekrar eder, kırpılmışta kenar pikseli uzar; yumuşatmasızda nokta, matrisin tersiyle bulunan resim
pikselinin rengini alır. Kenar, kenar kaydının bulunduğu yerdedir. Yani parke dokusu y = 489,75 piksele
kadar sürmeli; altında 1790'ın düz zemini görünmeli.

**Çizimler** (4×; `$D/x1791/`; `python3 -I $D/x1791_karsilastir.py`, `$D/x1791_kayma.py`,
`$D/x1791_yuvarlama.py`). Kendi çizimimi SWF verisinden bu kuralla yaptım (`$D/raster3.py`; tek-çift
kuralıyla bölge, `floor(M⁻¹p)` ile resim pikseli).

```
satır 876..891 (y=486.80..490.55) dokunun yatay değişkenliği (0 = düz zemin):
ffdec  [21, 21, 21, 21, 23, 23, 17, 0, 0, 0, 0, 0, 0, 0, 0, 0]   ← y≈488,4'te bitiyor
motor  [21, 21, 21, 21, 23, 23, 23, 23, 23, 23, 22, 16, 0, 0, 0, 0]  ← 489,75'te bitiyor (son satır kenar yumuşatma)
benim  [21, 21, 21, 21, 23, 23, 23, 23, 23, 23, 22, 22, 0, 0, 0, 0]  ← 489,75
rsvg   [0, 0, 0, ...]                                                ← parke dokusunu hiç çizmiyor
şeridin alt bandı y 488.6..489.6:   ffdec ↔ benim: %19,7 belirgin farklı;  motor ↔ benim: %1,3
alt dikdörtgen (resim 1790) ve üst bölge: üç çizici de benimkiyle aynı (%0,00)
doku yeri (şeridin içi): ffdec en iyi kayma dx=1 (4× piksel), motor 0
motor ↔ SVG'nin 4 ondalıklı matrisiyle benim çizimim: %0,01 farklı
```

**Sonuç.** Motorun çizimi Flash'ın kuralına uyuyor (kenar 489,75 pikselde). FFDec'in kendi çizicisi
dokuyu y ≈ 488,5'te (dokunun 1706. satır sınırında) kesiyor; bu FFDec'in hatası. librsvg bu deseni (büyük
ötelemeli eğik desen) hiç çizmiyor; o da hatalı. SVG'deki yol geometrisi SWF ile birebir. Motorun kalan
küçük doku farkı (%2,8 piksel, dokunun 0,1 piksel kayması) SVG'deki desen matrisinin 4 ondalığa
yuvarlanmasından (D3-2). Öneri: denetim aracında 1791 gerekçesiyle (bu rapordaki ölçüm) istisna yazılsın,
ya da resim dolgulu şekillerde FFDec'in PNG'si yerine SWF'den kurala göre yapılan bir çizimle karşılaştırılsın.

## Yeni bulgular

### D3-1. Taşıma işleminde açıkça yazılmış birim matris ve renk dönüşümü kayboluyor — önemli

**Ne bulundu.** Flash'ta PlaceObject2 "taşı" kaydı matris ya da renk dönüşümü alanı taşıyorsa, değer birim
olsa bile örneğin matrisi o değere *ayarlanır* (nesne başlangıç noktasına döner). `aktar.clean_op` birim
matrisi ve birim renk dönüşümünü işlem türüne bakmadan atıyor:

```python
if k == "matrix":
    if v != [1.0, 0.0, 0.0, 1.0, 0.0, 0.0]:   # araclar/aktar/aktar.py:77
        out[k] = round_list(v, 6)
```

Motor ise (`movie.rs`, `Clip::place`) taşımada verilmeyen alanı "değişmez" sayıyor (`p.matrix.unwrap_or(inst.matrix)`).
Sonuç: nesne eski yerinde/ölçeğinde kalıyor. Ekibin aracı (`denetim.same_op`) eksik matrisi birim sayıp "eşit"
diyor; Denetim 2 de bunu kaçırmıştı (hata `26adb60`'dan beri var; görünür hâle motorun oynatıcısıyla geldi).

**Kanıt** (`python3 -I $D/b10b_birim.py`, `$D/d31_duzelt.py`):

```
f1 görünür etkisi olan (önceki değer birim değil): 45   ör. ('kök', 9, 88, önceki matris (1,0,0,1, 771.2,192.9))
f2 görünür etkisi olan: 112   (matris 39 + 87, renk dönüşümü 6 + 25)
SWF kare 9 place {'move': True, 'depth': 88, 'char': 1350, 'matrix': (1.0, 0, 0, 1.0, 0, 0)}
LIB kare 9 {'depth': 88, 'move': True, 'char': 1350}      ← matris yok
```

Motorla çizilen kök kareleri, FFDec'in kare çizimine göre belirgin farklı piksel oranı (aktarılan →
`library.json` kopyasına yalnız bu 157 değer eklenince):

```
f1 kök kare 9: 0.131 → 0.011     f1 kök kare 13: 0.270 → 0.065
f2 kök kare 9: 0.131 → 0.011     f2 kök kare 13: 0.269 → 0.065     f2 kök kare 25: 0.118 → 0.016
```

Görsel: `$D/ekran/d31_f1_k13_levha.png` (soldan FFDec, aktarılan, düzeltilmiş kopya: evlerin yarısı yerinden
kaymış), `$D/ekran/f1_k9_yanyana.png`. Yeni commit'te (`396b153`) de aynı.

**Öneri.** `clean_op` taşıma (`move`) işlemlerinde SWF'de bulunan matris ve renk dönüşümünü birim olsa da
yazsın; ya da `library.json` biçimi "taşımada alan yoksa değişmez" kuralına göre birimi ayrıca işaretlesin.
Denetimde `same_op` eksik alanı yalnız yeni yerleştirmede birim saysın. Testi: kök kare 9, derinlik 88.

### D3-2. Şekil SVG'lerinde degrade ve desen matrisleri 4 ondalık — küçük

**Ne bulundu.** B10'un 2. maddesi değişmemiş. Tekrarlı zemin dokularında desenin başlangıç noktası çok
uzakta (ör. 1328: −1718 px; 1353 ve 1443: −3653 px; 1791: −8777 px); 4 ondalık matris hatası bu uzaklıkla
büyüyor ve doku ~0,1 piksel kayıyor.

**Kanıt** (`python3 -I $D/a10b_resimdolgu.py`, `$D/a10c_yuvarlama.py`): kendi çizimime (SWF matrisiyle) göre
motorun dokulu piksellerinin belirgin farklı oranı: F1 1328 %2,5, 1353 %6,4, 1421 %3,3, 1443 %3,3 (F2'deki
kopyaları 2150, 2174, 2230, 2252 aynı), 1791 %0,35 (2×); FFDec'te bu oranlar %0,00–0,29. Aynı çizim SVG'nin
4 ondalıklı matrisiyle yapılınca motorla fark %0,04–0,6'ya iniyor; yani fark yuvarlamadan. Gözle zor görülür.

**Öneri.** Desen ve degrade matrisleri SWF'den 6 ondalıkla (ya da ham değerle) yazılsın (morph uçlarında
yapıldığı gibi).

### D3-3. Denetim aracının kalan kör noktaları — küçük

Bkz. B9. Özet: (1) taşımada eksik matris/renk dönüşümü birim sayılıyor (D3-1); (2) bütün sayılar `TOL = 1e-3`
göreli payla karşılaştırılıyor (yorum hâlâ "4 basamağa yuvarlanır" diyor), 6 ondalık hassasiyet denetlenmiyor;
(3) resim dolgusunun türü (`-kirp`/`-yumusak`) SWF'deki türle karşılaştırılmıyor; (4) şekillerin renkleri
yalnız görsel ölçütle (32/255 eşiği) denetleniyor, sayısal karşılaştırma yok; (5) morph stil denetimi tek
yönlü (her SVG stili SWF'de var mı; SWF'de olup SVG'de olmayan stil ve degradenin yayılma türü
denetlenmiyor); (6) sponsor sözcükleri listesinde ArmorGames ve AddictingGames yok (yeni karar bu adları da
kapsıyor); (7) resim dolgulu şekillerde dayanak FFDec'in PNG'si; FFDec'in kendi hatası (1791) "sorun" olarak
çıkıyor.

### D3-4. 1791: FFDec'in çizim hatası denetimde sorun sayılıyor — bilgi

Bkz. yukarıdaki bölüm. Ayıklamada ve motorda hata yok.

### D3-5. `LISANSLAR.md`: TeX Gyre sürümü — küçük

Belge "TeX Gyre 2.501 Pagella ..., Bonum ..., Chorus, Adventor" ve "dosyaların sürümü: 2.501" diyor.
Dosyaların `head.fontRevision` değeri ve ailelerin README'leri: Pagella 2.501, Adventor 2.501, **Bonum 2.004,
Chorus 2.003**. (Dosyalar paketle bayt bayt aynı; yalnız yazılan sürüm numarası yanlış. 2.501, dağıtım
paketinin sürümüdür.)

### D3-6. Kod çevirisi sayısı MochiBot dosyasını da sayıyor — bilgi

`library.json → translation.counts.code_files` ve `FEUDALISM_ICERIK.md` 56 / 62 kod dosyası diyor; sahibinin
`kod.json`'undaki `frame_1/DoAction_2.as` (MochiBot çağrısını kapatan girdi) dosyası dışarıda bırakıldığı için
`kod-tr` altında 55 / 61 dosya var. Yeni commit'teki `translation.unused` yalnız `sabit` ve `kutular`
tablolarını kapsıyor; bu girdi orada da görünmüyor.

## Yeni commit `396b153` (kısa denetim)

Sahibinin kararı: sponsor yazıları ve korsan kopya ekranı gösterilmez. Yöntem: `396b153`'ün ayrı bir
kopyasında (`$D/wt4`) içerik `8bf1531` ile karşılaştırıldı ve B1, B4, B2, sayım ve D3-1 betikleri yeniden
çalıştırıldı (`python3 -I $D/yeni_commit.py`, `$D/b1_sponsor_wt4.py`, `$D/b4_kod.py $D/wt4/kaynak/feudalism/`,
`$D/b10_sayilar.py $D/wt4/content/feudalism/`).

```
f1: içerikten çıkan [] (değişiklik yok)
f2: içerikten çıkan [2020 şekil, 2021, 2022 yazı alanı, 2023 düğme, 3125–3130, 3132 yazı alanı, 3131 düğme]
   2020–2023'ü yalnız sprite 2024 (2. kare), 3125–3132'yi yalnız kök kare 115 kullanıyor; çocukları
   (yazı tipi 224, tıklama alanı 1764) oyunun başka yerlerinde de kullanıldığı için içerikte kalmış (doğru)
   library/texts'te başka değişen kayıt yok; yeni code_excluded: DefineButton2_2023 ve _3131 on(release)
   translation.unused {'kutular': ['2022']}, kutu sayısı 116 → 115
   sponsor adı geçen yazı (ArcadeTown, ArmorGames, AddictingGames, Newgrounds, Mochi): [] 
   (önceki sürümde: 2022, 3126, 3129, 3130, 3132)
f2 kod parçası 1126 = kod/ 996 + code_excluded 130, konum farkı 0; morph'lar 0 sorun
belge sayıları (şekil 2097+31+56, düğme 176+3, yazı alanı 184+10, sponsor 14 kök / 33 karakter) kendi sayımımla aynı
```

Sonuç: karar doğru ve yalnız hedeflenen 12 karakterle uygulanmış; oyunun başka parçası çıkmamış. Notlar:

- Kök kare 115 ("STOLEN" etiketi) ve sprite 2024'ün 2. karesi artık boş kare olarak duruyor. Oyunun
  kodundaki adres denetimi (`frame_1/DoAction.as` → `isExclusive()`, `DefineSprite_2024/frame_1`'de
  `gotoAndStop(2)`) korunuyor; oyunu yeniden yazarken bu denetimin her zaman "doğru" sayılması gerekir,
  yoksa boş panel görünür (bilgi).
- Ekibin denetim aracının sponsor sözcük listesi (`SPONSOR_WORDS`) ArmorGames ve AddictingGames'i içermiyor
  (D3-3, 6. madde). Şu an içerikte böyle bir yazı yok (kendi taramamla).
- D3-1 bu commit'te de duruyor (F1 45, F2 112 işlem).

## Yöntem ve sınırlar

**Bağımsız okuyucu (`$D/swfoku3.py`).** SWF 19 spesifikasyonundan bu denetim için yeniden yazıldı; ekibin
`swf.py`, `aktar.py`, `denetim.py`, `swfstats.py` kodu içe aktarılmadı, kopyalanmadı (yalnız mantık hatası
için okundu). Okuduğu: CWS/FWS/ZWS başlığı, uzun/kısa etiketler, iç içe DefineSprite; PlaceObject 1/2/3
(matris ham 16.16 değerleriyle, renk dönüşümü, oran, ad, kırpma, bütün süzgeç türleri, karışım, önbellek,
görünürlük, arka renk, klip eylemleri ve tuş kodu), RemoveObject 1/2, FrameLabel; DefineShape 1–4 (bütün
dolgu/çizgi stilleri, yeni stil kümeleri, kenarlar mutlak twip), DefineMorphShape 1/2 (iki uç, morph
degradeleri, odak); DefineButton 1/2 ve koşullu eylemler; DoAction, DoInitAction ve AVM1 dize sabitleri;
ExportAssets; JPEGTables + DefineBits (Pillow ile çözüm); DefineSound gövdesi; DefineText yazı tipi ve
DefineEditText yazı tipi başvurusu. Kendi etiket sayımlarım iki dosyada `manifest.json` ile tür tür aynı;
şekil ve morph kayıtlarında okunmadan kalan bayt 0.

**Flash kuralıyla kendi çizimim (`$D/raster3.py`).** Resim dolgulu şekiller için SWF verisinden doğrudan:
tek-çift kuralıyla dolgu bölgeleri (eğriler 24 parçaya bölünür), stil kümeleri sırayla, resim pikseli
`floor(M⁻¹·p)`, tekrarlıda mod, kırpılmışta sınıra kenetleme. Kenar yumuşatma yok (piksel merkezi örneği);
bu yüzden karşılaştırmalar kenardan 1 piksel içeride ya da satır profilleriyle yapıldı.

**Ekibin aracını çalıştırmak (yalnız B9 için, görev tanımının izniyle).** `8bf1531`'in iki ayrı kopyasında
(`$D/wt2`, `$D/wt3`); arşiv (`referans/`) ve `svg-batch` salt okunur bağlantıyla; geçici dosyalar
`TMPDIR=$D/tmp`. Depoya ve `swf-oyunlar`'a hiçbir şey yazılmadı; `cargo build` depodaki `target/`'a yazdı
(izinli). Worktree'ler işin sonunda `git worktree remove` ile kaldırıldı.

**Sınırlar.**

- `cikar.sh`'ın bütün FFDec dökümü yeniden üretilmedi (yalnız F2 betik dökümü).
- Şekillerin geometri ve dolgu stilleri bu denetimde yeniden karşılaştırılmadı: `f90b29e`'den (Denetim 2'nin
  doğruladığı içerik) bu yana `content/feudalism/*/shapes/` altında yalnız silme var (dışarıda bırakılan
  sponsor şekilleri; `git diff --name-status f90b29e 8bf1531`), değişen dosya yok. Resim dolgulu şekiller
  (desen kimliği değişti) yeniden denetlendi.
- Çizilmiş yazıları kendiliğinden bulan bir yöntemim yok.
- Lisans değerlendirmesi hukuki görüş değildir.
- Ekibin denetim aracını yalnız bir kez temiz ve bir kez hatalı kopya üzerinde çalıştırdım.

## Betikler ve çıktılar (`$D`)

| Betik | Ne yapar | Çıktı |
|---|---|---|
| `swfoku3.py` | bağımsız SWF okuyucusu (kütüphane) | – |
| `raster3.py` | SWF'den Flash kuralıyla resim dolgulu şekil çizimi (kütüphane) | – |
| `t0_genel.py`, `t1_kok.py` | başlık, etiket sayıları ↔ manifest; kök kareler ve sponsor kullanımları | `.txt` |
| `b1_sponsor.py`, `b1b_mx.py`, `b1c_gorsel.py` | B1: sponsor ağacı, içerik/derin özet, mx/Mochi kullanımı, görsel kopya | `.txt` |
| `b2_morph.py` | B2/B3: morph uç stilleri ve geometrisi (argümanla başka içerik klasörü) | `b2_morph.txt`, `b2_morph_eski.txt` |
| `b4_kod.py`, `b4b_doinit.py`, `b4c_sahip.py` | B4: kod parçaları ↔ dosyalar ↔ `code_excluded` | `.txt` |
| `b10_zaman.py`, `b10b_birim.py` | B10 ve D3-1: zaman çizelgeleri ham değerlerle; birim matris kaybı | `.txt` |
| `b10_sayilar.py` | tür sayıları ↔ belge | `.txt` |
| `d31_duzelt.py` | D3-1 sınaması: `library.json`'un **kopyasına** ($D/duzelt) eksik değerleri ekler | `d31_kareler.txt`, `ekran/` |
| `a10_desen.py`, `a10b_resimdolgu.py`, `a10c_yuvarlama.py` | desen eki ↔ dolgu türü; motor/FFDec ↔ kendi çizimim; 4 ondalık etkisi | `.txt`, `bm/` |
| `a11_ses_resim_ceviri.py` | sesler, resimler, çeviri tabloları ve hedefleri | `.txt` |
| `x1791_dump.py`, `x1791_karsilastir.py`, `x1791_kayma.py`, `x1791_yuvarlama.py` | 1791 incelemesi | `x1791/` |
| `b9_enjekte.py` | B9 sınaması: `$D/wt2` kopyasına 6 bilinen hata koyar | `b9_enjekte_rapor.md`, `b9_temel_rapor.md` |
| `yeni_commit.py` | `396b153` ↔ `8bf1531` içerik farkı ve sponsor yazısı taraması | `yeni_commit.txt` |

Ayrıca: `deb/` (indirilen Ubuntu paketleri ve açılmış hâlleri), `ffdec_kod/` (FFDec betik dökümü),
`eski/` (`f90b29e`'nin içeriği), `ekran/` (motorun ve FFDec'in ekran çizimleri).

