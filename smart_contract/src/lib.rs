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

use instruction::{
    arena_signup_instruction,
    reveal_secret_instruction::{self, reveal_secret_instruction},
    
};

use token_handler::{
    grizzly_token::create_grizzly_token,
    ability_token::{
        equip_ability_token,
        create_ability_token, merge_ability_tokens,
    }
};

pub fn arena_queue_id() -> Pubkey{
    Pubkey::new(bs58::decode("AErDcHrJfrPKNBP9is4EeW9v1abWsDdKW1kaosXbm3PL").into_vec().as_ref().unwrap())
}

pub fn bank_account_id() -> Pubkey{
    Pubkey::new(bs58::decode("ANdidaLBCN3KrDFyraGtPVQhpaQr2oAqpPqN2DJL4CXv").into_vec().as_ref().unwrap())
}

const NATIVE_TOKEN_ID: &str = "ABoFjoNoA5b2CM2iKzYE8RttpWgSwY7ZDnvWpaTg3igA";

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
        2 => reveal_secret_instruction(program_id, &accounts, &instruction_data),
        3 => arena_signup_instruction::clear_bear_data(program_id, &accounts, &instruction_data),
        4 => equip_ability_token(program_id, &accounts, &instruction_data),
        5 => create_ability_token(program_id, &accounts),
        6 => merge_ability_tokens(program_id, &accounts, &instruction_data)
        _ => {msg!("instruction data is {} hehe", instruction_data[0]); return Err(ProgramError::InvalidInstructionData)},
    }
}
