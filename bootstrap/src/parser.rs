use std::collections::HashMap;
use std::fmt;

use crate::ast::{Block, Expr, Function, Program, Stmt};
use crate::lexer::{Token, TokenKind};

#[derive(Debug)]
pub struct ParseError {
    pub message: String,
    pub file: String,
    pub line: usize,
    pub col: usize,
}

impl fmt::Display for ParseError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}:{}:{}: {}", self.file, self.line, self.col, self.message)
    }
}

pub struct Parser {
    tokens: Vec<Token>,
    file: String,
    pos: usize,
}

impl Parser {
    pub fn new(tokens: Vec<Token>, file: &str) -> Self {
        Self {
            tokens,
            file: file.to_string(),
            pos: 0,
        }
    }

    pub fn parse_program(&mut self) -> Result<Program, ParseError> {
        let mut functions = Vec::new();
        let mut main_stmts = Vec::new();

        while !self.eof() {
            if self.peek_symbol("ƒ") {
                let func = self.parse_function()?;
                functions.push(func);
            } else if self.peek_symbol("⌫") {
                return Err(self.error_here("unexpected end of block"));
            } else {
                let stmt = self.parse_stmt()?;
                main_stmts.push(stmt);
            }
        }

        Ok(Program {
            functions,
            main: Block { stmts: main_stmts },
        })
    }

    fn parse_function(&mut self) -> Result<Function, ParseError> {
        let start = self.next().ok_or_else(|| self.error_here("unexpected EOF"))?;
        if !is_symbol(&start, "ƒ") {
            return Err(self.error_at(&start, "expected ƒ"));
        }

        let mut body_tokens = Vec::new();
        let mut nesting = 0i32;

        loop {
            let tok = self.next().ok_or_else(|| self.error_at(&start, "unterminated function"))?;
            if is_symbol(&tok, "↵") {
                nesting += 1;
            } else if is_symbol(&tok, "⌫") {
                nesting -= 1;
            }

            if nesting == 0 && is_symbol(&tok, "¿") {
                if let Ok((body, params, name)) = split_func_trailer(body_tokens.clone(), &self.file) {
                    let mut body_parser = Parser::new(body, &self.file);
                    let body = body_parser.parse_block()?;
                    return Ok(Function { name, params, body });
                }
                body_tokens.push(tok);
                continue;
            }
            body_tokens.push(tok);
        }
    }

    fn parse_block(&mut self) -> Result<Block, ParseError> {
        let mut stmts = Vec::new();
        while !self.eof() {
            if self.peek_symbol("⌫") {
                self.next();
                break;
            }
            stmts.push(self.parse_stmt()?);
        }
        Ok(Block { stmts })
    }

    fn parse_stmt(&mut self) -> Result<Stmt, ParseError> {
        let mut expr_tokens = Vec::new();
        loop {
            let tok = self.next().ok_or_else(|| self.error_here("unexpected EOF"))?;
            if is_symbol(&tok, "⊕") {
                self.expect_symbol("¿")?;
                return Ok(Stmt::Continue);
            }
            if is_symbol(&tok, "⊗") {
                self.expect_symbol("¿")?;
                return Ok(Stmt::Break);
            }
            if is_symbol(&tok, "¿") {
                return stmt_from_expr(expr_tokens, &self.file);
            }

            if is_symbol(&tok, "⤴") {
                let cond = Expr { tokens: map_expr(expr_tokens_to_expr(expr_tokens, &self.file)?) };
                self.expect_symbol("↵")?;
                let then_blk = self.parse_block()?;
                let else_blk = if self.peek_symbol("⤵") {
                    self.next();
                    if self.peek_symbol("↵") {
                        self.next();
                        Some(self.parse_block()?)
                    } else {
                        Some(self.parse_else_if_block()?)
                    }
                } else {
                    None
                };
                self.expect_symbol("¿")?;
                return Ok(Stmt::If { cond, then_blk, else_blk });
            }

            if is_symbol(&tok, "⟲") {
                let cond = Expr { tokens: map_expr(expr_tokens_to_expr(expr_tokens, &self.file)?) };
                self.expect_symbol("↵")?;
                let body = self.parse_block()?;
                self.expect_symbol("¿")?;
                return Ok(Stmt::While { cond, body });
            }

            expr_tokens.push(tok);
        }
    }

