mod ast;
mod codegen_llvm;
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
            eprintln!("usage: unhingedc <input.uh|dir> -o <output> [--emit-llvm <path>]");
            std::process::exit(2);
        }
    };

    let mut output: Option<String> = None;
    let mut emit_llvm: Option<String> = None;
    while let Some(arg) = args.next() {
        if arg == "-o" {
            output = args.next();
            continue;
        }
        if arg == "--emit-llvm" {
            emit_llvm = args.next();
            continue;
        }
    }
    let output = match output {
        Some(o) => o,
        None => {
            eprintln!("error: missing -o <output>");
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

    let output_llvm = match codegen_llvm::emit_llvm(&merged, &func_arity) {
        Ok(c) => c,
        Err(e) => {
            eprintln!("error: {e}");
            std::process::exit(1);
        }
    };

    let keep_llvm = emit_llvm.is_some();
    let ll_path = if let Some(path) = emit_llvm {
        PathBuf::from(path)
    } else {
        temp_ll_path(&output_path)
    };

    if let Err(e) = std::fs::write(&ll_path, output_llvm) {
        eprintln!("error: failed to write {}: {e}", ll_path.display());
        std::process::exit(1);
    }

    if let Err(e) = compile_llvm(&ll_path, &output_path) {
        eprintln!("error: {e}");
        std::process::exit(1);
    }

    if !keep_llvm {
        let _ = std::fs::remove_file(&ll_path);
    }
}

fn temp_ll_path(output: &Path) -> PathBuf {
    let mut path = output.to_path_buf();
    let file = output
        .file_name()
        .and_then(|n| n.to_str())
        .unwrap_or("unhinged_out");
    let tmp = format!("{file}.ll");
    path.set_file_name(tmp);
    path
}

fn compile_llvm(ll_path: &Path, output: &Path) -> Result<(), String> {
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let root = manifest_dir
        .parent()
        .ok_or_else(|| "failed to locate repo root".to_string())?;
    let runtime_src = root.join("runtime").join("rt.c");
    let runtime_ll = ll_path.with_extension("rt.ll");
    let runtime_obj = ll_path.with_extension("rt.o");
    let obj_path = ll_path.with_extension("o");

    let status = Command::new("clang")
        .arg("-S")
        .arg("-emit-llvm")
        .arg("-O2")
        .arg("-o")
        .arg(&runtime_ll)
        .arg(&runtime_src)
        .status()
        .map_err(|e| format!("failed to invoke clang for runtime: {e}"))?;
    if !status.success() {
        return Err(format!("clang runtime failed with status {status}"));
    }

    let status = Command::new("llc")
        .arg("-filetype=obj")
        .arg(&runtime_ll)
        .arg("-o")
        .arg(&runtime_obj)
        .status()
        .map_err(|e| format!("failed to invoke llc for runtime: {e}"))?;
    if !status.success() {
        return Err(format!("llc runtime failed with status {status}"));
    }

    let status = Command::new("llc")
        .arg("-filetype=obj")
        .arg(ll_path)
        .arg("-o")
        .arg(&obj_path)
        .status()
        .map_err(|e| format!("failed to invoke llc for program: {e}"))?;
    if !status.success() {
        return Err(format!("llc program failed with status {status}"));
    }

    let status = Command::new("cc")
        .arg(&obj_path)
        .arg(&runtime_obj)
        .arg("-no-pie")
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
    let _ = std::fs::remove_file(&obj_path);
    Ok(())
}
