# Motor

Oyunun çalıştığı altyapının kararları ve yapısı.

## Karar: kendi motorumuz, sağlam kütüphanelerin üstünde

**Karar:** Oyun, **Rust** ile yazılmış kendi motorumuzda çalışır. Motor sıfırdan değil, yıllardır
kullanılan ve sınanmış açık kaynak kütüphanelerin üstüne kurulur: grafik kartıyla konuşmayı, pencereyi,
ses kartını bu kütüphaneler yapar; oyun döngüsü, çizim düzeni, vektör görseller, kukla animasyonu,
arayüz, savaş benzetimi ve kayıt bizimdir.

Seçenekler ve neden bu:

| Seçenek                          | Artısı                                                    | Eksisi                                                                                   |
| -------------------------------- | --------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| Tamamen sıfırdan motor           | Her şey bizim                                             | Yıllar sürer; grafik sürücüsü, ses aygıtı gibi oyuna bir şey katmayan işlere zaman gider |
| Hazır motor (Godot, Unity)       | İlk oynanabilir sürüme hızlı varılır                      | Görsel editör odaklı; motorun sınırları ve güncellemeleri bize dayatılır                 |
| **Kütüphaneler üstüne kendi motorumuz** | Her şey kodda ve denetimimizde; tam istediğimiz görsel tarz; çok hızlı benzetim; tek küçük `.exe` | İlk oynanabilir sürüm hazır motordan biraz geç gelir                                     |

Bu oyun için kendi motorumuzu öne çıkaran nedenler:

- **Görsel tarz**: Flash tarzı vektör çizim ve parçalı kukla animasyonu hazır motorlarda ikinci sınıftır;
  bizde merkezdedir. Her çözünürlükte keskin, kontur ve renkler tam istediğimiz gibi.
- **Kalabalık savaşlar**: yüzlerce asker, moral, arazi ve yapay zekâ; Rust bunu rahatça kaldırır.
- **Belirlenimci benzetim**: savaş kuralları görüntüden tamamen ayrıdır. Aynı başlangıç aynı sonucu
  verir; savaşlar ekransız, saniyede yüzlerce kez oynatılıp denge otomatik sınanır.
- **Her şey metin ve kod**: birlikler, şehirler, görevler, çizimler ve animasyonlar okunabilir metin
  dosyalarıdır. Değişiklikler git'te izlenir, testlerle denetlenir.
- **Uzun ömür**: oyun bir motor şirketinin kararlarına ya da sürüm değişikliklerine bağlı kalmaz.

## Kullanılan kütüphaneler

| İş                          | Kütüphane                  | Lisans                     |
| --------------------------- | -------------------------- | -------------------------- |
| Pencere ve girdi            | `winit` 0.30               | Apache-2.0                 |
| Grafik (DirectX 12/Vulkan)  | `wgpu` 30                  | MIT / Apache-2.0           |
| Vektör şekilleri üçgenlemek | `lyon_tessellation`        | MIT / Apache-2.0           |
| SVG okumak                  | `usvg`                     | MIT / Apache-2.0           |
| Harf dizme (aralık, bitişik harf) | `harfrust`           | MIT                        |
| Harf şekilleri ve ölçüleri  | `skrifa`                   | MIT / Apache-2.0           |
| Matematik                   | `glam`                     | MIT / Apache-2.0           |
| Veri dosyaları              | `serde`, `ron`             | MIT / Apache-2.0           |
| PNG okuma/yazma             | `png`                      | MIT / Apache-2.0           |
| Testlerde başvuru çizici    | `resvg` (yalnızca testler) | MIT / Apache-2.0           |
| Ses                         | `kira` (sonra eklenecek)   | MIT / Apache-2.0           |

Yeni bir kütüphane eklenmeden önce lisansı denetlenir (`cargo deny`). AGPL ve ticari kullanımı
yasaklayan lisanslar kabul edilmez.

## Yapı

```
crates/
  engine/   Oyundan bağımsız motor: pencere, çizim, vektör şekiller, yazı, girdi, zaman, arayüz
  sim/      Oyunun kuralları: savaş benzetimi, ordu, kahraman, dünya. Grafik bilmez; belirlenimci.
  game/     Oyunun kendisi (çalışan program): sim ile engine'i birleştirir, ekranları yönetir
content/    Oyunun verileri: birlikler, silahlar, şehirler, metinler, vektör çizimler, animasyonlar
docs/       Belgeler
```

Kurallar:

- `sim` hiçbir grafik, pencere ya da ses kütüphanesine bağlı değildir. Sabit adımla (saniyede 60)
  ilerler, kendi rastgele sayı üretecini kullanır, kayan nokta sonuçları platformdan bağımsız kalacak
  şekilde yazılır. Aynı tohum ve aynı girdiler her zaman aynı savaşı verir.
- `engine` oyun kuralı bilmez; başka bir oyunda da kullanılabilecek kadar genel kalır.
- Oyun içeriği kodda değil `content/` altındaki veri dosyalarındadır. Ekranda görünen bütün metinler
  Türkçe metin dosyalarındadır; ileride başka dil eklemek yeni bir dosya eklemek demektir.

