use std::collections::HashMap;

use crate::ast::{Block, Expr, ExprToken, Function, Program, Stmt};

struct EmitCtx {
    out: String,
    strings: Vec<String>,
    string_map: HashMap<String, usize>,
    temp_id: usize,
    label_id: usize,
    loop_stack: Vec<(String, String)>,
    allocas: Vec<String>,
}

impl EmitCtx {
    fn new() -> Self {
        Self {
            out: String::new(),
            strings: Vec::new(),
            string_map: HashMap::new(),
            temp_id: 0,
            label_id: 0,
            loop_stack: Vec::new(),
            allocas: Vec::new(),
        }
    }

    fn next_tmp(&mut self) -> String {
        let id = self.temp_id;
        self.temp_id += 1;
        format!("%t{id}")
    }

    fn next_label(&mut self, prefix: &str) -> String {
        let id = self.label_id;
        self.label_id += 1;
        format!("{prefix}{id}")
    }

    fn string_const(&mut self, value: &str) -> (usize, usize) {
        if let Some(&idx) = self.string_map.get(value) {
            return (idx, value.as_bytes().len() + 1);
        }
        let idx = self.strings.len();
        self.string_map.insert(value.to_string(), idx);
        self.strings.push(value.to_string());
        (idx, value.as_bytes().len() + 1)
    }

    fn emit_str_ptr(&mut self, value: &str) -> String {
        let (idx, len) = self.string_const(value);
        let tmp = self.next_tmp();
        self.out.push_str(&format!(
            "  {tmp} = getelementptr [{len} x i8], ptr @.str.{idx}, i64 0, i64 0\n"
        ));
        tmp
    }
}

fn fmt_double(v: f64) -> String {
    let s = format!("{v}");
    if s.contains('.') || s.contains('e') || s.contains('E') {
        s
    } else {
        format!("{s}.0")
    }
}

pub fn emit_llvm(program: &Program, func_arity: &HashMap<String, usize>) -> Result<String, String> {
    let mut ctx = EmitCtx::new();
    emit_header(&mut ctx);

    for func in &program.functions {
        emit_function(&mut ctx, func, func_arity)?;
        ctx.out.push('\n');
    }

    emit_dispatcher(&mut ctx, program);
    ctx.out.push('\n');

    emit_main(&mut ctx, program, func_arity)?;
    emit_string_globals(&mut ctx);
    Ok(ctx.out)
}

