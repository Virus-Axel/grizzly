use solana_program::{
    account_info::{next_account_info, AccountInfo},
    entrypoint::ProgramResult,
    msg,
    program_error::ProgramError,
    pubkey::Pubkey,
    sysvar::{clock::Clock, Sysvar},
};

use crate::{
    account_security::verify_and_get_mut_data,
    arena::fight_system::{
        evaluate_winner,
        is_battle_aborted,
    },
    arena_queue_id,
    data_structures::{arena_structure, grizzly_structure},
};

use mod_exp::mod_exp;

fn get_mapping_keys(account_data: &[u8]) -> Result<(Pubkey, Pubkey), ProgramError> {
    let nft_pubkey = Pubkey::new(&account_data[0..32]);
    let grizzly_pubkey = Pubkey::new(&account_data[32..64]);
    Ok((nft_pubkey, grizzly_pubkey))
}


/*
    Signup for a battle in the arena.

    program_id: Public key of the executing program
    accounts: Accounts of the program. The account order is as follows:
        sender_account,
        mapping_account,
        nft_accounts,
        grizzly_account,
        arena_queue_account,
        past_challenger_bear (If there is one),
        challenging_bear (If there is one)
    instruction_data: Data should consist of:
        instruction type - offset 0, length 1
        (
        randomness - offset 1, length 32 if there is no challenging bear
        signature - offset 1, length 64 if there is a challenging bear
        )

*/
pub fn arena_signup<'a>(
    program_id: &Pubkey,
    accounts: &'a [AccountInfo<'a>],
    instruction_data: &[u8],
) -> ProgramResult {
    let accounts_iter = &mut accounts.iter();

    // Get the accounts
    let _sender_account = next_account_info(accounts_iter)?;
    let mapping_account = next_account_info(accounts_iter)?;
    let nft_account = next_account_info(accounts_iter)?;
    let grizzly_account = next_account_info(accounts_iter)?;
    let other_grizzly_account = next_account_info(accounts_iter)?;
    let arena_queue_account = next_account_info(accounts_iter)?;

    // Verify owners and extract data
    let mut mapping_data = verify_and_get_mut_data(program_id, mapping_account)?;
    let mut grizzly_data = verify_and_get_mut_data(program_id, grizzly_account)?;
    let mut other_grizzly_data = verify_and_get_mut_data(program_id, other_grizzly_account)?;

    // Check if we are challenging or not
    // Set AB and shared secret
    grizzly_data[grizzly_structure::AB].copy_from_slice(&instruction_data[1..9]);
    let secret = u64::from_le_bytes(instruction_data[9..17].try_into().unwrap());

    // Calculate shared key
    let shared_key = mod_exp(
        u64::from_le_bytes(other_grizzly_data[grizzly_structure::AB].try_into().unwrap()),
        secret,
        u64::from_le_bytes(grizzly_data[grizzly_structure::P].try_into().unwrap()),
    );

    if u64::from_le_bytes(other_grizzly_data[grizzly_structure::SHARED_KEY].try_into().unwrap()) != shared_key{
        return Err(ProgramError::InvalidAccountData);
    }

    // We have randomness and process went fine
    evaluate_winner(&mut grizzly_data, &mut other_grizzly_data, shared_key ^ secret);

    Ok(())
}