    fn expect_symbol(&mut self, sym: &str) -> Result<(), ParseError> {
        let tok = self.next().ok_or_else(|| self.error_here("unexpected EOF"))?;
        if !is_symbol(&tok, sym) {
            return Err(self.error_at(&tok, &format!("expected {sym}")));
        }
        Ok(())
    }

    fn parse_else_if_block(&mut self) -> Result<Block, ParseError> {
        let mut cond_tokens = Vec::new();
        while let Some(tok) = self.next() {
            if is_symbol(&tok, "⤴") {
                break;
            }
            cond_tokens.push(tok);
        }
        self.expect_symbol("↵")?;
        let then_blk = self.parse_block()?;
        let else_blk = if self.peek_symbol("⤵") {
            self.next();
            if self.peek_symbol("↵") {
                self.next();
                Some(self.parse_block()?)
            } else {
                Some(self.parse_else_if_block()?)
            }
        } else {
            None
        };
        let cond = Expr { tokens: map_expr(expr_tokens_to_expr(cond_tokens, &self.file)?) };
        Ok(Block { stmts: vec![Stmt::If { cond, then_blk, else_blk }] })
    }

    fn peek_symbol(&self, sym: &str) -> bool {
        self.tokens
            .get(self.pos)
            .map(|t| is_symbol(t, sym))
            .unwrap_or(false)
    }

    fn next(&mut self) -> Option<Token> {
        if self.pos >= self.tokens.len() {
            None
        } else {
            let tok = self.tokens[self.pos].clone();
            self.pos += 1;
            Some(tok)
        }
    }

    fn eof(&self) -> bool {
        self.pos >= self.tokens.len()
    }

    fn error_here(&self, msg: &str) -> ParseError {
        ParseError {
            message: msg.to_string(),
            file: self.file.clone(),
            line: 1,
            col: 1,
        }
    }

    fn error_at(&self, tok: &Token, msg: &str) -> ParseError {
        ParseError {
            message: msg.to_string(),
            file: self.file.clone(),
            line: tok.line,
            col: tok.col,
        }
    }
}

fn split_func_trailer(tokens: Vec<Token>, file: &str) -> Result<(Vec<Token>, Vec<String>, String), ParseError> {
    let mut params = Vec::new();
    let mut i = tokens.len();

    while i >= 2 {
        let name_tok = &tokens[i - 1];
        let arrow_tok = &tokens[i - 2];
        if !is_symbol(arrow_tok, "↦") {
            break;
        }
        match &name_tok.kind {
            TokenKind::Ident(name) => {
                params.push(name.clone());
            }
            _ => {
                return Err(ParseError {
                    message: "expected identifier after ↦".to_string(),
                    file: file.to_string(),
                    line: name_tok.line,
                    col: name_tok.col,
                });
            }
        }
        i -= 2;
        if i == 0 {
            break;
        }
    }

    if params.is_empty() {
        return Err(ParseError {
            message: "function missing name".to_string(),
            file: file.to_string(),
            line: 1,
            col: 1,
        });
    }

    let name = params.remove(0);
    params.reverse();
    Ok((tokens[..i].to_vec(), params, name))
}

fn stmt_from_expr(tokens: Vec<Token>, file: &str) -> Result<Stmt, ParseError> {
    let expr = expr_tokens_to_expr(tokens, file)?;
    if let Some(pos) = expr.iter().position(|t| matches!(t, LocalExprToken::ReturnMarker)) {
        if pos + 1 != expr.len() {
            return Err(ParseError {
                message: "return must be at end of statement".to_string(),
                file: file.to_string(),
                line: 1,
                col: 1,
            });
        }
        let before = expr[..pos].to_vec();
        let opt_expr = if before.is_empty() { None } else { Some(Expr { tokens: map_expr(before) }) };
        return Ok(Stmt::Return(opt_expr));
    }
    Ok(Stmt::Expr(Expr { tokens: map_expr(expr) }))
}

