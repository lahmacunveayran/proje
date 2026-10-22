//! İçerik klasörünü (`content/`) oyunun içine gömer: oyun tek bir `.exe` dosyasından çalışır.

use std::error::Error;
use std::path::{Path, PathBuf};

fn collect(
    dir: &Path,
    root: &Path,
    out: &mut Vec<(String, PathBuf)>,
) -> Result<(), Box<dyn Error>> {
    let mut entries: Vec<_> = std::fs::read_dir(dir)?.collect::<Result<_, _>>()?;
    entries.sort_by_key(|e| e.file_name());
    for entry in entries {
        let path = entry.path();
        if path.is_dir() {
            collect(&path, root, out)?;
        } else {
            let rel = path
                .strip_prefix(root)?
                .components()
                .map(|c| c.as_os_str().to_string_lossy().into_owned())
                .collect::<Vec<_>>()
                .join("/");
            out.push((rel, path));
        }
    }
    Ok(())
}

fn main() -> Result<(), Box<dyn Error>> {
    let manifest = PathBuf::from(std::env::var("CARGO_MANIFEST_DIR")?);
    let content = manifest.join("../../content").canonicalize()?;
    println!("cargo:rerun-if-changed={}", content.display());
    let mut files = Vec::new();
    collect(&content, &content, &mut files)?;
    let mut code = String::from(
        "/// Oyuna gömülü içerik dosyaları.\npub static EMBEDDED: &[(&str, &[u8])] = &[\n",
    );
    for (rel, abs) in files {
        code.push_str(&format!(
            "    ({rel:?}, include_bytes!({:?})),\n",
            abs.display().to_string()
        ));
    }
    code.push_str("];\n");
    let out = PathBuf::from(std::env::var("OUT_DIR")?);
    std::fs::write(out.join("embedded_content.rs"), code)?;
    Ok(())
}
