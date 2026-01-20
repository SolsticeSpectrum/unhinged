use std::collections::HashSet;
use std::cmp::Ordering;
use std::fs;
use std::path::{Path, PathBuf};

use crate::lexer::{self, TokenKind};

#[derive(Debug, Clone)]
pub struct Source {
    pub name: String,
    pub contents: String,
}

pub fn load_sources(input: &Path) -> Result<Vec<Source>, String> {
    if input.is_file() {
        let mut seen = HashSet::new();
        return load_file_recursive(input, &mut seen);
    }

    if !input.is_dir() {
        return Err(format!("input path not found: {}", input.display()));
    }

    let mut root = input.to_path_buf();
    let src = input.join("src");
    if src.is_dir() {
        root = src;
    }

    let main_file = root.join("main.uh");
    if main_file.is_file() {
        let mut seen = HashSet::new();
        return load_file_recursive(&main_file, &mut seen);
    }

    let mut files = Vec::new();
    collect_uh_files(&root, &mut files)?;
    if files.is_empty() {
        return Err(format!("no .uh files found under {}", root.display()));
    }

    files.sort_by(|a, b| {
        if a.file_name().map(|n| n == "main.uh").unwrap_or(false) {
            return Ordering::Greater;
        }
        if b.file_name().map(|n| n == "main.uh").unwrap_or(false) {
            return Ordering::Less;
        }
        a.cmp(b)
    });

    let mut sources = Vec::new();
    for file in files {
        let contents = fs::read_to_string(&file)
            .map_err(|e| format!("failed to read {}: {e}", file.display()))?;
        sources.push(Source {
            name: file.display().to_string(),
            contents,
        });
    }

    Ok(sources)
}

fn collect_uh_files(dir: &Path, out: &mut Vec<PathBuf>) -> Result<(), String> {
    for entry in fs::read_dir(dir)
        .map_err(|e| format!("failed to read {}: {e}", dir.display()))?
    {
        let entry = entry.map_err(|e| format!("failed to read dir entry: {e}"))?;
        let path = entry.path();
        if path.is_dir() {
            collect_uh_files(&path, out)?;
            continue;
        }
        if path.extension().and_then(|s| s.to_str()) == Some("uh") {
            out.push(path);
        }
    }
    Ok(())
}

fn load_file_recursive(path: &Path, seen: &mut HashSet<PathBuf>) -> Result<Vec<Source>, String> {
    let canonical = path
        .canonicalize()
        .map_err(|e| format!("failed to read {}: {e}", path.display()))?;
    if !seen.insert(canonical.clone()) {
        return Ok(Vec::new());
    }

    let contents = fs::read_to_string(&canonical)
        .map_err(|e| format!("failed to read {}: {e}", canonical.display()))?;
    let imports = extract_imports(&contents, &canonical)?;
    let mut sources = Vec::new();
    for import in imports {
        sources.extend(load_file_recursive(&import, seen)?);
    }
    sources.push(Source {
        name: canonical.display().to_string(),
        contents,
    });
    Ok(sources)
}

fn extract_imports(contents: &str, base: &Path) -> Result<Vec<PathBuf>, String> {
    let tokens = lexer::tokenize(contents, &base.display().to_string())
        .map_err(|e| format!("{e}"))?;
    let mut imports = Vec::new();
    let mut i = 0usize;
    while i + 3 < tokens.len() {
        let t0 = &tokens[i];
        let t1 = &tokens[i + 1];
        let t2 = &tokens[i + 2];
        let t3 = &tokens[i + 3];
        if let TokenKind::String(path_str) = &t0.kind {
            if matches!(&t1.kind, TokenKind::Symbol(s) if s == "⟪")
                && matches!(&t2.kind, TokenKind::Ident(name) if name == "import" || name == ".import")
                && matches!(&t3.kind, TokenKind::Symbol(s) if s == "⟫")
            {
                let import_path = resolve_import_path(base, path_str);
                imports.push(import_path);
            }
        }
        i += 1;
    }
    Ok(imports)
}

fn resolve_import_path(base: &Path, raw: &str) -> PathBuf {
    let mut path = PathBuf::from(raw);
    if path.extension().is_none() {
        path.set_extension("uh");
    }
    if path.is_absolute() {
        return path;
    }
    if let Some(dir) = base.parent() {
        return dir.join(path);
    }
    path
}
