#[derive(Debug, Clone)]
pub struct Program {
    pub functions: Vec<Function>,
    pub main: Block,
}

#[derive(Debug, Clone)]
pub struct Function {
    pub name: String,
    pub params: Vec<String>,
    pub body: Block,
}

#[derive(Debug, Clone)]
pub struct Block {
    pub stmts: Vec<Stmt>,
}

#[derive(Debug, Clone)]
pub enum Stmt {
    Expr(Expr),
    If { cond: Expr, then_blk: Block, else_blk: Option<Block> },
    While { cond: Expr, body: Block },
    Return(Option<Expr>),
    Break,
    Continue,
}

#[derive(Debug, Clone)]
pub struct Expr {
    pub tokens: Vec<ExprToken>,
}

#[derive(Debug, Clone)]
pub enum ExprToken {
    Number(f64),
    Bool(bool),
    Null,
    String(String),
    Ident(String),
    Array(Vec<ExprToken>),
    Dict(Vec<(ExprToken, ExprToken)>),
    Add,
    Sub,
    Mul,
    Div,
    Mod,
    Concat,
    Index,
    Stringify,
    StoreIndex,
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
}
