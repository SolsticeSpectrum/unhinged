use std::collections::HashMap;

use crate::ast::{Block, Expr, ExprToken, Function, Program, Stmt};

pub fn emit_c(program: &Program, func_arity: &HashMap<String, usize>) -> Result<String, String> {
    let mut out = String::new();
    out.push_str("#include \"runtime/rt.h\"\n#include <string.h>\n\n");

    for func in &program.functions {
        out.push_str(&format!("static UhValue uh_fn_{}(UhEnv *env", func.name));
        for (idx, _param) in func.params.iter().enumerate() {
            out.push_str(&format!(", UhValue a{idx}"));
        }
        out.push_str(");\n");
    }
    out.push_str("\n");

    for func in &program.functions {
        emit_function(func, func_arity, &mut out)?;
        out.push_str("\n");
    }

    emit_dispatcher(program, &mut out);

    out.push_str("int main(int argc, char **argv) {\n");
    out.push_str("  uh_set_args(argc, argv);\n");
    out.push_str("  UhEnv env; uh_env_init(&env, NULL);\n");
    out.push_str("  uh_set_global_env(&env);\n");
    out.push_str("  UhStack st; uh_stack_init(&st);\n");
    out.push_str("  uh_env_set(&env, \"⎕\", uh_sysobj());\n");
    let mut temp_id = 0usize;
    emit_block(&program.main, func_arity, &mut out, "  ", &mut temp_id)?;
    out.push_str("  return 0;\n");
    out.push_str("}\n");

    Ok(out)
}

fn emit_dispatcher(program: &Program, out: &mut String) {
    out.push_str("UhValue uh_call_named(UhEnv *env, const char *name, int argc, UhValue *args) {\n");
    out.push_str("  if (!name) return uh_num(0);\n");
    for func in &program.functions {
        let fname = escape_c_string(&func.name);
        out.push_str(&format!("  if (strcmp(name, \"{fname}\") == 0) {{\n"));
        out.push_str(&format!("    if (argc != {}) return uh_num(0);\n", func.params.len()));
        out.push_str(&format!("    return uh_fn_{}(env", func.name));
        for idx in 0..func.params.len() {
            out.push_str(&format!(", args[{idx}]"));
        }
        out.push_str(");\n  }\n");
    }
    out.push_str("  return uh_num(0);\n}\n\n");
}

fn emit_function(func: &Function, func_arity: &HashMap<String, usize>, out: &mut String) -> Result<(), String> {
    out.push_str(&format!("static UhValue uh_fn_{}(UhEnv *parent", func.name));
    for (idx, _param) in func.params.iter().enumerate() {
        out.push_str(&format!(", UhValue a{idx}"));
    }
    out.push_str(") {\n");
    out.push_str("  UhEnv env; uh_env_init(&env, parent);\n");
    out.push_str("  UhStack st; uh_stack_init(&st);\n");
    for (idx, param) in func.params.iter().enumerate() {
        out.push_str(&format!("  uh_env_set(&env, \"{}\", a{idx});\n", escape_c_string(param)));
    }

    let mut temp_id = 0usize;
    emit_block(&func.body, func_arity, out, "  ", &mut temp_id)?;
    out.push_str("  return uh_num(0);\n");
    out.push_str("}\n");
    Ok(())
}

fn emit_block(
    block: &Block,
    func_arity: &HashMap<String, usize>,
    out: &mut String,
    indent: &str,
    temp_id: &mut usize,
) -> Result<(), String> {
    for stmt in &block.stmts {
        emit_stmt(stmt, func_arity, out, indent, temp_id)?;
    }
    Ok(())
}

