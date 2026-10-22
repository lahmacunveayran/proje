# Ayıklama denetimi

`python3 araclar/aktar/denetim.py --gorsel` üretir. Oyuna aktarılanı FFDec'in kendi
ayrıştırıcısıyla ürettiği XML dökümüyle kayıt kayıt karşılaştırır; şekilleri motorun çizimiyle
FFDec'in çizimi arasında piksel piksel karşılaştırır.

## Feudalism (f1)

| Denetim | Denetlenen | Sorun |
|---|---|---|
| Etiket türlerinin sayıları | 37291 | 0 |
| Karakterler (tür ve yer) | 2093 | 0 |
| Zaman çizelgeleri: her yerleştirme ve kaldırma, etiketler, sesler (durdurma, tekrar, zarf dahil) | 27152 | 0 |
| Düğmeler (her kayıt) | 411 | 0 |
| Dışa aktarılan adlar (bileşen, sınıf ve dışarıda bırakılanlar hariç) | 60 | 0 |
| Sabit yazılar (sınır, matris; her kaydın yazı tipi, boyu, rengi, saydamlığı, yeri, glifleri; çözülmüş yazı) | 226 | 0 |
| Yazı alanları (bütün alanlar: sınır, bayraklar, yazı tipi, boy, renk, uzunluk, hizalama, değişken, yazı) | 250 | 0 |
| Sesler (baytlar, örnek sayısı ve MP3 gecikmesi SWF'dekiyle aynı) | 16 | 0 |
| Resimler (SWF'deki veriden çözülen resimle piksel piksel aynı) | 18 | 0 |
| Kod parçaları: yer yer (kare, sınıf, düğme, klip eylemi); üçüncü tarafınkiler yalnız listede | 622 | 0 |
| Resim dolgulu şekiller (desen matrisi ve resmi SWF'dekiyle aynı) | 19 | 0 |
| İnce çizgi işaretleri (işaretli çizgiler; FFDec'in SVG'sindekilerle aynı) | 35 | 0 |
| Türkçe çeviri tabloları (kaynağıyla bayt bayt aynı) | 6 | 0 |
| Çeviri hedefleri (her yazı, kutu, yazı tipi ve çizim SWF'de; parça sayısı kayıt sayısıyla aynı) | 266 | 0 |
| Koddaki çeviriler (çevrilen koddaki her yeni dize sahibinin Türkçe SWF'sinin bayt kodunda) | 476 | 0 |
| Yazı tiplerinin açık lisanslı karşılıkları (dosya kaynağıyla aynı, lisansı yanında) | 15 | 0 |
| Morph sınırları (iki ucun SWF'deki sınırlarının birleşimi) | 11 | 0 |
| Şekillerin renkleri, saydamlıkları, çizgi kalınlıkları, degrade matrisleri ve durakları (FFDec XML'iyle sayısal) | 8011 | 0 |
| Morph uçlarının renkleri, saydamlıkları, çizgi kalınlıkları ve degrade matrisleri (FFDec XML'iyle sayısal) | 44 | 0 |
| Tanımsız karakter başvurusu (dışarıda bırakılana 2 başvuru: oynatıcı atlar) | 27152 | 0 |
| Sponsor ve üçüncü taraf izi (çizimlerin içerik özetiyle iki oyunda; yazılarda; kaynak/ kodunda) | 1854 | 0 |
| Şekiller (resim dolgulular dahil): motorun çizimi FFDec'inkiyle piksel piksel (en kötü: %8.88 farklı, katı 1) | 1176 | 0 |
| Morph başlangıç ve bitişleri piksel piksel (en kötü: %0.02 farklı, katı 0) | 22 | 0 |
| Çizilmiş yazıların Türkçe hâlleri, Türkçe SWF'nin çizimiyle (en kötü: %0.00 farklı, katı 0) | 1 | 0 |

## Feudalism 2 (f2)

| Denetim | Denetlenen | Sorun |
|---|---|---|
| Etiket türlerinin sayıları | 65626 | 0 |
| Karakterler (tür ve yer) | 3183 | 0 |
| Zaman çizelgeleri: her yerleştirme ve kaldırma, etiketler, sesler (durdurma, tekrar, zarf dahil) | 49080 | 0 |
| Düğmeler (her kayıt) | 385 | 0 |
| Dışa aktarılan adlar (bileşen, sınıf ve dışarıda bırakılanlar hariç) | 87 | 0 |
| Sabit yazılar (sınır, matris; her kaydın yazı tipi, boyu, rengi, saydamlığı, yeri, glifleri; çözülmüş yazı) | 131 | 0 |
| Yazı alanları (bütün alanlar: sınır, bayraklar, yazı tipi, boy, renk, uzunluk, hizalama, değişken, yazı) | 184 | 0 |
| Sesler (baytlar, örnek sayısı ve MP3 gecikmesi SWF'dekiyle aynı) | 16 | 0 |
| Resimler (SWF'deki veriden çözülen resimle piksel piksel aynı) | 24 | 0 |
| Kod parçaları: yer yer (kare, sınıf, düğme, klip eylemi); üçüncü tarafınkiler yalnız listede | 1126 | 0 |
| Resim dolgulu şekiller (desen matrisi ve resmi SWF'dekiyle aynı) | 31 | 0 |
| İnce çizgi işaretleri (işaretli çizgiler; FFDec'in SVG'sindekilerle aynı) | 48 | 0 |
| Türkçe çeviri tabloları (kaynağıyla bayt bayt aynı) | 6 | 0 |
| Çeviri hedefleri (her yazı, kutu, yazı tipi ve çizim SWF'de; parça sayısı kayıt sayısıyla aynı) | 220 | 0 |
| Koddaki çeviriler (çevrilen koddaki her yeni dize sahibinin Türkçe SWF'sinin bayt kodunda) | 1031 | 0 |
| Yazı tiplerinin açık lisanslı karşılıkları (dosya kaynağıyla aynı, lisansı yanında) | 16 | 0 |
| Morph sınırları (iki ucun SWF'deki sınırlarının birleşimi) | 24 | 0 |
| Şekillerin renkleri, saydamlıkları, çizgi kalınlıkları, degrade matrisleri ve durakları (FFDec XML'iyle sayısal) | 13545 | 0 |
| Morph uçlarının renkleri, saydamlıkları, çizgi kalınlıkları ve degrade matrisleri (FFDec XML'iyle sayısal) | 144 | 0 |
| Tanımsız karakter başvurusu (dışarıda bırakılana 17 başvuru: oynatıcı atlar) | 49080 | 0 |
| Sponsor ve üçüncü taraf izi (çizimlerin içerik özetiyle iki oyunda; yazılarda; kaynak/ kodunda) | 3209 | 0 |
| Şekiller (resim dolgulular dahil): motorun çizimi FFDec'inkiyle piksel piksel (en kötü: %8.88 farklı, katı 2) | 2128 | 0 |
| Morph başlangıç ve bitişleri piksel piksel (en kötü: %0.53 farklı, katı 0) | 48 | 0 |
| Çizilmiş yazıların Türkçe hâlleri, Türkçe SWF'nin çizimiyle (en kötü: %0.00 farklı, katı 0) | 1 | 0 |

Toplam sorun: 0.

## Yöntem ve sınırlar

- Kaynak: SWF'yi bizim ayrıştırıcımızdan bağımsız okuyan FFDec 24.1.1'in XML dökümü (`-swf2xml`)
  ve FFDec'in kendi PNG çizimleri (şekiller ve morph uçları 4× büyütülmüş).
- Piksel karşılaştırması (şekil başına, yerel): iki çizim beyaz tuvale gerilmeden konur. Bir piksel,
  öbür çizimin 3×3 komşuluğundaki en yakın pikselden bile 32/255'ten fazla farklıysa belirgin
  farklıdır (kenar yumuşatmasındaki 1 piksellik kayma affedilir). Sorun: iç piksellerin (3×3
  komşuluğu iki çizimde de dolu) %12'sinden fazlası belirgin farklı, ya da 16 pikselden büyük katı
  farklı bölge (3×3 komşuluğunun tamamı farklı) var. Ayar: doğru çizimlerde en çok %8,9 ve 2 piksel;
  Denetim 2'nin B2 hatası (ters degrade) %13,9 ve 433 752 piksel verir.
- İnce çizgiler: Flash 1 pikselden ince çizgiyi ekranda 1 piksel çizer. Bu çizgiler
  `data-hairline` ile işaretli aktarılır ve library.json'da listelenir; denetim onları bu kuralla
  çizer. Motor kuralı oynatıcıda uygulayacak (Faz B).
- Morph uçları: FFDec'in morph PNG'leri sınıra belgelenmemiş bir pay ekler; çizimler mürekkep
  merkezi ve en iyi örtüşmeyle hizalanır (yalnız bütünün yeri; parçaların yerel kayması ölçütte
  görünür). Sınırın kendisi XML'deki iki ucun sınırıyla sayısal olarak ayrıca denetlenir. Uçların
  renkleri, saydamlıkları, çizgi kalınlıkları ve degrade matrisleri FFDec'in XML'iyle sayısal
  olarak karşılaştırılır.
- FFDec'in bilinen çizim hataları (sorun sayılmaz; motorun çizimi SWF'nin verisine uyar):
  - f2 şekil 1791: FFDec tekrarlı resim dolgusunu (0x42, resim 1789) dokunun satır sınırında, parke bölgesinin SWF'deki alt kenarından (y = 9795 twip = 489,75 px) 1,35 piksel önce kesiyor; Flash'ın kuralında doku kenara kadar sürer, motor da öyle çiziyor (Denetim 3, D3-4)
- Resim dolgulu şekiller (zemin dokuları): kenarların kullandığı her resim dolgusunun SVG'deki desen
  matrisi SWF'deki dolgu matrisiyle, desenin resmi aktarılan resim dosyasıyla piksel piksel aynıdır;
  motorun çizimi (resim boyası) FFDec'in çizimiyle öbür şekiller gibi karşılaştırılır.
- Sesler: dosyalar SWF'deki MP3 verisiyle bayt bayt, örnek sayısı ve MP3 başlangıç gecikmesi
  XML'deki değerlerle aynıdır. Zaman çizelgelerindeki ses kayıtları durdurma, tekrar, giriş/çıkış
  noktası ve zarf bilgisiyle karşılaştırılır.
- Türkçe çeviri: tablolar kaynağıyla (swf-oyunlar) bayt bayt aynıdır; her girdinin hedefi FFDec'in
  dökümünde aranır, sabit yazıların parça sayısı XML'deki kayıt sayısıyla karşılaştırılır. Kod
  çevirisinde orijinalde olmayan her dize, sahibinin Türkçe SWF'sinin bayt kodundaki dizeler
  arasında aranır (kendi okuyucumuzla). "Öldün..." çizimi Türkçe SWF'nin FFDec çizimiyle
  piksel piksel karşılaştırılır.
- Aktarılmayanlar (yerel arşivde): sponsor logoları, Macromedia/Adobe arayüz bileşenleri, gömülü
  yazı tipleri (yerine açık lisanslı karşılıkları). Listesi ve nedenleri
  `kaynak/feudalism/<oyun>/manifest.json` içindedir.
