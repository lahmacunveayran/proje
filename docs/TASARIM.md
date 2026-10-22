# Tasarım belgesi

Durum: **taslak**. Oyunun adı henüz konmadı; belgede "oyun" diye geçer.
Bu belge yaşayan bir belgedir: oynadıkça değişir. Kesinleşen kararlar **Karar:** diye işaretlenir,
henüz tartışılan konular en sondaki "Açık sorular" bölümündedir.

## Vizyon

Feudalism serisinin sevdiğimiz yanlarını alıp çok daha derin, uzun soluklu bir Windows oyunu yapmak:
ordu toplamak, kahramanı büyütmek, şehirden şehre gezip savaşmak ve el çizimi, sıcak renkli görseller.

Tek cümleyle: **Küçük bir sınır beyinin; ordusunu, adını ve soyunu kurduğu, her şehrin ve her
savaşın kendine özgü olduğu bir ortaçağ serüveni.**

## Temel ilke: hiçbir şey birbirinin kopyası değil

Seride savaşlar, şehirler, ordu ve kahraman gelişimi keyifliydi ama hepsi birbirine benziyordu:
her şehir aynı ekran, her savaş aynı düz çayır, her asker birbirinin aynısı. Bu oyunun bütün
tasarım kararları şu dört kurala göre verilir:

1. **Her şehir bir yerdir.** Kendi manzarası, yerleşimi, kültürü, yöneticisi, derdi ve sırrı vardır.
   Bir şehri ekran görüntüsünden tanıyabilmelisin.
2. **Her savaşın bir hikâyesi vardır.** Arazi, hava, saat, amaç ve düşman komutanının tavrı her
   savaşı farklı oynatır. Aynı düşmanla iki savaş aynı geçmez.
3. **Her asker bir kişidir.** Hayatta kalanların adı, unvanı ve geçmişi olur; ölenin yokluğu hissedilir.
4. **Her kahraman bir seçimler toplamıdır.** İki oyunun sonundaki iki kahraman birbirine benzemez.

## Seriden ne alıyoruz, neyi değiştiriyoruz

| Seride                                    | Bu oyunda                                                                   |
| ----------------------------------------- | --------------------------------------------------------------------------- |
| Kahramanı doğrudan oynadığın savaşlar     | Korunur; üstüne ordu bölüklerine verilen basit komutlar, moral ve arazi     |
| Tek tip düz savaş alanı                   | Tepe, orman, nehir geçidi, köprü, bataklık, kar, gece, sis, yağmur          |
| Hep aynı amaç: herkesi yen                | Pusu, kervan baskını, kale savunması, kuşatma, düello, geri çekilme         |
| Aynı ekranlı şehirler                     | Elle tasarlanmış, her biri farklı görünen ve farklı işleyen şehirler        |
| Satın alınan, birbirinin aynı askerler    | Deneyim kazanan, terfi eden, adı ve unvanı olan askerler                    |
| Nitelikler, beceriler, auralar, rünler    | Korunur; beceri ağaçlarında gerçek seçimler, silah türüne göre dövüş stili  |
| Demirci, silah geliştirme                 | Korunur; savaşta iz bırakan silahlar zamanla ad ve özellik kazanır          |
| Dünya haritası, el değiştiren şehirler    | Yaşayan dünya: diğer beyler de sefer eder, ittifak kurar, mevsimler değişir |
| Kısa sefer                                | Hikâye seferi + serbest oyun; uzun soluklu bir hanedan                      |

**Karar:** Seriden yalnızca esinlenilir. Görseller, adlar, metinler ve müzik bu oyun için özgün
olarak hazırlanır; Feudalism'in dosyaları ve adı kullanılmaz.

## Oyun döngüsü

```
Dünya haritası ──► yolculuk ve yol olayları ──► savaş ──► ganimet, deneyim, kayıplar
      ▲                                                            │
      └── şehir: asker topla, donan, görev al, ticaret yap ◄───────┘
                         dünya değişir: şehirler el değiştirir, ilişkiler kurulur/bozulur
```

Kısa döngü (dakikalar): bir savaş, bir şehir ziyareti.
Orta döngü (saatler): bir görev zinciri, bir şehri ele geçirmek, bir beylikle ittifak.
Uzun döngü (onlarca saat): hikâye seferi, bir bölgeye hâkim olmak, hanedanı sürdürmek.

## Dünya

Öneri: **kurmaca ama tanıdık** bir coğrafya. Seri gibi farklı kültürleri bir araya getirir, ama
gerçek tarihe bağlı kalmak zorunda değildir; adlar ve olaylar bize aittir.

Taslak bölgeler (her biri kendine özgü askerler, binalar, mimari ve müzikle):

