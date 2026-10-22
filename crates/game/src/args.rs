//! Komut satırı seçenekleri.

use std::fmt;
use std::path::PathBuf;

use engine::glam::UVec2;

pub const HELP: &str = "Kullanım: oyun [seçenekler]

  --goruntu <dosya.png>   Deneme sahnesini pencere açmadan resme çizer ve çıkar
  --boyut <GxY>           --goruntu için resim boyu (varsayılan 1920x1080)
  --icerik <klasör>       İçeriği önce bu klasörden okur
  --tam-ekran             Tam ekran açılır
  --surum                 Sürümü yazar
  --yardim                Bu yardımı yazar";

#[derive(Clone, Debug, Default, PartialEq)]
pub struct Args {
    pub screenshot: Option<PathBuf>,
    pub size: Option<UVec2>,
    pub content: Option<PathBuf>,
    pub fullscreen: bool,
    pub version: bool,
    pub help: bool,
}

#[derive(Debug, PartialEq)]
pub struct ArgsError(pub String);

impl fmt::Display for ArgsError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}\n\n{HELP}", self.0)
    }
}

impl std::error::Error for ArgsError {}

fn parse_size(s: &str) -> Option<UVec2> {
    let (w, h) = s.split_once(['x', 'X', '×'])?;
    let size = UVec2::new(w.trim().parse().ok()?, h.trim().parse().ok()?);
    (size.x > 0 && size.y > 0 && size.x <= 16384 && size.y <= 16384).then_some(size)
}

impl Args {
    pub fn parse(args: impl IntoIterator<Item = String>) -> Result<Args, ArgsError> {
        let mut out = Args::default();
        let mut it = args.into_iter();
        while let Some(arg) = it.next() {
            let mut value = |name: &str| {
                it.next()
                    .ok_or_else(|| ArgsError(format!("{name} seçeneği bir değer bekliyor")))
            };
            match arg.as_str() {
                "--goruntu" => out.screenshot = Some(PathBuf::from(value("--goruntu")?)),
                "--boyut" => {
                    let v = value("--boyut")?;
                    out.size = Some(
                        parse_size(&v).ok_or_else(|| ArgsError(format!("geçersiz boyut: {v}")))?,
                    );
                }
                "--icerik" => out.content = Some(PathBuf::from(value("--icerik")?)),
                "--tam-ekran" => out.fullscreen = true,
                "--surum" => out.version = true,
                "--yardim" | "-h" | "--help" => out.help = true,
                other => return Err(ArgsError(format!("bilinmeyen seçenek: {other}"))),
            }
        }
        Ok(out)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn parse(s: &str) -> Result<Args, ArgsError> {
        Args::parse(s.split_whitespace().map(String::from))
    }

    #[test]
    fn empty_args() {
        assert_eq!(parse("").unwrap(), Args::default());
    }

    #[test]
    fn screenshot_with_size() {
        let a = parse("--goruntu cikti.png --boyut 3840x2160").unwrap();
        assert_eq!(a.screenshot, Some(PathBuf::from("cikti.png")));
        assert_eq!(a.size, Some(UVec2::new(3840, 2160)));
    }

    #[test]
    fn flags() {
        let a = parse("--tam-ekran --surum --icerik dene").unwrap();
        assert!(a.fullscreen && a.version);
        assert_eq!(a.content, Some(PathBuf::from("dene")));
    }

    #[test]
    fn errors() {
        assert!(parse("--goruntu").is_err());
        assert!(parse("--boyut 0x100").is_err());
        assert!(parse("--boyut genis").is_err());
        assert!(parse("--bilinmeyen").is_err());
    }
}
