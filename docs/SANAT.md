# Sanat rehberi

> **Karar (16 Ekim 2026):** Oyunun sahibi yeni çizim yapılmamasına karar verdi. Oyunun bütün
> görselleri Feudalism 1 ve 2'nin kendi görselleridir; hak sahibinin izniyle kullanılır ve
> `araclar/aktar/aktar.py` ile `content/feudalism/` altına aktarılır (bkz. `docs/LISANSLAR.md`).
> Bu belgedeki ölçümler esinin nasıl çizildiğini anlatan kayıt olarak kalır; yeni çizim kuralı
> değildir.

Oyunun görünüşünü belirleyen kurallar. Her kural esin kaynağı iki Flash oyununun çizimlerinden
**ölçülmüştür** ve yanında dayandığı ölçüm yazılıdır. Ölçüme dayanmayan bir kural yalnızca oyunun
sahibinin kararıysa yazılır ve öyle işaretlenir: *(sahibin kararı)*.

Ölçümlerin kaynağı [`olcum/sonuclar.md`](../olcum/sonuclar.md) dosyasıdır. Bu dosyayı
`python3 araclar/olcum/olcum.py rapor` üretir; elle yazılmaz. Bu belgedeki sayılar oradan alınmıştır.

Belgedeki kısaltmalar:

| Kısaltma | Anlamı                                                                           |
| -------- | -------------------------------------------------------------------------------- |
| S        | Doygunluk (HSV): 0 gri, 1 en canlı                                               |
| V        | Parlaklık (HSV): 0 siyah, 1 en parlak                                            |
| ΔV, ΔS   | Bir degradenin iki ucu arasındaki parlaklık ve doygunluk farkı                   |
| baş      | Baş yüksekliği: baş tepesinden (saç dahil, başlık hariç) çeneye. Çizimde 64 birim |
| orta yarı | Referansların 1. ile 3. çeyreği arası. Bizim çizimlerimiz için geçme aralığıdır |

## Yöntem

Bu kurallar kesindir *(sahibin kararı)*:

1. **Referans depoya girmez.** Esin kaynağından çıkarılan SVG ve PNG'ler yalnızca bu bilgisayarda,
   `referans/` klasöründe kalır (git dışı). Depoya yalnızca ölçüm aracı, ölçüm sonuçları (sayılar, renk
   kodları) ve işaret dosyaları girer.
2. **Kopyalama yok.** Referansın yol verisi (path) kopyalanmaz; değiştirilerek de kopyalanmaz, iz
   sürülerek de çizilmez. Referanstan yalnızca oranlar, katman mantığı ve gölgeleme yöntemi alınır.
3. **Ölçümsüz karar yok.** Her stil kuralı dayandığı ölçümle yazılır.
4. **Ölçütler geçmeden çizim gösterilmez.** Gösterilen her çizimin yanında ölçüm tablosu bulunur:
   referans aralığı, bizim değer, geçti/kaldı.

Bir çizim şu sırayla yapılır (ayrıntısı "Çizim yöntemi" bölümünde):

1. İskelet: kendi pozumuz, eklem noktalarıyla. Esinin hiçbir pozuyla örtüşmez.
2. Hacimler, renkler, gölge şekilleri, yüz, el ve silah.
3. Ölçüm: `olcum.py karsilastir`. Kalan her ölçüt düzeltilir.
4. Yan yana levha: referansla aynı boyda, %5'lik cetvel çizgileriyle.

## Ruh

Flash döneminin elle çizilmiş vektör oyunları. Ölçülen ortak özellikler:

- Şekiller keskin kenarlıdır; kenarların büyük kısmı eğridir (kahramanlarda %59–75).
- Dış hat yoktur. Bir kahramanda en fazla birkaç ince çizgi vardır (0–4, ortanca 1).
- Az sayıda büyük şekil vardır: bir kahraman 21–50 dolgudan oluşur (ortanca 32).
- Hacim, iki uçlu, aynı renkte, yatay degradelerle ve keskin kenarlı gölge şekilleriyle verilir.
- Renkler sanıldığı kadar canlı değildir. Kahramanların yarısında ortalama doygunluk 0,16–0,55'tir ve
  canlı renk çoğunlukla tek bir vurgudur (kırmızı tunik, altın kemer).
- Duruşlar asimetriktir: ağırlık bir bacakta, silah gövdeye yakın ve çapraz.

Karakterler gerçekçi değildir, sevimli de değildir. Yüzleri sadedir ama gözleri açıktır.

**Kural:** Bütün çizimler bu oyun için özgün olarak yapılır. Esin kaynağının çizimleri, pozları,
yerleşimleri, karakterleri, simgeleri, adları ve metinleri kopyalanmaz *(sahibin kararı)*.

## Yapılmayacaklar

Bir çizimde bunlardan biri varsa çizim kabul edilmez.

| Yapılmayacak                                              | Dayandığı ölçüm ya da karar                                     |
| --------------------------------------------------------- | --------------------------------------------------------------- |
| Siyah dış hat (figürün çevresinde kontur)                 | 11 kahramanın hiçbirinde yok; 11 ince çizginin 2'si siyah, ikisi de yay kirişi |
| Büyük alanda saf ana renk (`#FF0000`, `#00FF00` gibi)     | Saf ana renk (S ≥ 0,95, V ≥ 0,95) alanı: orta yarı %0–0,4      |
| Önden, simetrik duruş                                     | Asimetri orta yarısı 9,9°–17,7°; önden en simetrik kahraman 3,8° |
| Esinin bir karesindeki pozun aynısı ya da hafif değiştirilmişi | Poz özgünlüğü eşiği 9,7° (bkz. "Duruş")                      |
| Her yerde aynı genişlikte süs şeridi                      | *(sahibin kararı)*; esinde şeritler uçlara doğru incelir        |
| Tende degrade                                             | 33 ten dolgusunun hiçbiri degrade değil                         |
| Çok duraklı (4+) ya da eğik degrade                       | Degradelerin %88–100'ü 2 duraklı; eksenden sapma en fazla 14,6° |
| Çok parlak, bağıran palet                                 | Çok doygun piksel (S > 0,85, V > 0,6) orta yarısı %0,7–16      |
| Kapsül ya da sosis biçimli uzuv                           | Esinin uzuv kesitleri bir yanı düz, bir yanı şişkindir ([KARAKTER_OLCULERI.md](KARAKTER_OLCULERI.md)) |
| Low-poly (düz kenarlı çokgen şekiller)                    | Kenarların %59–75'i eğri *(ayrıca sahibin kararı)*              |
| Pul pul zırh dokusu, perçin ayrıntısı                     | *(sahibin kararı)*                                              |
| Gerçekçi yüz (kırışık, anatomik ayrıntı, yüzde degrade)   | Yüz 4–6 küçük düz şekildir (bkz. "Yüz") *(ayrıca sahibin kararı)* |
| Kalın siyah yüz çizgileri                                 | Yüz öğeleri dolgudur; kaş saç renginde                          |
| Silahın elin yanında yüzmesi                              | 11 silahlı kahramanın 11'inde sapın ekseni elden geçer          |
| Fotoğraf, resim dosyası, gürültü dokusu, bulanıklaştırma  | Esin saf vektördür                                              |
| Aynı yerleşimle iki şehir, aynı dizilimle iki savaş, birebir aynı iki asker | *(sahibin kararı)*                            |