fn expr_tokens_to_expr(tokens: Vec<Token>, file: &str) -> Result<Vec<LocalExprToken>, ParseError> {
    let mut out = Vec::new();
    let mut i = 0usize;
    while i < tokens.len() {
        let tok = &tokens[i];
        match &tok.kind {
            TokenKind::Number(n) => out.push(LocalExprToken::Number(*n)),
            TokenKind::String(s) => out.push(LocalExprToken::String(s.clone())),
            TokenKind::Ident(name) => out.push(LocalExprToken::Ident(name.clone())),
            TokenKind::Symbol(sym) => match sym.as_str() {
                "⊞" => out.push(LocalExprToken::Add),
                "⊟" => out.push(LocalExprToken::Sub),
                "⊠" => out.push(LocalExprToken::Mul),
                "⊘" => out.push(LocalExprToken::Div),
                "⊙" => out.push(LocalExprToken::Mod),
                "⊞⊞" => out.push(LocalExprToken::Concat),
                "⌈" => out.push(LocalExprToken::Index),
                "⌉" => {}
                "⍕" => out.push(LocalExprToken::Stringify),
                "≡" => out.push(LocalExprToken::Eq),
                "≢" => out.push(LocalExprToken::Neq),
                "≺" => out.push(LocalExprToken::Lt),
                "≻" => out.push(LocalExprToken::Gt),
                "≼" => out.push(LocalExprToken::Le),
                "≽" => out.push(LocalExprToken::Ge),
                "∧" => out.push(LocalExprToken::And),
                "∨" => out.push(LocalExprToken::Or),
                "¬" => out.push(LocalExprToken::Not),
                "⊤" => out.push(LocalExprToken::Bool(true)),
                "⊥" => out.push(LocalExprToken::Bool(false)),
                "∅" => out.push(LocalExprToken::Null),
                "∈" => out.push(LocalExprToken::Contains),
                "⊢" => out.push(LocalExprToken::Print),
                "【" => {
                    let (arr, new_i) = parse_array_literal(&tokens, i, file)?;
                    out.push(LocalExprToken::Array(arr));
                    i = new_i;
                }
                "❴" => {
                    let (dict, new_i) = parse_dict_literal(&tokens, i, file)?;
                    out.push(LocalExprToken::Dict(dict));
                    i = new_i;
                }
                "→" => {
                    let next = tokens.get(i + 1).ok_or_else(|| ParseError {
                        message: "expected identifier after →".to_string(),
                        file: file.to_string(),
                        line: tok.line,
                        col: tok.col,
                    })?;
                    match &next.kind {
                        TokenKind::Ident(name) => out.push(LocalExprToken::Assign(name.clone())),
                        _ => {
                            return Err(ParseError {
                                message: "expected identifier after →".to_string(),
                                file: file.to_string(),
                                line: next.line,
                                col: next.col,
                            })
                        }
                    }
                    i += 1;
                }
                "⟪" => {
                    let name_tok = tokens.get(i + 1).ok_or_else(|| ParseError {
                        message: "expected identifier after ⟪".to_string(),
                        file: file.to_string(),
                        line: tok.line,
                        col: tok.col,
                    })?;
                    let end_tok = tokens.get(i + 2).ok_or_else(|| ParseError {
                        message: "expected ⟫ after identifier".to_string(),
                        file: file.to_string(),
                        line: tok.line,
                        col: tok.col,
                    })?;
                    if !is_symbol(end_tok, "⟫") {
                        return Err(ParseError {
                            message: "expected ⟫ after identifier".to_string(),
                            file: file.to_string(),
                            line: end_tok.line,
                            col: end_tok.col,
                        });
                    }
                    match &name_tok.kind {
                        TokenKind::Ident(name) => out.push(LocalExprToken::Call(name.clone())),
                        _ => {
                            return Err(ParseError {
                                message: "expected identifier after ⟪".to_string(),
                                file: file.to_string(),
                                line: name_tok.line,
                                col: name_tok.col,
                            })
                        }
                    }
                    i += 2;
                }
                "⇄" => out.push(LocalExprToken::ReturnMarker),
                "←" => out.push(LocalExprToken::StoreIndexMarker),
                "↵" | "⌫" | "⤴" | "⤵" | "⟲" | "ƒ" | "↦" | "⟫" | "¿" | "】" | "⊕" | "⊗" => {
                    return Err(ParseError {
                        message: format!("unexpected symbol in expression: {sym}"),
                        file: file.to_string(),
                        line: tok.line,
                        col: tok.col,
                    })
                }
                _ => {
                    return Err(ParseError {
                        message: format!("unsupported symbol in expression: {sym}"),
                        file: file.to_string(),
                        line: tok.line,
                        col: tok.col,
                    })
                }
            },
        }
        i += 1;
    }
    if let Some(_pos) = out.iter().position(|t| matches!(t, LocalExprToken::StoreIndexMarker)) {
        out.retain(|t| !matches!(t, LocalExprToken::StoreIndexMarker));
        if let Some(last) = out.last() {
            if matches!(last, LocalExprToken::Index) {
                out.pop();
            }
        }
        out.push(LocalExprToken::StoreIndex);
    }
    Ok(out)
}

