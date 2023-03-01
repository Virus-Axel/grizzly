mod instruction;
mod account_security;
mod data_structures;
mod arena;
mod token_handler;

use solana_program::{
    account_info::AccountInfo,
    entrypoint,
    entrypoint::ProgramResult,
    pubkey::Pubkey,
    program_error::ProgramError,
    msg, config::program,
};

use instruction::arena_signup_instruction;
use token_handler::grizzly_token::create_grizzly_token;

pub fn arena_queue_id() -> Pubkey{
    Pubkey::new(bs58::decode("arenaqueuepubkey123").into_vec().as_ref().unwrap())
}

pub fn bank_account_id() -> Pubkey{
    Pubkey::new(bs58::decode("bankaccountkey123").into_vec().as_ref().unwrap())
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
        0 => arena_signup_instruction::arena_signup(program_id, &accounts, &instruction_data),
        1 => create_grizzly_token(program_id, &accounts, &instruction_data),
        _ => {msg!("instruction data is {} hehe", instruction_data[0]); return Err(ProgramError::InvalidInstructionData)},
    }
}