fn emit_header(ctx: &mut EmitCtx) {
    ctx.out.push_str("; ModuleID = 'unhinged'\n");
    ctx.out
        .push_str("target triple = \"x86_64-unknown-linux-gnu\"\n\n");

    ctx.out.push_str("%UhValue = type { i32, double, ptr, ptr, ptr }\n");
    ctx.out.push_str("%UhArray = type { ptr, i64, i64 }\n");
    ctx.out.push_str("%UhDictEntry = type { ptr, %UhValue }\n");
    ctx.out.push_str("%UhDict = type { ptr, i64, i64 }\n");
    ctx.out.push_str("%UhVar = type { ptr, %UhValue, ptr }\n");
    ctx.out.push_str("%UhEnv = type { ptr, ptr }\n");
    ctx.out.push_str("%UhStack = type { ptr, i64, i64 }\n\n");

    ctx.out.push_str("declare void @uh_env_init(ptr, ptr)\n");
    ctx.out.push_str("declare void @uh_env_get(ptr sret(%UhValue), ptr, ptr)\n");
    ctx.out.push_str("declare void @uh_env_set(ptr, ptr, ptr byval(%UhValue))\n");
    ctx.out.push_str("declare void @uh_stack_init(ptr)\n");
    ctx.out.push_str("declare void @uh_stack_push(ptr, ptr byval(%UhValue))\n");
    ctx.out.push_str("declare void @uh_stack_pop(ptr sret(%UhValue), ptr)\n");
    ctx.out.push_str("declare void @uh_stack_clear(ptr)\n");

    ctx.out.push_str("declare void @uh_num(ptr sret(%UhValue), double)\n");
    ctx.out.push_str("declare void @uh_str(ptr sret(%UhValue), ptr)\n");
    ctx.out.push_str("declare void @uh_null(ptr sret(%UhValue))\n");
    ctx.out.push_str("declare void @uh_arr_new(ptr sret(%UhValue))\n");
    ctx.out.push_str("declare void @uh_arr_push(ptr, ptr byval(%UhValue))\n");
    ctx.out.push_str("declare void @uh_dict_new(ptr sret(%UhValue))\n");
    ctx.out.push_str("declare void @uh_dict_set(ptr, ptr byval(%UhValue), ptr byval(%UhValue))\n");

    ctx.out.push_str("declare i32 @uh_value_eq(ptr byval(%UhValue), ptr byval(%UhValue))\n");
    ctx.out.push_str("declare i32 @uh_cmp(ptr byval(%UhValue), ptr byval(%UhValue))\n");
    ctx.out.push_str("declare i32 @uh_is_true(ptr byval(%UhValue))\n");
    ctx.out.push_str("declare i32 @uh_contains(ptr byval(%UhValue), ptr byval(%UhValue))\n");
    ctx.out.push_str("declare void @uh_concat(ptr sret(%UhValue), ptr byval(%UhValue), ptr byval(%UhValue))\n");
    ctx.out.push_str("declare void @uh_index(ptr sret(%UhValue), ptr byval(%UhValue), ptr byval(%UhValue))\n");
    ctx.out.push_str("declare void @uh_store_index(ptr, ptr byval(%UhValue), ptr byval(%UhValue))\n");
    ctx.out.push_str("declare void @uh_stringify(ptr sret(%UhValue), ptr byval(%UhValue))\n");
    ctx.out.push_str("declare void @uh_print(ptr byval(%UhValue))\n");

    ctx.out.push_str("declare void @uh_import(ptr sret(%UhValue), ptr byval(%UhValue))\n");
    ctx.out.push_str("declare void @uh_args(ptr sret(%UhValue))\n");
    ctx.out.push_str("declare void @uh_len(ptr sret(%UhValue), ptr byval(%UhValue))\n");
    ctx.out.push_str("declare void @uh_append(ptr sret(%UhValue), ptr byval(%UhValue), ptr byval(%UhValue))\n");
    ctx.out.push_str("declare void @uh_split(ptr sret(%UhValue), ptr byval(%UhValue), ptr byval(%UhValue))\n");
    ctx.out.push_str("declare void @uh_join(ptr sret(%UhValue), ptr byval(%UhValue), ptr byval(%UhValue))\n");
    ctx.out.push_str("declare void @uh_substr(ptr sret(%UhValue), ptr byval(%UhValue), ptr byval(%UhValue), ptr byval(%UhValue))\n");
    ctx.out.push_str("declare void @uh_char_at(ptr sret(%UhValue), ptr byval(%UhValue), ptr byval(%UhValue))\n");
    ctx.out.push_str("declare void @uh_hex(ptr sret(%UhValue), ptr byval(%UhValue))\n");
    ctx.out.push_str("declare void @uh_read_file(ptr sret(%UhValue), ptr byval(%UhValue))\n");
    ctx.out.push_str("declare void @uh_write_file(ptr sret(%UhValue), ptr byval(%UhValue), ptr byval(%UhValue))\n");
    ctx.out.push_str("declare void @uh_syscall(ptr sret(%UhValue), ptr byval(%UhValue))\n");
    ctx.out.push_str("declare void @uh_int(ptr sret(%UhValue), ptr byval(%UhValue))\n");
    ctx.out.push_str("declare void @uh_ws_serve(ptr sret(%UhValue), ptr byval(%UhValue))\n");
    ctx.out.push_str("declare void @uh_ws_connect(ptr sret(%UhValue), ptr byval(%UhValue))\n");
    ctx.out.push_str("declare void @uh_ws_receive(ptr sret(%UhValue), ptr byval(%UhValue))\n");
    ctx.out.push_str("declare void @uh_send(ptr sret(%UhValue), ptr byval(%UhValue), ptr byval(%UhValue))\n");

    ctx.out.push_str("declare void @uh_set_args(i32, ptr)\n");
    ctx.out.push_str("declare void @uh_set_global_env(ptr)\n");
    ctx.out.push_str("declare void @uh_sysobj(ptr sret(%UhValue))\n\n");
    ctx.out.push_str("declare i32 @strcmp(ptr, ptr)\n\n");
}

fn emit_string_globals(ctx: &mut EmitCtx) {
    if ctx.strings.is_empty() {
        return;
    }
    ctx.out.push('\n');
    for (idx, value) in ctx.strings.iter().enumerate() {
        let mut escaped = String::new();
        for b in value.as_bytes() {
            match *b {
                b'\\' => escaped.push_str("\\5C"),
                b'"' => escaped.push_str("\\22"),
                b'\n' => escaped.push_str("\\0A"),
                b'\r' => escaped.push_str("\\0D"),
                b'\t' => escaped.push_str("\\09"),
                0x20..=0x7e => escaped.push(*b as char),
                _ => escaped.push_str(&format!("\\{:02X}", b)),
            }
        }
        let len = value.as_bytes().len() + 1;
        ctx.out.push_str(&format!(
            "@.str.{idx} = private unnamed_addr constant [{len} x i8] c\"{escaped}\\00\"\n"
        ));
    }
}

