# Ölçüm sonuçları

`python3 araclar/olcum/olcum.py rapor` ile üretilir; elle değiştirmeyin. Referans çizimler
depoda yoktur; burada yalnızca sayılar ve renk kodları vardır. Her ölçüt için kümedeki en küçük,
çeyrekler, ortanca ve en büyük değer verilir. Bizim çizimlerimiz için geçme aralığı 1. ile 3. çeyrek
arasıdır (referansların orta yarısı): uç örneklere değil tipik figüre benzemek gerekir.

## Kahraman (tam boy)

Figürler: f1/1104, f1/1106, f1/1108, f1/1110, f1/1112, f1/1114, f1/1116, f1/1118, f2/2005, f2/2007, f2/2011

| Ölçüt | En küçük | 1. çeyrek | Ortanca | 3. çeyrek | En büyük |
|---|---|---|---|---|---|
| Dolgu grubu sayısı | 21 | 29,5 | 32 | 37 | 50 |
| Kontur (çizgi) sayısı | 0 | 0 | 1 | 1 | 4 |
| En kalın kontur (çizim birimi) | 0 | 0 | 1 | 1 | 1 |
| Ayrı dolgu rengi / degradesi | 13 | 19 | 20 | 26,5 | 32 |
| Kenarlarda eğri payı | 0,591 | 0,615 | 0,683 | 0,708 | 0,749 |
| Degradeli dolgu oranı | 0,238 | 0,299 | 0,405 | 0,498 | 0,562 |
| Dairesel degrade sayısı | 0 | 0 | 0 | 0 | 2 |
| Degradelerde 2 duraklı oranı | 0,875 | 1 | 1 | 1 | 1 |
| Degrade uçları parlaklık farkı ΔV (ortanca) | 0,008 | 0,075 | 0,149 | 0,18 | 0,29 |
| Degrade uçları doygunluk farkı ΔS (ortanca) | 0 | 0 | 0,003 | 0,137 | 0,391 |
| Ortalama doygunluk (opak piksel) | 0,017 | 0,157 | 0,405 | 0,552 | 0,658 |
| Ortalama parlaklık (opak piksel) | 0,227 | 0,508 | 0,667 | 0,712 | 0,861 |
| Çok doygun piksel oranı (S>0,85, V>0,6) | 0 | 0,007 | 0,045 | 0,16 | 0,318 |
| Geniş alanların doygunluğu (alanı ≥%5 renkler, alan ağırlıklı) | 0 | 0,155 | 0,394 | 0,554 | 0,709 |
| En doygun geniş alan (alanı ≥%5) | 0 | 0,469 | 0,669 | 0,993 | 1 |
| Doygun renklerin (S>0,7, V>0,4) toplam alanı | 0 | 0,033 | 0,046 | 0,309 | 0,463 |
| Doygun renk ailesi sayısı (30°'lik ton dilimi, alanı ≥%2) | 0 | 1 | 1 | 2,5 | 3 |
| Saf ana renk alanı (S≥0,95, V≥0,95) | 0 | 0 | 0 | 0,004 | 0,094 |

Doğrusal degrade yönleri (açıktan koyuya, toplam 147): sola koyulaşır: 53 (%36), sağa koyulaşır: 51 (%35), aşağı koyulaşır: 32 (%22), yukarı koyulaşır: 11 (%7).

Bütün degradelerde ΔV: ortanca 0,126, çeyrekler arası 0,071–0,184.

İşaretlerden oranlar (`olcum/isaretler.json`):

| Oran | En küçük | 1. çeyrek | Ortanca | 3. çeyrek | En büyük |
|---|---|---|---|---|---|
| Asimetri (önden simetrik duruştan uzuv açısı farkı, derece) | 3,787 | 9,886 | 14,425 | 17,733 | 37,034 |
| Bacak / boy (kasıktan tabana) | 0,365 | 0,403 | 0,422 | 0,43 | 0,446 |
| Boy (baş sayısı) | 6 | 7,227 | 7,654 | 8,255 | 8,714 |
| Bel yüksekliği / boy (tepeden) | 0,37 | 0,389 | 0,407 | 0,418 | 0,45 |
| Diz yüksekliği / boy (tepeden) | 0,694 | 0,708 | 0,729 | 0,759 | 0,769 |
| El (uzun kenar) / boy | 0,07 | 0,075 | 0,083 | 0,09 | 0,111 |
| El / yüz (tepe–çene) | 0,5 | 0,583 | 0,609 | 0,692 | 0,833 |
| Omuz genişliği / baş yüksekliği | 1,5 | 1,658 | 1,812 | 1,96 | 2,154 |
| Omuz genişliği / boy | 0,181 | 0,214 | 0,231 | 0,277 | 0,302 |
| Silah açısı (yataydan, derece) | 14,199 | 39,446 | 56,524 | 70,386 | 89,181 |

Silah sapının ekseni el kutusundan geçiyor: 11 / 11 silahlı figür.

Figür başına:

| Figür | Dolgu | Kontur | Degrade | ΔV | Ort. S | Çok doygun | Geniş alan S |
|---|---|---|---|---|---|---|---|
| f1/1104 | 46 | 0 | 0,348 | 0,2 | 0,14 | 0,012 | 0,114 |
| f1/1106 | 27 | 1 | 0,518 | 0,118 | 0,087 | 0 | 0,052 |
| f1/1108 | 31 | 1 | 0,355 | 0,157 | 0,53 | 0,143 | 0,516 |
| f1/1110 | 21 | 0 | 0,238 | 0,176 | 0,425 | 0,045 | 0,457 |
| f1/1112 | 32 | 1 | 0,562 | 0,184 | 0,605 | 0,251 | 0,709 |
| f1/1114 | 32 | 2 | 0,438 | 0,149 | 0,175 | 0,052 | 0,197 |
| f1/1116 | 31 | 1 | 0,516 | 0,29 | 0,658 | 0,177 | 0,7 |
| f1/1118 | 28 | 0 | 0,25 | 0,067 | 0,017 | 0 | 0 |
| f2/2005 | 37 | 1 | 0,243 | 0,074 | 0,405 | 0,008 | 0,394 |
| f2/2007 | 50 | 4 | 0,48 | 0,076 | 0,286 | 0,007 | 0,292 |
| f2/2011 | 37 | 0 | 0,405 | 0,008 | 0,575 | 0,318 | 0,592 |

## Kasaba figürü (tam boy)

Figürler: f1/1180, f1/1861, f1/1862, f1/1863, f1/1864, f1/1881, f2/2800

| Ölçüt | En küçük | 1. çeyrek | Ortanca | 3. çeyrek | En büyük |
|---|---|---|---|---|---|
| Dolgu grubu sayısı | 23 | 39 | 41 | 43,5 | 47 |
| Kontur (çizgi) sayısı | 0 | 0 | 0 | 0,5 | 1 |
| En kalın kontur (çizim birimi) | 0 | 0 | 0 | 0,5 | 1 |
| Ayrı dolgu rengi / degradesi | 17 | 18 | 19 | 20,5 | 24 |
| Kenarlarda eğri payı | 0,718 | 0,732 | 0,765 | 0,776 | 0,786 |
| Degradeli dolgu oranı | 0,391 | 0,582 | 0,6 | 0,681 | 0,787 |
| Dairesel degrade sayısı | 0 | 0 | 4 | 4,5 | 5 |
| Degradelerde 2 duraklı oranı | 0,645 | 0,876 | 0,917 | 0,955 | 1 |
| Degrade uçları parlaklık farkı ΔV (ortanca) | 0 | 0,062 | 0,133 | 0,169 | 0,2 |
| Degrade uçları doygunluk farkı ΔS (ortanca) | 0 | 0 | 0,085 | 0,186 | 0,4 |
| Ortalama doygunluk (opak piksel) | 0,114 | 0,171 | 0,333 | 0,412 | 0,573 |
| Ortalama parlaklık (opak piksel) | 0,285 | 0,541 | 0,79 | 0,821 | 0,882 |
| Çok doygun piksel oranı (S>0,85, V>0,6) | 0 | 0,007 | 0,015 | 0,125 | 0,179 |
| Geniş alanların doygunluğu (alanı ≥%5 renkler, alan ağırlıklı) | 0 | 0,126 | 0,281 | 0,403 | 0,583 |
| En doygun geniş alan (alanı ≥%5) | 0 | 0,523 | 0,7 | 0,89 | 1 |
| Doygun renklerin (S>0,7, V>0,4) toplam alanı | 0 | 0,021 | 0,042 | 0,218 | 0,299 |
| Doygun renk ailesi sayısı (30°'lik ton dilimi, alanı ≥%2) | 0 | 0,5 | 1 | 1 | 1 |
| Saf ana renk alanı (S≥0,95, V≥0,95) | 0 | 0 | 0,003 | 0,031 | 0,155 |

Doğrusal degrade yönleri (açıktan koyuya, toplam 157): sağa koyulaşır: 67 (%43), aşağı koyulaşır: 42 (%27), yukarı koyulaşır: 26 (%17), sola koyulaşır: 22 (%14).

Bütün degradelerde ΔV: ortanca 0,133, çeyrekler arası 0,004–0,2.

İşaretlerden oranlar (`olcum/isaretler.json`):

| Oran | En küçük | 1. çeyrek | Ortanca | 3. çeyrek | En büyük |
|---|---|---|---|---|---|
| El / yüz (tepe–çene) | 0,393 | 0,428 | 0,443 | 0,469 | 0,524 |
| Omuz genişliği / baş yüksekliği | 1,417 | 1,597 | 1,714 | 1,762 | 1,959 |
| Silah açısı (yataydan, derece) | 74,055 | 78,677 | 80,586 | 82,135 | 89,698 |

Silah sapının ekseni el kutusundan geçiyor: 6 / 6 silahlı figür.

Figür başına:

| Figür | Dolgu | Kontur | Degrade | ΔV | Ort. S | Çok doygun | Geniş alan S |
|---|---|---|---|---|---|---|---|
| f1/1180 | 23 | 1 | 0,391 | 0,188 | 0,198 | 0 | 0,177 |
| f1/1861 | 40 | 0 | 0,625 | 0,008 | 0,447 | 0,179 | 0,43 |
| f1/1862 | 45 | 0 | 0,6 | 0,149 | 0,144 | 0,015 | 0 |
| f1/1863 | 41 | 1 | 0,585 | 0 | 0,573 | 0,088 | 0,583 |
| f1/1864 | 47 | 0 | 0,787 | 0,133 | 0,114 | 0,008 | 0,075 |
| f1/1881 | 42 | 0 | 0,738 | 0,2 | 0,379 | 0,162 | 0,376 |
| f2/2800 | 38 | 0 | 0,579 | 0,116 | 0,333 | 0,007 | 0,281 |

## Portre (baş-omuz)

Figürler: f1/208, f1/209, f1/210, f1/211, f1/212, f1/213, f1/214, f2/443, f2/444, f2/446

| Ölçüt | En küçük | 1. çeyrek | Ortanca | 3. çeyrek | En büyük |
|---|---|---|---|---|---|
| Dolgu grubu sayısı | 12 | 14,25 | 15,5 | 17,75 | 31 |
| Kontur (çizgi) sayısı | 0 | 0 | 0 | 0,75 | 2 |
| En kalın kontur (çizim birimi) | 0 | 0 | 0 | 0,75 | 1 |
| Ayrı dolgu rengi / degradesi | 11 | 13 | 13,5 | 14,75 | 26 |
| Kenarlarda eğri payı | 0,492 | 0,537 | 0,595 | 0,666 | 0,756 |
| Degradeli dolgu oranı | 0,154 | 0,261 | 0,333 | 0,351 | 0,562 |
| Dairesel degrade sayısı | 0 | 0 | 0 | 0 | 2 |
| Degradelerde 2 duraklı oranı | 0,6 | 1 | 1 | 1 | 1 |
| Degrade uçları parlaklık farkı ΔV (ortanca) | 0,01 | 0,08 | 0,106 | 0,2 | 0,392 |
| Degrade uçları doygunluk farkı ΔS (ortanca) | 0 | 0,001 | 0,011 | 0,178 | 0,391 |
| Ortalama doygunluk (opak piksel) | 0,035 | 0,318 | 0,359 | 0,423 | 0,612 |
| Ortalama parlaklık (opak piksel) | 0,25 | 0,614 | 0,665 | 0,769 | 0,904 |
| Çok doygun piksel oranı (S>0,85, V>0,6) | 0 | 0 | 0,015 | 0,116 | 0,328 |
| Geniş alanların doygunluğu (alanı ≥%5 renkler, alan ağırlıklı) | 0,035 | 0,318 | 0,356 | 0,433 | 0,632 |
| En doygun geniş alan (alanı ≥%5) | 0,4 | 0,424 | 0,591 | 0,979 | 1 |
| Doygun renklerin (S>0,7, V>0,4) toplam alanı | 0 | 0,006 | 0,05 | 0,182 | 0,502 |
| Doygun renk ailesi sayısı (30°'lik ton dilimi, alanı ≥%2) | 0 | 0 | 1 | 1,75 | 2 |
| Saf ana renk alanı (S≥0,95, V≥0,95) | 0 | 0 | 0 | 0 | 0,106 |

Doğrusal degrade yönleri (açıktan koyuya, toplam 54): sağa koyulaşır: 20 (%37), sola koyulaşır: 15 (%28), aşağı koyulaşır: 12 (%22), yukarı koyulaşır: 7 (%13).

Bütün degradelerde ΔV: ortanca 0,114, çeyrekler arası 0,068–0,2.

Figür başına:

| Figür | Dolgu | Kontur | Degrade | ΔV | Ort. S | Çok doygun | Geniş alan S |
|---|---|---|---|---|---|---|---|
| f1/208 | 17 | 0 | 0,294 | 0,2 | 0,612 | 0,328 | 0,632 |
| f1/209 | 16 | 1 | 0,562 | 0,392 | 0,536 | 0 | 0,504 |
| f1/210 | 15 | 0 | 0,333 | 0,2 | 0,215 | 0,046 | 0,157 |
| f1/211 | 14 | 0 | 0,357 | 0,114 | 0,322 | 0,14 | 0,331 |
| f1/212 | 13 | 0 | 0,154 | 0,257 | 0,399 | 0 | 0,439 |
| f1/213 | 12 | 1 | 0,25 | 0,098 | 0,335 | 0 | 0,331 |
| f1/214 | 15 | 0 | 0,333 | 0,067 | 0,035 | 0 | 0,035 |
| f2/443 | 31 | 2 | 0,387 | 0,098 | 0,317 | 0,014 | 0,313 |
| f2/444 | 22 | 0 | 0,182 | 0,074 | 0,384 | 0,016 | 0,382 |
| f2/446 | 18 | 0 | 0,333 | 0,01 | 0,431 | 0,157 | 0,415 |

## Savaş kuklası

Figürler: f1/hat-piyadesi-mizrakci, f1/kervan-muhafizi, f1/koylu-yumruk, f1/lejyoner, f1/mizrakci-ger-kadin, f1/mizrakci-rus, f1/okcu-ger, f1/sehir-muhafizi-balta, f2/hafif-gozcu-mon, f2/hafif-mizrakci-viz, f2/han-muhafizi-mon, f2/kadin-okcu-ger, f2/kervan-muhafizi-viz, f2/kilicli-mon, f2/koylu-yumruk-viz, f2/mizrakci-mon, f2/okcu-mon, f2/okcu-viz

| Ölçüt | En küçük | 1. çeyrek | Ortanca | 3. çeyrek | En büyük |
|---|---|---|---|---|---|
| Dolgu grubu sayısı | 32 | 41,5 | 49 | 54,75 | 66 |
| Kontur (çizgi) sayısı | 1 | 1 | 2 | 3 | 3 |
| En kalın kontur (çizim birimi) | 0,999 | 0,999 | 1 | 1 | 1 |
| Ayrı dolgu rengi / degradesi | 11 | 18,25 | 22,5 | 30,5 | 35 |
| Kenarlarda eğri payı | 0,547 | 0,591 | 0,602 | 0,616 | 0,674 |
| Degradeli dolgu oranı | 0 | 0 | 0 | 0 | 0 |
| Dairesel degrade sayısı | 0 | 0 | 0 | 0 | 0 |
| Ortalama doygunluk (opak piksel) | 0,071 | 0,216 | 0,466 | 0,53 | 0,718 |
| Ortalama parlaklık (opak piksel) | 0,466 | 0,537 | 0,561 | 0,613 | 0,723 |
| Çok doygun piksel oranı (S>0,85, V>0,6) | 0 | 0,024 | 0,032 | 0,04 | 0,391 |
| Geniş alanların doygunluğu (alanı ≥%5 renkler, alan ağırlıklı) | 0,029 | 0,186 | 0,455 | 0,521 | 0,671 |
| En doygun geniş alan (alanı ≥%5) | 0,424 | 0,457 | 0,835 | 1 | 1 |
| Doygun renklerin (S>0,7, V>0,4) toplam alanı | 0,005 | 0,046 | 0,109 | 0,276 | 0,619 |
| Doygun renk ailesi sayısı (30°'lik ton dilimi, alanı ≥%2) | 0 | 1 | 1 | 2 | 3 |
| Saf ana renk alanı (S≥0,95, V≥0,95) | 0 | 0 | 0,002 | 0,009 | 0,114 |

Figür başına:

| Figür | Dolgu | Kontur | Degrade | ΔV | Ort. S | Çok doygun | Geniş alan S |
|---|---|---|---|---|---|---|---|
| f1/hat-piyadesi-mizrakci | 54 | 3 | 0 | – | 0,516 | 0,018 | 0,482 |
| f1/kervan-muhafizi | 41 | 3 | 0 | – | 0,535 | 0,033 | 0,56 |
| f1/koylu-yumruk | 32 | 1 | 0 | – | 0,071 | 0,032 | 0,038 |
| f1/lejyoner | 56 | 3 | 0 | – | 0,562 | 0,06 | 0,603 |
| f1/mizrakci-ger-kadin | 43 | 2 | 0 | – | 0,13 | 0,034 | 0,107 |
| f1/mizrakci-rus | 49 | 2 | 0 | – | 0,482 | 0,092 | 0,444 |
| f1/okcu-ger | 44 | 1 | 0 | – | 0,085 | 0,029 | 0,029 |
| f1/sehir-muhafizi-balta | 51 | 3 | 0 | – | 0,718 | 0,391 | 0,671 |
| f2/hafif-gozcu-mon | 55 | 1 | 0 | – | 0,3 | 0,024 | 0,267 |
| f2/hafif-mizrakci-viz | 49 | 3 | 0 | – | 0,567 | 0,028 | 0,523 |
| f2/han-muhafizi-mon | 66 | 1 | 0 | – | 0,464 | 0,114 | 0,515 |
| f2/kadin-okcu-ger | 46 | 2 | 0 | – | 0,098 | 0,041 | 0,039 |
| f2/kervan-muhafizi-viz | 41 | 3 | 0 | – | 0,534 | 0,036 | 0,557 |
| f2/kilicli-mon | 56 | 1 | 0 | – | 0,188 | 0,004 | 0,159 |
| f2/koylu-yumruk-viz | 34 | 3 | 0 | – | 0,469 | 0,037 | 0,486 |
| f2/mizrakci-mon | 54 | 1 | 0 | – | 0,317 | 0 | 0,268 |
| f2/okcu-mon | 55 | 1 | 0 | – | 0,335 | 0,005 | 0,283 |
| f2/okcu-viz | 40 | 3 | 0 | – | 0,491 | 0,024 | 0,465 |
