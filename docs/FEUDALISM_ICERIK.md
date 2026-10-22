# Feudalism 1 ve 2: içerik dökümü

`python3 araclar/aktar/envanter.py` üretir; elle değiştirmeyin. Oyunların neyi var, neyi yok ve
her birinin oyunumuza aktarılma durumu. Görseller hak sahibinin izniyle kullanılır
(bkz. `docs/LISANSLAR.md`).

## Feudalism (f1)

Sahne 800×600 piksel, saniyede 30 kare, arka plan `#35567B`. Kaynak: `feudalism-orijinal.swf`.

| İçerik | Sayı | Oyuna aktarılan | Yalnız yerel arşivde (neden) |
|---|---|---|---|
| Şekil (vektör çizim) | 1234 | 1157 vektör + 19 resim dolgulu | 58 (sponsor ya da Macromedia) |
| Sprite (hareketli sembol) | 246 | 222 | 24 |
| Düğme | 175 | 174 | 1 |
| Morph (biçim değiştiren şekil) | 16 | 11 (başlangıç ve bitiş) | 5 |
| Ekran (kök film karesi) | 92 | 92 | – |
| Resim (bit eşlem) | 18 | 18 | – |
| Ses efekti | 16 | 16 | – |
| Müzik | 0 | oyunda müzik yok | – |
| Sabit yazı | 122 | 122 (yerleşimiyle; Türkçesiyle) | 0 |
| Yazı alanı | 251 | 250 (bütün özellikleriyle) | 1 |
| Yazı tipi | 15 | harf kodları; yerine açık lisanslı karşılığı | 15 (lisans yazı tipi yapımcısında) |
| Türkçe çeviri | 122 sabit yazı, 143 kutu, 55 kod dosyası | `content/feudalism/f1/ceviri/` | – |
| Oyun kodu | 29 sınıf, 612 dosya | `kaynak/feudalism/f1/kod` (oyuna gömülmez) | – |
| Macromedia arayüz bileşeni | 0 | – | – |
| Sponsor parçası | 2 kök sembol, altlarıyla 89 karakter | – | hepsi (sponsorun; oyunun ekranlarında kullanılanlar dahil) |
| Üçüncü taraf kodu | 10 dosya | – | hepsi (sponsor, Adobe, MochiAds, MochiBot; listesi manifest.json → code_excluded) |

Eksik kalan karakter: 0. Tanınmayan etiket türü: 0. Her karakterin ve her etiket türünün nereye gittiği: `kaynak/feudalism/f1/manifest.json`.

### Ekranlar (kök film)

| Kare | Ne |
|---|---|
| 1–3 | açılış: yükleme, sponsor logoları (aktarılmadı), giriş animasyonu |
| 4 | ana menü |
| 5–84 | savaş alanı arka planları (80 kare) |
| 85 | kamp / kasaba (`TOWN_SCREEN`) |
| 86 | dünya haritası (`WORLD_MAP`) |
| 87 | savaşa hazırlık (`SPLASH_SCREEN`) |
| 88 | kayıt yükleme (`GAME_LOAD`) |
| 89 | oyun bitti (`GAME_OVER`) |
| 90 | zafer (`VICTORY`) |
| 91 | korsan kopya uyarısı (`STOLEN`) |
| 92 | savaş öğreticisi (`BATTLE_TUT`) |

### Dışa aktarılan semboller (oyunun kodla çağırdığı)

`Ammun`, `Amount window`, `Arrow`, `ArrowShower`, `ArrowWall`, `BarnUnit`, `BarracksUnit`, `BarracksUnit - tutorial`, `Barrel`, `BlackSquare`, `Blood_1`, `Blood_2`, `Bush_1`, `Bush_2`, `Bush_3`, `Bush_4`, `Cities`, `Crate_1`, `Crate_2`, `FlyCritDamage`, `FlyDamage`, `GrenSymb`, `Grenade`, `Head_on_spear`, `HealAnim`, `Horseman`, `Horseman_Player`, `Human`, `Human_Player`, `ICON Equipment`, `ICON Inventory`, `ICON Mouse`, `Lantern`, `RIP_1`, `RIP_2`, `RageAnim`, `RiseAnim`, `Screen`, `SelectBorder`, `Sign`, `Sign2`, `SkullTower`, `Sword_in_ground_1`, `Sword_in_ground_2`, `TreeBroken_1`, `Tree_1`, `Tree_10`, `Tree_11`, `Tree_12`, `Tree_2`, `Tree_3`, `Tree_4`, `Tree_5`, `Tree_6`, `Tree_7`, `Tree_8`, `Tree_9`, `Well_1`, `WorldMap`, `slash.wav`

### Sesler

Hepsi kısa ses efekti; müzik yok.

| Kimlik | Ad | Süre | Biçim | Nerede çalıyor |
|---|---|---|---|---|
| 530 |  | 1.4 sn | MP3 11025 Hz mono | Human.body / sword / kare 12; Horseman.body / sword / kare 12 |
| 531 |  | 0.8 sn | MP3 11025 Hz mono | Human.body / twohanded_sword / kare 53; Horseman.body / twohanded_sword / kare 53 |
| 532 |  | 1.8 sn | MP3 11025 Hz mono | Human.body / twohanded_axe / kare 94; Horseman.body / twohanded_axe / kare 94 |
| 533 |  | 1.5 sn | MP3 11025 Hz mono | Human.body / double / kare 116; Human.body / double / kare 130; Human.body / katana / kare 307 |
| 534 |  | 0.8 sn | MP3 11025 Hz mono | Human.body / spear / kare 149; Horseman.body / spear / kare 120 |
| 535 |  | 0.5 sn | MP3 11025 Hz mono | Human.body / bow / kare 187; Human.body / crossbow / kare 225; Horseman.body / bow / kare 161; Horseman.body / crossbow / kare 194 |
| 536 |  | 0.4 sn | MP3 11025 Hz mono | Human.body / dagger / kare 276; Human.body / fists / kare 367; Human.body / fists / kare 377; Horseman.body / fists / kare 259 |
| 537 |  | 0.4 sn | MP3 11025 Hz mono | Human.body / staff / kare 321 |
| 538 |  | 0.7 sn | MP3 11025 Hz mono | Human.body / staff / kare 337 |
| 539 |  | 0.5 sn | MP3 11025 Hz mono | Human.body / suriken / kare 400; Horseman.body / suriken / kare 291 |
| 540 |  | 0.9 sn | MP3 11025 Hz mono | Human.body / die_ranged / kare 736 |
| 541 |  | 0.8 sn | MP3 11025 Hz mono | Human.body / die_twohanded / kare 776 |
| 542 |  | 1.0 sn | MP3 11025 Hz mono | Human.body / die_onehanded / kare 826 |
| 565 |  | 1.4 sn | MP3 11025 Hz mono | Horseman.body / die_horse / kare 566 |
| 578 |  | 2.5 sn | MP3 11025 Hz mono | Grenade / blow / kare 2 |
| 930 | slash.wav | 0.6 sn | MP3 11025 Hz mono | kök film / kare 2 (durdurur) |

### Resimler

| Kimlik | Boyut | Not |
|---|---|---|
| 1327 | 70×71 |  |
| 1341 | 800×200 | savaş alanı zemin dokusu |
| 1352 | 800×200 | savaş alanı zemin dokusu |
| 1362 | 800×200 | savaş alanı zemin dokusu |
| 1372 | 800×200 | savaş alanı zemin dokusu |
| 1382 | 800×200 | savaş alanı zemin dokusu |
| 1389 | 800×200 | savaş alanı zemin dokusu |
| 1394 | 800×200 | savaş alanı zemin dokusu |
| 1398 | 800×200 | savaş alanı zemin dokusu |
| 1401 | 800×200 | savaş alanı zemin dokusu |
| 1405 | 800×200 | savaş alanı zemin dokusu |
| 1409 | 800×200 | savaş alanı zemin dokusu |
| 1412 | 800×200 | savaş alanı zemin dokusu |
| 1417 | 800×200 | savaş alanı zemin dokusu |
| 1431 | 800×200 | savaş alanı zemin dokusu |
| 1434 | 800×200 | savaş alanı zemin dokusu |
| 1439 | 800×200 | savaş alanı zemin dokusu |
| 1442 | 800×200 | savaş alanı zemin dokusu |

### Yazı tipleri

Gömülü hâlleri aktarılmaz (lisansları yazı tipi yapımcılarındadır); yazılar açık lisanslı karşılığıyla çizilir (bkz. `docs/LISANSLAR.md`).

| Kimlik | Ad | Biçem | Gömülü glif | Karşılığı |
|---|---|---|---|---|
| 45 | Arial | kalın | 10 | `fonts/LiberationSans-Bold.ttf` |
| 49 | _sans | kalın | yok (sistem yazı tipi) | `fonts/LiberationSans-Bold.ttf` |
| 156 | Times New Roman | kalın, italik | yok (sistem yazı tipi) | `fonts/LiberationSerif-BoldItalic.ttf` |
| 159 | Times New Roman | normal | 43 | `fonts/LiberationSerif-Regular.ttf` |
| 176 | _serif | normal | yok (sistem yazı tipi) | `fonts/LiberationSerif-Regular.ttf` |
| 889 | _serif | kalın | yok (sistem yazı tipi) | `fonts/LiberationSerif-Bold.ttf` |
| 1038 | Book Antiqua | kalın | 51 | `fonts/texgyrepagella-bold.otf` |
| 1153 | Bookman Old Style | kalın | 52 | `fonts/texgyrebonum-bold.otf` |
| 1253 | _sans | normal | yok (sistem yazı tipi) | `fonts/LiberationSans-Regular.ttf` |
| 1483 | Book Antiqua | kalın, italik | 11 | `fonts/texgyrepagella-bolditalic.otf` |
| 1521 | _serif | kalın, italik | yok (sistem yazı tipi) | `fonts/LiberationSerif-BoldItalic.ttf` |
| 1758 | Bookman Old Style | italik | 38 | `fonts/texgyrebonum-italic.otf` |
| 1837 | _sans | kalın, italik | yok (sistem yazı tipi) | `fonts/LiberationSans-BoldItalic.ttf` |
| 1983 | Monotype Corsiva | kalın | 18 | `fonts/texgyrechorus-mediumitalic.otf` |
| 2008 | Century Gothic | kalın | 29 | `fonts/texgyreadventor-bold.otf` |

