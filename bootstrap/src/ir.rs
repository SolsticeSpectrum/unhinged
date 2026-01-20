#[derive(Debug, Clone)]
pub enum Instr {
    PushNum(f64),
    PushStr(String),
    Load(String),
    Store(String),
    Add,
    Sub,
    Mul,
    Div,
    Mod,
    Print,
    Halt,
}