fn emit_dispatcher(ctx: &mut EmitCtx, program: &Program) {
    ctx.out.push_str("define void @uh_call_named(ptr sret(%UhValue) %out, ptr %env, ptr %name, i32 %argc, ptr %args) {\n");
    ctx.out.push_str("entry:\n");
    ctx.out.push_str("  %isnull = icmp eq ptr %name, null\n");
    ctx.out.push_str("  br i1 %isnull, label %ret0, label %check0\n");
    ctx.out.push_str("ret0:\n");
    ctx.out.push_str("  call void @uh_num(ptr sret(%UhValue) %out, double 0.0)\n");
    ctx.out.push_str("  ret void\n");
    ctx.out.push_str("check0:\n");

    if program.functions.is_empty() {
        ctx.out.push_str("  br label %ret0\n");
    }

    for (idx, func) in program.functions.iter().enumerate() {
        let fname_ptr = ctx.emit_str_ptr(&func.name);
        let cmp = ctx.next_tmp();
        let eq = ctx.next_tmp();
        let ok = ctx.next_tmp();
        let call_label = ctx.next_label("call");
        let next_label = ctx.next_label("next");
        ctx.out.push_str(&format!(
            "  {cmp} = call i32 @strcmp(ptr %name, ptr {fname_ptr})\n"
        ));
        ctx.out.push_str(&format!("  {eq} = icmp eq i32 {cmp}, 0\n"));
        ctx.out.push_str(&format!(
            "  br i1 {eq}, label %{call_label}, label %{next_label}\n"
        ));
        ctx.out.push_str(&format!("{call_label}:\n"));
        ctx.out.push_str(&format!(
            "  {ok} = icmp eq i32 %argc, {}\n",
            func.params.len()
        ));
        let argc_ok = ctx.next_label("argc_ok");
        let argc_bad = ctx.next_label("argc_bad");
        ctx.out.push_str(&format!(
            "  br i1 {ok}, label %{argc_ok}, label %{argc_bad}\n"
        ));
        ctx.out.push_str(&format!("{argc_ok}:\n"));
        let mut args = Vec::new();
        for aidx in 0..func.params.len() {
            let ptr = ctx.next_tmp();
            ctx.out.push_str(&format!(
                "  {ptr} = getelementptr %UhValue, ptr %args, i64 {aidx}\n"
            ));
            args.push(ptr);
        }
        ctx.out.push_str(&format!(
            "  call void @uh_fn_{}(ptr sret(%UhValue) %out, ptr %env",
            func.name
        ));
        for arg in &args {
            ctx.out.push_str(&format!(", ptr byval(%UhValue) {arg}"));
        }
        ctx.out.push_str(")\n");
        ctx.out.push_str("  ret void\n");
        ctx.out.push_str(&format!("{argc_bad}:\n"));
        ctx.out.push_str("  br label %ret0\n");
        ctx.out.push_str(&format!("{next_label}:\n"));

        if idx == program.functions.len() - 1 {
            ctx.out.push_str("  br label %ret0\n");
        }
    }

    ctx.out.push_str("}\n");
}
fn emit_function(ctx: &mut EmitCtx, func: &Function, func_arity: &HashMap<String, usize>) -> Result<(), String> {
    ctx.allocas.clear();
    let mut saved = String::new();
    std::mem::swap(&mut ctx.out, &mut saved);

    for (idx, param) in func.params.iter().enumerate() {
        let name_ptr = ctx.emit_str_ptr(param);
        ctx.out.push_str(&format!(
            "  call void @uh_env_set(ptr %env, ptr {name_ptr}, ptr byval(%UhValue) %a{idx})\n"
        ));
    }
    emit_block(ctx, &func.body, func_arity)?;
    let ret0 = emit_call_value(ctx, "uh_num", &[String::from("double 0.0")]);
    let ret0_val = emit_load_value(ctx, &ret0);
    ctx.out
        .push_str(&format!("  store %UhValue {ret0_val}, ptr %out\n  ret void\n"));
    let body = std::mem::take(&mut ctx.out);

    let allocas = ctx.allocas.join("");
    ctx.allocas.clear();
    std::mem::swap(&mut ctx.out, &mut saved);

    ctx.out.push_str(&format!(
        "define void @uh_fn_{}(ptr sret(%UhValue) %out, ptr %parent",
        func.name
    ));
    for (idx, _param) in func.params.iter().enumerate() {
        ctx.out.push_str(&format!(", ptr byval(%UhValue) %a{idx}"));
    }
    ctx.out.push_str(") {\nentry:\n");
    ctx.out.push_str("  %env = alloca %UhEnv\n");
    ctx.out.push_str("  %st = alloca %UhStack\n");
    ctx.out.push_str("  call void @uh_env_init(ptr %env, ptr %parent)\n");
    ctx.out.push_str("  call void @uh_stack_init(ptr %st)\n");
    ctx.out.push_str(&allocas);
    ctx.out.push_str(&body);
    ctx.out.push_str("}\n");
    Ok(())
}