### Türkçe çeviri

Kaynak: `swf-oyunlar/oyunlar/feudalism/ceviri` (oyunların sahibinin çevirisi). Tablolar değiştirilmeden `content/feudalism/f1/ceviri/` altında; çevrilmiş kod `kaynak/feudalism/f1/kod-tr`.

| Ne | Çevrilen | Toplam |
|---|---|---|
| Sabit yazı | 122 | 122 |
| Ekran kutusu | 143 | 250 |
| Kod dosyası (ekranda görünen metinler) | 55 | – |
| Silah, zırh ve birlik adı | 280 | – |
| Resim olarak çizilmiş yazı | 1 | – (kendiliğinden bulunamaz; bilinenler aşağıda) |

Resim olarak çizilmiş yazılar, ekranlara bakılarak bulunanlar (başkaları da olabilir):

- şekil 2019: "Öldün..." → çevrildi (`ceviri/sekiller/2019.svg`)
- şekil 995: "The Age of..." → ana menüde oyunun başlığının parçası; İngilizce kalır (yeni çizim yapılmaz; sahibinin Türkçe sürümünde de İngilizce)
- şekil 1019: "FEUDALISM" → oyunun adı; özel ad, çevrilmez

Çevrilmeyen ekran kutuları ve nedeni:

| Neden | Sayı | Kutular |
|---|---|---|
| boş | 14 | 1121, 1122, 1481, 1602, 1603, 1634, 1635, 1750, 1751, 1752, 1860, 1873, 1876, 1882 |
| sürüm numarası (çevrilmez) | 1 | 1020 (v1.041k) |
| tek kelime: özel ad ya da kodda anahtar (çevrilmez) | 33 | 890 (RIP), 1254 (Wanderburg), 1256 (Endem), 1258 (Hoffen), 1260 (Braunburg), 1262 (Gerlitz), 1264 (Sturmburg), 1266 (Jana), 1268 (Konstanz), 1270 (Trapezus), 1272 (Lutetia), 1274 (Arretium), 1276 (Alexandria), 1278 (Lacrimosa), 1280 (Ravenna), 1282 (Carthage), 1284 (Caesarea), 1286 (Grouzeno), 1288 (Medvedevo), 1290 (Dobrov), 1292 (Dubkee), 1294 (Ra-Gorod), 1296 (Losevo), 1298 (Dalnevodye), 1300 (Echigo), 1303 (Nagoya), 1305 (Fukushima), 1307 (Omi), 1309 (Kozuke), 1311 (Suo), 1313 (Matsuyama), 1315 (Izumo), 1318 (Zlatograd) |
| yalnız sayı ve işaret (oyun doldurur) | 59 | 157 (2222/2222), 177 (9999/9999), 236 (999), 237 (999), 238 (999), 239 (999), 240 (999), 241 (999), 793 (3000), 1069 (999), 1070 (999), 1071 (999), 1072 (999), 1073 (999), 1074 (999), 1075 (999), 1076 (999), 1077 (999), 1078 (999), 1079 (999), 1080 (999), 1081 (999), 1082 (999), 1083 (999), 1084 (999), 1085 (999), 1103 (999), 1455 (120/120), 1547 (999), 1623 (999), 1624 (999), 1625 (999), 1626 (999), 1627 (999), 1628 (999), 1667 (999), 1668 (999), 1669 (999), 1670 (999), 1671 (999), 1672 (999), 1673 (999), 1674 (999), 1675 (999), 1676 (999), 1677 (999), 1678 (999), 1679 (999), 1680 (999), 1681 (999), 1682 (999), 1683 (999), 1701 (999), 1702 (999), 1988 (0), 1989 (0), 1990 (0), 1991 (0), 2038 (1500/2000) |

### Oyun kodunun sınıfları

`Armor`, `Arrow`, `ArrowStorm`, `BarnIcon`, `BarracksIcon`, `Cage`, `Cities`, `Creature`, `Enchant`, `EquipmentIcon`, `Grenade`, `Hero`, `Horse`, `Item`, `ItemInfo`, `Player`, `Projectile`, `Quest`, `Screen`, `SelectBorder`, `Soldier`, `StoreIcon`, `Town`, `Tree`, `Unit`, `UnitInfo`, `Weapon`, `WeaponClass`, `WorldMap`

## Feudalism 2 (f2)

Sahne 800×600 piksel, saniyede 30 kare, arka plan `#35567B`. Kaynak: `feudalism-2-orijinal.swf`.

