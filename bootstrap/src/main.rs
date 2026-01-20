mod ast;
mod codegen_c;
mod lexer;
mod loader;
mod parser;

use std::env;
use std::path::{Path, PathBuf};
use std::process::Command;

fn main() {
    let mut args = env::args().skip(1);
    let input = match args.next() {
        Some(a) => a,
        None => {
            eprintln!("usage: unhingedc <input.uh|dir> -o <output> [--emit-c <path>]");
            std::process::exit(2);
        }
    };

    let mut output: Option<String> = None;
    let mut emit_c: Option<String> = None;
    while let Some(arg) = args.next() {
        if arg == "-o" {
            output = args.next();
            continue;
        }
        if arg == "--emit-c" {
            emit_c = args.next();
            continue;
        }
    }
    let output = match output {
        Some(o) => o,
        None => {
            eprintln!("error: missing -o <output.c>");
            std::process::exit(2);
        }
    };

    let input_path = PathBuf::from(input);
    let output_path = PathBuf::from(output);

    let sources = match loader::load_sources(&input_path) {
        Ok(s) => s,
        Err(e) => {
            eprintln!("error: {e}");
            std::process::exit(1);
        }
    };

    let mut programs = Vec::new();
    for source in sources {
        let tokens = match lexer::tokenize(&source.contents, &source.name) {
            Ok(t) => t,
            Err(e) => {
                eprintln!("error: {e}");
                std::process::exit(1);
            }
        };
        let mut p = parser::Parser::new(tokens, &source.name);
        let prog = match p.parse_program() {
            Ok(pr) => pr,
            Err(e) => {
                eprintln!("error: {e}");
                std::process::exit(1);
            }
        };
        programs.push(prog);
    }

    let mut functions = Vec::new();
    let mut main_stmts = Vec::new();
    for prog in &programs {
        functions.extend(prog.functions.clone());
        main_stmts.extend(prog.main.stmts.clone());
    }

    let merged = ast::Program {
        functions,
        main: ast::Block { stmts: main_stmts },
    };

    let func_arity = parser::collect_functions(&programs);

    let output_c = match codegen_c::emit_c(&merged, &func_arity) {
        Ok(c) => c,
        Err(e) => {
            eprintln!("error: {e}");
            std::process::exit(1);
        }
    };

    let keep_c = emit_c.is_some();
    let c_path = if let Some(path) = emit_c {
        PathBuf::from(path)
    } else {
        temp_c_path(&output_path)
    };

    if let Err(e) = std::fs::write(&c_path, output_c) {
        eprintln!("error: failed to write {}: {e}", c_path.display());
        std::process::exit(1);
    }

    if let Err(e) = compile_c(&c_path, &output_path) {
        eprintln!("error: {e}");
        std::process::exit(1);
    }

    if !keep_c {
        let _ = std::fs::remove_file(&c_path);
    }
}

fn temp_c_path(output: &Path) -> PathBuf {
    let mut path = output.to_path_buf();
    let file = output
        .file_name()
        .and_then(|n| n.to_str())
        .unwrap_or("unhinged_out");
    let tmp = format!("{file}.c");
    path.set_file_name(tmp);
    path
}

fn compile_c(c_path: &Path, output: &Path) -> Result<(), String> {
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let root = manifest_dir
        .parent()
        .ok_or_else(|| "failed to locate repo root".to_string())?;
    let runtime_c = root.join("runtime").join("rt.c");
    let include_dir = root.to_path_buf();

    let status = Command::new("cc")
        .arg(c_path)
        .arg(runtime_c)
        .arg("-I")
        .arg(include_dir)
        .arg("-lm")
        .arg("-lcurl")
        .arg("-lsqlite3")
        .arg("-lpthread")
        .arg("-o")
        .arg(output)
        .status()
        .map_err(|e| format!("failed to invoke cc: {e}"))?;
    if !status.success() {
        return Err(format!("cc failed with status {status}"));
    }
    Ok(())
}