fn map_expr(expr: Vec<LocalExprToken>) -> Vec<crate::ast::ExprToken> {
    expr.into_iter().filter_map(|t| match t {
        LocalExprToken::ReturnMarker => None,
        other => Some(other.into()),
    }).collect()
}

fn is_symbol(tok: &Token, sym: &str) -> bool {
    matches!(&tok.kind, TokenKind::Symbol(s) if s == sym)
}

#[derive(Debug, Clone)]
enum LocalExprToken {
    Number(f64),
    Bool(bool),
    Null,
    String(String),
    Ident(String),
    Array(Vec<LocalExprToken>),
    Dict(Vec<(LocalExprToken, LocalExprToken)>),
    Add,
    Sub,
    Mul,
    Div,
    Mod,
    Concat,
    Index,
    Stringify,
    StoreIndex,
    StoreIndexMarker,
    Contains,
    Eq,
    Neq,
    Lt,
    Gt,
    Le,
    Ge,
    And,
    Or,
    Not,
    Assign(String),
    Call(String),
    Print,
    ReturnMarker,
}

impl From<LocalExprToken> for crate::ast::ExprToken {
    fn from(token: LocalExprToken) -> Self {
        match token {
            LocalExprToken::Number(n) => crate::ast::ExprToken::Number(n),
            LocalExprToken::Bool(b) => crate::ast::ExprToken::Bool(b),
            LocalExprToken::Null => crate::ast::ExprToken::Null,
            LocalExprToken::String(s) => crate::ast::ExprToken::String(s),
            LocalExprToken::Ident(s) => crate::ast::ExprToken::Ident(s),
            LocalExprToken::Array(items) => {
                let mapped = items
                    .into_iter()
                    .filter_map(|t| match t {
                        LocalExprToken::ReturnMarker => None,
                        other => Some(other.into()),
                    })
                    .collect();
                crate::ast::ExprToken::Array(mapped)
            }
            LocalExprToken::Dict(pairs) => {
                let mapped = pairs
                    .into_iter()
                    .map(|(k, v)| (k.into(), v.into()))
                    .collect();
                crate::ast::ExprToken::Dict(mapped)
            }
            LocalExprToken::Add => crate::ast::ExprToken::Add,
            LocalExprToken::Sub => crate::ast::ExprToken::Sub,
            LocalExprToken::Mul => crate::ast::ExprToken::Mul,
            LocalExprToken::Div => crate::ast::ExprToken::Div,
            LocalExprToken::Mod => crate::ast::ExprToken::Mod,
            LocalExprToken::Concat => crate::ast::ExprToken::Concat,
            LocalExprToken::Index => crate::ast::ExprToken::Index,
            LocalExprToken::Stringify => crate::ast::ExprToken::Stringify,
            LocalExprToken::StoreIndex => crate::ast::ExprToken::StoreIndex,
            LocalExprToken::Contains => crate::ast::ExprToken::Contains,
            LocalExprToken::Eq => crate::ast::ExprToken::Eq,
            LocalExprToken::Neq => crate::ast::ExprToken::Neq,
            LocalExprToken::Lt => crate::ast::ExprToken::Lt,
            LocalExprToken::Gt => crate::ast::ExprToken::Gt,
            LocalExprToken::Le => crate::ast::ExprToken::Le,
            LocalExprToken::Ge => crate::ast::ExprToken::Ge,
            LocalExprToken::And => crate::ast::ExprToken::And,
            LocalExprToken::Or => crate::ast::ExprToken::Or,
            LocalExprToken::Not => crate::ast::ExprToken::Not,
            LocalExprToken::Assign(s) => crate::ast::ExprToken::Assign(s),
            LocalExprToken::Call(s) => crate::ast::ExprToken::Call(s),
            LocalExprToken::Print => crate::ast::ExprToken::Print,
            LocalExprToken::ReturnMarker => unreachable!(),
            LocalExprToken::StoreIndexMarker => unreachable!(),
        }
    }
}

