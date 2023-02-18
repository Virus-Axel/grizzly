use solana_program::{
    account_info::AccountInfo, entrypoint::ProgramResult, msg, program_error::ProgramError,
    pubkey::Pubkey,
};

use crate::bank_account_id;
use std::cell::RefMut;

pub fn verify_and_get_mut_data<'a>(
    program_id: &Pubkey,
    account: &'a AccountInfo<'a>,
) -> Result<RefMut<'a, &'a mut [u8]>, ProgramError> {
    if account.owner != program_id {
        return Err(ProgramError::IllegalOwner);
    }
    Ok(account.data.borrow_mut())
}

pub fn verify_bank_account<'a>(owner: &Pubkey, account: &'a AccountInfo<'a>) -> ProgramResult {
    if account.owner != owner {
        return Err(ProgramError::IllegalOwner);
    }
    if *account.key != bank_account_id() {
        return Err(ProgramError::InvalidArgument);
    }

    Ok(())
}

pub fn verify_bear_nft<'a>(
    program_id: &Pubkey,
    mint_account: &'a AccountInfo<'a>,
    token_account: &'a AccountInfo<'a>,
    grizzly_account: &'a AccountInfo<'a>,
    mapping_account: &'a AccountInfo<'a>,
) -> ProgramResult{
    Ok(())
}