fn emit_stmt(
    stmt: &Stmt,
    func_arity: &HashMap<String, usize>,
    out: &mut String,
    indent: &str,
    temp_id: &mut usize,
) -> Result<(), String> {
    match stmt {
        Stmt::Expr(expr) => {
            emit_expr(expr, func_arity, out, indent, temp_id)?;
            out.push_str(indent);
            out.push_str("uh_stack_clear(&st);\n");
        }
        Stmt::Break => {
            out.push_str(indent);
            out.push_str("break;\n");
        }
        Stmt::Continue => {
            out.push_str(indent);
            out.push_str("continue;\n");
        }
        Stmt::Return(expr) => {
            if let Some(expr) = expr {
                emit_expr(expr, func_arity, out, indent, temp_id)?;
                out.push_str(indent);
                out.push_str("return uh_stack_pop(&st);\n");
            } else {
                out.push_str(indent);
                out.push_str("return uh_num(0);\n");
            }
        }
        Stmt::If { cond, then_blk, else_blk } => {
            emit_expr(cond, func_arity, out, indent, temp_id)?;
            let cond_id = *temp_id;
            *temp_id += 1;
            out.push_str(indent);
            out.push_str(&format!("UhValue _cond{cond_id} = uh_stack_pop(&st);\n"));
            out.push_str(indent);
            out.push_str(&format!("if (uh_is_true(_cond{cond_id})) {{\n"));
            emit_block(then_blk, func_arity, out, &format!("{indent}  "), temp_id)?;
            out.push_str(indent);
            out.push_str("}");
            if let Some(else_blk) = else_blk {
                out.push_str(" else {\n");
                emit_block(else_blk, func_arity, out, &format!("{indent}  "), temp_id)?;
                out.push_str(indent);
                out.push_str("}\n");
            } else {
                out.push_str("\n");
            }
        }
        Stmt::While { cond, body } => {
            out.push_str(indent);
            out.push_str("while (1) {\n");
            emit_expr(cond, func_arity, out, &format!("{indent}  "), temp_id)?;
            let cond_id = *temp_id;
            *temp_id += 1;
            out.push_str(&format!("{indent}  UhValue _cond{cond_id} = uh_stack_pop(&st);\n"));
            out.push_str(&format!("{indent}  if (!uh_is_true(_cond{cond_id})) break;\n"));
            emit_block(body, func_arity, out, &format!("{indent}  "), temp_id)?;
            out.push_str(indent);
            out.push_str("}\n");
        }
    }
    Ok(())
}