fn parse_array_literal(tokens: &[Token], start: usize, file: &str) -> Result<(Vec<LocalExprToken>, usize), ParseError> {
    let mut items = Vec::new();
    let mut i = start + 1;
    while i < tokens.len() {
        let tok = &tokens[i];
        if is_symbol(tok, "】") {
            return Ok((items, i));
        }
        match &tok.kind {
            TokenKind::Number(n) => items.push(LocalExprToken::Number(*n)),
            TokenKind::String(s) => items.push(LocalExprToken::String(s.clone())),
            TokenKind::Ident(name) => items.push(LocalExprToken::Ident(name.clone())),
            TokenKind::Symbol(sym) if sym == "⊤" => items.push(LocalExprToken::Bool(true)),
            TokenKind::Symbol(sym) if sym == "⊥" => items.push(LocalExprToken::Bool(false)),
            TokenKind::Symbol(sym) if sym == "∅" => items.push(LocalExprToken::Null),
            TokenKind::Symbol(sym) if sym == "❴" => {
                let (nested, new_i) = parse_dict_literal(tokens, i, file)?;
                items.push(LocalExprToken::Dict(nested));
                i = new_i;
            }
            TokenKind::Symbol(sym) if sym == "【" => {
                let (nested, new_i) = parse_array_literal(tokens, i, file)?;
                items.push(LocalExprToken::Array(nested));
                i = new_i;
            }
            _ => {
                return Err(ParseError {
                    message: "unsupported array element".to_string(),
                    file: file.to_string(),
                    line: tok.line,
                    col: tok.col,
                });
            }
        }
        i += 1;
    }
    Err(ParseError {
        message: "unterminated array literal".to_string(),
        file: file.to_string(),
        line: 1,
        col: 1,
    })
}

fn parse_dict_literal(tokens: &[Token], start: usize, file: &str) -> Result<(Vec<(LocalExprToken, LocalExprToken)>, usize), ParseError> {
    let mut items: Vec<(LocalExprToken, LocalExprToken)> = Vec::new();
    let mut i = start + 1;
    let mut pending_key: Option<LocalExprToken> = None;
    while i < tokens.len() {
        let tok = &tokens[i];
        if is_symbol(tok, "❵") {
            if pending_key.is_some() {
                return Err(ParseError {
                    message: "dict literal missing value".to_string(),
                    file: file.to_string(),
                    line: tok.line,
                    col: tok.col,
                });
            }
            return Ok((items, i));
        }
        let value = match &tok.kind {
            TokenKind::Number(n) => LocalExprToken::Number(*n),
            TokenKind::String(s) => LocalExprToken::String(s.clone()),
            TokenKind::Ident(name) => LocalExprToken::Ident(name.clone()),
            TokenKind::Symbol(sym) if sym == "⊤" => LocalExprToken::Bool(true),
            TokenKind::Symbol(sym) if sym == "⊥" => LocalExprToken::Bool(false),
            TokenKind::Symbol(sym) if sym == "∅" => LocalExprToken::Null,
            TokenKind::Symbol(sym) if sym == "【" => {
                let (nested, new_i) = parse_array_literal(tokens, i, file)?;
                i = new_i;
                LocalExprToken::Array(nested)
            }
            TokenKind::Symbol(sym) if sym == "❴" => {
                let (nested, new_i) = parse_dict_literal(tokens, i, file)?;
                i = new_i;
                LocalExprToken::Dict(nested)
            }
            _ => {
                return Err(ParseError {
                    message: "unsupported dict element".to_string(),
                    file: file.to_string(),
                    line: tok.line,
                    col: tok.col,
                });
            }
        };
        if let Some(key) = pending_key.take() {
            items.push((key, value));
        } else {
            pending_key = Some(value);
        }
        i += 1;
    }
    Err(ParseError {
        message: "unterminated dict literal".to_string(),
        file: file.to_string(),
        line: 1,
        col: 1,
    })
}

pub fn collect_functions(programs: &[Program]) -> HashMap<String, usize> {
    let mut map = HashMap::new();
    for prog in programs {
        for f in &prog.functions {
            map.insert(f.name.clone(), f.params.len());
        }
    }
    map
}
