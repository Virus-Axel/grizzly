use solana_program::{
    account_info::{AccountInfo, next_account_info},
    entrypoint::ProgramResult,
    pubkey::Pubkey,
    msg, program_error::ProgramError,
};

use crate::account_security::verify_and_get_mut_data;

fn get_mapping_keys(account_data: &[u8]) -> Result<(Pubkey, Pubkey), ProgramError>{
    let nft_pubkey = Pubkey::new(&account_data[0..32]);
    let grizzly_pubkey = Pubkey::new(&account_data[32..64]);
    Ok((nft_pubkey, grizzly_pubkey))

}

pub fn arena_signup(program_id: &Pubkey, accounts: &[AccountInfo]) -> ProgramResult{
    let accounts_iter = &mut accounts.iter();

    let sender_account = next_account_info(accounts_iter)?;
    let mapping_account = next_account_info(accounts_iter)?;
    let mapping_data = verify_and_get_mut_data(program_id, sender_account)?;



    Ok(())
}