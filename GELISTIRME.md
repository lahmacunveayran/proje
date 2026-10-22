# Geliştirme

## Belgeler

- [docs/TASARIM.md](docs/TASARIM.md): oyunun tasarımı
- [docs/MOTOR.md](docs/MOTOR.md): motorun kararları ve yapısı
- [docs/YOL_HARITASI.md](docs/YOL_HARITASI.md): aşamalar ve yapılacaklar
- [docs/gunluk/](docs/gunluk/): geliştirme günlüğü; her çalışma gününün sonunda ne yapıldığı,
  durum ve sıradaki adım

## Gerekenler

- Rust: https://rustup.rs (sürüm `rust-toolchain.toml` dosyasında sabittir; rustup doğru sürümü kendisi kurar)
- Linux'ta derlemek için: `libx11-dev libxkbcommon-dev libwayland-dev` ve bir Vulkan sürücüsü.
  Ekransız görüntü testleri için grafik kartı gerekmez: `mesa-vulkan-drivers` (lavapipe) yeterlidir.

## Komutlar

Hepsi depo kökünde çalıştırılır.

| İş                          | Komut                                                     |
| --------------------------- | --------------------------------------------------------- |
| Oyunu çalıştır              | `cargo run -p game`                                       |
| Testler                     | `cargo test --workspace`                                  |
| Beklenen resimleri yenile   | `UPDATE_SNAPSHOTS=1 cargo test --workspace`               |
| Biçim                       | `cargo fmt --all` (denetim: `cargo fmt --all --check`)    |
| Lint                        | `cargo clippy --workspace --all-targets -- -D warnings`   |
| Lisans denetimi             | `cargo deny check licenses bans sources`                  |
| Sürüm derlemesi             | `cargo build --release -p game`                           |
| Açılış ekranını resme çiz   | `cargo run -p game -- --goruntu cikti.png --boyut 1600x1200` |
| Bir SVG'yi resme çiz        | `cargo run -p engine --example svg-png -- girdi.svg cikti.png 2` |
| Oyunları eksiksiz çıkar ve aktar | `araclar/aktar/cikar.sh` → `referans/` (git dışı yerel arşiv) ve `content/feudalism/` |
| Feudalism içeriğini ve Türkçe çeviriyi aktar | `python3 araclar/aktar/aktar.py` → `content/feudalism/`, `content/fonts/` (önce `araclar/aktar/cikar.sh`) |
| Aktarım aracının testleri   | `python3 -m unittest discover -s araclar/aktar -p 'test_*.py'` |
| Oyunların içerik dökümü     | `python3 araclar/aktar/envanter.py` → `docs/FEUDALISM_ICERIK.md` |
| Ayıklama denetimi           | `python3 araclar/aktar/denetim.py --gorsel` → `docs/AYIKLAMA_DENETIMI.md` (önce `cargo build --release -p engine --example svg-batch`) |
| Çok sayıda SVG'yi resme çiz | `cargo run --release -p engine --example svg-batch -- liste.txt` (satır: `girdi.svg<TAB>cikti.png<TAB>ölçek`) |
| Feudalism'in bir ekranını çiz | `cargo run --release -p engine --example movie-png -- content feudalism/f1 4 menu.png` (kök filmin 4. karesi; kare yerine `sprite:1480:1` bir sprite'ı çizer; sona `800 0 orijinal` eklenirse yazılar İngilizce) |

Görüntü testleri (Feudalism ekranları, `crates/game/tests/reference/`): çizilen ve fark resimleri `target/goruntu-testleri/` altına yazılır. Bir test
"beklenen resim yok" ya da "farklı" derse önce bu resimlere bakılır; değişiklik bilerek yapıldıysa
beklenen resimler `UPDATE_SNAPSHOTS=1` ile yenilenir ve değişiklikle birlikte commit edilir.

## Kurallar

Dil:

- Kod tanımlayıcıları (değişken, işlev, tür adları) İngilizce; yorumlar, belgeler, commit mesajları ve
  oyunda görünen metinler Türkçe.