## Çizim

- Bütün görseller vektördür. SVG dosyaları okunur (`engine::svg`), `lyon` ile bir kez üçgenlere
  çevrilir (`engine::tessellate`) ve grafik kartına yüklenir (`Renderer::upload`). Sonraki karelerde
  yalnızca konum, dönüş, ölçek ve renk dönüşümü değişir; yüzlerce asker her karede yeniden
  hesaplanmaz.
- Boyalar: düz renk, doğrusal degrade, radyal (odaklı) degrade; yayılma: uç rengi sürdürme, aynalama,
  tekrar. Degradeler gölgelendiricide hesaplanır; renkleri 256 öğelik bir şeritten (rampa) okunur.
- **Renkler sRGB uzayında karışır** (Flash'taki gibi): çizim hedefi "sRGB" olmayan bir dokudur,
  saydamlık önceden çarpılmıştır.
- Kenar yumuşatma 4 örneklemeli MSAA ile yapılır.
- Her çizime Flash'taki gibi bir **renk dönüşümü** verilebilir: `renk × çarpan + ek`. Saydamlık,
  renklendirme ve gün saati ışığı bununla yapılır.
- Ekran 1920×1080 mantıksal alan üzerinden düzenlenir ve pencereye en-boy oranı korunarak sığdırılır
  (`engine::viewport`); artan yerler koyu şerit olur, şeritlere taşan çizim kırpılır. Vektör olduğu için
  her boyutta (4K dahil) keskindir.
- Yazılar yazı tipinin vektör çizgilerinden çizilir (`engine::text`): `harfrust` ile Türkçe dil
  kurallarıyla dizilir, `skrifa` ile harf şekilleri okunur; satır kaydırma ve hizalama motordadır.
  Değişken kalınlıklı yazı tipleri desteklenir. Türkçe büyük-küçük harf dönüşümü ayrı işlevdedir
  (`to_upper_tr`).
- Karakterler parçalardan oluşur (baş, gövde, kollar, bacaklar, silah, kalkan); her parça SVG'de ayrı
  bir gruptur. Parçalar Aşama 1'de kemiklere bağlanıp anahtar karelerle oynatılacak; donanım
  değişince ilgili parça değişir.

## Flash sembolleri ve zaman çizelgesi (Feudalism içeriği)

Feudalism'in görselleri SWF'deki yapılarıyla aktarılır (`content/feudalism/<oyun>/library.json`,
`araclar/aktar/aktar.py`). Motor bunları Flash 8 oynatıcısı gibi oynatır:

- `engine::movie`: kütüphane (şekiller, morph'lar, sprite'lar, düğmeler, yazılar, kök film) ve oynatıcı
  (`Clip`). Her kare bir işlem listesidir (yerleştir, taşı, kaldır); oynatıcı bunları uygulayıp görüntü
  listesini kurar. Sprite'lar kendi zaman çizelgelerini bağımsız oynatır; kare betiklerinden çıkarılan
  basit komutlar (dur, oynat, kareye ya da etikete git, olay) ve ses başlatma/durdurma çalışır ya da
  olay olarak bildirilir. Kurallar modülün başında yazılıdır (geri gitmek görüntü listesini baştan kurar,
  karesi olmayan sprite 1 boş karedir, tanımı olmayan karakter, ör. dışarıda bırakılan sponsor logosu,
  yerleştirilmez).
- `Clip::draw_commands`: iç içe sprite'ları düzleştirir; matrisler ve renk dönüşümleri birleşir,
  maskeler (kırpma derinliği) başlangıç ve bitiş komutu olur, morph'lar oranlarıyla gelir.
- `engine::movie_draw::MovieMeshes`: komutları çizim listesine çevirir. Sembollerin SVG'leri bir kez
  üçgenlenip önbellekte tutulur. Morph'un ara hâli iki ucun doğrusal karışımıdır (`engine::morph`:
  noktalar, renkler, degrade durakları ve matrisleri), oran başına bir kez kurulur. Flash'ın ince çizgi
  kuralı: 1 pikselden ince çizgi ekranda 1 piksel çizilir (ölçeğe göre ayrı ağ).
- Maskeler kalıp (stencil) arabelleğiyle çizilir: `DrawList::push_mask` / `pop_mask`. Maske şekli
  görünmez, maske açıkken çizilenler yalnız onun içinde görünür; maskeler iç içe olabilir.
- Resim dolguları (zemin dokuları) resim boyasıyla çizilir (`engine::paint::ImagePaint`): resimler
  grafik kartında tek bir atlas dokusundadır; gölgelendirici şekil koordinatından resim pikselini bulur.
  Flash'taki dört tür: tekrarlı ya da kırpılmış (resmin dışında kenar pikseli uzar), yumuşatmalı ya da
  en yakın piksel. Tür, aktarım aracının desen kimliğine yazdığı ekten okunur (`-kirp`, `-yumusak`).
