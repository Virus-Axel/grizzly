mod arena_instruction;
mod account_security;

use solana_program::{
    account_info::AccountInfo,
    entrypoint,
    entrypoint::ProgramResult,
    pubkey::Pubkey,
    program_error::ProgramError,
    msg, config::program,
};

// Declare and export the program's entrypoint
entrypoint!(process_instruction);

// Program entrypoint's implementation
pub fn process_instruction(
    program_id: &Pubkey, // Public key of the account the hello world program was loaded into
    accounts: &[AccountInfo], // The accounts
    instruction_data: &[u8],
) -> ProgramResult {
    match instruction_data[0]{
        0 => arena_instruction::arena_signup(program_id, &accounts),
        _ => Err(ProgramError::InvalidInstructionData),
    }
}