- Commit mesajlarının ilk satırı kısa ve emir kipinde ("Savaşa moral ekle"). Mesajın sonuna ek imza
  ya da etiket satırı eklenmez.
- Commit'ler `gozlemesevdalisi <333462860+gozlemesevdalisi@users.noreply.github.com>` adıyla atılır
  (depoda `git config user.name` ve `user.email` ile ayarlıdır).

Kod:

- `cargo fmt` ve `cargo clippy -D warnings` temiz olmadan push yapılmaz.
- `unsafe` kullanılmaz.
- Kütüphane kodunda `unwrap()`/`expect()`/`panic!` yerine hata türleri döndürülür (testler hariç).
- `sim` grafik, pencere ya da ses kütüphanesine bağlanmaz ve belirlenimci kalır (bkz. MOTOR.md).
- Oyun içeriği ve metinler koda gömülmez, `content/` altındaki veri dosyalarına yazılır.
- Her yeni işlev testleriyle gelir. Bir hata düzeltilirken önce o hatayı yakalayan test yazılır.

Görseller ve lisanslar:

- Oyunun bütün görselleri Feudalism 1 ve 2'nin kendi görselleridir; hak sahibinin izniyle kullanılır
  (bkz. `docs/LISANSLAR.md`). Yeni çizim yapılmaz (sahibin kararı, 16 Ekim 2026).
- Görseller `araclar/aktar/aktar.py` ile orijinal SWF dosyalarından `content/feudalism/` altına
  aktarılır; elle değiştirilmez. Oyunun yazarına ait olmayanlar aktarılmaz: sponsor logoları,
  Macromedia/Adobe arayüz bileşenleri, gömülü yazı tipleri.
- Türkçe metinler oyunların sahibinin çevirisinden gelir (`swf-oyunlar/oyunlar/<oyun>/ceviri/`). Tablolar
  orada durur; aktarım aracı onları değiştirmeden `content/feudalism/<oyun>/ceviri/` altına kopyalar ve
  her girdinin hedefini doğrular (tutmayan girdi aktarımı durdurur). Bu depodan `swf-oyunlar`'a hiçbir
  şey yazılmaz; çeviride değişiklik gerekirse sahibine sorulur.
- Oyunların gömülü yazı tipleri aktarılmaz; yazılar açık lisanslı karşılıklarıyla çizilir (Liberation,
  TeX Gyre; eşleme `texts.json` → `fonts.<kimlik>.file`, ayrıntı `docs/LISANSLAR.md`).
- Aktarım aracı ya da motorun çizimi değiştiğinde `python3 araclar/aktar/denetim.py --gorsel`
  çalıştırılır ve "Toplam sorun: 0" ile bitmelidir. Denetim her kaydı FFDec'in bağımsız XML dökümüyle,
  her şekli FFDec'in çizimiyle piksel piksel karşılaştırır (rapor: `docs/AYIKLAMA_DENETIMI.md`).
- Dışarıdan alınan her varlık (yazı tipi, ses, müzik) eklenmeden önce lisansı doğrulanır ve kaynağıyla
  birlikte `docs/LISANSLAR.md` içine yazılır. AGPL ve ticari kullanımı yasaklayan lisanslar kabul edilmez.

Görsel güvenlik:

- Hiçbir efekt saniyede 3'ten fazla parlama üretmez; ani tam ekran beyaz ya da kırmızı geçiş yoktur.

## Yayın

- Her gönderimde (hangi dal olursa olsun) GitHub Actions çalışır (`.github/workflows/derleme.yml`):
  Linux'ta biçim, lint ve testler; lisans denetimi; ardından Windows'ta testler ve sürüm derlemesi.
  Hepsi geçerse `oyun.exe` "test-surumu" Release'ine konur. İndirme linki sabittir:
  https://github.com/lahmacunveayran/proje/releases/download/test-surumu/oyun.exe
- Rust sürümü `rust-toolchain.toml` ve iş akışında birlikte sabittir; yükseltirken ikisi birlikte değişir.
- Sürüm numarası `Cargo.toml` (çalışma alanı) içindedir.