- **Bozkır Beylikleri**: atlı okçular, obalar, at pazarları, geniş düzlükler. Oyuncunun başladığı yer.
- **Kıyı Kentleri**: tüccar şehirler, limanlar, paralı askerler, deniz yoluyla yolculuk.
- **Dağ Kaleleri**: dar geçitler, demir madenleri, usta demirciler, ağır piyade.
- **Orman Sınırı**: ormanlık sınır boyu, pusular, avcılar, okçular.
- **Kuzey Akıncıları**: soğuk kıyılar, kalkan duvarları, baltacılar, kışın kapanan yollar.
- **Kum Yolları**: kervan şehirleri, vahalar, develi birlikler, değerli mallar.

**Yaşayan dünya:**

- Diğer beyler de sefer eder, şehir alır, ittifak kurar. Oyuncu beklerken dünya durmaz.
- **Mevsimler**: kış dağ geçitlerini kapatır, bahar nehirleri taşırır, hasattan sonra erzak ucuzlar.
- **Ün**: yaptıkların duyulur; kimi şehir kapısını açar, kimi kapatır.

## Şehirler

Şehirler oyunun kalbidir. v1.0 için hedef 15–20 elle tasarlanmış şehir. Her şehirde:

- **Kendine özgü görünüm**: katmanlı, elle çizilmiş manzara (dağ yamacı, liman, vaha, nehir adası).
- **Özel bir bina**: at yetiştiricisi, usta demirci, mabet, liman, arena, kütüphane, paralı asker hanı…
- **Yerel birlik**: yalnızca orada toplanabilen askerler.
- **Yönetici**: kişiliği olan bir bey (cömert, kuşkucu, hırslı, korkak); onunla ilişki zamanla değişir.
- **Derdi**: veba, haydut baskını, taht kavgası, kıtlık; görev zincirleri buradan doğar.
- **Sırrı**: keşfedilmeyi bekleyen bir yer, bir kişi ya da bir eşya.

Ele geçirilen şehir yönetilir: vergi, garnizon, yeni yapılar, halkın memnuniyeti. Yönetilmeyen şehir
isyan eder ya da komşu bey tarafından alınır.

## Savaş

**Karar:** Savaş seride olduğu gibi gerçek zamanlıdır. Karakterler yandan görünür, alan derinliği olan
bir çayırdır; kahramanı oyuncu doğrudan yönetir (hareket, saldırı, özel hareket, iksir), askerler
kendi akıllarıyla dövüşür.

Üstüne eklenenler:

- **Arazi**: tepe (yüksekteki üstündür), orman (okları keser, pusuya uygundur), nehir geçidi ve köprü
  (darboğaz), bataklık (yavaşlatır), kar.
- **Hava ve saat**: yağmur yayları zayıflatır, sis görüşü kısar, gece pusuya elverişlidir.
- **Amaçlar**: meydan savaşı, pusu kurmak ya da pusudan kurtulmak, kervan baskını ya da koruması,
  kale savunması, kuşatma, düello, ordunun bir kısmını kurtarıp geri çekilmek.
- **Bölük komutları**: ordu bölüklere ayrılır (ön saf, kanatlar, okçular, süvari). Birkaç tuşla basit
  komutlar: *hücum*, *yerini tut*, *beni izle*, *geri çekil*. Amaç strateji oyunu olmak değil,
  kahramanla dövüşürken orduya yön verebilmek.
- **Moral**: ağır kayıp veren bölük dağılabilir. Sancak, kahramanın naraları ve özel hareketleri moral
  verir. Düşman komutanı düşerse düşman sarsılır.
- **Düşman komutanları**: kişilikleri vardır (temkinli, saldırgan, hilekâr). Biri okçularını tepeye
  çıkarır, biri gece baskın yapar.
- **Sonuç**: yaralılar iyileşmek için zaman ister, esirler fidyeyle bırakılabilir, ganimet paylaşılır,
  ölen gaziler kalıcı olarak gider.

**Kuşatma** ayrı ve büyük bir özelliktir: surlar, kapı, merdivenler, mancınık, kaynar yağ; her
kalenin surları ve haritası kendisine göredir. Savunan taraf olmak da mümkündür.

Savaş alanları elle hazırlanmış parçalardan (arazi şekilleri, ağaç kümeleri, yapılar) kurulur; arazi,
hava, saat ve amaç birleşince her savaş farklı görünür ve farklı oynanır.

## Ordu

- **Kültüre bağlı birlikler**: her bölgenin kendi askerleri vardır.
- **Deneyim ve terfi**: asker savaştıkça gelişir; terfide yol seçilir (ör. mızrakçı → kalkanlı
  muhafız ya da uzun mızraklı).
- **Gaziler**: çok savaş gören askerler ad ve unvan kazanır ("Köprü Kapan Tolga"); kendi küçük
  geçmişleri olur.
