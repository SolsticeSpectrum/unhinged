use std::fmt;

#[derive(Debug, Clone, PartialEq)]
pub enum TokenKind {
    Number(f64),
    String(String),
    Ident(String),
    Symbol(String),
}

#[derive(Debug, Clone)]
pub struct Token {
    pub kind: TokenKind,
    pub line: usize,
    pub col: usize,
}

#[derive(Debug)]
pub struct LexError {
    pub message: String,
    pub line: usize,
    pub col: usize,
    pub file: String,
}

impl fmt::Display for LexError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}:{}:{}: {}", self.file, self.line, self.col, self.message)
    }
}

pub fn tokenize(input: &str, file: &str) -> Result<Vec<Token>, LexError> {
    let mut tokens = Vec::new();
    let mut chars = input.chars().peekable();
    let mut line = 1usize;
    let mut col = 1usize;

    let symbols = [
        "⊕⊕", "⊞⊞", "⊟⊟", "⊛", "⊞", "⊟", "⊠", "⊘", "⊙",
        "≡", "≢", "≺", "≻", "≼", "≽", "∧", "∨", "¬", "⊤", "⊥",
        "∅", "∈", "←",
        "→", "¿", "⊢", "⇄", "ƒ", "↦", "⟪", "⟫", "⍕", "⊕", "⊗",
        "【", "】", "⌈", "⌉", "❴", "❵",
        "↵", "⌫", "⟲", "⤴", "⤵",
    ];

    while let Some(&ch) = chars.peek() {
        if ch == '\n' {
            chars.next();
            line += 1;
            col = 1;
            continue;
        }
        if ch.is_whitespace() {
            chars.next();
            col += 1;
            continue;
        }
        if ch == ':' || ch == ',' {
            chars.next();
            col += 1;
            continue;
        }

        if ch == '⍝' {
            while let Some(c) = chars.next() {
                if c == '\n' {
                    line += 1;
                    col = 1;
                    break;
                }
            }
            continue;
        }

        if ch == '"' {
            let start_col = col;
            chars.next();
            col += 1;
            let mut s = String::new();
            while let Some(c) = chars.next() {
                col += 1;
                if c == '"' {
                    break;
                }
                if c == '\\' {
                    if let Some(escaped) = chars.next() {
                        col += 1;
                        match escaped {
                            'n' => s.push('\n'),
                            'r' => s.push('\r'),
                            't' => s.push('\t'),
                            '\"' => s.push('\"'),
                            '\\' => s.push('\\'),
                            other => s.push(other),
                        }
                        continue;
                    }
                }
                if c == '\n' {
                    return Err(LexError {
                        message: "unterminated string literal".to_string(),
                        line,
                        col: start_col,
                        file: file.to_string(),
                    });
                }
                s.push(c);
            }
            tokens.push(Token {
                kind: TokenKind::String(s),
                line,
                col: start_col,
            });
            continue;
        }

        if ch.is_ascii_digit() {
            let start_col = col;
            let mut num = String::new();
            while let Some(&c) = chars.peek() {
                if c.is_ascii_digit() || c == '.' {
                    num.push(c);
                    chars.next();
                    col += 1;
                } else {
                    break;
                }
            }
            let value: f64 = num.parse().map_err(|_| LexError {
                message: format!("invalid number: {num}"),
                line,
                col: start_col,
                file: file.to_string(),
            })?;
            tokens.push(Token {
                kind: TokenKind::Number(value),
                line,
                col: start_col,
            });
            continue;
        }

        let mut matched = None;
        for sym in symbols.iter() {
            if input_at(&mut chars, *sym) {
                matched = Some(sym.to_string());
                break;
            }
        }
        if let Some(sym) = matched {
            let start_col = col;
            for _ in sym.chars() {
                chars.next();
                col += 1;
            }
            tokens.push(Token {
                kind: TokenKind::Symbol(sym),
                line,
                col: start_col,
            });
            continue;
        }

        if ch.is_alphabetic() || ch == '_' || ch == '.' || is_apl_ident(ch) {
            let start_col = col;
            let mut ident = String::new();
            while let Some(&c) = chars.peek() {
                if c.is_alphanumeric() || c == '_' || c == '.' || is_apl_ident(c) {
                    ident.push(c);
                    chars.next();
                    col += 1;
                } else {
                    break;
                }
            }
            tokens.push(Token {
                kind: TokenKind::Ident(ident),
                line,
                col: start_col,
            });
            continue;
        }

        return Err(LexError {
            message: format!("unexpected character: {ch}"),
            line,
            col,
            file: file.to_string(),
        });
    }

    Ok(tokens)
}

fn input_at(chars: &mut std::iter::Peekable<std::str::Chars<'_>>, sym: &str) -> bool {
    let mut iter = chars.clone();
    for sc in sym.chars() {
        match iter.next() {
            Some(c) if c == sc => continue,
            _ => return false,
        }
    }
    true
}

fn is_apl_ident(ch: char) -> bool {
    matches!(ch, '⍺' | '⍵' | '⍹')
}