fn emit_main(ctx: &mut EmitCtx, program: &Program, func_arity: &HashMap<String, usize>) -> Result<(), String> {
    ctx.allocas.clear();
    let mut saved = String::new();
    std::mem::swap(&mut ctx.out, &mut saved);

    let sysobj = emit_call_value(ctx, "uh_sysobj", &[]);
    let sys_name = ctx.emit_str_ptr("⎕");
    ctx.out
        .push_str(&format!("  call void @uh_env_set(ptr %env, ptr {sys_name}, ptr byval(%UhValue) {sysobj})\n"));
    emit_block(ctx, &program.main, func_arity)?;
    ctx.out.push_str("  ret i32 0\n");
    let body = std::mem::take(&mut ctx.out);

    let allocas = ctx.allocas.join("");
    ctx.allocas.clear();
    std::mem::swap(&mut ctx.out, &mut saved);

    ctx.out
        .push_str("define i32 @main(i32 %argc, ptr %argv) {\nentry:\n");
    ctx.out.push_str("  call void @uh_set_args(i32 %argc, ptr %argv)\n");
    ctx.out.push_str("  %env = alloca %UhEnv\n");
    ctx.out.push_str("  %st = alloca %UhStack\n");
    ctx.out.push_str("  call void @uh_env_init(ptr %env, ptr null)\n");
    ctx.out.push_str("  call void @uh_set_global_env(ptr %env)\n");
    ctx.out.push_str("  call void @uh_stack_init(ptr %st)\n");
    ctx.out.push_str(&allocas);
    ctx.out.push_str(&body);
    ctx.out.push_str("}\n");
    Ok(())
}

fn emit_block(ctx: &mut EmitCtx, block: &Block, func_arity: &HashMap<String, usize>) -> Result<(), String> {
    for stmt in &block.stmts {
        emit_stmt(ctx, stmt, func_arity)?;
    }
    Ok(())
}

fn emit_stmt(ctx: &mut EmitCtx, stmt: &Stmt, func_arity: &HashMap<String, usize>) -> Result<(), String> {
    match stmt {
        Stmt::Expr(expr) => {
            emit_expr(ctx, expr, func_arity)?;
            ctx.out.push_str("  call void @uh_stack_clear(ptr %st)\n");
        }
        Stmt::Break => {
            let (break_label, _) = ctx
                .loop_stack
                .last()
                .ok_or_else(|| "break outside loop".to_string())?;
            ctx.out.push_str(&format!("  br label %{break_label}\n"));
            let after = ctx.next_label("after_break");
            ctx.out.push_str(&format!("{after}:\n"));
        }
        Stmt::Continue => {
            let (_, continue_label) = ctx
                .loop_stack
                .last()
                .ok_or_else(|| "continue outside loop".to_string())?;
            ctx.out.push_str(&format!("  br label %{continue_label}\n"));
            let after = ctx.next_label("after_cont");
            ctx.out.push_str(&format!("{after}:\n"));
        }
        Stmt::Return(expr) => {
            if let Some(expr) = expr {
                emit_expr(ctx, expr, func_arity)?;
                let val = emit_call_value(ctx, "uh_stack_pop", &[String::from("ptr %st")]);
                let val_loaded = emit_load_value(ctx, &val);
                ctx.out
                    .push_str(&format!("  store %UhValue {val_loaded}, ptr %out\n"));
                ctx.out.push_str("  ret void\n");
                let after = ctx.next_label("after_ret");
                ctx.out.push_str(&format!("{after}:\n"));
            } else {
                let ret0 = emit_call_value(ctx, "uh_num", &[String::from("double 0.0")]);
                let ret0_val = emit_load_value(ctx, &ret0);
                ctx.out
                    .push_str(&format!("  store %UhValue {ret0_val}, ptr %out\n"));
                ctx.out.push_str("  ret void\n");
                let after = ctx.next_label("after_ret");
                ctx.out.push_str(&format!("{after}:\n"));
            }
        }
        Stmt::If { cond, then_blk, else_blk } => {
            emit_expr(ctx, cond, func_arity)?;
            let cond_val = emit_call_value(ctx, "uh_stack_pop", &[String::from("ptr %st")]);
            let cond_bool = ctx.next_tmp();
            ctx.out
                .push_str(&format!("  {cond_bool} = call i32 @uh_is_true(ptr byval(%UhValue) {cond_val})\n"));
            let cond_cmp = ctx.next_tmp();
            ctx.out
                .push_str(&format!("  {cond_cmp} = icmp ne i32 {cond_bool}, 0\n"));
            let then_label = ctx.next_label("then");
            let else_label = ctx.next_label("else");
            let end_label = ctx.next_label("endif");
            ctx.out.push_str(&format!(
                "  br i1 {cond_cmp}, label %{then_label}, label %{else_label}\n"
            ));
            ctx.out.push_str(&format!("{then_label}:\n"));
            emit_block(ctx, then_blk, func_arity)?;
            ctx.out.push_str(&format!("  br label %{end_label}\n"));
            ctx.out.push_str(&format!("{else_label}:\n"));
            if let Some(else_blk) = else_blk {
                emit_block(ctx, else_blk, func_arity)?;
            }
            ctx.out.push_str(&format!("  br label %{end_label}\n"));
            ctx.out.push_str(&format!("{end_label}:\n"));
        }
        Stmt::While { cond, body } => {
            let loop_label = ctx.next_label("loop");
            let body_label = ctx.next_label("loop_body");
            let end_label = ctx.next_label("loop_end");
            ctx.out.push_str(&format!("  br label %{loop_label}\n"));
            ctx.out.push_str(&format!("{loop_label}:\n"));
            emit_expr(ctx, cond, func_arity)?;
            let cond_val = emit_call_value(ctx, "uh_stack_pop", &[String::from("ptr %st")]);
            let cond_bool = ctx.next_tmp();
            ctx.out
                .push_str(&format!("  {cond_bool} = call i32 @uh_is_true(ptr byval(%UhValue) {cond_val})\n"));
            let cond_cmp = ctx.next_tmp();
            ctx.out
                .push_str(&format!("  {cond_cmp} = icmp ne i32 {cond_bool}, 0\n"));
            ctx.out.push_str(&format!(
                "  br i1 {cond_cmp}, label %{body_label}, label %{end_label}\n"
            ));
            ctx.out.push_str(&format!("{body_label}:\n"));
            ctx.loop_stack.push((end_label.clone(), loop_label.clone()));
            emit_block(ctx, body, func_arity)?;
            ctx.loop_stack.pop();
            ctx.out.push_str(&format!("  br label %{loop_label}\n"));
            ctx.out.push_str(&format!("{end_label}:\n"));
        }
    }
    Ok(())
}

