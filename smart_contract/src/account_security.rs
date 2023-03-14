use solana_program::{
    account_info::AccountInfo, entrypoint::ProgramResult, msg, program_error::ProgramError,
    pubkey::Pubkey,
};
use spl_associated_token_account::get_associated_token_address_with_program_id;

use crate::ENABLE_METADATA;
use crate::bank_account_id;
use std::cell::RefMut;

use crate::token_handler::grizzly_token::AUTHORITY_SEED;

use crate::token_handler::grizzly_token::get_mapping_keys;

use spl_associated_token_account::get_associated_token_address;

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
    msg!("0");
    if account.owner != owner {
        return Err(ProgramError::IllegalOwner);
    }
    msg!("1");
    if account.key != &bank_account_id() {
        return Err(ProgramError::InvalidArgument);
    }
    msg!("2");

    Ok(())
}

pub fn validate_bear_nft<'a>(
    program_id: &Pubkey,
    sender_account: &'a AccountInfo<'a>,
    mint_account: &'a AccountInfo<'a>,
    token_account: &'a AccountInfo<'a>,
    metadata_account: &'a AccountInfo<'a>,
    grizzly_account: &'a AccountInfo<'a>,
    mapping_account: &'a AccountInfo<'a>,
) -> ProgramResult{
    // Verify owners and extract data
    let mapping_data = verify_and_get_mut_data(program_id, mapping_account)?;
    let (nft_pubkey, grizzly_pubkey) = get_mapping_keys(&mapping_data)?;
    
    msg!("Checking that {} equals to  {}", nft_pubkey.to_string(), mint_account.key.to_string());
    if nft_pubkey != *mint_account.key
        || grizzly_pubkey != *grizzly_account.key
    {
        return Err(ProgramError::InvalidAccountData);
    }

    // Check if token account is ours
    let expected_token_account = get_associated_token_address_with_program_id(&sender_account.key, &mint_account.key, &spl_token_2022::ID);
    msg!("Checking that {} equals to {}", expected_token_account.to_string(), token_account.key.to_string());
    if expected_token_account != *token_account.key{
        return Err(ProgramError::IllegalOwner);
    }

    let (expected_mint_authority, _bump) = Pubkey::find_program_address(
        &[AUTHORITY_SEED, program_id.as_ref()],
        &program_id
    );

    let mint_data = mint_account.data.borrow_mut();
    let token_data = token_account.data.borrow_mut();
    let metadata_data = metadata_account.data.borrow_mut();

    // Check if we are the owner of the token
    msg!("Checking if we are the owner of the token");
    if token_data[64] != 1{
        return Err(ProgramError::IllegalOwner);
    }

    if token_data[108] != 1{
        msg!("Data at 108 is not 1: {}", token_data[108]);
        return Err(ProgramError::InsufficientFunds);
    }

    // Check if we have one of the token in the mint
    if mint_data[36] != 1{
        msg!("Data at 36 is not 1: {}", token_data[36]);
        return Err(ProgramError::InsufficientFunds);
    }

    if ENABLE_METADATA{
        // Verify with metaplex
        const METADATA_SIGNED: usize = 358;
        if metadata_data[METADATA_SIGNED] == 0{
            msg!("Data at 358 is not 1: {}", token_data[358]);
            return Err(ProgramError::InsufficientFunds);
        }

        msg!("Checking if we provided the correct metaplex key");
        //if metadata_account.owner != &mpl_token_metadata::ID{
        //   return Err(ProgramError::IllegalOwner);
        //}

        let update_auth = Pubkey::new(&metadata_data[1..33]);
        let freeze_auth = Pubkey::new(&metadata_data[326..358]);

        if update_auth != expected_mint_authority{
            return Err(ProgramError::InvalidAccountData);
        }
        if freeze_auth != expected_mint_authority{
            return Err(ProgramError::InvalidAccountData);
        }
    }
    msg!("NFT is valid");

    Ok(())
}

pub fn verify_ability_token<'a>(
    sender_account: &'a AccountInfo<'a>,
    mint_account: &'a AccountInfo<'a>,
    token_account: &'a AccountInfo<'a>,
) -> ProgramResult{

    // Check if token account is ours
    msg!("Checking if token is ours");
    let expected_token_account = get_associated_token_address_with_program_id(&sender_account.key, &mint_account.key, &spl_token_2022::ID);
    if expected_token_account != *token_account.key{
        return Err(ProgramError::IllegalOwner);
    }

    let mint_data = mint_account.data.borrow_mut();
    let token_data = token_account.data.borrow_mut();

    // Check token balance
    msg!("Checking balance of token");
    if token_data[64] < 1{
        msg!("token data at 64 is: {}", token_data[64]);
        return Err(ProgramError::InsufficientFunds);
    }

    if token_data[108] != 1{
        return Err(ProgramError::InsufficientFunds);
    }

    // Check if we have one of the token in the mint
    /*if mint_data[36] != 1{
        return Err(ProgramError::InsufficientFunds);
    }*/

    Ok(())
}