- Yazılar (`engine::movie_text`): sabit yazılar ve yazı alanları açık lisanslı karşılık yazı
  tipleriyle dizilir (`texts.json` → `fonts`). `TextBank::load(.., true)` Türkçe çeviriyi uygular;
  kurallar Türkçe SWF'yi üreten aracınkiyle aynıdır: sabit yazının her kaydı çevirideki parçayla
  değişir (istenirse eski satırın ortasına hizalanır ya da küçültülür); özgün yazısı elle satırlara
  bölünmüş çok satırlı kutu yazıyı kendisi kaydırır ve genişliği özgün yazının en uzun satırına iner.
  Yazı alanında Flash'ın kuralları: kenarlarda 2 piksel boşluk, hizalama, kenar boşlukları, girinti,
  satır aralığı, kelime kaydırma; HTML yazılarında `p`, `font` (ad, boy, renk), `b`, `i`, `br`/`sbr`.
  Yazı tiplerinin kalınlık ve italiklik bayrakları uygulanır (özgün Flash oynatıcısı gibi). Yazı bankası
  verilmezse yazılar çizilmez, sayılır.
- Süzgeçler (`engine::render::Filter`): süzgeçli nesne ekran boyunda ayrı bir dokuya çizilir, süzgeçten
  geçer ve dıştaki çizime konur (dıştaki maskeler sonuca uygulanır; içindeki maskeler kendi dokusunda
  çalışır). `DrawList::push_filters` / `pop_filters`. Flash'taki gibi: bulanıklık kutu süzgecidir
  (yatay, dikey, "geçiş" sayısı kadar); parlama, bulanıklaştırılmış saydamlığın gücüyle çarpılıp
  parlama rengiyle çizimin arkasına konmasıdır (iç parlama ve delme de var). Süzgeç genişlikleri sahne
  pikselidir: sahneyi büyüten dönüşümle büyür, nesnenin kendi ölçeğiyle büyümez. Feudalism'de
  kullanılanlar yalnız parlama ve bulanıklık; F2 menüsündeki kılıç parlaması Ruffle'ın (wgpu)
  çizimiyle karşılaştırıldı.
- Karışım kipleri: iki oyunda da yalnız "normal" kullanılıyor (SWF dökümünde başka kip yok); oynatıcı
  başka bir kip görürse hata verir.
- Deneme aracı: `cargo run --release -p engine --example movie-png -- content feudalism/f1 4 menu.png`
  kök filmin bir karesini resme çizer (`sprite:<kimlik>:<kare>` ile bir sprite'ı; yazılar Türkçe,
  `orijinal` verilirse özgün hâliyle).

## Pencere ve döngü

- `engine::app` pencereyi açar, girdiyi toplar (`engine::input`) ve oyunun kurallarını saniyede 60 sabit
  adımla ilerletir (`engine::time`); çizim ekranın yenilenme hızında yapılır ve iki adım arası
  ara değerlenir. F11 tam ekran ile pencere arasında geçiş yapar.
- Oyun `engine::app::Game` özelliğini uygular: `update` (bir sabit adım) ve `draw` (bir kare).

## İçerik

- İçerik (`content/`) derleme sırasında `.exe` dosyasının içine gömülür; oyun tek dosyadan çalışır.
- `.exe` dosyasının yanında bir `content` klasörü varsa önce oradan okunur (içerik denemek için).
  `--icerik <klasör>` seçeneği de aynı işi yapar.
- Metinler `content/text/tr.ron`, sahne dizilimleri `content/scenes/*.ron`, çizimler
  `content/art/**/*.svg`, yazı tipleri `content/fonts/` altındadır.

## Sınama

- **Birim testleri**: her modülün yanında (`cargo test`).
- **Benzetim testleri**: belirli savaşlar ekransız oynatılır ve sonuçları denetlenir (kim kazandı,
  kaç kare sürdü, aynı tohum aynı sonucu verdi mi).
- **Görüntü testleri**: sahneler ekransız çizilip resim dosyasına kaydedilir; beklenen resimle
  (`tests/reference/*.png`) karşılaştırılır. Böylece bir değişiklik görüntüyü bozarsa testler yakalar.
  Grafik kartı gerekmez: Linux'ta yazılımla çalışan Vulkan sürücüsü (lavapipe), Windows'ta WARP
  kullanılır. Farklı kartlar kenar yumuşatmada birkaç piksel farklı çizebildiği için küçük bir pay
  bırakılır. Ayrıca SVG çizimi, bağımsız bir SVG çiziciyle (`resvg`) karşılaştırılarak sınanır;
  degradeler işlemcideki hesapla piksel piksel karşılaştırılır.
- **Denge araçları**: iki ordu binlerce kez çarpıştırılır, kazanma oranları raporlanır.

## Dağıtım

- Hedef: Windows 10 ve 11, 64 bit. Grafik: DirectX 12 (yoksa Vulkan).
- Her güncellemede GitHub Actions oyunu Windows'ta derler ve "Test sürümü" Release'ine koyar;
  indirme linki sabittir (README'de).
- Oyun tek bir `.exe` ve yanında `content/` klasörü olarak dağıtılır; kurulum gerektirmez.
  Kayıtlar ve ayarlar kullanıcının `AppData` klasöründe tutulur.
- Oyun internete bağlanmaz; telemetri yoktur.