fn emit_expr(ctx: &mut EmitCtx, expr: &Expr, func_arity: &HashMap<String, usize>) -> Result<(), String> {
    for token in &expr.tokens {
        match token {
            ExprToken::Number(n) => {
                let tmp = emit_call_value(ctx, "uh_num", &[format!("double {}", fmt_double(*n))]);
                ctx.out
                    .push_str(&format!("  call void @uh_stack_push(ptr %st, ptr byval(%UhValue) {tmp})\n"));
            }
            ExprToken::Bool(b) => {
                let v = if *b { 1.0 } else { 0.0 };
                let tmp = emit_call_value(ctx, "uh_num", &[format!("double {}", fmt_double(v))]);
                ctx.out
                    .push_str(&format!("  call void @uh_stack_push(ptr %st, ptr byval(%UhValue) {tmp})\n"));
            }
            ExprToken::Null => {
                let tmp = emit_call_value(ctx, "uh_null", &[]);
                ctx.out
                    .push_str(&format!("  call void @uh_stack_push(ptr %st, ptr byval(%UhValue) {tmp})\n"));
            }
            ExprToken::String(s) => {
                let ptr = ctx.emit_str_ptr(s);
                let tmp = emit_call_value(ctx, "uh_str", &[format!("ptr {ptr}")]);
                ctx.out
                    .push_str(&format!("  call void @uh_stack_push(ptr %st, ptr byval(%UhValue) {tmp})\n"));
            }
            ExprToken::Ident(name) => {
                let ptr = ctx.emit_str_ptr(name);
                let tmp = emit_call_value(ctx, "uh_env_get", &[String::from("ptr %env"), format!("ptr {ptr}")]);
                ctx.out
                    .push_str(&format!("  call void @uh_stack_push(ptr %st, ptr byval(%UhValue) {tmp})\n"));
            }
            ExprToken::Array(items) => {
                let arr = emit_call_value(ctx, "uh_arr_new", &[]);
                for item in items {
                    let nested = Expr { tokens: vec![item.clone()] };
                    emit_expr(ctx, &nested, func_arity)?;
                    let it = emit_call_value(ctx, "uh_stack_pop", &[String::from("ptr %st")]);
                    ctx.out.push_str(&format!(
                        "  call void @uh_arr_push(ptr {arr}, ptr byval(%UhValue) {it})\n"
                    ));
                }
                ctx.out
                    .push_str(&format!("  call void @uh_stack_push(ptr %st, ptr byval(%UhValue) {arr})\n"));
            }
            ExprToken::Dict(pairs) => {
                let dict = emit_call_value(ctx, "uh_dict_new", &[]);
                for (key, val) in pairs {
                    let key_expr = Expr { tokens: vec![key.clone()] };
                    emit_expr(ctx, &key_expr, func_arity)?;
                    let k = emit_call_value(ctx, "uh_stack_pop", &[String::from("ptr %st")]);
                    let val_expr = Expr { tokens: vec![val.clone()] };
                    emit_expr(ctx, &val_expr, func_arity)?;
                    let v = emit_call_value(ctx, "uh_stack_pop", &[String::from("ptr %st")]);
                    ctx.out.push_str(&format!(
                        "  call void @uh_dict_set(ptr {dict}, ptr byval(%UhValue) {k}, ptr byval(%UhValue) {v})\n"
                    ));
                }
                ctx.out
                    .push_str(&format!("  call void @uh_stack_push(ptr %st, ptr byval(%UhValue) {dict})\n"));
            }
            ExprToken::Add
            | ExprToken::Sub
            | ExprToken::Mul
            | ExprToken::Div
            | ExprToken::Mod
            | ExprToken::Concat
            | ExprToken::Index
            | ExprToken::Eq
            | ExprToken::Neq
            | ExprToken::Lt
            | ExprToken::Gt
            | ExprToken::Le
            | ExprToken::Ge
            | ExprToken::And
            | ExprToken::Or
            | ExprToken::Contains => {
                let b = emit_call_value(ctx, "uh_stack_pop", &[String::from("ptr %st")]);
                let a = emit_call_value(ctx, "uh_stack_pop", &[String::from("ptr %st")]);
                let aval = emit_load_value(ctx, &a);
                let bval = emit_load_value(ctx, &b);
                let res = match token {
                    ExprToken::Add => {
                        let anum = ctx.next_tmp();
                        let bnum = ctx.next_tmp();
                        ctx.out.push_str(&format!(
                            "  {anum} = extractvalue %UhValue {aval}, 1\n"
                        ));
                        ctx.out.push_str(&format!(
                            "  {bnum} = extractvalue %UhValue {bval}, 1\n"
                        ));
                        let sum = ctx.next_tmp();
                        ctx.out.push_str(&format!("  {sum} = fadd double {anum}, {bnum}\n"));
                        emit_call_value(ctx, "uh_num", &[format!("double {sum}")])
                    }
                    ExprToken::Sub => {
                        let anum = ctx.next_tmp();
                        let bnum = ctx.next_tmp();
                        ctx.out.push_str(&format!(
                            "  {anum} = extractvalue %UhValue {aval}, 1\n"
                        ));
                        ctx.out.push_str(&format!(
                            "  {bnum} = extractvalue %UhValue {bval}, 1\n"
                        ));
                        let diff = ctx.next_tmp();
                        ctx.out.push_str(&format!("  {diff} = fsub double {anum}, {bnum}\n"));
                        emit_call_value(ctx, "uh_num", &[format!("double {diff}")])
                    }
                    ExprToken::Mul => {
                        let anum = ctx.next_tmp();
                        let bnum = ctx.next_tmp();
                        ctx.out.push_str(&format!(
                            "  {anum} = extractvalue %UhValue {aval}, 1\n"
                        ));
                        ctx.out.push_str(&format!(
                            "  {bnum} = extractvalue %UhValue {bval}, 1\n"
                        ));
                        let prod = ctx.next_tmp();
                        ctx.out.push_str(&format!("  {prod} = fmul double {anum}, {bnum}\n"));
                        emit_call_value(ctx, "uh_num", &[format!("double {prod}")])
                    }
                    ExprToken::Div => {
                        let anum = ctx.next_tmp();
                        let bnum = ctx.next_tmp();
                        ctx.out.push_str(&format!(
                            "  {anum} = extractvalue %UhValue {aval}, 1\n"
                        ));
                        ctx.out.push_str(&format!(
                            "  {bnum} = extractvalue %UhValue {bval}, 1\n"
                        ));
                        let quo = ctx.next_tmp();
                        ctx.out.push_str(&format!("  {quo} = fdiv double {anum}, {bnum}\n"));
                        emit_call_value(ctx, "uh_num", &[format!("double {quo}")])
                    }
                    ExprToken::Mod => {
                        let anum = ctx.next_tmp();
                        let bnum = ctx.next_tmp();
                        ctx.out.push_str(&format!(
                            "  {anum} = extractvalue %UhValue {aval}, 1\n"
                        ));
                        ctx.out.push_str(&format!(
                            "  {bnum} = extractvalue %UhValue {bval}, 1\n"
                        ));
                        let ai = ctx.next_tmp();
                        let bi = ctx.next_tmp();
                        ctx.out.push_str(&format!("  {ai} = fptosi double {anum} to i64\n"));
                        ctx.out.push_str(&format!("  {bi} = fptosi double {bnum} to i64\n"));
                        let rem = ctx.next_tmp();
                        ctx.out.push_str(&format!("  {rem} = srem i64 {ai}, {bi}\n"));
                        let remf = ctx.next_tmp();
                        ctx.out.push_str(&format!("  {remf} = sitofp i64 {rem} to double\n"));
                        emit_call_value(ctx, "uh_num", &[format!("double {remf}")])
                    }
                    ExprToken::Concat => {
                        emit_call_value(
                            ctx,
                            "uh_concat",
                            &[
                                format!("ptr byval(%UhValue) {a}"),
                                format!("ptr byval(%UhValue) {b}"),
                            ],
                        )
                    }
                    ExprToken::Index => {
                        emit_call_value(
                            ctx,
                            "uh_index",
                            &[
                                format!("ptr byval(%UhValue) {a}"),
                                format!("ptr byval(%UhValue) {b}"),
                            ],
                        )
                    }
                    ExprToken::Eq | ExprToken::Neq | ExprToken::Lt | ExprToken::Gt | ExprToken::Le | ExprToken::Ge => {
                        let cmp = ctx.next_tmp();
                        if matches!(token, ExprToken::Eq | ExprToken::Neq) {
                            ctx.out.push_str(&format!(
                                "  {cmp} = call i32 @uh_value_eq(ptr byval(%UhValue) {a}, ptr byval(%UhValue) {b})\n"
                            ));
                            let val = ctx.next_tmp();
                            if matches!(token, ExprToken::Eq) {
                                ctx.out.push_str(&format!("  {val} = icmp ne i32 {cmp}, 0\n"));
                            } else {
                                ctx.out.push_str(&format!("  {val} = icmp eq i32 {cmp}, 0\n"));
                            }
                            let as_i32 = ctx.next_tmp();
                            ctx.out.push_str(&format!("  {as_i32} = zext i1 {val} to i32\n"));
                            let as_f = ctx.next_tmp();
                            ctx.out.push_str(&format!("  {as_f} = sitofp i32 {as_i32} to double\n"));
                            emit_call_value(ctx, "uh_num", &[format!("double {as_f}")])
                        } else {
                            ctx.out.push_str(&format!(
                                "  {cmp} = call i32 @uh_cmp(ptr byval(%UhValue) {a}, ptr byval(%UhValue) {b})\n"
                            ));
                            let pred = ctx.next_tmp();
                            let op = match token {
                                ExprToken::Lt => "slt",
                                ExprToken::Gt => "sgt",
                                ExprToken::Le => "sle",
                                ExprToken::Ge => "sge",
                                _ => "slt",
                            };
                            ctx.out.push_str(&format!("  {pred} = icmp {op} i32 {cmp}, 0\n"));
                            let as_i32 = ctx.next_tmp();
                            ctx.out.push_str(&format!("  {as_i32} = zext i1 {pred} to i32\n"));
                            let as_f = ctx.next_tmp();
                            ctx.out.push_str(&format!("  {as_f} = sitofp i32 {as_i32} to double\n"));
                            emit_call_value(ctx, "uh_num", &[format!("double {as_f}")])
                        }
                    }
                    ExprToken::And | ExprToken::Or => {
                        let av = ctx.next_tmp();
                        let bv = ctx.next_tmp();
                        ctx.out.push_str(&format!(
                            "  {av} = call i32 @uh_is_true(ptr byval(%UhValue) {a})\n"
                        ));
                        ctx.out.push_str(&format!(
                            "  {bv} = call i32 @uh_is_true(ptr byval(%UhValue) {b})\n"
                        ));
                        let abool = ctx.next_tmp();
                        let bbool = ctx.next_tmp();
                        ctx.out.push_str(&format!("  {abool} = icmp ne i32 {av}, 0\n"));
                        ctx.out.push_str(&format!("  {bbool} = icmp ne i32 {bv}, 0\n"));
                        let comb = ctx.next_tmp();
                        let op = if matches!(token, ExprToken::And) { "and" } else { "or" };
                        ctx.out.push_str(&format!("  {comb} = {op} i1 {abool}, {bbool}\n"));
                        let as_i32 = ctx.next_tmp();
                        ctx.out.push_str(&format!("  {as_i32} = zext i1 {comb} to i32\n"));
                        let as_f = ctx.next_tmp();
                        ctx.out.push_str(&format!("  {as_f} = sitofp i32 {as_i32} to double\n"));
                        emit_call_value(ctx, "uh_num", &[format!("double {as_f}")])
                    }
                    ExprToken::Contains => {
                        let cmp = ctx.next_tmp();
                        ctx.out.push_str(&format!(
                            "  {cmp} = call i32 @uh_contains(ptr byval(%UhValue) {b}, ptr byval(%UhValue) {a})\n"
                        ));
                        let pred = ctx.next_tmp();
                        ctx.out.push_str(&format!("  {pred} = icmp ne i32 {cmp}, 0\n"));
                        let as_i32 = ctx.next_tmp();
                        ctx.out.push_str(&format!("  {as_i32} = zext i1 {pred} to i32\n"));
                        let as_f = ctx.next_tmp();
                        ctx.out.push_str(&format!("  {as_f} = sitofp i32 {as_i32} to double\n"));
                        emit_call_value(ctx, "uh_num", &[format!("double {as_f}")])
                    }
                    _ => emit_call_value(ctx, "uh_num", &[String::from("double 0.0")]),
                };
                ctx.out.push_str(&format!(
                    "  call void @uh_stack_push(ptr %st, ptr byval(%UhValue) {res})\n"
                ));
            }
            ExprToken::Not => {
                let v = emit_call_value(ctx, "uh_stack_pop", &[String::from("ptr %st")]);
                let t = ctx.next_tmp();
                ctx.out.push_str(&format!(
                    "  {t} = call i32 @uh_is_true(ptr byval(%UhValue) {v})\n"
                ));
                let pred = ctx.next_tmp();
                ctx.out.push_str(&format!("  {pred} = icmp eq i32 {t}, 0\n"));
                let as_i32 = ctx.next_tmp();
                ctx.out.push_str(&format!("  {as_i32} = zext i1 {pred} to i32\n"));
                let as_f = ctx.next_tmp();
                ctx.out.push_str(&format!("  {as_f} = sitofp i32 {as_i32} to double\n"));
                let res = emit_call_value(ctx, "uh_num", &[format!("double {as_f}")]);
                ctx.out.push_str(&format!(
                    "  call void @uh_stack_push(ptr %st, ptr byval(%UhValue) {res})\n"
                ));
            }
            ExprToken::Stringify => {
                let v = emit_call_value(ctx, "uh_stack_pop", &[String::from("ptr %st")]);
                let res = emit_call_value(ctx, "uh_stringify", &[format!("ptr byval(%UhValue) {v}")]);
                ctx.out.push_str(&format!(
                    "  call void @uh_stack_push(ptr %st, ptr byval(%UhValue) {res})\n"
                ));
            }
            ExprToken::StoreIndex => {
                let v = emit_call_value(ctx, "uh_stack_pop", &[String::from("ptr %st")]);
                let k = emit_call_value(ctx, "uh_stack_pop", &[String::from("ptr %st")]);
                let c = emit_call_value(ctx, "uh_stack_pop", &[String::from("ptr %st")]);
                ctx.out.push_str(&format!(
                    "  call void @uh_store_index(ptr {c}, ptr byval(%UhValue) {k}, ptr byval(%UhValue) {v})\n"
                ));
            }
            ExprToken::Assign(name) => {
                let v = emit_call_value(ctx, "uh_stack_pop", &[String::from("ptr %st")]);
                let ptr = ctx.emit_str_ptr(name);
                ctx.out
                    .push_str(&format!("  call void @uh_env_set(ptr %env, ptr {ptr}, ptr byval(%UhValue) {v})\n"));
            }
            ExprToken::Print => {
                let v = emit_call_value(ctx, "uh_stack_pop", &[String::from("ptr %st")]);
                ctx.out.push_str(&format!("  call void @uh_print(ptr byval(%UhValue) {v})\n"));
            }
            ExprToken::Call(name) => {
                if let Some((argc, callee)) = builtin_call(name) {
                    let mut args = Vec::new();
                    for _ in 0..argc {
                        let arg = emit_call_value(ctx, "uh_stack_pop", &[String::from("ptr %st")]);
                        args.push(arg);
                    }
                    args.reverse();
                    let mut call_args = Vec::new();
                    for a in &args {
                        call_args.push(format!("ptr byval(%UhValue) {a}"));
                    }
                    let res = emit_call_value(ctx, callee, &call_args);
                    ctx.out.push_str(&format!(
                        "  call void @uh_stack_push(ptr %st, ptr byval(%UhValue) {res})\n"
                    ));
                } else {
                    let argc = *func_arity.get(name).ok_or_else(|| format!("unknown function: {name}"))?;
                    let mut args = Vec::new();
                    for _ in 0..argc {
                        let arg = emit_call_value(ctx, "uh_stack_pop", &[String::from("ptr %st")]);
                        args.push(arg);
                    }
                    args.reverse();
                    let mut call_args = Vec::new();
                    call_args.push(String::from("ptr %env"));
                    for a in args {
                        call_args.push(format!("ptr byval(%UhValue) {a}"));
                    }
                    let res = emit_call_value(ctx, &format!("uh_fn_{name}"), &call_args);
                    ctx.out.push_str(&format!(
                        "  call void @uh_stack_push(ptr %st, ptr byval(%UhValue) {res})\n"
                    ));
                }
            }
        }
    }
    Ok(())
}