## Referanslar

Ölçümler esin kaynağı iki oyunun kendi dosyalarından yapılır.

```sh
araclar/olcum/cikar.sh ../swf-oyunlar      # referans/ klasörüne çıkarır (git dışı)
python3 araclar/olcum/olcum.py rapor        # olcum/sonuclar.json ve sonuclar.md
```

`cikar.sh` şunları yapar:

1. FFDec ile iki oyunun bütün şekillerini SVG ve PNG (4×) olarak, kodunu ve kukla sprite'larını dışa
   aktarır.
2. 18 savaş birliğini oyunun kendi formülleriyle (ulus, cinsiyet, zırh, miğfer, silah, duruş)
   birleştirir.
3. Kuklanın yapısını ve bütün animasyon karelerinin eklemlerini çıkarır (`olcum/kukla-*.json`;
   karelerin eklemleri git dışında `referans/<oyun>/pozlar.json`).
4. Kukla parçalarını ölçer: [KARAKTER_OLCULERI.md](KARAKTER_OLCULERI.md).

### Referans kümeleri

| Küme       | Figürler (şekil kimliği)                                    | Ne için                     |
| ---------- | ----------------------------------------------------------- | --------------------------- |
| Kahraman   | F1: 1104, 1106, 1108, 1110, 1112, 1114, 1116, 1118; F2: 2005, 2007, 2011 | Büyük resimdeki karakter (seçim ekranı, konuşma) |
| Kasaba     | F1: 1180, 1861–1864, 1881; F2: 2800 (yarım boy)              | Şehirdeki kişiler; el ve baş oranı |
| Portre     | F1: 208–214; F2: 443, 444, 446                              | Baş-omuz resimleri          |
| Savaş kuklası | İki oyundan 18 birlik                                    | Savaştaki parçalı figür     |

F2'deki 1991–2003, 2013 kahramanları ve 2796, 2797, 2799, 2820 kasaba figürleri F1'dekilerin
kopyasıdır; sayılmaz.

### Ölçüm aracı

`araclar/olcum/olcum.py` aynı ölçütleri referanslara ve bizim çizimlerimize uygular. Her çalıştırmada
aynı sonucu verir. Bütün çizimler motorun kendi çizicisiyle (`svg-png`) aynı boyda çizilip ölçülür.

| Ölçüt                    | Nasıl ölçülür                                                          |
| ------------------------ | ---------------------------------------------------------------------- |
| Dolgu, kontur            | SVG'deki dolgulu yol ve çizgi sayısı; çizgi kalınlığı                  |
| Degrade                  | Sayısı, türü, durakları; uçlar arası ΔV ve ΔS; yönü (açıktan koyuya)   |
| Palet ve alan            | Her şekil tek bir kimlik rengiyle boyanıp çizilir; görünen pikseller sayılır |
| Doygunluk, parlaklık     | Çizilen resmin opak piksellerinde ortalama S ve V; çok doygun piksel payı |
| Eğri payı                | Dolgulu yolların kenarlarında eğri parça payı                          |
| İşaretler                | Baş tepesi, çene, omuz, dirsek, bel, kasık, diz, ayak, el kutuları, silah ekseni: `olcum/isaretler.json`. Her figür %5'lik cetvel çizgili büyütmede elle okunur (`olcum.py cetvel`) |
| Oranlar                  | İşaretlerden: boy (baş sayısı), bacak / boy, omuz / boy, el / boy, el / yüz, asimetri, silah açısı, sapın elden geçmesi |
| Poz özgünlüğü            | Uzuv açıları esinin bütün pozlarıyla karşılaştırılır (bkz. "Duruş")    |

Bizim bir çizimimiz `olcum.py karsilastir cizim.svg kahraman iskelet.json` ile ölçülür. Çıktı,
her ölçütün referans aralığı, bizim değeri ve geçti/kaldı sonucudur. **Geçme aralığı orta yarıdır**
(1. ile 3. çeyrek arası): uç örneklere değil, tipik figüre benzemek gerekir.

## Karakter: büyük resim (kahraman ve portre)

Bu bölümdeki aralıklar 11 kahramandan ölçüldü; "orta yarı" geçme aralığıdır. Portre (baş-omuz)
çizimleri de aynı kurallara uyar; portre kümesinin aralıkları `olcum/sonuclar.md` dosyasındadır.

### Şekil ve ayrıntı

| Kural                                   | Orta yarı      | Ölçülen (en küçük–ortanca–en büyük) |
| --------------------------------------- | -------------- | ----------------------------------- |
| Dolgu grubu sayısı                      | 30–37          | 21 – 32 – 50                        |
| Ayrı dolgu rengi ya da degradesi        | 19–26          | 13 – 20 – 32                        |
| Kenarlarda eğri payı                    | %62–71         | %59 – 68 – 75                       |

- Ayrıntı şekille yapılır, çizgiyle değil: kıvrım koyu bir bant şekli, kemer bir şerit, zırh iki
  tonlu büyük plakadır.

### Kontur

| Kural                                   | Orta yarı      | Ölçülen                             |
| --------------------------------------- | -------------- | ----------------------------------- |
| İnce çizgi sayısı                       | 0–1            | 0 – 1 – 4                           |
| Çizgi kalınlığı                         | Figür boyunun en fazla ‰3'ü (bizim çizimde ≤ 1,5 birim) | Hepsi 1 piksel; kahramanlar ≈ 330 piksel boyunda |

- **Kural:** Dış hat yoktur. Parçalar birbirinden renk ve parlaklık farkıyla ayrılır.
- İnce çizgi yalnızca doğası çizgi olan şeylerde ya da tek bir ayrıntıda kullanılır: yay kirişi,
  bir kıvrım, burun ucu. Rengi altındaki rengin koyusudur (ölçülen 11 çizginin renkleri: `#666666`
  ×4, ten gölgeleri ×3, kahverengi ×2, `#000000` ×2; siyahların ikisi de yay kirişi).

### Hacim: degrade ve gölge

| Kural                                   | Orta yarı      | Ölçülen                             |
| --------------------------------------- | -------------- | ----------------------------------- |
| Degradeli dolgu payı                    | %30–50         | %24 – 41 – 56                       |
| Degradede durak sayısı                  | 2              | 2 duraklı payı %88–100              |
| Degrade uçları farkı ΔV                 | 0,10–0,18 (bütün degradelerde çeyrekler arası 0,07–0,18; sahibin talimatı 0,10–0,20) | ortanca 0,13 |
| Degrade uçları farkı ΔS                 | ≈ 0 (aynı renk) | figür ortancası 0 – 0,003 – 0,39   |
| Eksenden sapma                          | 0°             | 147 degradenin %90'ı tam yatay ya da dikey; en büyük 14,6° |
| Dairesel degrade                        | 0              | 0 – 0 – 2 (yalnızca zırhlı figürlerde) |

