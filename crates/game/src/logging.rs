//! Günlük: iletiler hem hata çıktısına hem de bir dosyaya yazılır.
//!
//! Dosya Windows'ta `%LOCALAPPDATA%\Proje\gunluk.txt` konumundadır. Oyun beklenmedik biçimde
//! kapanırsa bu dosya hatanın nedenini gösterir.

use std::fs::File;
use std::io::Write;
use std::path::PathBuf;
use std::sync::Mutex;

struct Logger {
    file: Option<Mutex<File>>,
}

impl log::Log for Logger {
    fn enabled(&self, metadata: &log::Metadata) -> bool {
        metadata.level() <= log::Level::Info
    }

    fn log(&self, record: &log::Record) {
        if !self.enabled(record.metadata()) {
            return;
        }
        let line = format!("[{}] {}\n", level_name(record.level()), record.args());
        eprint!("{line}");
        if let Some(file) = &self.file
            && let Ok(mut f) = file.lock()
        {
            let _ = f.write_all(line.as_bytes());
            let _ = f.flush();
        }
    }

    fn flush(&self) {}
}

fn level_name(level: log::Level) -> &'static str {
    match level {
        log::Level::Error => "HATA",
        log::Level::Warn => "UYARI",
        log::Level::Info => "BİLGİ",
        log::Level::Debug => "AYRINTI",
        log::Level::Trace => "İZ",
    }
}

/// Kullanıcı verilerinin klasörü (kayıtlar, ayarlar, günlük).
pub fn data_dir() -> Option<PathBuf> {
    if cfg!(windows) {
        std::env::var_os("LOCALAPPDATA").map(|p| PathBuf::from(p).join("Proje"))
    } else {
        std::env::var_os("XDG_DATA_HOME")
            .map(PathBuf::from)
            .or_else(|| std::env::var_os("HOME").map(|h| PathBuf::from(h).join(".local/share")))
            .map(|p| p.join("proje"))
    }
}

/// Günlüğü kurar; günlük dosyasının yolunu döndürür.
pub fn init() -> Option<PathBuf> {
    let path = data_dir().map(|d| d.join("gunluk.txt"));
    let file = path.as_ref().and_then(|p| {
        std::fs::create_dir_all(p.parent()?).ok()?;
        File::create(p).ok()
    });
    let logger = Box::new(Logger {
        file: file.map(Mutex::new),
    });
    if log::set_boxed_logger(logger).is_ok() {
        log::set_max_level(log::LevelFilter::Info);
    }
    std::panic::set_hook(Box::new(|info| {
        log::error!("beklenmedik hata: {info}");
    }));
    path
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn level_names_are_turkish() {
        assert_eq!(level_name(log::Level::Error), "HATA");
        assert_eq!(level_name(log::Level::Info), "BİLGİ");
    }

    #[test]
    fn data_dir_is_named_after_the_game() {
        if let Some(d) = data_dir() {
            let name = d.file_name().unwrap().to_string_lossy().to_lowercase();
            assert_eq!(name, "proje");
        }
    }
}
