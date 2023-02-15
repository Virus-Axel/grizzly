use solana_program::{
    account_info::AccountInfo,
    pubkey::Pubkey,
    program_error::ProgramError,
    msg,
};

use std::cell::RefMut;

pub fn verify_and_get_mut_data<'a>(program_id: &Pubkey, account: &'a AccountInfo<'a>) -> Result<RefMut<'a, &'a mut [u8]>, ProgramError>{
    if account.owner != program_id{
        return Err(ProgramError::IllegalOwner);
    }
    Ok(account.data.borrow_mut())
}