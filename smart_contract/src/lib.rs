mod arena_instruction;
mod account_security;
mod data_structures;
mod arena;

use solana_program::{
    account_info::AccountInfo,
    entrypoint,
    entrypoint::ProgramResult,
    pubkey::Pubkey,
    program_error::ProgramError,
    msg, config::program,
};

pub fn arena_queue_id() -> Pubkey{
    Pubkey::new(bs58::decode("arenaqueuepubkey123").into_vec().as_ref().unwrap())
}

// Declare and export the program's entrypoint
entrypoint!(process_instruction);

// Program entrypoint's implementation
pub fn process_instruction<'a>(
    program_id: &Pubkey, // Public key of the account the hello world program was loaded into
    accounts: &'a [AccountInfo<'a>], // The accounts
    instruction_data: &[u8],
) -> ProgramResult {
    match instruction_data[0]{
        0 => arena_instruction::arena_signup(program_id, &accounts),
        _ => Err(ProgramError::InvalidInstructionData),
    }
}