- **Yoldaşlar**: kahramana katılan birkaç adlı karakter; kendi hikâyeleri, görevleri ve fikirleri vardır.
- **Masraf**: maaş ve erzak. Ordu büyüdükçe yük artar; ordu sınırını kahramanın ünü ve komutanlığı
  belirler.

## Kahraman

Seriden korunanlar: nitelikler, beceriler, auralar, rünler, silahlar, zırhlar, demirci.

Yeni olanlar:

- **Beceri ağaçları**: dövüşçü, komutan ve yönetici yönleri. Her şeyi birden açmak mümkün değildir;
  seçim gerçek bir seçimdir.
- **Dövüş stilleri**: kılıç-kalkan, iki elli balta, mızrak, yay, at üstünde dövüş. Her silah türünün
  kendi hareket seti vardır, yalnızca hasar sayısı değişmez.
- **Adı olan silahlar**: çok savaş gören silah zamanla bir ad ve küçük bir özellik kazanır.
- **Ün ve kişilik**: kararlar kahramanın ününü şekillendirir (merhametli, korkulan, güvenilir, hilekâr);
  şehirler ve beyler buna göre davranır.
- **Hanedan** (sonraki sürümler): kahraman yaşlanır ya da düşerse varisi devralır; dünya, ün ve
  ilişkiler ondan kalır.

## Ekonomi

- Ganimet, görev ödülleri, vergiler.
- Şehirler arası ticaret: her şehrin ucuz ve pahalı malları vardır; kervan götürmek bir kazanç yoludur
  (ve yolda baskına uğrayabilir).
- Demircide silah ve zırh yapımı ve geliştirme; değerli malzemeler belirli bölgelerden gelir.

## Oyun biçimleri

- **Hikâye seferi**: elle yazılmış bir hikâye, birden çok sonla.
- **Serbest oyun**: başlangıç bölgesi ve kahraman seçilir, dünya rastgele tohumla biraz farklı kurulur.
- **Zorluk** seviyeleri ve isteğe bağlı **tek can** (kahraman düşerse oyun biter) seçeneği.

## Görsel tarz

- **Karar:** Flash döneminin el çizimi vektör tarzı: kontursuz, belirgin şekiller, sıcak toprak renkleri,
  canlı gök; karakterlerde ince ve koyu renkli bir dış hat. Ayrıntılar: [SANAT.md](SANAT.md).
  Seriden esinlenilir, bütün çizimler özgündür.
- Görseller vektör olarak saklanır ve çizilir: her çözünürlükte (4K dahil) keskindir.
- Karakterler parçalı kukla olarak canlandırılır (gövde, kollar, baş, silah ayrı parçalar; kemiklerle
  oynatılır). Böylece aynı iskelet farklı zırh ve silahlarla giydirilebilir: donanım görünüşe yansır.
- Manzaralar paralaks katmanlıdır (uzak dağlar, orta ağaçlar, ön çimen) ve günün saatine göre renk alır.

## Ses ve müzik

Bölgelere göre farklı müzik (bozkırda kopuz ve davul, kıyıda ud, kuzeyde boru ve davul gibi).
Kaynaklar lisansı uygun olanlardan seçilir ya da özgün yapılır; her dış varlık lisansıyla
`docs/LISANSLAR.md` içine yazılır.

## Kontroller

Klavye ve fare. Savaşta seri gibi WASD ya da yön tuşları ile hareket, Boşluk ile saldırı; iksirler ve
özel hareketler sayı tuşlarında; bölük komutları ayrı tuşlarda. Tuşlar ayarlardan değiştirilebilir.
Oyun kolu desteği sonraki sürümlerde.

## Kalite hedefleri

- 1080p ekranda, dahili grafik kartında, savaş alanında 300 asker varken 60 kare/saniye.
- Oyun 3 saniyeden kısa sürede açılır; kayıt yükleme 1 saniyenin altında.
- Çökme yok; beklenmedik bir hata olursa oyun kaydı bozulmaz.
- Savaş benzetimi belirlenimcidir: aynı başlangıç aynı sonucu verir. Böylece savaşlar kaydedilip
  yeniden oynatılabilir ve denge binlerce otomatik savaşla sınanabilir.

## Açık sorular

- **Ad**: oyunun adı ilerledikçe konacak.
- **Dünya**: kurmaca ve tanıdık bir dünya mı (öneri), seri gibi gerçek kültürler mi, yoksa tamamen
  hayal ürünü bir dünya mı?
- **Başlangıç**: oyuncu küçük bir sınır beyi olarak mı başlar (öneri), yoksa seri gibi kahraman seçerek mi?
- **Büyü**: seri rün ve aura gibi hafif büyülü öğeler içeriyordu. Bu oyunda büyü ne kadar olsun:
  yok, hafif (öneri), ya da belirgin?
- **Lisans**: oyunun kodu açık kaynak mı olacak, yoksa ileride satılacak kapalı bir oyun mu?