| İçerik | Sayı | Oyuna aktarılan | Yalnız yerel arşivde (neden) |
|---|---|---|---|
| Şekil (vektör çizim) | 2184 | 2097 vektör + 31 resim dolgulu | 56 (sponsor ya da Macromedia) |
| Sprite (hareketli sembol) | 441 | 306 | 135 |
| Düğme | 179 | 176 | 3 |
| Morph (biçim değiştiren şekil) | 25 | 24 (başlangıç ve bitiş) | 1 |
| Ekran (kök film karesi) | 116 | 116 | – |
| Resim (bit eşlem) | 24 | 24 | – |
| Ses efekti | 16 | 16 | – |
| Müzik | 0 | oyunda müzik yok | – |
| Sabit yazı | 104 | 104 (yerleşimiyle; Türkçesiyle) | 0 |
| Yazı alanı | 194 | 184 (bütün özellikleriyle) | 10 |
| Yazı tipi | 16 | harf kodları; yerine açık lisanslı karşılığı | 16 (lisans yazı tipi yapımcısında) |
| Türkçe çeviri | 104 sabit yazı, 115 kutu, 61 kod dosyası | `content/feudalism/f2/ceviri/` | – |
| Oyun kodu | 43 sınıf, 996 dosya | `kaynak/feudalism/f2/kod` (oyuna gömülmez) | – |
| Macromedia arayüz bileşeni | 85 | – | hepsi (Adobe'nin; oyunda kullanılmıyor) |
| Sponsor parçası | 14 kök sembol, altlarıyla 33 karakter | – | hepsi (sponsorun; oyunun ekranlarında kullanılanlar dahil) |
| Üçüncü taraf kodu | 130 dosya | – | hepsi (sponsor, Adobe, MochiAds, MochiBot; listesi manifest.json → code_excluded) |

Eksik kalan karakter: 0. Tanınmayan etiket türü: 0. Her karakterin ve her etiket türünün nereye gittiği: `kaynak/feudalism/f2/manifest.json`.

### Ekranlar (kök film)

| Kare | Ne |
|---|---|
| 1–3 | açılış: yükleme, sponsor logoları, giriş animasyonu |
| 4 | ana menü |
| 5–108 | savaş alanı arka planları (104 kare) |
| 109 | kamp / kasaba (`TOWN_SCREEN`) |
| 110 | dünya haritası (`WORLD_MAP`) |
| 111 | savaşa hazırlık (`SPLASH_SCREEN`) |
| 112 | kayıt yükleme (`GAME_LOAD`) |
| 113 | oyun bitti (`GAME_OVER`) |
| 114 | zafer (`VICTORY`) |
| 115 | korsan kopya uyarısı (`STOLEN`) |
| 116 | öğretici (`TUTORIAL`) |

### Dışa aktarılan semboller (oyunun kodla çağırdığı)

`Ammun`, `Amount window`, `Arrow`, `ArrowShower`, `ArrowWall`, `BalanceAnim`, `BansheeCryAnim`, `BarnUnit`, `BarracksUnit`, `BarracksUnit - tutorial`, `Barrel`, `BarrierAnim`, `BigStone_1`, `BigStone_2`, `BlackSquare`, `Blood_1`, `Blood_2`, `Blow 3x3`, `Blow 5x5`, `Bush_1`, `Bush_2`, `Bush_3`, `Bush_4`, `Choose Active Skill`, `Choose Aura Skill`, `Choose Nation`, `Choose Skill`, `Cities`, `Crate_1`, `Crate_2`, `DummyHorseman`, `DummyHuman`, `FlyCritDamage`, `FlyDamage`, `FlyHeal`, `FlyMiss`, `GrenSymb`, `Grenade`, `Head_on_spear`, `HealAnim`, `Horseman`, `Horseman_Player`, `Human`, `Human_Player`, `ICON Equipment`, `ICON Inventory`, `ICON Mouse`, `Lantern`, `LifeLeechAnim`, `LightningAnim`, `MouseHint`, `Position mark`, `RIP_1`, `RIP_2`, `RageAnim`, `RiseAnim`, `Screen`, `SelectBorder`, `Sign_1`, `Sign_2`, `Sign_3`, `SkullTower`, `SoulDrainAnim`, `StarsAnim`, `Sword_in_ground_1`, `Sword_in_ground_2`, `TreeBroken_1`, `Tree_1`, `Tree_10`, `Tree_11`, `Tree_12`, `Tree_2`, `Tree_3`, `Tree_4`, `Tree_5`, `Tree_6`, `Tree_7`, `Tree_8`, `Tree_9`, `TutorialBattle`, `UnholyBreathAnim`, `VenomCluodAnim`, `Well_1`, `Willow_1`, `Willow_2`, `WorldMap`, `slash.wav`

### Sesler

Hepsi kısa ses efekti; müzik yok.

| Kimlik | Ad | Süre | Biçim | Nerede çalıyor |
|---|---|---|---|---|
| 990 |  | 1.4 sn | MP3 11025 Hz mono | Human.body / shield / kare 12; Horseman.body / shield / kare 12 |
| 991 |  | 0.8 sn | MP3 11025 Hz mono | Human.body / 2H_sword / kare 171; Horseman.body / 2H_sword / kare 79 |
| 995 |  | 1.8 sn | MP3 11025 Hz mono | Human.body / 2H_axe / kare 362; Horseman.body / 2H_axe / kare 120 |
| 996 |  | 1.5 sn | MP3 11025 Hz mono | Human.body / dual / kare 535; Human.body / dual / kare 549; Human.body / katana / kare 1567 |
| 998 |  | 0.8 sn | MP3 11025 Hz mono | Human.body / spear / kare 837; Horseman.body / spear / kare 146 |
| 1008 |  | 0.5 sn | MP3 11025 Hz mono | Human.body / bow / kare 995; Human.body / crossbow / kare 1183; Horseman.body / bow / kare 187; Horseman.body / bow_2 / kare 302 |
| 1009 |  | 0.4 sn | MP3 11025 Hz mono | Human.body / dagger / kare 1446; Human.body / fists / kare 1867; Human.body / fists / kare 1877 |
| 1027 |  | 0.4 sn | MP3 11025 Hz mono | Human.body / staff / kare 1686 |
| 1028 |  | 0.7 sn | MP3 11025 Hz mono | Human.body / staff / kare 1702 |
| 1030 |  | 0.5 sn | MP3 11025 Hz mono | Human.body / throwing / kare 1900; Horseman.body / crossbow / kare 364 |
| 1031 |  | 0.9 sn | MP3 11025 Hz mono | Human.body / die_ranged / kare 2386 |
| 1032 |  | 0.8 sn | MP3 11025 Hz mono | Human.body / die_twohanded / kare 2426 |
| 1033 |  | 1.0 sn | MP3 11025 Hz mono | Human.body / die_onehanded / kare 2476 |
| 1056 |  | 1.4 sn | MP3 11025 Hz mono | Horseman.body / die_horse / kare 1071 |
| 1060 |  | 2.5 sn | MP3 11025 Hz mono | Grenade / blow / kare 2 |
| 1743 | slash.wav | 0.6 sn | MP3 11025 Hz mono | kök film / kare 2 (durdurur) |

### Resimler

| Kimlik | Boyut | Not |
|---|---|---|
| 1789 | 70×71 |  |
| 1790 | 800×200 | savaş alanı zemin dokusu |
| 1845 | 800×200 | savaş alanı zemin dokusu |
| 1852 | 800×200 | savaş alanı zemin dokusu |
| 1859 | 800×200 | savaş alanı zemin dokusu |
| 1870 | 800×200 | savaş alanı zemin dokusu |
| 1875 | 800×200 | savaş alanı zemin dokusu |
| 2163 | 800×200 | savaş alanı zemin dokusu |
| 2192 | 800×200 | savaş alanı zemin dokusu |
| 2199 | 800×200 | savaş alanı zemin dokusu |
| 2207 | 800×200 | savaş alanı zemin dokusu |
| 2210 | 800×200 | savaş alanı zemin dokusu |
| 2214 | 800×200 | savaş alanı zemin dokusu |
| 2218 | 800×200 | savaş alanı zemin dokusu |
| 2221 | 800×200 | savaş alanı zemin dokusu |
| 2226 | 800×200 | savaş alanı zemin dokusu |
| 2240 | 800×200 | savaş alanı zemin dokusu |
| 2243 | 800×200 | savaş alanı zemin dokusu |
| 2248 | 800×200 | savaş alanı zemin dokusu |
| 2251 | 800×200 | savaş alanı zemin dokusu |
| 2353 | 800×200 | savaş alanı zemin dokusu |
| 2365 | 800×200 | savaş alanı zemin dokusu |
| 2382 | 800×200 | savaş alanı zemin dokusu |
| 2387 | 800×200 | savaş alanı zemin dokusu |

### Yazı tipleri

Gömülü hâlleri aktarılmaz (lisansları yazı tipi yapımcılarındadır); yazılar açık lisanslı karşılığıyla çizilir (bkz. `docs/LISANSLAR.md`).

| Kimlik | Ad | Biçem | Gömülü glif | Karşılığı |
|---|---|---|---|---|
| 45 | Arial | kalın | 10 | `fonts/LiberationSans-Bold.ttf` |
| 77 | _sans | normal | yok (sistem yazı tipi) | `fonts/LiberationSans-Regular.ttf` |
| 222 | _sans | normal | yok (sistem yazı tipi) | `fonts/LiberationSans-Regular.ttf` |
| 224 | _sans | kalın | 27 | `fonts/LiberationSans-Bold.ttf` |
| 350 | Times New Roman | kalın, italik | yok (sistem yazı tipi) | `fonts/LiberationSerif-BoldItalic.ttf` |
| 353 | Times New Roman | normal | 44 | `fonts/LiberationSerif-Regular.ttf` |
| 461 | _serif | normal | yok (sistem yazı tipi) | `fonts/LiberationSerif-Regular.ttf` |
| 482 | Monotype Corsiva | kalın | 32 | `fonts/texgyrechorus-mediumitalic.otf` |
| 1702 | _serif | kalın | yok (sistem yazı tipi) | `fonts/LiberationSerif-Bold.ttf` |
| 1964 | Book Antiqua | kalın | 54 | `fonts/texgyrepagella-bold.otf` |
| 2043 | Bookman Old Style | kalın | 50 | `fonts/texgyrebonum-bold.otf` |
| 2298 | Book Antiqua | kalın, italik | 11 | `fonts/texgyrepagella-bolditalic.otf` |
| 2339 | _sans | kalın, italik | yok (sistem yazı tipi) | `fonts/LiberationSans-BoldItalic.ttf` |
| 2400 | _serif | kalın, italik | yok (sistem yazı tipi) | `fonts/LiberationSerif-BoldItalic.ttf` |
| 2417 | Monotype Corsiva | normal | 114 | `fonts/texgyrechorus-mediumitalic.otf` |
| 3083 | Century Gothic | kalın | 29 | `fonts/texgyreadventor-bold.otf` |

### Türkçe çeviri

Kaynak: `swf-oyunlar/oyunlar/feudalism-2/ceviri` (oyunların sahibinin çevirisi). Tablolar değiştirilmeden `content/feudalism/f2/ceviri/` altında; çevrilmiş kod `kaynak/feudalism/f2/kod-tr`.

| Ne | Çevrilen | Toplam |
|---|---|---|
| Sabit yazı | 104 | 104 |
| Ekran kutusu | 115 | 184 |
| Kod dosyası (ekranda görünen metinler) | 61 | – |
| Silah, zırh ve birlik adı | 543 | – |
| Resim olarak çizilmiş yazı | 1 | – (kendiliğinden bulunamaz; bilinenler aşağıda) |

Resim olarak çizilmiş yazılar, ekranlara bakılarak bulunanlar (başkaları da olabilir):

- şekil 3094: "Öldün..." → çevrildi (`ceviri/sekiller/3094.svg`)
- birkaç parça: "Feudalism II" → ana menüdeki oyunun adı; özel ad, çevrilmez

Çevrilmeyen ekran kutuları ve nedeni:

| Neden | Sayı | Kutular |
|---|---|---|
| boş | 15 | 2025, 2026, 2296, 2574, 2598, 2606, 2607, 2619, 2620, 2633, 2795, 2810, 2813, 2821, 3134 |
| sürüm numarası (çevrilmez) | 1 | 1950 (v1.02) |
| tasarım örneği; oyun kodla doldurur (Türkçesi kod çevirisinde) | 10 | 223 (Character throws his dagger at), 225 (Horsemen Defense Mastery), 242 (SP cost: 100), 251 (Horseman Twohanded Sword), 252 (Two Handed Sword), 253 (Damage: 50-93Critical rate: 10), 257 (Legionary), 258 (STR: 32DEX: 10CON: 19SPR: 10Pr), 338 (HP: 9999 SP: 9999Defense: 500 ), 340 (Strength is a very very very i) |
| tek kelime: özel ad ya da kodda anahtar (çevrilmez) | 3 | 1703 (RIP), 2376 (T i f l i s), 2914 (Katar) |
| yalnız sayı ve işaret (oyun doldurur) | 40 | 265 (99), 351 (2222/2222), 462 (9999/9999), 475 (9999/9999), 479 (999), 480 (999), 490 (1), 492 (2), 493 (3), 494 (4), 495 (5), 496 (6), 1458 (3000), 2018 (?), 2269 (120/120), 2432 (999), 2585 (10), 2610 (999), 2611 (999), 2635 (999), 2861 (999), 2862 (999), 2863 (999), 2864 (999), 2865 (999), 2866 (999), 2867 (999), 2868 (999), 2869 (999), 2870 (999), 2871 (999), 2872 (999), 2873 (999), 2874 (999), 2875 (999), 2891 (999), 2909 (50), 2915 (999), 2918 (?), 3112 (1500/2000) |

### Oyun kodunun sınıfları

`ActiveSkillChooser`, `Armor`, `Arrow`, `ArrowStorm`, `Aura`, `AuraSkillChooser`, `BarnIcon`, `BarracksIcon`, `Cage`, `Cities`, `Creature`, `DamageData`, `Enchant`, `EquipmentIcon`, `Grenade`, `Hero`, `Horse`, `Item`, `ItemInfo`, `MochiAd`, `MouseHint`, `MovieDummy`, `NationChooser`, `PassiveSkillChooser`, `Player`, `Projectile`, `Quest`, `Rune`, `Screen`, `SelectBorder`, `Skill`, `SkillChooser`, `Soldier`, `Status`, `StoreIcon`, `Town`, `Tree`, `Tutorial`, `Unit`, `UnitInfo`, `Weapon`, `WeaponClass`, `WorldMap`

## Ek: oyunlardaki sabit yazılar

Ekranlarda çizili yazılar ve Türkçeleri. Yazı alanlarının başlangıç değerleri ayrıca listelenir.

### Feudalism

| Kimlik | Yazı | Türkçesi |
|---|---|---|
| 160 | Hold Position [Home] / Makes the selected soldiers  / to stay at current position. | Yerini Koru [Home] / Seçili askerlerin bulundukları / yerde kalmasını sağlar. |
| 161 | Swap weapons [PageUp] / Switches to ranged and  / back. Some units have no  / weapon to swap. | Silah Değiştir [PageUp] / Menzilli silaha geçer ve geri / döner. Bazı birliklerin / değişecek silahı yoktur. |
| 162 | Small potion / Heals 50 HP | Küçük iksir / 40 can yeniler |
| 163 | Medium potion / Heals 300 HP | Orta iksir / 300 can yeniler |
| 164 | Large potion / Completely heals hero | Büyük iksir / Kahramanı tamamen iyileştirir |
| 165 | Small heal scroll / Heals all your unit for 1/3  / of their max HP. | Küçük şifa parşömeni / Tüm birliklerin canının / 1/3'ünü yeniler. |
| 166 | Large heal scroll / Heals all your unit for 2/3  / of their max HP. | Büyük şifa parşömeni / Tüm birliklerin canının / 2/3'ünü yeniler. |
| 167 | Scroll of rage / Makes your units attack  / much faster. | Öfke parşömeni / Birliklerin çok daha hızlı / saldırır. |
| 168 | Arrow Shower / An area attack, which can  / hurt friendly units too. | Ok Yağmuru / Bir alana saldırır; dost / birliklere de zarar verebilir. |
| 169 | Arrow Wall / An attack which shots  / several crossbow bolts to  / selected positions. | Ok Duvarı / Seçili yerlere birkaç / arbalet oku fırlatan / bir saldırı. |
| 901 | Scotland | İskoçya |
| 908 | England | İngiltere |
| 1039 | TUTORIAL | EĞİTİM |
| 1040 | NEW GAME | YENİ OYUN |
| 1041 | RESUME GAME | DEVAM ET |
| 1042 | OPTIONS | AYARLAR |
| 1043 | CONTROLS | KONTROLLER |
| 1044 | MORE GAMES | DİĞER OYUNLAR |
| 1045 | PUT THIS GAME ON YOUR SITE | BU OYUNU SİTENE EKLE |
| 1046 | E-MAIL ME | BANA YAZ |
| 1140 | Choose your hero | Kahramanını seç |
| 1141 | START JOURNEY | YOLA ÇIK |
| 1154 | Medium / quality | Orta / kalite |
| 1155 | High / quality | Yüksek / kalite |
| 1156 | Low / quality | Düşük / kalite |
| 1159 | Highlight troops | Birlikleri vurgula |
| 1160 | Show help tips | İpuçlarını göster |
| 1162 | Save slot 1 | Kayıt yuvası 1 |
| 1164 | Load | Yükle |
| 1167 | Save slot 2 | Kayıt yuvası 2 |
| 1169 | Save slot 3 | Kayıt yuvası 3 |
| 1171 | Auto save | Otomatik kayıt |
| 1175 | Load game... | Oyun yükle... |
| 1176 | ...which slot? | ...hangi yuva? |
| 1484 | Press a button | Bir tuşa bas |
| 1487 | Move up: | Yukarı: |
| 1488 | Move down: | Aşağı: |
| 1489 | Move left: | Sola: |
| 1490 | Move right: | Sağa: |
| 1491 | Attack: | Saldırı: |
| 1492 | Swap weapons: | Silah değiştir: |
| 1493 | SAVE AND EXIT | KAYDET VE ÇIK |
| 1606 | Your items: | Eşyaların: |
| 1607 | Merchant's items: | Tüccarın eşyaları: |
| 1608 | Drag'n'drop items to buy or sell them for 1/2 of their price | Eşyaları sürükleyip bırakarak al ya da yarı fiyatına sat |
| 1609 | Don't ask amount, just sell all | Miktar sorma, hepsini sat |
| 1629 | Click on a potion or scroll to buy it. Shift-click to by 5 potions per time. | Almak için tıkla; Shift ile tıklarsan 5 tane alırsın. |
| 1631 | Reserve troops - they will fight, when someone from 1st or 2nd line will die | Yedekler: 1. ya da 2. sıradan biri ölünce savaşa girer |
| 1632 | 2nd line | 2 / . sıra |
| 1633 | 1st line | 1 / . sıra |
| 1644 | Troops available to recruit | Toplanabilecek birlikler |
| 1757 | Piercing | Delici |
| 1759 | Increases hit chance by  / 10% | İsabet şansını / %10 artırır |
| 1761 | Bloody | Kanlı |
| 1762 | Increases critical strike  / chance by 10% | Kritik vuruş şansını / %10 artırır |
| 1763 | Bleeding | Kanatan |
| 1764 | Increases critical strike  / chance by 20% | Kritik vuruş şansını / %20 artırır |
| 1766 | of Massacre | (Katliam) |
| 1767 | Increases critical strike  / chance by 10% and  / damage by 0-20 | Kritik vuruş şansını / %10, hasarı 0-20 / artırır |
| 1769 | Increases critical strike  / chance by 30%, but  / reduces dodge chance  / by 20% of its value | Kritik vuruş şansını / %30 artırır ama / kaçınma şansını kendi / değerinin %20'si kadar azaltır |
| 1770 | Creeping | Sinsi |
| 1772 | Increases damage by  / 20 points and HP by  / 20% | Hasarı 20 puan, / canı %20 / artırır |
| 1773 | Strong | Güçlü |
| 1775 | Increases critical strike  / chance by 30%, but  / decreases damage by 5  / points and HP by 50% | Kritik vuruş şansını / %30 artırır ama hasarı / 5 puan, canı %50 / azaltır |
| 1776 | Cursed | Lanetli |
| 1778 | Increases damage by  / 20-70, but decreases  / HP by 30% and defence  / by 50% | Hasarı 20-70 artırır / ama canı %30, / savunmayı %50 / azaltır |
| 1779 | Undead | Hortlak |
| 1781 | Increases damage by  / 100-300 and defence  / by 150%, but decreases  / HP by 90% and dodge  / chance by 99% | Hasarı 100-300, / savunmayı %150 artırır / ama canı %90, / kaçınma şansını %99 / azaltır |
| 1782 | ~~Unholy~~ | ~~Şeytani~~ |
| 1784 | Increases damage by  / 20-50, HP by 20%,  / defence by 10% and  / dodge chance by 2% | Hasarı 20-50, canı %20, / savunmayı %10, kaçınma / şansını %2 / artırır |
| 1785 | Great | Yüce |
| 1787 | Increases damage by  / 50-350, but decreases  / HP and defence by  / 50%, and dodge chance  / by 20% | Hasarı 50-350 artırır / ama canı ve / savunmayı %50, / kaçınma şansını / %20 azaltır |
| 1788 | Glorious | Şanlı |
| 1789 | of Sacrifice | (Fedakârlık) |
| 1791 | Increases HP by 100%  / and defence by 20%,  / and dodge chance by  / 4%, but decreases hit  / chance by 15% | Canı %100, savunmayı / %20, kaçınma şansını / %4 artırır ama / isabet şansını / %15 azaltır |
| 1792 | of Compassion | (Merhamet) |
| 1794 | of Valor | (Yiğitlik) |
| 1795 | Increases damage by  / 50-100, defence by  / 50%, but decreases  / dodge chance by 70% | Hasarı 50-100, / savunmayı %50 artırır / ama kaçınma şansını / %70 azaltır |
| 1797 | Immortal | Ölümsüz |
| 1798 | Increases HP by 200%  / and defence by 100%,  / but decreases damage  / by 5-15, hit chance by  / 20% critical strike  / chance by 10% | Canı %200, / savunmayı %100 artırır / ama hasarı 5-15, / isabet şansını %20, / kritik vuruş şansını / %10 azaltır |
| 1800 | ~~Mysterious | ~~Gizemli |
| 1801 | Increases hit chance by  / 100%, critical strike  / chance by 90% and  / damage by 0-1000, but  / sets defence and dodge  / chance to 0 and  / decreases HP by 80% | İsabet şansını %100, / kritik vuruş şansını / %90, hasarı 0-1000 / artırır ama savunma / ve kaçınma şansını / sıfırlar, canı %80 / azaltır |
| 1802 | of Death~~ | (Ölüm)~~ |
| 1804 | Marksman's | Nişancı |
| 1805 | Increases hit chance by  / 5% | İsabet şansını / %5 artırır |
| 1807 | Lucky | Şanslı |
| 1808 | Increases hit chance by  / 20%, crical strike  / chance by 20% and  / damage by 0-20 | İsabet şansını %20, / kritik vuruş şansını / %20, hasarı 0-20 / artırır |
| 1810 | Sleeping | Uyuyan |
| 1811 | Increases damage by 0- / 50, defence and HP by  / 30%, but decreases hit  / chance by 5%, crical  / strike chance by 5%  / and dodge chance by  / 10% | Hasarı 0-50, savunmayı / ve canı %30 artırır / ama isabet şansını / %5, kritik vuruş / şansını %5, kaçınma / şansını %10 / azaltır |
| 1813 | Suffering | Acı Çeken |
| 1814 | Increases damage by  / 50, hit and crical strike  / chance by 30%, dodge  / chance by 2%, but  / decreases  defence and  / HP by 30% | Hasarı 50, isabet ve / kritik vuruş şansını / %30, kaçınma şansını / %2 artırır ama / savunmayı ve canı / %30 azaltır |
| 1816 | Blind | Kör |
| 1817 | Increases damage by  / 30-80, crical strike  / chance by 20% and  / defence by 50%, but  / decreases  hit chance  / by 10% | Hasarı 30-80, kritik / vuruş şansını %20, / savunmayı %50 / artırır ama isabet / şansını %10 / azaltır |
| 1819 | Increases damage by  / 60-160, crical strike  / chance by 40% and  / defence by 80%, but  / decreases  hit chance  / by 30% and dodge  / chance by 60% | Hasarı 60-160, kritik / vuruş şansını %40, / savunmayı %80 / artırır ama isabet / şansını %30, kaçınma / şansını %60 / azaltır |
| 1820 | of Rage | (Öfke) |
| 1822 | Breaking | Kıran |
| 1823 | Increases crical strike  / chance by 70% and hit  / chance by 10% | Kritik vuruş şansını / %70, isabet şansını / %10 artırır |
| 1825 | Crushing | Ezen |
| 1826 | Increases damage by  / 100-300, but decreases  / crical strike chance by  / 90% | Hasarı 100-300 / artırır ama kritik / vuruş şansını %90 / azaltır |
| 1828 | ~~Saint | ~~Aziz |
| 1829 | Increases defence and  / HP by 200%, but  / decreases hit chance by  / 40% and dodge chance  / by 90% | Savunmayı ve canı / %200 artırır ama / isabet şansını %40, / kaçınma şansını %90 / azaltır |
| 1830 | of Divine Light~~ | (İlahi Işık)~~ |
| 1846 | Save | Kaydet |
| 1867 | No, maybe something else? | Hayır, başka bir şey göster. |
| 1877 | Sell your horse | Atını sat |
| 1880 | Click on a horse to buy it. Notice, that some kind of weapons can't be used from a horse | Almak için bir ata tıkla. Bazı silahların at üstünde kullanılamadığını unutma |
| 1891 | Okay, let's fight | Peki, dövüşelim |
| 1894 | ... hmm Okay | ... hımm, peki |
| 1984 | Hero level: | Kahraman seviyesi: |
| 1985 | Gold gained: | Kazanılan altın: |
| 1986 | Max Hero damage: | En yüksek hasar: |
| 1987 | Max Hero HP: | En yüksek can: |
| 2009 | Prepare | Savaşa |
| 2010 | Battle... | olun... |
| 2011 | for | hazır |
| 2020 | Load game? | Oyun yüklensin mi? |
| 2022 | MAIN MENU | ANA MENÜ |
| 2029 | Continue | Devam |
| 2033 | Victory! | Zafer! |
| 2034 | Experience: | Deneyim: |
| 2035 | Gold: | Altın: |
| 2037 | Items obtained: | Kazanılan eşyalar: |

Yazı alanlarının başlangıç değerleri (Feudalism): oyun bunların çoğunu çalışırken değiştirir; burada tasarımdaki örnek değerleri var.

| Kimlik | Yazı | Türkçesi |
|---|---|---|
| 46 | miss | ıska |
| 50 | 100% |  |
| 157 | 2222/2222 |  |
| 177 | 9999/9999 |  |
| 236 | 999 |  |
| 237 | 999 |  |
| 238 | 999 |  |
| 239 | 999 |  |
| 240 | 999 |  |
| 241 | 999 |  |
| 793 | 3000 |  |
| 799 | OK | Tamam |
| 802 | Cancel | İptal |
| 805 | miss | ıska |
| 890 | RIP |  |
| 1020 | v1.041k |  |
| 1052 | Strength | Güç |
| 1053 | Dexterity | Çeviklik |
| 1054 | Constitution | Dayanıklılık |
| 1055 | Intelligence | Zekâ |
| 1056 | Sword | Kılıç |
| 1057 | Axe | Balta |
| 1058 | Mace | Gürz |
| 1059 | Staff | Asa |
| 1060 | Far East Weapons | Uzak Doğu |
| 1061 | Dagger | Hançer |
| 1062 | Spear | Mızrak |
| 1063 | Dual Weapons | Çift Silah |
| 1064 | Bow | Yay |
| 1065 | Crossbow | Arbalet |
| 1066 | Throwing | Fırlatma |
| 1067 | Art of War | Savaş Sanatı |
| 1068 | Patriotism | Vatanseverlik |
| 1069 | 999 |  |
| 1070 | 999 |  |
| 1071 | 999 |  |
| 1072 | 999 |  |
| 1073 | 999 |  |
| 1074 | 999 |  |
| 1075 | 999 |  |
| 1076 | 999 |  |
| 1077 | 999 |  |
| 1078 | 999 |  |
| 1079 | 999 |  |
| 1080 | 999 |  |
| 1081 | 999 |  |
| 1082 | 999 |  |
| 1083 | 999 |  |
| 1084 | 999 |  |
| 1085 | 999 |  |
| 1102 | Free points | Boş puan |
| 1103 | 999 |  |
| 1147 | Back | Geri |
| 1179 | Hello, wanderer! I'll guide you through the  / basics and teach how to survive in this  / world. | Merhaba yolcu! Sana temel bilgileri anlatacağım ve bu dünyada nasıl hayatta kalacağını öğreteceğim. |
| 1181 | Next | İleri |
| 1240 | This is the screen of your city. There are  / several buildings: | Burası şehir ekranın. Burada birkaç bina var: |
| 1242 | City Hall. Here you can view your hero  / stats, ask for a quest, or declare war on the  / town. | Belediye Sarayı. Burada kahramanının özelliklerine bakabilir, görev isteyebilir ya da şehre savaş açabilirsin. |
| 1244 | Forge. Here you can buy and sell weapons  / and armor. | Demirci. Burada silah ve zırh alıp satabilirsin. |
| 1246 | Barracks. Here you can recruit and disband  / your troops. | Kışla. Burada asker toplayabilir ya da askerlerini terhis edebilirsin. |
| 1248 | Temple. Here you can buy healing potions  / and scrolls. | Tapınak. Burada şifa iksirleri ve parşömenler alabilirsin. |
| 1250 | Also, there're a barn and a harbor in some  / towns. | Bazı şehirlerde ayrıca bir ahır ve bir liman da vardır. |
| 1254 | Wanderburg |  |
| 1256 | Endem |  |
| 1258 | Hoffen |  |
| 1260 | Braunburg |  |
| 1262 | Gerlitz |  |
| 1264 | Sturmburg |  |
| 1266 | Jana |  |
| 1268 | Konstanz |  |
| 1270 | Trapezus |  |
| 1272 | Lutetia |  |
| 1274 | Arretium |  |
| 1276 | Alexandria |  |
| 1278 | Lacrimosa |  |
| 1280 | Ravenna |  |
| 1282 | Carthage |  |
| 1284 | Caesarea |  |
| 1286 | Grouzeno |  |
| 1288 | Medvedevo |  |
| 1290 | Dobrov |  |
| 1292 | Dubkee |  |
| 1294 | Ra-Gorod |  |
| 1296 | Losevo |  |
| 1298 | Dalnevodye |  |
| 1300 | Echigo |  |
| 1303 | Nagoya |  |
| 1305 | Fukushima |  |
| 1307 | Omi |  |
| 1309 | Kozuke |  |
| 1311 | Suo |  |
| 1313 | Matsuyama |  |
| 1315 | Izumo |  |
| 1318 | Zlatograd |  |
| 1324 | Once you leave a town, you'll find yourself  / on the world map. | Bir şehirden ayrıldığında kendini dünya haritasında bulursun. |
| 1326 | Click at the map to move your hero. | Kahramanını yürütmek için haritaya tıkla. |
| 1455 | 120/120 |  |
| 1464 | This is battle screen. Here you'll fight for  / the glory and gold. | Burası savaş ekranı. Burada şan ve altın için dövüşeceksin. |
| 1466 | Control your hero with WASD or directional  / keys and attack with Space or Numpad 0 | Kahramanını WASD ya da yön tuşlarıyla yönet; Boşluk ya da Numpad 0 ile saldır. |
| 1468 | These guys are your troops. You have no  / need to order them. They're wise enough to  / fight on their own. | Bunlar senin askerlerin. Onlara emir vermene gerek yok; kendi başlarına dövüşecek kadar akıllılar. |
| 1471 | But if you want them to stop or swap their  / weapons (if they have a weapon to swap  / to), use these buttons. | Ama durmalarını ya da silah değiştirmelerini istersen (değiştirecek silahları varsa) bu düğmeleri kullan. |
| 1473 | The enemies start at the left, at these  / positions. | Düşmanlar soldan, bu konumlardan başlar. |
| 1476 | If you or your soldiers will get injured, click  / these buttons (or hotkeys 1-6) to use  / healing potions and scrolls. | Sen ya da askerlerin yaralanırsanız şifa iksirlerini ve parşömenleri kullanmak için bu düğmelere (ya da 1-6 tuşlarına) tıkla. |
| 1478 | That's all I wanted to tell. Now go, and start  / your long journey to the world domination!MWA HA HA HA HAaaaa!!!! | Hepsi bu kadar. Şimdi git, dünyaya hükmetmek için yola çık! / MUHAHAHAHAaaaa!!!! |
| 1518 | The trade camp of Trapezus | Trapezus ticaret kampı |
| 1522 | City HallHere you can view  / your hero stats, ask  / for a quest, or  / declare war. | Belediye Sarayı / Kahramanına bak, görev iste ya da savaş aç. |
| 1524 | ForgeHere you can buy  / and sell weapons  / and armor. | Demirci / Silah ve zırh al, sat. |
| 1526 | BarracksHere you can recruit  / and disbandyour troops. | Kışla / Asker topla ya da terhis et. |
| 1528 | TempleHere you can buy  / healing potionsand scrolls. | Tapınak / Şifa iksirleri ve parşömenler al. |
| 1530 | HarborYou can board a  / ship there totravel by sea. | Liman / Buradan gemiye binip denizden yolculuk edebilirsin. |
| 1532 | BarnBuy and sell horses  / here. | Ahır / Burada at alıp satabilirsin. |
| 1534 | ExitExit to the world  / map. | Çıkış / Dünya haritasına çık. |
| 1541 | Inventory | Envanter |
| 1547 | 999 |  |
| 1604 | 3000 gold | 3000 altın |
| 1605 | Money: | Para: |
| 1619 | Scroll of Bloody Rage | Kanlı Öfke Parşömeni |
| 1620 | Makes your units attack much faster. Units with low attack speed gain a huge bunus, perhaps fast attacking units get a very small bonus. | Birliklerin çok daha hızlı saldırır. Yavaş saldıran birlikler büyük bonus alır, hızlı saldıranlar ise çok küçük bir bonus alır. |
| 1621 | 3000 gold | 3000 altın |
| 1622 | Money: | Para: |
| 1623 | 999 |  |
| 1624 | 999 |  |
| 1625 | 999 |  |
| 1626 | 999 |  |
| 1627 | 999 |  |
| 1628 | 999 |  |
| 1636 | 3000 gold | 3000 altın |
| 1637 | Money: | Para: |
| 1650 | Strength | Güç |
| 1651 | Dexterity | Çeviklik |
| 1652 | Constitution | Dayanıklılık |
| 1653 | Intelligence | Zekâ |
| 1654 | Sword | Kılıç |
| 1655 | Axe | Balta |
| 1656 | Mace | Gürz |
| 1657 | Staff | Asa |
| 1658 | Far East Weapons | Uzak Doğu |
| 1659 | Dagger | Hançer |
| 1660 | Spear | Mızrak |
| 1661 | Dual Weapons | Çift Silah |
| 1662 | Bow | Yay |
| 1663 | Crossbow | Arbalet |
| 1664 | Throwing | Fırlatma |
| 1665 | Art of War | Savaş Sanatı |
| 1666 | Patriotism | Vatanseverlik |
| 1667 | 999 |  |
| 1668 | 999 |  |
| 1669 | 999 |  |
| 1670 | 999 |  |
| 1671 | 999 |  |
| 1672 | 999 |  |
| 1673 | 999 |  |
| 1674 | 999 |  |
| 1675 | 999 |  |
| 1676 | 999 |  |
| 1677 | 999 |  |
| 1678 | 999 |  |
| 1679 | 999 |  |
| 1680 | 999 |  |
| 1681 | 999 |  |
| 1682 | 999 |  |
| 1683 | 999 |  |
| 1700 | Free points | Boş puan |
| 1701 | 999 |  |
| 1702 | 999 |  |
| 1753 | Michael KlobovLevel 49 | Michael Klobov / Seviye 49 |
| 1756 | Full Plate Of Holy Light | Kutsal Işık Zırhı |
| 1838 | View your hero's stats | Kahramanına bak |
| 1839 | Try to capture this town | Şehri ele geçir |
| 1840 | Ask for a quest | Görev iste |
| 1872 | Michael KlobovLevel 49 | Michael Klobov / Seviye 49 |
| 1878 | 3000 gold | 3000 altın |
| 1879 | Money: | Para: |
| 1883 | Yes! | Evet! |
| 1885 | No.. | Hayır.. |
| 1888 | You don't rule our city!We don't want to sell our troops to strangers!(You need to capture this town to recruit troops  / here) | Bizi sen yönetmiyorsun! / Askerlerimizi yabancılara satmayız! /  / (Burada asker toplamak için önce bu şehri ele geçirmelisin) |
| 1890 | What the... ??Enemy himself has come at our gates! We'll  / punish you for all our captured cities.To arms, my men, to arms!! | Bu da ne...?? / Düşmanın kendisi kapımıza dayandı! Ele geçirdiğin bütün şehirlerimizin hesabını soracağız. /  / Silah başına askerler, silah başına!! |
| 1893 | Sire! This town is already ours!We can't kill our own people for nothing! | Efendim! Bu şehir zaten bizim! / Kendi halkımızı boş yere öldüremeyiz! |
| 1896 | Are you sure want to fight us?! | Bize karşı savaşmak istediğine emin misin?! |
| 1899 | The trade camp of Lutetia | Lutetia ticaret kampı |
| 1903 | The trade camp of Arretium | Arretium ticaret kampı |
| 1905 | The trade camp of Ravenna | Ravenna ticaret kampı |
| 1906 | The trade camp of Lacrimosa | Lacrimosa ticaret kampı |
| 1908 | The city of Caesaria | Caesaria şehri |
| 1909 | The Great city of Carthage | Büyük Carthage şehri |
| 1910 | The Glorious city of Alexandria | Görkemli Alexandria şehri |
| 1911 | Capital of the Great Trade Republic | Büyük Ticaret Cumhuriyeti'nin başkenti |
| 1916 | The village of Jana | Jana köyü |
| 1917 | The small town of Konstanz | Küçük Konstanz kasabası |
| 1918 | The small town of Gerlitz | Küçük Gerlitz kasabası |
| 1919 | The town of Sturmburg | Sturmburg kasabası |
| 1920 | Order's south keep | Tarikatın güney kalesi |
| 1922 | The village of Hoffen | Hoffen köyü |
| 1923 | The village of Endem | Endem köyü |
| 1924 | The Great city of Braunburg | Büyük Braunburg şehri |
| 1925 | Order's major city | Tarikatın büyük şehri |
| 1926 | The Glorious city of Wanderburg | Görkemli Wanderburg şehri |
| 1927 | The Capital of Order of Holy Cross | Kutsal Haç Tarikatı'nın başkenti |
| 1932 | The small village of Dubkee | Küçük Dubkee köyü |
| 1933 | The village of Dalnevodye | Dalnevodye köyü |
| 1934 | The village of Losevo | Losevo köyü |
| 1935 | The town of Dobrov | Dobrov kasabası |
| 1936 | The city of Zlatograd | Zlatograd şehri |
| 1937 | Forest Lands' Trade Center | Orman Diyarı'nın ticaret merkezi |
| 1938 | The village of Medvedevo | Medvedevo köyü |
| 1939 | The small village of Grouzeno | Küçük Grouzeno köyü |
| 1940 | All Heroes' Motherland | Bütün kahramanların anayurdu |
| 1941 | The Gloriuos city of Ra-Gorod | Görkemli Ra-Gorod şehri |
| 1942 | The Capital of Forest Lands | Orman Diyarı'nın başkenti |
| 1948 | The small village of Omi | Küçük Omi köyü |
| 1949 | The small village of Kozuke | Küçük Kozuke köyü |
| 1950 | The small town of Matsuyama | Küçük Matsuyama kasabası |
| 1951 | The village of Fukushima | Fukushima köyü |
| 1952 | The city of Izumo | Izumo şehri |
| 1953 | Far East Empire's Trade Center | Uzak Doğu İmparatorluğu'nun ticaret merkezi |
| 1954 | The village of Suo | Suo köyü |
| 1955 | The Glorious city of Nagoya | Görkemli Nagoya şehri |
| 1956 | The Capital of Far East Empire | Uzak Doğu İmparatorluğu'nun başkenti |
| 1957 | The small village of Echigo | Küçük Echigo köyü |
| 1958 | Black Samurai Academy | Kara Samuray Akademisi |
| 1988 | 0 |  |
| 1989 | 0 |  |
| 1990 | 0 |  |
| 1991 | 0 |  |
| 1996 | Click anywhere at the map  / to move your hero. | Kahramanını yürütmek için haritada herhangi bir yere tıkla. |
| 1997 | Show help tips. | İpuçlarını göster. |
| 2036 | Sword Of Storms,Full Plate Of Holy Light x4, | Fırtına Kılıcı, / Kutsal Işık Zırhı x4, |
| 2038 | 1500/2000 |  |
| 2039 | 15000 gp. | 15000 altın |
| 2054 | This is battle screen. Here you'll fight for  / the glory and gold. | Burası savaş ekranı. Burada şan ve altın için dövüşeceksin. |
| 2055 | This is your hero. Control him with WASD  / or directional keys and attack with Space or  / Numpad 0. | Bu senin kahramanın. Onu WASD ya da yön tuşlarıyla yönet; Boşluk ya da Numpad 0 ile saldır. |
| 2056 | These guys are your troops. You have no  / need to order them. They're wise enough to  / fight on their own. | Bunlar senin askerlerin. Onlara emir vermene gerek yok; kendi başlarına dövüşecek kadar akıllılar. |
| 2057 | But if you want them to stop or swap their  / weapons (if they have a weapon to swap  / to), use these buttons. | Ama durmalarını ya da silah değiştirmelerini istersen (değiştirecek silahları varsa) bu düğmeleri kullan. |
| 2058 | The enemies start at the right, at these  / positions. | Düşmanlar sağdan, bu konumlardan başlar. |
| 2059 | If you or your soldiers will get injured, click  / these buttons (or hotkeys 1-6) to use  / healing potions and scrolls. | Sen ya da askerlerin yaralanırsanız şifa iksirlerini ve parşömenleri kullanmak için bu düğmelere (ya da 1-6 tuşlarına) tıkla. |
| 2060 | If there're some bowmen in your reserve  / you can oder them to attack an area by  / klicking this button. Attack will be the most  / powerful when there're 7 or more bowmen  / in reserve. | Yedeğinde okçular varsa bu düğmeye tıklayarak bir alana saldırmalarını emredebilirsin. Yedekte 7 ya da daha fazla okçu varken saldırı en güçlü hâlini alır. |
| 2061 | If there're some crossbowmen in your  / reserve you can oder them to fire a line of  / arrows by klicking this button. Attack will  / be the most powerful when there're 5 or  / more crossbowmen in reserve. / | Yedeğinde arbaletçiler varsa bu düğmeye tıklayarak bir sıra ok atmalarını emredebilirsin. Yedekte 5 ya da daha fazla arbaletçi varken saldırı en güçlü hâlini alır. / |
| 2063 | That's all you need to know. Good luck.  / Gain some levels by killing rogues and then  / recruit a huge army and try to capture a  / small village to gain acces to better troops. | Bilmen gerekenler bu kadar. Bol şans. / Haydutları öldürerek birkaç seviye atla, sonra büyük bir ordu topla ve daha iyi askerlere ulaşmak için küçük bir köyü ele geçirmeye çalış. |

### Feudalism 2

| Kimlik | Yazı | Türkçesi |
|---|---|---|
| 354 | Hold Position / Makes the selected soldiers  / to stay at current position. | Yerini Koru / Seçili askerlerin bulundukları / yerde kalmasını sağlar. |
| 355 | Swap weapons / Switches to ranged and  / back. Some units have no  / weapon to swap. | Silah Değiştir / Menzilli silaha geçer ve geri / döner. Bazı birliklerin / değişecek silahı yoktur. |
| 356 | Small potion [Z key] / Heals 40 HP | Küçük iksir [Z tuşu] / 40 can yeniler |
| 357 | Medium potion [X key] / Heals 300 HP | Orta iksir [X tuşu] / 300 can yeniler |
| 358 | Large potion / Completely heals hero | Büyük iksir / Kahramanı tamamen iyileştirir |
| 359 | Small heal scroll / Heals all your unit for 1/3  / of their max HP. | Küçük şifa parşömeni / Tüm birliklerin canının / 1/3'ünü yeniler. |
| 360 | Large heal scroll / Heals all your unit for 2/3  / of their max HP. | Büyük şifa parşömeni / Tüm birliklerin canının / 2/3'ünü yeniler. |
| 361 | Scroll of rage / Makes your units attack  / much faster. | Öfke parşömeni / Birliklerin çok daha hızlı / saldırır. |
| 362 | Arrow Shower / An area attack, which can  / hurt friendly units too. | Ok Yağmuru / Bir alana saldırır; dost / birliklere de zarar verebilir. |
| 363 | Arrow Wall / An attack which shots  / several crossbow bolts to  / selected positions. | Ok Duvarı / Seçili yerlere birkaç / arbalet oku fırlatan / bir saldırı. |
| 483 | Active Skills | Aktif Beceriler |
| 484 | Aura Skills | Auralar |
| 1714 | Scotland | İskoçya |
| 1721 | England | İngiltere |
| 1965 | NEW GAME | YENİ OYUN |
| 1966 | RESUME GAME | DEVAM ET |
| 1967 | OPTIONS | AYARLAR |
| 1968 | CONTROLS | KONTROLLER |
| 1969 | MORE GAMES | DİĞER OYUNLAR |
| 1970 | PUT THIS GAME ON YOUR SITE | BU OYUNU SİTENE EKLE |
| 1971 | E-MAIL ME | BANA YAZ |
| 1972 | Play Feudalism 1 | Feudalism 1'i oyna |
| 2027 | Choose your hero | Kahramanını seç |
| 2028 | START JOURNEY | YOLA ÇIK |
| 2029 | BACK | GERİ |
| 2044 | Medium / quality | Orta / kalite |
| 2045 | High / quality | Yüksek / kalite |
| 2046 | Low / quality | Düşük / kalite |
| 2049 | Highlight troops | Birlikleri vurgula |
| 2050 | Show help tips | İpuçlarını göster |
| 2051 | Save slot 1 | Kayıt yuvası 1 |
| 2053 | Load | Yükle |
| 2057 | Save slot 2 | Kayıt yuvası 2 |
| 2059 | Save slot 3 | Kayıt yuvası 3 |
| 2061 | Auto save | Otomatik kayıt |
| 2065 | Load game... | Oyun yükle... |
| 2066 | ...which slot? | ...hangi yuva? |
| 2299 | Press a button | Bir tuşa bas |
| 2302 | Move up: | Yukarı: |
| 2303 | Move down: | Aşağı: |
| 2304 | Move left: | Sola: |
| 2305 | Move right: | Sağa: |
| 2306 | Attack: | Saldırı: |
| 2307 | Swap weapons: | Silah değiştir: |
| 2308 | SAVE AND EXIT | KAYDET VE ÇIK |
| 2324 | Special moves | Özel hareketler |
| 2325 | Passive skills | Pasif beceriler |
| 2326 | Aura skills | Auralar |
| 2327 | Nation | Ulus |
| 2328 | Gender | Cinsiyet |
| 2329 | Name: | Ad: |
| 2336 | Choose Difficultly | Zorluk seç |
| 2337 | EASY | KOLAY |
| 2338 | NORMAL | NORMAL |
| 2570 | Your items: | Eşyaların: |
| 2571 | Merchant's items: | Tüccarın eşyaları: |
| 2572 | Drag'n'drop items to buy or sell them for 1/2 of their price | Eşyaları sürükleyip bırakarak al ya da yarı fiyatına sat |
| 2573 | Don't ask amount, just sell all | Miktar sorma, hepsini sat |
| 2576 | SELL ALL | HEPSİNİ SAT |
| 2584 | Refine level | Geliştirme seviyesi |
| 2587 | Rune to enchant | Büyülenecek rün |
| 2588 | Refine! | Geliştir! |
| 2589 | Enchant rune! | Rünü işle! |
| 2612 | Click on a potion or scroll to buy it. Shift-click to by 5 potions per time. | Almak için tıkla; Shift ile tıklarsan 5 tane alırsın. |
| 2616 | Reserve troops - they will fight, when someone from 1st or 2nd line will die | Yedekler: 1. ya da 2. sıradan biri ölünce savaşa girer |
| 2617 | 2nd line | 2 / . sıra |
| 2618 | 1st line | 1 / . sıra |
| 2627 | Troops available to recruit | Toplanabilecek birlikler |
| 2781 | Save | Kaydet |
| 2804 | No, maybe something else? | Hayır, başka bir şey göster. |
| 2814 | Sell your horse | Atını sat |
| 2817 | Click on a horse to buy it. Notice, that some kind of weapons can't be used from a horse | Almak için bir ata tıkla. Bazı silahların at üstünde kullanılamadığını unutma |
| 2818 | Also remember that only bow, crossbow and throwing weapons' special  / moves can be performad from a horse. You can't use any melee  / weapons' special moves when mounted. And it's impossipbe to fight  / with dual wepons, daggers, katars or staffs from a horse. | Şunu da unutma: at üstünde yalnızca yay, arbalet ve fırlatma silahlarının / özel hareketleri yapılabilir. Atlıyken yakın dövüş silahlarının özel / hareketleri kullanılamaz. At üstünde çift silahla, hançerle, katarla / ya da asayla dövüşülemez. |
| 2830 | Okay, let's fight | Peki, dövüşelim |
| 2833 | Duel | Düello |
| 2835 | Fight with army | Orduyla dövüş |
| 2837 | Maybe later... | Belki sonra... |
| 2892 | Special moves | Özel hareketler |
| 2896 | Passive skills | Pasif beceriler |
| 2897 | Auras | Auralar |
| 2920 | View all skill descriptions (opens in a new window) | Bütün beceri açıklamaları (yeni pencerede açılır) |
| 2997 | South Desert | Güney Çölü |
| 3001 | Great Trade Republic | Büyük Ticaret Cumhuriyeti |
| 3005 | Forest Lands | Orman Diyarı |
| 3009 | Black | Kara |
| 3010 | Horde's | Orda'nın |
| 3011 | Lands | Toprakları |
| 3015 | Order of Holy | Kutsal Haç |
| 3016 | Cross | Tarikatı |
| 3020 | Far East | Uzak Doğu |
| 3021 | Empire | İmparatorluğu |
| 3063 | CONTINUE PLAYING | OYUNA DEVAM |
| 3065 | MAIN MENU | ANA MENÜ |
| 3084 | Prepare | Savaşa |
| 3085 | Battle... | olun... |
| 3086 | for | hazır |
| 3095 | Load game? | Oyun yüklensin mi? |
| 3096 | MAIN MENU | ANA MENÜ |
| 3103 | Continue | Devam |
| 3107 | Victory! | Zafer! |
| 3108 | Experience: | Deneyim: |
| 3109 | Gold: | Altın: |
| 3111 | Items obtained: | Kazanılan eşyalar: |
| 3139 | START GAME | OYUNA BAŞLA |

Yazı alanlarının başlangıç değerleri (Feudalism 2): oyun bunların çoğunu çalışırken değiştirir; burada tasarımdaki örnek değerleri var.

| Kimlik | Yazı | Türkçesi |
|---|---|---|
| 46 | miss | ıska |
| 223 | Character throws his dagger at enemy, then jumps, catches the dagger in the air and hits the ground. Flying dagger hits the enemy 3 times, each hit deals 50+10*SkillLv% damage. The ground hit damages all enemies in 5x5 area around the character for 50+20*SkillLv%. |  |
| 225 | Horsemen Defense Mastery |  |
| 226 | Passive skill | Pasif beceri |
| 242 | SP cost: 100 |  |
| 251 | Horseman Twohanded Sword |  |
| 252 | Two Handed Sword |  |
| 253 | Damage: 50-93Critical rate: 10Attack speed +5%Requires 49 STRPrice: 580 |  |
| 257 | Legionary |  |
| 258 | STR: 32DEX: 10CON: 19SPR: 10Price: 100000 |  |
| 265 | 99 |  |
| 338 | HP: 9999 SP: 9999Defense: 500 Dodge: 200Damage: 200-300 (100% crit)Attack speed: 4.88Sword mastery: 73 |  |
| 340 | Strength is a very very very important stat. It is required for using loooots of weapons and armor. You should master it to the max XD |  |
| 351 | 2222/2222 |  |
| 462 | 9999/9999 |  |
| 475 | 9999/9999 |  |
| 479 | 999 |  |
| 480 | 999 |  |
| 490 | 1 |  |
| 492 | 2 |  |
| 493 | 3 |  |
| 494 | 4 |  |
| 495 | 5 |  |
| 496 | 6 |  |
| 1458 | 3000 |  |
| 1464 | OK | Tamam |
| 1467 | Cancel | İptal |
| 1470 | miss | ıska |
| 1624 | miss | ıska |
| 1627 | miss | ıska |
| 1703 | RIP |  |
| 1777 | Click anywhere to skip | Geçmek için tıkla |
| 1949 | Copyright Vitaly Zaborov 2008 | © Vitaly Zaborov 2008 |
| 1950 | v1.02 |  |
| 2018 | ? |  |
| 2019 | Customize | Özelleştir |
| 2021 | ? |  |
| 2022 | Custom Characters Only Available  / from ArcadeTown.com.  Click Here  / to create your own character. | Özel karakterler yalnızca ArcadeTown.com'da açıktır. Kendi karakterini oluşturmak için buraya tıkla. |
| 2037 | Back | Geri |
| 2069 | Hello, wanderer! I'll guide you through the  / basics and teach how to survive in this  / world. | Merhaba yolcu! Sana temel bilgileri anlatacağım ve bu dünyada nasıl hayatta kalacağını öğreteceğim. |
| 2071 | Next | İleri |
| 2130 | This is the screen of your city. There are  / several buildings: | Burası şehir ekranın. Burada birkaç bina var: |
| 2132 | City Hall. Here you can view your hero  / stats, ask for a quest, or declare war on the  / town. | Belediye Sarayı. Burada kahramanının özelliklerine bakabilir, görev isteyebilir ya da şehre savaş açabilirsin. |
| 2134 | Forge. Here you can buy and sell weapons  / and armor. | Demirci. Burada silah ve zırh alıp satabilirsin. |
| 2136 | Barracks. Here you can recruit and disband  / your troops. | Kışla. Burada asker toplayabilir ya da askerlerini terhis edebilirsin. |
| 2138 | Temple. Here you can buy healing potions  / and scrolls. | Tapınak. Burada şifa iksirleri ve parşömenler alabilirsin. |
| 2140 | Also, there're a barn and a harbor in some  / towns. | Bazı şehirlerde ayrıca bir ahır ve bir liman da vardır. |
| 2147 | Once you leave a town, you'll find yourself  / on the world map. | Bir şehirden ayrıldığında kendini dünya haritasında bulursun. |
| 2149 | Click at the map to move your hero. | Kahramanını yürütmek için haritaya tıkla. |
| 2269 | 120/120 |  |
| 2279 | This is battle screen. Here you'll fight for  / the glory and gold. | Burası savaş ekranı. Burada şan ve altın için dövüşeceksin. |
| 2281 | Control your hero with WASD or directional  / keys and attack with Space or Numpad 0 | Kahramanını WASD ya da yön tuşlarıyla yönet; Boşluk ya da Numpad 0 ile saldır. |
| 2283 | These guys are your troops. You have no  / need to order them. They're wise enough to  / fight on their own. | Bunlar senin askerlerin. Onlara emir vermene gerek yok; kendi başlarına dövüşecek kadar akıllılar. |
| 2286 | But if you want them to stop or swap their  / weapons (if they have a weapon to swap  / to), use these buttons. | Ama durmalarını ya da silah değiştirmelerini istersen (değiştirecek silahları varsa) bu düğmeleri kullan. |
| 2288 | The enemies start at the left, at these  / positions. | Düşmanlar soldan, bu konumlardan başlar. |
| 2291 | If you or your soldiers will get injured, click  / these buttons (or hotkeys 1-6) to use  / healing potions and scrolls. | Sen ya da askerlerin yaralanırsanız şifa iksirlerini kullanmak için bu düğmelere tıkla (ya da Z ve X tuşlarına bas). |
| 2293 | That's all I wanted to tell. Now go, and start  / your long journey to the world domination!MWA HA HA HA HAaaaa!!!! | Hepsi bu kadar. Şimdi git, dünyaya hükmetmek için yola çık! / MUHAHAHAHAaaaa!!!! |
| 2316 | Male | Erkek |
| 2318 | Female | Kadın |
| 2330 | Player | Oyuncu |
| 2340 | No army size limits,  / stats does not  / depend on level, max  / stat is 200, your units  / have more HP, no  / attack can hit hero  / for more than 90% of  / his max HP, weapon  / upgrade chances are  / boosted. | Ordu sınırı yok, özellikler seviyeye bağlı değil, en yüksek özellik 200, birliklerin canı daha yüksek, hiçbir saldırı kahramanın canının %90'ından fazlasını götüremez, silah geliştirme şansı yüksek. |
| 2341 | Max army size is 30,  / max stat is 100 and  / depends on level,  / random battles  / happen more often,  / weapon upgrade  / chances are normal. | En büyük ordu 30 kişi, en yüksek özellik 100 ve seviyeye bağlı, rastgele savaşlar daha sık, silah geliştirme şansı normal. |
| 2376 | T i f l i s |  |
| 2401 | City HallHere you can view  / your hero stats, ask  / for a quest, or  / declare war. | Belediye Sarayı / Kahramanına bak, görev iste ya da savaş aç. |
| 2403 | ForgeUpgrade your  / weapons here | Demirci / Silah geliştir. |
| 2405 | BarracksHere you can recruit  / and disbandyour troops. | Kışla / Asker topla ya da terhis et. |
| 2407 | TempleHere you can buy  / healing potionsand scrolls. | Tapınak / Şifa iksirleri ve parşömenler al. |
| 2409 | HarborYou can board a  / ship there totravel by sea. | Liman / Buradan gemiye binip denizden yolculuk edebilirsin. |
| 2411 | BarnBuy and sell horses  / here. | Ahır / Burada at alıp satabilirsin. |
| 2413 | ExitExit to the world  / map. | Çıkış / Dünya haritasına çık. |
| 2415 | Marketplace.Buy and sell items  / here | Pazar yeri / Burada eşya alıp sat. |
| 2418 | Glorious city of Caesarea, capital of Great Trade Republic | Görkemli Caesarea şehri, Büyük Ticaret Cumhuriyeti'nin başkenti |
| 2423 | Inventory | Envanter |
| 2426 | Skills | Beceriler |
| 2432 | 999 |  |
| 2569 | 3000 gold | 3000 altın |
| 2582 | Money: 3000 gold | Para: 3000 altın |
| 2585 | 10 |  |
| 2586 | Success chance: 100%Price: 100000 gold | Başarı şansı: %100 / Fiyat: 100000 altın |
| 2599 | Note: each point of weapon  / refine adds 3 points to base  / damage and increases variable  / part of damage by 10% / These bonuses are not shown  / in weapon stats / | Not: silahın her geliştirme seviyesi temel hasara 3 puan ekler ve hasarın değişken kısmını %10 artırır. / Bu bonuslar silahın özelliklerinde görünmez. / |
| 2608 | 3000 gold | 3000 altın |
| 2609 | Money: | Para: |
| 2610 | 999 |  |
| 2611 | 999 |  |
| 2613 | You don't rule our city! So we won't allow to  / recruit troops here!(You have to capture this town to recruit troops) | Bizi sen yönetmiyorsun! Burada asker toplamana izin vermeyiz! / (Burada asker toplamak için önce bu şehri ele geçirmelisin) |
| 2621 | 3000 gold | 3000 altın |
| 2622 | Money: | Para: |
| 2634 | Michael KlobovLevel 49exp: 99999/10000000 | Michael Klobov / Seviye 49 / deneyim: 99999/10000000 |
| 2635 | 999 |  |
| 2768 | View your hero's stats | Kahramanına bak |
| 2769 | Ask for a quest | Görev iste |
| 2772 | Try to capture this town | Şehri ele geçir |
| 2773 | Fight town  champion | Şehrin şampiyonuyla dövüş |
| 2809 | Michael KlobovLevel 49 | Michael Klobov / Seviye 49 |
| 2815 | 3000 gold | 3000 altın |
| 2816 | Money: | Para: |
| 2822 | Yes! | Evet! |
| 2824 | No.. | Hayır.. |
| 2827 | You don't rule our city!We don't want to sell our troops to strangers!(You need to capture this town to recruit troops  / here) | Bizi sen yönetmiyorsun! / Askerlerimizi yabancılara satmayız! /  / (Burada asker toplamak için önce bu şehri ele geçirmelisin) |
| 2829 | What the... ??Enemy himself has come at our gates! We'll  / punish you for all our captured cities.To arms, my men, to arms!! | Bu da ne...?? / Düşmanın kendisi kapımıza dayandı! Ele geçirdiğin bütün şehirlerimizin hesabını soracağız. /  / Silah başına askerler, silah başına!! |
| 2831 | So, you are challenging me... intersting...Will it be a 1 vs 1 fight or you'll hide behind your  / soldiers' back? | Demek bana meydan okuyorsun... ilginç... /  / Tek başına mı dövüşeceğiz, yoksa askerlerinin arkasına mı saklanacaksın? |
| 2839 | Are you sure want to fight us?! | Bize karşı savaşmak istediğine emin misin?! |
| 2846 | Strength | Güç |
| 2847 | Dexterity | Çeviklik |
| 2848 | Constitution | Dayanıklılık |
| 2849 | Spirit | Ruh |
| 2850 | Sword | Kılıç |
| 2851 | Axe | Balta |
| 2852 | Mace | Topuz |
| 2853 | Staff | Asa |
| 2854 | Far East Weapons | Uzak Doğu |
| 2855 | Dagger | Hançer |
| 2856 | Spear | Mızrak |
| 2857 | Dual Weapons | Çift Silah |
| 2858 | Bow | Yay |
| 2859 | Crossbow | Arbalet |
| 2860 | Throwing | Fırlatma |
| 2861 | 999 |  |
| 2862 | 999 |  |
| 2863 | 999 |  |
| 2864 | 999 |  |
| 2865 | 999 |  |
| 2866 | 999 |  |
| 2867 | 999 |  |
| 2868 | 999 |  |
| 2869 | 999 |  |
| 2870 | 999 |  |
| 2871 | 999 |  |
| 2872 | 999 |  |
| 2873 | 999 |  |
| 2874 | 999 |  |
| 2875 | 999 |  |
| 2890 | Free points | Boş puan |
| 2891 | 999 |  |
| 2893 | Two handed sword skills | İki elli kılıç becerileri |
| 2894 | Two handed axe and mace skills | İki elli balta ve topuz becerileri |
| 2895 | Crossbow skills | Arbalet becerileri |
| 2898 | Lv. 5 | Sv. 5 |
| 2900 | Lv. 5 | Sv. 5 |
| 2901 | Lv. 5 | Sv. 5 |
| 2902 | Lv. 5 | Sv. 5 |
| 2903 | Lv. 5 | Sv. 5 |
| 2904 | Lv. 5 | Sv. 5 |
| 2906 | Lv. 5 / | Sv. 5 / |
| 2907 | Lv. 5 / | Sv. 5 / |
| 2908 | Points left: / | Kalan puan: / |
| 2909 | 50 |  |
| 2910 | Lv. 1 / | Sv. 1 / |
| 2911 | Lv. 1 / | Sv. 1 / |
| 2912 | Lv. 1 / | Sv. 1 / |
| 2913 | Lv. 1 / | Sv. 1 / |
| 2914 | Katar |  |
| 2915 | 999 |  |
| 2918 | ? |  |
| 3028 | Byzantium city | Bizans şehri |
| 3030 | Russian city | Rus şehri |
| 3032 | Mongol city | Moğol şehri |
| 3034 | German village | Alman köyü |
| 3036 | Japaneese village | Japon köyü |
| 3039 | Arabian village | Arap köyü |
| 3041 | Byzantium village | Bizans köyü |
| 3043 | Russian village | Rus köyü |
| 3045 | German city | Alman şehri |
| 3047 | Mongol village | Moğol köyü |
| 3049 | Japaneese city | Japon şehri |
| 3051 | Arabian city | Arap şehri |
| 3078 | Start battle! / | Savaşı başlat! / |
| 3110 | Sword Of Storms,Full Plate Of Holy Light x4, | Fırtına Kılıcı, / Kutsal Işık Zırhı x4, |
| 3112 | 1500/2000 |  |
| 3113 | 15000 gp. | 15000 altın |
| 3125 | If you see this message on any other site please  / contact developer by email: zaborov@mail.ru / If you're a webmaster and want to place Feudalism 2  / on your site please take the game from this link: / |  |
| 3126 | This version were probably  / stolen from ArmorGames.Com  / or AddictingGames.com |  |
| 3127 | ЭТУ ИГРУ СПЕРЛИ!!! |  |
| 3128 | it is absolutely free and the game is the same. |  |
| 3129 | And the last thing. If somehow happened that this message appears on  / ArmorGames.com or AddictingGames.com please contact me ASAP and I'll fix it  / as fast as I can. |  |
| 3130 | http://www.arcadetown.com/free_content/index.asp / |  |
| 3132 | The game is playable at ArcadeTown / |  |
| 3136 | Skip | Geç |