fn builtin_call(name: &str) -> Option<(usize, &'static str)> {
    match name {
        "import" | ".import" => Some((1, "uh_import")),
        "args" | ".args" => Some((0, "uh_args")),
        "len" | ".len" => Some((1, "uh_len")),
        "append" | ".append" => Some((2, "uh_append")),
        "split" | ".split" => Some((2, "uh_split")),
        "join" | ".join" => Some((2, "uh_join")),
        "substr" | ".substr" => Some((3, "uh_substr")),
        "char_at" | ".char_at" => Some((2, "uh_char_at")),
        "hex" | ".hex" => Some((1, "uh_hex")),
        "read_file" | ".read" => Some((1, "uh_read_file")),
        "write_file" | ".write" => Some((2, "uh_write_file")),
        "syscall" | ".syscall" => Some((1, "uh_syscall")),
        "int" | ".int" => Some((1, "uh_int")),
        "ws.serve" => Some((1, "uh_ws_serve")),
        "ws.connect" => Some((1, "uh_ws_connect")),
        ".receive" => Some((1, "uh_ws_receive")),
        ".send" => Some((2, "uh_send")),
        _ => None,
    }
}

fn emit_call_value(ctx: &mut EmitCtx, name: &str, args: &[String]) -> String {
    let ptr = ctx.next_tmp();
    ctx.allocas.push(format!("  {ptr} = alloca %UhValue\n"));
    ctx.out
        .push_str(&format!("  call void @{name}(ptr sret(%UhValue) {ptr}"));
    for arg in args {
        ctx.out.push_str(&format!(", {arg}"));
    }
    ctx.out.push_str(")\n");
    ptr
}

fn emit_load_value(ctx: &mut EmitCtx, ptr: &str) -> String {
    let val = ctx.next_tmp();
    ctx.out
        .push_str(&format!("  {val} = load %UhValue, ptr {ptr}\n"));
    val
}