- **Kural:** Her büyük hacim (giysi parçası, uzuv, silah) tek renkli, 2 duraklı bir degradeyle
  boyanır: iki uç aynı rengin açığı ve koyusudur (ΔS ≈ 0, ΔV 0,10–0,18).
- **Kural:** Degradeler yataydır; dikey olanlar aşağı koyulaşır. Ölçülen 147 degradenin %71'i yatay
  (yarısı sağa, yarısı sola koyulaşır), %22'si aşağı, %7'si yukarı koyulaşır. Esinde ışık yönü
  tutarsızdır; bizde ışık sol üstten gelir, yatay degradeler sağa koyulaşır *(sahibin kararı)*.
- **Kural:** Ten, saç, yüz öğeleri ve küçük ayrıntılar düz renktir (33 ten dolgusunun hiçbiri degrade
  değil).
- Hacme ek olarak keskin kenarlı gölge şekilleri ve birkaç ışık şekli konabilir; degradeli dolgu payı
  yine %30–50 içinde kalır.

### Renk

| Kural                                                   | Orta yarı  | Ölçülen                |
| ------------------------------------------------------- | ---------- | ---------------------- |
| Ortalama doygunluk (opak piksel)                        | 0,16–0,55  | 0,02 – 0,41 – 0,66     |
| Ortalama parlaklık                                      | 0,51–0,71  | 0,23 – 0,67 – 0,86     |
| Çok doygun piksel (S > 0,85, V > 0,6)                   | %0,7–16    | %0 – 4,5 – 32          |
| Geniş alanların doygunluğu (alanı ≥ %5 renkler)          | 0,16–0,55  | 0 – 0,39 – 0,71        |
| Doygun renklerin (S > 0,7) toplam alanı                 | %3–31      | %0 – 4,6 – 46          |
| Doygun renk ailesi sayısı (30°'lik ton dilimi, alanı ≥ %2) | 1–2,5; kural: en fazla 1 | 0 – 1 – 3  |
| Saf ana renk alanı                                      | %0–0,4     | %0 – 0 – 9,4           |

- **Kural:** Büyük alanlar düşük doygunluktadır: zeytin, kahve, gri, boz, soluk mavi.
- **Kural:** En fazla bir vurgu rengi ailesi vardır (kırmızı ya da altın ya da mavi). Ölçülen 11
  kahramanın 7'sinde en fazla bir doygun renk ailesi var *(sahibin kararı: en fazla bir)*.
- Ölçülen renkler (degrade uçları, açık → koyu): kırmızı `#BA0101` → `#871212`; altın `#FED945` →
  `#ECBD02`; zeytin `#B3B979` → `#747942`, `#77773C` / `#5A5A2E`; kahve `#985B01` → `#6D4201`;
  ten `#F4D0A0`, `#F3C98B`, `#FFCC99` (düz).

### Oranlar

İşaretlerden ölçüldü (`olcum/isaretler.json`; boy = baş tepesinden tabana).

| Oran                                 | Orta yarı      | Ölçülen                  |
| ------------------------------------ | -------------- | ------------------------ |
| Boy (baş sayısı)                     | 7,2–8,3        | 6,0 – 7,7 – 8,7          |
| Bacak (kasıktan tabana) / boy        | 0,40–0,43      | 0,37 – 0,42 – 0,45       |
| Bel yüksekliği (tepeden) / boy       | 0,39–0,42      | 0,37 – 0,41 – 0,45       |
| Diz yüksekliği (tepeden) / boy       | 0,71–0,76      | 0,69 – 0,73 – 0,77       |
| Omuz genişliği / boy                 | 0,21–0,28      | 0,18 – 0,23 – 0,30       |
| Omuz genişliği / baş                 | 1,66–1,96      | 1,50 – 1,81 – 2,15       |
| El (uzun kenar) / boy                | 0,075–0,090    | 0,070 – 0,083 – 0,111    |
| El / yüz (baş yüksekliği)            | 0,58–0,69      | 0,50 – 0,61 – 0,83       |

- Yumruk boyun %7,5–9'udur; başın yarısından biraz büyüktür. Kasaba figürlerinde el / yüz daha
  küçüktür (0,43–0,47).

### Duruş

| Kural                                    | Sınır          | Ölçülen                                   |
| ---------------------------------------- | -------------- | ----------------------------------------- |
| Asimetri (önden simetrik duruştan fark)  | 9,9°–17,7° (orta yarı) | 3,8° – 14,4° – 37,0°               |
| Poz özgünlüğü: esinin en yakın pozuna uzuv açısı farkı | En az 9,7° | Esinin en benzer iki kahramanı (1104 ve 1112) arasındaki fark |
| Silah sapı elden geçer                   | Her zaman      | 11 / 11 kahraman, 6 / 6 kasaba figürü     |
| Silah açısı (yataydan)                   | Bilgi için     | 14° – 57° – 89°                           |

- **Poz özgünlüğü nasıl ölçülür:** bir poz uzuvlarının yönleriyle tanımlanır: gövde, iki üst kol,
  iki ön kol, iki uyluk, iki baldır, silah. İki poz karşılaştırılırken en elverişli eşleşme aranır
  (ayna, sol-sağ değişimi). Bizim poz; 11 kahramanla ve iki oyunun kuklalarının bütün 3360 animasyon
  karesiyle karşılaştırılır. En yakınına uzaklığı 9,7°'den az olamaz. 9,7°, esinin kendi kahramanları
  arasındaki en küçük farktır; kuklanın ardışık iki karesi arasındaki fark ortanca 3,2°'dir.
- **Kural:** Her karakterin pozu kendi iskeletinden kurulur: 3/4 görünüş, ağırlık bir bacakta
  (contrapposto), ayaklar farklı yönlere bakar, baş hafifçe döner. Silah gövdeye yakın, bel
  hizasında ve çaprazdır; iki elle ya da sapı saran bir elle tutulur *(sahibin kararı; ölçüyle
  uyumlu: silah açısının orta yarısı 39°–70°)*.
- **Kural:** Yan yana duran iki karakterin pozu aynı değildir (aralarındaki fark da en az 9,7°).

### Yüz

11 kahramanın yüzünden ölçüldü (`olcum/yuz.json`). Birim: baş yüksekliği; yükseklikler baş
tepesinden ölçülür.

| Öğe     | Kural                                                         | Ölçülen                                   |
| ------- | ------------------------------------------------------------- | ----------------------------------------- |
| Göz     | Badem; göz akı beyaz; ince (boyu 0,05–0,06). İki göz birlikte 0,45–0,49 genişlik kaplar. Göz hattı 0,50–0,59'da | 5 figür |
| İris    | Küçük, renkli ya da koyu (`#01498F`, `#562410`, `#651F01`, `#000000`); göz akının içinde. İki iris birlikte 0,31–0,42 | 6 figür |
| Kaş     | Saç renginde, ince: kalınlık 0,06–0,12                        | 5 figür (`#FFE87C`, `#C4C4C4`, `#A92201`, `#4D3C2B`, `#2B2B2B`) |
| Burun   | Tek bir gölge şekli, tenin bir ton koyusu; boy 0,14–0,33 (ortanca 0,24), en 0,07–0,17 | 8 figür (`#F2BE8C`, `#FEC792`, `#F3B58C`, `#EDCCAB`) |
| Ağız    | Küçük, yumuşak renkli dudak (`#EA792F`, `#EF9C65`, `#FD9935`); sakallı erkekte koyu (`#660000`). En 0,11–0,28 (ortanca 0,22); üst kenarı 0,71–0,92'de | 9 figür |
| Ten     | Düz renk                                                      | 33 / 33 ten dolgusu düz                   |

- **Kural:** Yüzde kalın siyah çizgi yoktur. Yüz 4–6 küçük düz şekildir: göz akı, iris, kaş, burun
  gölgesi, ağız (gerekirse bıyık ya da sakal).
- **Kural:** Her karakterde tek bir ayırt edici yüz öğesi vardır: bıyık biçimi, yara izi, örgü
  *(sahibin kararı)*.

### El ve silah

- **Kural:** Katman sırası avuç → sap → parmaklar. Sap avucun üstünden geçer, parmaklar sapın üstüne
  biner; sap yumruğun iki yanından çıkar.
- **Kural:** Sapın ekseni el kutusundan geçer. Ölçüm aracı bunu her çizimde denetler.
- Tutuş yeri ve silah boyları esinin kuklasından ölçüldü (silahın üst ucundan tutuşa oran): tek elle
  kılıç 0,87; iki elle kılıç ve balta 0,86–0,90; mızrak 0,66; yay 0,50. Boylar: tek elle kılıç
  2,5–3,8 baş, iki elle kılıç 4,9–5,3, mızrak 8–9, yay 4,3–4,6.

## Karakter: savaş kuklası

Savaştaki figür. 18 birlikten ölçüldü ([KARAKTER_OLCULERI.md](KARAKTER_OLCULERI.md),
`olcum/kukla-f1.json`, `olcum/kukla-f2.json`).

| Kural                                   | Orta yarı      | Ölçülen                             |
| --------------------------------------- | -------------- | ----------------------------------- |
| Dolgu grubu sayısı                      | 42–55          | 32 – 49 – 66                        |
| İnce çizgi sayısı (1 birim)             | 1–3            | 1 – 2 – 3                           |
| Degrade                                 | Yok            | 903 dolgunun hiçbiri                |
| Ortalama doygunluk                      | 0,22–0,53      | 0,07 – 0,47 – 0,72                  |
| Çok doygun piksel                       | %2,4–4         | %0 – 3,2 – 39                       |
| Kenarlarda eğri payı                    | %59–62         | %55 – 60 – 67                       |

### Oranlar (baş birimi)

| Ölçü                         | Değer (ortanca) | Not                                   |
| ---------------------------- | --------------- | ------------------------------------- |
| Ayakta boy                   | 6,2 baş         | Büyük resimden kısa ve tıknaz         |
| Boyun–kalça                  | 2,05            |                                       |
| Uyluk (kalça–diz)            | 1,51            |                                       |
| Diz–taban                    | 1,92            |                                       |
| Üst kol (omuz–dirsek)        | 1,25            |                                       |
| Ön kol + el                  | 1,43            |                                       |
| El boyu / eni                | 0,68 / 0,38     | El, ön kol kadar geniş                |
| Ön kol eni / bilek eni       | 0,40 / 0,24     | Bilek belirgin daralır                |
| Uyluk en geniş               | 0,71            | Dizde 0,38                            |
| Ayak boyu                    | 0,61            |                                       |

### Parçalar

Kukla 12 parçadır; her parçanın dönme noktası bir eklemdir (`olcum/kukla-f1.json`).

| Parça        | Kapsadığı yer                     | Dönme noktası  |
| ------------ | --------------------------------- | -------------- |
| `ust_kol_*`  | Omuzdan dirseğe                   | Omuz           |
| `on_kol_*`   | Dirsekten parmak ucuna (el dahil) | Dirsek         |
| `uyluk_*`    | Kalçadan dize                     | Kalça          |
| `baldir_*`   | Dizden tabana (çizme dahil)       | Diz            |
| `govde`      | Boyundan etek ucuna               | Kalça          |
| `bas`        | Saç, yüz, başlık                  | Boyun          |
| `silah_*`    | Silah                             | Tutuş yeri     |

- **Çizim sırası (arkadan öne):** üst kol (arka) → ön kol (arka) → silah (arka) → uyluk (arka) →
  baldır (arka) → uyluk (ön) → baldır (ön) → gövde → baş → silah (ön) → üst kol (ön) → ön kol (ön).
- Eklem yerlerinde parçalar birbirinin üstüne biner; esinde bindirme payı 0,18–0,27 baştır.
- Esinde iki oyunun kuklası 855 ve 2505 kare, 27 ve 65 animasyondur.
- Bizim kuklamızda el ve ayak ayrı gruptur (baş, gövde, üst kol, ön kol, el, uyluk, baldır, ayak,
  silah, kalkan) *(sahibin kararı)*.

### Her asker bir kişidir *(sahibin kararı)*

Aynı birlikten iki asker yan yana durduğunda farkları görülür:

- **Yüz:** en az 4 kaş, 4 bıyık ve sakal, 3 burun; ten tonu ve saç rengi.
- **Boy ve omuz:** boy ölçeği 0,94–1,06; omuz genişliği ölçeği 0,92–1,10.
- **Donanım:** küçük farklar; kalkanlarda boyalı damga motifleri.
- **Yaş ve ifade:** genç acemi, yorgun gazi.

## Palet

**Kural:** Çizimlerde **yalnızca** bu renkler kullanılır.

**Kural (doygunluk):** Paletin canlı renkleri (ör. `kırmızı-parlak`, `yeşil-parlak`) paleti
kısıtlamaz, kullanımı kısıtlar. Bir karakterde büyük alanlar düşük doygunluktadır ve en fazla bir
vurgu rengi ailesi bulunur. Sınırlar "Karakter → Renk" bölümündedir.

- Renklerin hepsi esin kaynağından ölçüldü.
- Paletin kaynağı `tools/art/palet.txt` dosyasıdır; bu tablo onun kopyasıdır.
- Otomatik denetim, bu tabloda paletin bütün renklerinin bulunduğunu da denetler.
- Yeni renk gerekirse önce referanstan ölçülür, sonra iki yere birden eklenir.
- Saydamlık serbesttir. Yarı saydam şekillerde de renk paletten seçilir.

#### Ten

| Ad | Renk | Ad | Renk | Ad | Renk |
| --- | --- | --- | --- | --- | --- |
| ten | `#FFCC99` | ten-gölge | `#F3B58C` | ten-derin | `#C69271` |
| ten-açık | `#FED8B4` | ten-buğday | `#F3C98B` | ten-pembe | `#F5C4A3` |
| ten-sarı | `#F4D0A0` | ten-sarı-gölge | `#F2BE8C` | dudak | `#CC3300` |
| dudak-açık | `#EF9C65` | dudak-pembe | `#F1A674` | ağız-koyu | `#881111` |
| ağız | `#660000` |  |  |  |  |

#### Saç ve sakal

| Ad | Renk | Ad | Renk | Ad | Renk |
| --- | --- | --- | --- | --- | --- |
| saç-siyah | `#000000` | saç-siyah-ışık | `#333333` | saç-sarı | `#FEFDBC` |
| saç-sarı-gölge | `#FEDE5F` | saç-kızıl | `#CC3300` | saç-kızıl-gölge | `#A73403` |
| saç-ak | `#E6E6E6` | saç-ak-gölge | `#CCCCCC` |  |  |

#### Kırmızı kumaş

| Ad | Renk | Ad | Renk | Ad | Renk |
| --- | --- | --- | --- | --- | --- |
| kırmızı-parlak | `#FF0000` | kırmızı | `#CC0000` | kırmızı-koyu | `#990000` |
| kırmızı-degrade-açık | `#BA0101` | kırmızı-degrade-koyu | `#871212` | kırmızı-gölge | `#57150F` |
| kırmızı-soluk | `#B92E2E` |  |  |  |  |

#### Beyaz, gri, siyah kumaş

| Ad | Renk | Ad | Renk | Ad | Renk |
| --- | --- | --- | --- | --- | --- |
| beyaz | `#FFFFFF` | beyaz-gölge | `#E6E6E6` | gri-açık | `#CCCCCC` |
| gri | `#999999` | gri-koyu | `#666666` | kömür-açık | `#4D4D4D` |
| kömür | `#333333` | kömür-koyu | `#222222` | siyah-ışık | `#1A1A1A` |
| siyah | `#000000` |  |  |  |  |

#### Yeşil ve zeytin kumaş

| Ad | Renk | Ad | Renk | Ad | Renk |
| --- | --- | --- | --- | --- | --- |
| yeşil-parlak | `#00CC00` | yeşil | `#009900` | yeşil-soluk | `#669966` |
| yeşil-soluk-gölge | `#558055` | zeytin | `#77773C` | zeytin-koyu | `#5A5A2E` |
| zeytin-derin | `#505027` | zeytin-sarı | `#E0CB16` | zeytin-açık | `#B2B27D` |
| zeytin-gri | `#9C8D52` | zeytin-sarı-gölge | `#C2B012` |  |  |

#### Çelik ve demir

| Ad | Renk | Ad | Renk | Ad | Renk |
| --- | --- | --- | --- | --- | --- |
| çelik-parlak | `#D0D5D9` | çelik-lavanta | `#CCCCE6` | çelik-açık | `#B2B2B2` |
| çelik-mavi | `#A1A8AB` | çelik-gölge | `#778A9A` | çelik-koyu | `#646579` |
| çelik-derin | `#353642` |  |  |  |  |

#### Mavi

| Ad | Renk | Ad | Renk | Ad | Renk |
| --- | --- | --- | --- | --- | --- |
| mavi | `#003399` | mavi-koyu | `#003366` | mavi-derin | `#000099` |
| mavi-soluk | `#395593` | mavi-açık | `#89ADFE` | lacivert-zemin | `#253C56` |

#### Altın ve sarı

| Ad | Renk | Ad | Renk | Ad | Renk |
| --- | --- | --- | --- | --- | --- |
| altın | `#FFCC00` | altın-açık | `#FEDE5F` | altın-parlama | `#FEEDAB` |
| altın-gölge | `#C6A04A` | altın-koyu | `#A88535` | altın-derin | `#745425` |
| altın-çerçeve | `#D5B32B` | turuncu | `#FF9900` | altın-sarı | `#F3C81D` |
| altın-hardal | `#D6AC07` | altın-çizme | `#D0A706` |  |  |

#### Kahve, deri, ahşap

| Ad | Renk | Ad | Renk | Ad | Renk |
| --- | --- | --- | --- | --- | --- |
| deri-açık | `#996633` | deri | `#795128` | deri-gölge | `#6C4824` |
| kahve | `#664422` | kahve-gölge | `#604020` | kahve-koyu | `#4D331A` |
| kahve-derin | `#392613` | kahve-siyah | `#2D1E0F` | ahşap-degrade-koyu | `#57390F` |
| ahşap-degrade-açık | `#A06A1B` | çizme-degrade-koyu | `#321E01` | çizme-degrade-açık | `#985B01` |
| sap | `#996600` | sap-koyu | `#4A2C01` |  |  |

#### Gök (gündüz ve gece)

| Ad | Renk | Ad | Renk | Ad | Renk |
| --- | --- | --- | --- | --- | --- |
| gök-tepe | `#00359B` | gök | `#0045AB` | gök-ufuk | `#0057BD` |
| gece-tepe | `#001122` | gece | `#0D1D2D` | gece-ufuk | `#35567B` |
| ay-ışığı | `#C3CDD8` | ay | `#EBEEF2` |  |  |

#### Yaprak, çimen

| Ad | Renk | Ad | Renk | Ad | Renk |
| --- | --- | --- | --- | --- | --- |
| yaprak-parlak | `#39DE10` | yaprak-açık | `#68B968` | yaprak | `#4DA94D` |
| yaprak-canlı | `#009900` | yaprak-koyu | `#14510D` | yaprak-derin | `#0D3309` |
| çam-koyu | `#003300` | çam | `#006600` | çam-açık | `#336633` |
| çam-ışık | `#339900` | çimen-açık | `#AFD3AB` | çimen-soluk | `#85BC7E` |
| çimen-gri | `#99BB9F` | gövde-kızıl | `#651F01` | gövde-koyu | `#3B3831` |
| gövde-gri | `#5B5346` |  |  |  |  |

#### Zemin ve kuru ot

| Ad | Renk | Ad | Renk | Ad | Renk |
| --- | --- | --- | --- | --- | --- |
| zemin-açık | `#538548` | zemin | `#4C8F40` | zemin-koyu | `#307439` |
| zemin-derin | `#417336` | kuru-ot | `#9DA139` | kuru-ot-koyu | `#9B8528` |
| toprak | `#A08639` | toprak-koyu | `#867A23` |  |  |

#### Su ve harita

| Ad | Renk | Ad | Renk | Ad | Renk |
| --- | --- | --- | --- | --- | --- |
| deniz-koyu | `#003366` | deniz | `#01597E` | deniz-açık | `#0B828E` |
| kara-koyu | `#1C8233` | kara | `#339933` | kara-açık | `#62AF23` |
| kara-sarı | `#82B013` | kıyı | `#C4C41A` | kıyı-koyu | `#B5B517` |

#### Taş ve yapı

| Ad | Renk | Ad | Renk | Ad | Renk |
| --- | --- | --- | --- | --- | --- |
| taş-gri | `#5E5E5E` | taş-yeşil | `#4D7574` | badana | `#FFFFCC` |
| badana-sarı | `#EBDF78` | badana-açık | `#F1ECC0` | kiremit | `#831F1F` |
| kiremit-koyu | `#691E18` |  |  |  |  |

#### Arayüz: parşömen, çerçeve, düğme

| Ad | Renk | Ad | Renk | Ad | Renk |
| --- | --- | --- | --- | --- | --- |
| parşömen-koyu | `#AD936B` | parşömen | `#CCBF91` | parşömen-açık | `#EBE1D8` |
| parşömen-kenar | `#8F7145` | parşömen-mürekkep | `#453621` | parşömen-derin | `#221B11` |
| parşömen-kart | `#BCA97E` | parşömen-rulo | `#4D3F2B` | altın-rakam | `#E1CC7A` |
| altın-ışıltı | `#FFCC33` | yuva-gri | `#5F5F5F` | yuva-siyah | `#050505` |
| düğme-kırmızı-odak | `#CF5A5A` | düğme-kırmızı-koyu | `#A20000` | panel-yeşil-koyu | `#042607` |
| panel-yeşil | `#446130` | panel-yeşil-açık | `#54773C` | panel-yeşil-derin | `#07450D` |

### Bölge renkleri

*(sahibin kararı; henüz ölçülmedi)*

Her bölge, paletin içinden kendi baskın renklerini seçer. Bir ekran görüntüsünden hangi bölgede
olunduğu anlaşılabilmelidir.

| Bölge              | Baskın renkler                                                            | Hava                               |
| ------------------ | ------------------------------------------------------------------------- | ---------------------------------- |
| Bozkır Beylikleri  | kuru-ot, toprak, mavi, kırmızı, altın                                     | Geniş, açık gök, uzun ufuk         |
| Kıyı Kentleri      | badana, kiremit, deniz-açık, zeytin                                       | Parlak, beyaz ışık, deniz meltemi  |
| Dağ Kaleleri       | taş-gri, taş-yeşil, çam-koyu, çelik                                       | Serin, keskin gölgeler, yükseklik  |
| Orman Sınırı       | çam, yaprak-koyu, yaprak-açık, ahşap                                      | Loş, katman katman ağaç            |
| Kuzey Akıncıları   | beyaz, çelik-mavi, mavi-koyu, gövde-kızıl                                 | Soğuk, alçak güneş, uzun gölgeler  |
| Kum Yolları        | badana-sarı, turuncu, toprak, yaprak, mavi                                | Sıcak, beyaza yakın ufuk           |

### Gün saati

Gün saati, katmanların renklerine çarpan ve eklenen bir renk dönüşümüyle verilir. Bu, Flash'taki
renk dönüşümünün karşılığıdır. Çizimler gündüz renkleriyle yapılır; saat ayarını motor yapar.

| Saat    | Işık                           | Gök                                  |
| ------- | ------------------------------ | ------------------------------------ |
| Sabah   | Altın sarısı                   | Ufuk sıcak                           |
| Öğle    | Nötr, parlak                   | Kobalt                               |
| Akşam   | Turuncu                        | Ufuk turuncu, tepe lacivert          |
| Gece    | Mavi ay ışığı                  | Gece paleti, ay parıltısı            |

**Kural:** Saat geçişleri yavaştır, en az birkaç saniye sürer. Ani tam ekran renk değişimi yoktur.

## Ölçek ve birimler

Bütün çizimler SVG olarak tutulur. Bir SVG biriminin ekranda kaç piksel olduğu çizimin türüne göre
sabittir:

| Tür              | Çizim alanı                                         | Ekrana ölçek                                      |
| ---------------- | --------------------------------------------------- | ------------------------------------------------- |
| Ekran ve arayüz  | 1 birim = 1 mantıksal piksel (1920×1080 ekran)      | 1                                                 |
| Manzara katmanı  | 1 birim = 1 mantıksal piksel; ekrandan geniş olabilir | Paralaksa göre kayar                           |
| Karakter (büyük resim) | Baş 64 birim; boy 7,2–8,3 baş (460–530 birim)  | Seçim ekranında 1–1,4                             |
| Karakter (kukla) | Baş 64 birim; boy 6,2 baş (≈400 birim)              | Savaşta ~0,3 (≈120 piksel)                        |
| Simge            | 128×128 birim                                       | Arayüzde 48–96 piksel                             |

Mantıksal ekran 1920×1080'dir; motor bunu pencere boyutuna ölçekler. Çizimler vektör olduğu için
her ölçekte, 4K'da da keskindir.

## Manzara

> **Durum:** Bu bölüm eski yöntemle (gözle ve ekran görüntüsünden) yazıldı. Yeni yöntemle (ölçüm
> aracı, referans kümesi, geçti/kaldı tablosu) karakterlerden sonra yeniden yazılacak. O zamana kadar
> yeni çizim için bağlayıcı değildir; yalnızca yön gösterir.

Savaş alanları ve şehir sahneleri katmanlardan kurulur. Katmanlar kamera kayarken farklı hızlarda
kayar (paralaks).

| Sıra | Katman           | Paralaks | Açıklık (gündüz)  | İçerik                                         |
| ---- | ---------------- | -------- | ----------------- | ---------------------------------------------- |
| 1    | Gök              | 0–0,05   | L\* 27–40         | 2 duraklı dikey kobalt degradesi, güneş parıltısı |
| 2    | Uzak             | 0,1–0,2  | L\* 55–70         | Tepe ve dağ siluetleri                          |
| 3    | Orta             | 0,3–0,4  | L\* 15–35 (koyu)  | Koyu ağaç dizisi                                |
| 4    | Yakın arka plan  | 0,6–0,8  | L\* 40–70         | Ağaçlar, yapılar; koyu dizinin önünde parlak    |
| 5    | Savaş zemini     | 1        | L\* 45–60         | Büyük lekeli çayır, yol; oyun alanı             |
| 6    | Ön plan          | 1,2–1,4  | L\* 20–35         | Koyu ot öbekleri, çalılar (yalnızca kenarlarda) |

- **Kural:** Komşu katmanlar arasında ΔL\* ≥ 10 olur. Uzaklık soluklaştırarak değil, **koyu
  siluetle** verilir. Gök rengine karışım uzak katmanda en fazla %25–35'tir.
- **Kural:** Bir katmanda şekillerin en fazla %10'u yarı saydamdır (siyah gölge ve beyaz ışık hariç).
  Lekeler üst üste bindirilmiş yarı saydam şekiller değil, düz şekillerdir.
- **Ağaç:**
  - 3–4 düz yeşil kullanılır; tonlar arasındaki her adım ΔL\* 8–14'tür.
  - Yaprak kümeleri tümsekli ya da sivri loblu, düz lekelerdir.
  - Dallar görünür; gövde 2 tonludur.
  - Bir ağaç 8–20 şekilden oluşur.
  - Tek top ağaç ve lolipop selvi yasaktır.
- **Ot:**
  - Ufuk çizgisinde sivri, alev biçimli uzun bir ot saçağı vardır (2 sarımsı yeşil).
  - Bir ot öbeği 5–9 sivri yapraktır.
- **Zemin:** az sayıda, büyük ve üç tonlu lekeler vardır. Yol doygun okradır ve kenarında koyu bir
  bant bulunur.
- **Küçük serpinti:** çakıl ve tek ot gibi serpintiler kümeler hâlinde olur; ekranda en fazla 15 tane
  bulunur.
- **Gölge:** karakterlerin ve ağaçların altında düz, yarı saydam siyah bir elips gölge vardır.
- **Kural:** Aynı katman takımı iki savaşta aynı dizilimle kullanılmaz.

## Arayüz

> **Durum:** Bu bölüm eski yöntemle (gözle ve ekran görüntüsünden) yazıldı. Yeni yöntemle (ölçüm
> aracı, referans kümesi, geçti/kaldı tablosu) karakterlerden sonra yeniden yazılacak. O zamana kadar
> yeni çizim için bağlayıcı değildir; yalnızca yön gösterir.

Arayüz ağır, metalik ve karşıtlığı yüksektir. Oyunun dünyasından yapılmış nesneler gibi görünür:
parşömen, altın, ahşap, mühür, kalkan.

### Parşömen kart (sahibin en sevdiği öğe)

Esin kaynağının savaş panelindeki parşömen kartlar ve tomar düğmeler oyunun sahibinin en sevdiği
arayüz öğeleridir. **Tarzları** bizim arayüzümüzün temelidir. İçlerindeki simgeler (haçlar, kanlı
kılıç) alınmaz; simgeler bizim dünyamıza göre baştan tasarlanır.

| Öğe            | Görünüş                                                                                  |
| -------------- | ---------------------------------------------------------------------------------------- |
| Panel          | Koyu yeşil zemin (`panel-yeşil-derin` `#07450D`, `panel-yeşil-koyu` `#042607`)           |
| Yuva           | Koyu, kabartmalı çerçeve: dıştan içe `yuva-gri` `#5F5F5F` → `yuva-siyah` `#050505` silindir degradesi. İçi koyu yeşil, ortası hafif açık (radyal) |
| Kart           | Dik parşömen: üstten alta `parşömen-kart` `#BCA97E` → `parşömen-açık` `#EBE1D8`. Sol ve sağ kenar hafif S biçiminde dalgalıdır. Üst kenar rulo kıvrımlıdır; sol üstte `parşömen-rulo` `#4D3F2B` küçük bir kıvrım ucu vardır. Alt kenarın altında ince koyu bir rulo gölgesi bulunur |
| Simge          | Kartın ortasında, kartın %60–75'ini dolduran iri bir şekildir. Açık iç dolgunun çevresinde beyaz ya da altın bir kenar ve 2–3 sıra **ışıltı çizgisi** bulunur: şeklin dışına doğru aralıklı, kesik kesik eş biçimli çizgiler. Simge "parlıyor" gibi durur |
| Sayı           | Sağ altta, `altın-rakam` `#E1CC7A` |

### Tomar düğme

İki ucu rulo kıvrımlı, yatay bir parşömen tomarıdır.

- Üstünde koyu mürekkeple (`parşömen-mürekkep`) çizilmiş küçük bir simge ve düğmenin adı bulunur:
  "Beceriler", "Envanter" gibi.
- Simge tek renkli ve kalındır: yumruk, kılıç, kalkan.

### Öbür öğeler

| Öğe              | Görünüş                                                                                       |
| ---------------- | --------------------------------------------------------------------------------------------- |
| Pervaz (çerçeve) | 1080p'de 14–20 piksel kalınlıkta. 3 duraklı silindir degrade (`altın-derin` → `altın-çerçeve` → `altın-derin`, ΔL\* 35–50). İçte 2–3 piksel koyu çizgi; köşelerde metal köşebent |
| Pencere zemini   | Parşömen, radyal degrade: merkez L\* 86–90 (`parşömen-açık`), kenar L\* 65–72 (`parşömen-koyu`) |
| Başlık           | Kurdele: ön yüzü kırmızı degrade; kıvrımın arka yüzü ΔL\* 15–20 koyu (`kırmızı-gölge`); uçları çatallı |
| Onay düğmesi     | Kırmızı mühür: dalgalı kenarlı, kırmızı degradeli                                              |
| Ok düğmesi       | Elmas ya da üçgen biçimli, kırmızı degradeli                                                   |
| Geri düğmesi     | Metal kenarlı kalkan                                                                           |
| Bilgi kutusu     | Kıvrık uçlu parşömen tomarı; ad, özellikler (küçük simgelerle) ve fiyat (sikke simgesiyle)     |
| Konuşma          | Konuşanın portresi ve parşömen. **Düz beyaz baloncuk yok**                                     |

**Kural:** Simgeler kontursuzdur. Yuvalarının %70–85'ini doldururlar. 3 ton ve 1 parlama kullanırlar;
doygunlukları C\* ≥ 55'tir. Bir ekranda tek simge tarzı kullanılır: renkli simge ya da mürekkep
çizimi simge. İkisi aynı satırda karışmaz.

**Davranış:**

- **Üstüne gelince:** yumuşak altın parıltı 0,15 saniyede belirir.
- **Basınca:** öğe 2 piksel aşağı iner ve bir ton koyulaşır.
- **Klavyeyle seçilen öğe:** çevresinde altın odak çerçevesi olur.

### Yazı

| Kullanım           | Yazı tipi        | Boyut (1080p) |
| ------------------ | ---------------- | ------------- |
| Oyunun adı         | Alegreya SC Bold | 96–128        |
| Başlık             | Alegreya SC      | 40–56         |
| Düz metin          | Alegreya         | 26            |
| Küçük metin, sayı  | Alegreya Sans    | 20–22         |

- Satır aralığı, yazı boyunun 1,3 katıdır.
- Parşömen üstündeki yazının rengi `parşömen-mürekkep` `#453621`'dir. Kırmızı ve koyu zemin üstündeki
  yazı `parşömen-açık` `#EBE1D8` olur.
- **Kural:** Türkçe büyük harf dönüşümü Türkçe kurallarla yapılır (i → İ, ı → I).

## Dünya haritası

> **Durum:** Eski yöntemle yazıldı; karakterlerden sonra ölçümle yeniden yazılacak.

Elle çizilmiş, yaşayan bir haritadır.

- **Deniz:** `deniz-koyu` → `deniz` degradesi. Kıyıya yakın açık bir şerit ve dalga kıvrımları vardır.
- **Kara:** dikey yeşil → zeytin degradesiyle büyük lekelerdir. Kıyı boyunca `kıyı` renginde bir
  "kalınlık" şeridi vardır; kara kâğıttan kesilip yapıştırılmış gibi durur.
- **Şehirler:** kültürüne göre farklı, 3/4 kuşbakışı küçük simgelerdir. Aydınlık ve gölge yüzleri
  belirgindir. Her şehrin kendine özgü bir ayrıntısı vardır: liman, kule, kubbe.
- **Süsler:** dağlar, ağaç kümeleri, vaha, yol izleri. Kenarda pusula gülü ve bordür bulunur.
- **Mevsim:** haritaya yansır. Kışın kuzey beyazlaşır.

## Şehirler

**Kural:** İki şehir aynı yerleşimle çizilmez. Her şehrin kendine ait şunları vardır:

- manzara: dağ yamacı, liman, vaha ya da nehir adası;
- mimari;
- özel bir bina.

Bir şehir ekran görüntüsünden tanınabilmelidir.

## Hareket ve efektler

- Kukla animasyonu yumuşak geçişlidir: hareket yavaşlayarak başlar ve biter. Vuruşlarda kısa bir ön
  hazırlık ve vuruş anında 2–3 karelik duraklama olur.
- Efektler (kıvılcım, toz, kan) küçük ve yereldir; vektör parçacıklarla çizilir.

**Kural (görsel güvenlik):**

- Hiçbir efekt saniyede 3'ten fazla parlama üretmez.
- Ani tam ekran beyaz ya da kırmızı geçiş yoktur. Ekranın geneline yayılan renk değişimleri en az 0,5
  saniye sürer.
- Doygun kırmızıyla yanıp sönen efekt yoktur.

## SVG yazım kuralları

Motorun okuduğu SVG alt kümesi:

- **Kullanılır:** `path`, `rect`, `circle`, `ellipse`, `polygon`, `g`, `transform`, `fill`, `opacity`,
  `fill-opacity`, `linearGradient`, `radialGradient`, `stop`.
- **Kullanılmaz:** filtre (bulanıklaştırma, gölge), maske, kırpma, desen, gömülü resim, SVG içinde
  yazı, kesikli çizgi. Yazılar motorda çizilir.
- Grup saydamlığı (`<g opacity>`) yerine her şeklin kendi saydamlığı kullanılır.
- Kimlikler (`id`) İngilizce ve küçük harflidir.
- Renkler yalnızca paletten seçilir.

**Dosya düzeni:** Otomatik denetim çizimin türünü klasörden anlar.

| Klasör adı    | Tür                                              |
| ------------- | ------------------------------------------------ |
| `characters/` | Karakterler ve hayvanlar                         |
| `landscape/`  | Manzara katmanları                               |
| `ui/`         | Arayüz ve simgeler                               |

Örnek: `content/art/samples/characters/hero.svg`.

Çizimler elle değil, `tools/art/` içindeki Python betikleriyle üretilir. Betikler renkleri
`palet.py` üzerinden adıyla ister (`r("kırmızı")`); paletin dışında renk yazılamaz.

## Otomatik denetim

İki denetim vardır.

**1. Her gönderimde (CI):** `cargo test -p game --test art_rules` her SVG'yi motorun okuduğu biçimde
yükler ve şunları denetler:

| Denetim                                         | Sınır                                  | Dayanağı                    |
| ----------------------------------------------- | -------------------------------------- | --------------------------- |
| Bütün renkler paletten mi                       | Hepsi                                  | Palet ölçüldü               |
| Degrade durak sayısı                            | En fazla 3                             | Kahramanlarda 2 duraklı payı %88–100 |
| Doğrusal degradenin eksenden sapması            | En fazla 15°                           | En büyük 14,6°              |
| Karakterde kontur                               | Yok (en fazla 1,5 birimlik ince çizgi) | Figür boyunun ‰3'ü          |
| Manzarada kontur                                | Yok                                    | Eski yöntem                 |
| Karakterde degradeli şekil oranı                | En fazla %56                           | Kahramanlarda en büyük %56; kuklada 0 |
| Karakter yollarında eğri parça oranı            | %55–75                                 | Kukla %55–67, kahraman %59–75 |
| Manzarada yarı saydam şekil oranı               | En fazla %10 (siyah ve beyaz hariç)    | Eski yöntem                 |
| Sahne dosyalarındaki yazı renkleri              | Paletten                               |                             |
| Bu belgede paletin bütün renkleri yazılı mı     | Hepsi                                  |                             |

Kurala aykırı bir çizim derlemeyi kırmızıya düşürür.

**2. Her yeni karakterde (ölçüm aracı):** `python3 araclar/olcum/olcum.py karsilastir cizim.svg
kahraman iskelet.json`. Bu bölümdeki bütün aralıkları (orta yarı), oranları, sapın elden geçmesini ve
poz özgünlüğünü denetler. Bütün satırlar "GEÇTİ" olmadan çizim gösterilmez.

## Çizim yöntemi

Karakterler `tools/art/` içindeki Python betikleriyle üretilir. Sıra:

1. **İskelet (JSON):** 3/4 görünüş, contrapposto, ağırlık bir bacakta. Eklem noktaları:
   baş tepesi, çene, omuzlar, dirsekler, el kutuları, bel, kasık, dizler, ayaklar, silah ekseni
   (`olcum/isaretler.json` biçiminde). Oranlar "Oranlar" tablosunun orta yarısından seçilir. Poz
   özgünlüğü önce iskelette denetlenir: `olcum.py ortusme iskelet.json`.
2. **Hacim:** her parça organik bir hacimdir: kumaş kenarları uçlara doğru incelir, uzuvlar bir yanı
   düz bir yanı şişkindir.
3. **Renk:** önce paletten taban renkleri; büyük alanlar düşük doygunlukta, tek vurgu ailesi.
4. **Gölge:** her hacme aynı renkte 2 duraklı yatay degrade (ΔV 0,10–0,18, ışık sol üstten); gerekirse
   keskin kenarlı gölge şekli ve birkaç ışık şekli.
5. **Yüz:** "Yüz" tablosundaki kuruluş.
6. **El ve silah:** avuç → sap → parmaklar; sapın ekseni el kutusundan geçer.
7. **Kukla:** parçalar ayrı gruplar olarak, her biri kendi eklem noktasıyla verilir: baş, gövde, üst
   kol, ön kol, el, uyluk, baldır, ayak, silah, kalkan.
8. **Ölçüm:** `olcum.py karsilastir`; kalan her satır düzeltilir.
9. **Levha:** referansla aynı boyda, %5'lik cetvel çizgileriyle yan yana; altında ölçüm tablosu.

## Kontrol listesi

Her yeni karakter için:

- [ ] Otomatik denetimden (`art_rules`) geçiyor mu?
- [ ] `olcum.py karsilastir` tablosunda bütün satırlar GEÇTİ mi?
- [ ] Poz özgünlüğü en az 9,7° mi? Pozu esinin bir karesine benziyor mu? Benziyorsa değiştir.
- [ ] "Yapılmayacaklar" listesindeki hiçbir şey yok mu?
- [ ] Büyük alanlar düşük doygunlukta mı? Tek vurgu ailesi mi?
- [ ] Ten ve yüz düz mü? Yüz 4–6 küçük şekil mi?
- [ ] Sap elden geçiyor mu? Parmaklar sapın üstünde mi?
- [ ] Kukla parçaları ayrı gruplarda ve eklem noktaları doğru mu?
- [ ] Esin kaynağındaki bir karaktere, simgeye ya da yerleşime benziyor mu? Benziyorsa değiştir.