fn emit_expr(
    expr: &Expr,
    func_arity: &HashMap<String, usize>,
    out: &mut String,
    indent: &str,
    temp_id: &mut usize,
) -> Result<(), String> {
    for token in &expr.tokens {
        match token {
            ExprToken::Number(n) => {
                out.push_str(indent);
                out.push_str(&format!("uh_stack_push(&st, uh_num({n}));\n"));
            }
            ExprToken::Bool(b) => {
                out.push_str(indent);
                let v = if *b { 1 } else { 0 };
                out.push_str(&format!("uh_stack_push(&st, uh_num({v}));\n"));
            }
            ExprToken::Null => {
                out.push_str(indent);
                out.push_str("uh_stack_push(&st, uh_null());\n");
            }
            ExprToken::String(s) => {
                out.push_str(indent);
                out.push_str(&format!("uh_stack_push(&st, uh_str(\"{}\"));\n", escape_c_string(s)));
            }
            ExprToken::Ident(name) => {
                out.push_str(indent);
                out.push_str(&format!("uh_stack_push(&st, uh_env_get(&env, \"{}\"));\n", escape_c_string(name)));
            }
            ExprToken::Array(items) => {
                let arr_id = *temp_id;
                *temp_id += 1;
                out.push_str(indent);
                out.push_str(&format!("UhValue _arr{arr_id} = uh_arr_new();\n"));
                for item in items {
                    let nested = Expr { tokens: vec![item.clone()] };
                    emit_expr(&nested, func_arity, out, indent, temp_id)?;
                    out.push_str(indent);
                    out.push_str(&format!("uh_arr_push(&_arr{arr_id}, uh_stack_pop(&st));\n"));
                }
                out.push_str(indent);
                out.push_str(&format!("uh_stack_push(&st, _arr{arr_id});\n"));
            }
            ExprToken::Dict(pairs) => {
                let dict_id = *temp_id;
                *temp_id += 1;
                out.push_str(indent);
                out.push_str(&format!("UhValue _dict{dict_id} = uh_dict_new();\n"));
                for (key, val) in pairs {
                    let key_expr = Expr { tokens: vec![key.clone()] };
                    emit_expr(&key_expr, func_arity, out, indent, temp_id)?;
                    let k_id = *temp_id;
                    *temp_id += 1;
                    out.push_str(indent);
                    out.push_str(&format!("UhValue _k{k_id} = uh_stack_pop(&st);\n"));
                    let val_expr = Expr { tokens: vec![val.clone()] };
                    emit_expr(&val_expr, func_arity, out, indent, temp_id)?;
                    let v_id = *temp_id;
                    *temp_id += 1;
                    out.push_str(indent);
                    out.push_str(&format!("UhValue _v{v_id} = uh_stack_pop(&st);\n"));
                    out.push_str(indent);
                    out.push_str(&format!("uh_dict_set(&_dict{dict_id}, _k{k_id}, _v{v_id});\n"));
                }
                out.push_str(indent);
                out.push_str(&format!("uh_stack_push(&st, _dict{dict_id});\n"));
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
                out.push_str(indent);
                out.push_str(&format!("UhValue _b{tid} = uh_stack_pop(&st);\n", tid = *temp_id));
                out.push_str(indent);
                out.push_str(&format!("UhValue _a{tid} = uh_stack_pop(&st);\n", tid = *temp_id));
                out.push_str(indent);
                match token {
                    ExprToken::Add => out.push_str(&format!("uh_stack_push(&st, uh_num(_a{tid}.num + _b{tid}.num));\n", tid = *temp_id)),
                    ExprToken::Sub => out.push_str(&format!("uh_stack_push(&st, uh_num(_a{tid}.num - _b{tid}.num));\n", tid = *temp_id)),
                    ExprToken::Mul => out.push_str(&format!("uh_stack_push(&st, uh_num(_a{tid}.num * _b{tid}.num));\n", tid = *temp_id)),
                    ExprToken::Div => out.push_str(&format!("uh_stack_push(&st, uh_num(_a{tid}.num / _b{tid}.num));\n", tid = *temp_id)),
                    ExprToken::Mod => out.push_str(&format!("uh_stack_push(&st, uh_num((long)_a{tid}.num % (long)_b{tid}.num));\n", tid = *temp_id)),
                    ExprToken::Concat => out.push_str(&format!("uh_stack_push(&st, uh_concat(_a{tid}, _b{tid}));\n", tid = *temp_id)),
                    ExprToken::Index => out.push_str(&format!("uh_stack_push(&st, uh_index(_a{tid}, _b{tid}));\n", tid = *temp_id)),
                    ExprToken::Eq => out.push_str(&format!("uh_stack_push(&st, uh_num(uh_value_eq(_a{tid}, _b{tid}) ? 1 : 0));\n", tid = *temp_id)),
                    ExprToken::Neq => out.push_str(&format!("uh_stack_push(&st, uh_num(uh_value_eq(_a{tid}, _b{tid}) ? 0 : 1));\n", tid = *temp_id)),
                    ExprToken::Lt => out.push_str(&format!("uh_stack_push(&st, uh_num(uh_cmp(_a{tid}, _b{tid}) < 0 ? 1 : 0));\n", tid = *temp_id)),
                    ExprToken::Gt => out.push_str(&format!("uh_stack_push(&st, uh_num(uh_cmp(_a{tid}, _b{tid}) > 0 ? 1 : 0));\n", tid = *temp_id)),
                    ExprToken::Le => out.push_str(&format!("uh_stack_push(&st, uh_num(uh_cmp(_a{tid}, _b{tid}) <= 0 ? 1 : 0));\n", tid = *temp_id)),
                    ExprToken::Ge => out.push_str(&format!("uh_stack_push(&st, uh_num(uh_cmp(_a{tid}, _b{tid}) >= 0 ? 1 : 0));\n", tid = *temp_id)),
                    ExprToken::And => out.push_str(&format!("uh_stack_push(&st, uh_num((uh_is_true(_a{tid}) && uh_is_true(_b{tid})) ? 1 : 0));\n", tid = *temp_id)),
                    ExprToken::Or => out.push_str(&format!("uh_stack_push(&st, uh_num((uh_is_true(_a{tid}) || uh_is_true(_b{tid})) ? 1 : 0));\n", tid = *temp_id)),
                    ExprToken::Contains => out.push_str(&format!("uh_stack_push(&st, uh_num(uh_contains(_b{tid}, _a{tid}) ? 1 : 0));\n", tid = *temp_id)),
                    _ => return Err("unhandled binary op".to_string()),
                }
                *temp_id += 1;
            }
            ExprToken::Not => {
                out.push_str(indent);
                out.push_str(&format!("UhValue _v{tid} = uh_stack_pop(&st);\n", tid = *temp_id));
                out.push_str(indent);
                out.push_str(&format!("uh_stack_push(&st, uh_num(uh_is_true(_v{tid}) ? 0 : 1));\n", tid = *temp_id));
                *temp_id += 1;
            }
            ExprToken::Stringify => {
                out.push_str(indent);
                out.push_str(&format!("UhValue _v{tid} = uh_stack_pop(&st);\n", tid = *temp_id));
                out.push_str(indent);
                out.push_str(&format!("uh_stack_push(&st, uh_stringify(_v{tid}));\n", tid = *temp_id));
                *temp_id += 1;
            }
            ExprToken::StoreIndex => {
                out.push_str(indent);
                out.push_str(&format!("UhValue _v{tid} = uh_stack_pop(&st);\n", tid = *temp_id));
                out.push_str(indent);
                out.push_str(&format!("UhValue _k{tid} = uh_stack_pop(&st);\n", tid = *temp_id));
                out.push_str(indent);
                out.push_str(&format!("UhValue _c{tid} = uh_stack_pop(&st);\n", tid = *temp_id));
                out.push_str(indent);
                out.push_str(&format!("uh_store_index(&_c{tid}, _k{tid}, _v{tid});\n", tid = *temp_id));
                *temp_id += 1;
            }
            ExprToken::Assign(name) => {
                out.push_str(indent);
                out.push_str(&format!("UhValue _v{tid} = uh_stack_pop(&st);\n", tid = *temp_id));
                out.push_str(indent);
                out.push_str(&format!("uh_env_set(&env, \"{}\", _v{tid});\n", escape_c_string(name), tid = *temp_id));
                *temp_id += 1;
            }
            ExprToken::Print => {
                out.push_str(indent);
                out.push_str(&format!("UhValue _v{tid} = uh_stack_pop(&st);\n", tid = *temp_id));
                out.push_str(indent);
                out.push_str(&format!("uh_print(_v{tid});\n", tid = *temp_id));
                *temp_id += 1;
            }
            ExprToken::Call(name) => {
                if let Some((argc, callee)) = builtin_call(name) {
                    let mut args = Vec::new();
                    for _ in 0..argc {
                        out.push_str(indent);
                        out.push_str(&format!("UhValue _arg{tid} = uh_stack_pop(&st);\n", tid = *temp_id));
                        args.push(format!("_arg{tid}", tid = *temp_id));
                        *temp_id += 1;
                    }
                    args.reverse();
                    out.push_str(indent);
                    out.push_str(&format!("UhValue _call{tid} = {callee}(", tid = *temp_id));
                    for (idx, a) in args.iter().enumerate() {
                        if idx > 0 {
                            out.push_str(", ");
                        }
                        out.push_str(a);
                    }
                    out.push_str(");\n");
                    out.push_str(indent);
                    out.push_str(&format!("uh_stack_push(&st, _call{tid});\n", tid = *temp_id));
                    *temp_id += 1;
                } else {
                    let argc = *func_arity.get(name).ok_or_else(|| format!("unknown function: {name}"))?;
                    let mut args = Vec::new();
                    for _ in 0..argc {
                        out.push_str(indent);
                        out.push_str(&format!("UhValue _arg{tid} = uh_stack_pop(&st);\n", tid = *temp_id));
                        args.push(format!("_arg{tid}", tid = *temp_id));
                        *temp_id += 1;
                    }
                    args.reverse();
                    out.push_str(indent);
                    out.push_str(&format!("UhValue _call{tid} = uh_fn_{}(&env", name, tid = *temp_id));
                    for a in args {
                        out.push_str(&format!(", {a}"));
                    }
                    out.push_str(");\n");
                    out.push_str(indent);
                    out.push_str(&format!("uh_stack_push(&st, _call{tid});\n", tid = *temp_id));
                    *temp_id += 1;
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
        "read_file" | ".read" => Some((1, "uh_read_file")),
        "write_file" | ".write" => Some((2, "uh_write_file")),
        "syscall" | ".syscall" => Some((1, "uh_syscall")),
        "ws.serve" => Some((1, "uh_ws_serve")),
        "ws.connect" => Some((1, "uh_ws_connect")),
        ".receive" => Some((1, "uh_ws_receive")),
        ".send" => Some((2, "uh_send")),
        _ => None,
    }
}

fn escape_c_string(input: &str) -> String {
    let mut out = String::new();
    for c in input.chars() {
        match c {
            '\\' => out.push_str("\\\\"),
            '"' => out.push_str("\\\""),
            '\n' => out.push_str("\\n"),
            '\r' => out.push_str("\\r"),
            '\t' => out.push_str("\\t"),
            _ => out.push(c),
        }
    }
    out
}
