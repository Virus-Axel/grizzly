use solana_program::{
    account_info::{next_account_info, AccountInfo},
    entrypoint::ProgramResult,
    msg,
    program::{invoke, invoke_signed},
    program_error::ProgramError,
    pubkey::Pubkey,
    system_instruction,
    system_instruction::create_account,
};

use spl_token::instruction::{initialize_mint, mint_to};

use spl_associated_token_account::instruction::create_associated_token_account;

use mpl_token_metadata::instruction::{
    create_master_edition_v3, create_metadata_accounts_v3, sign_metadata,
};

use crate::{account_security::{validate_bear_nft, verify_ability_token, verify_bank_account, verify_and_get_mut_data}, data_structures::grizzly_structure};

pub const AUTHORITY_SEED: &[u8] = b"GRIZZLY_SEED";

const ABILITY_TOKEN_IDS: [&str; 5] = [
    "TOKEN_PUBKEY",
    "TOKEN_PUBKEY",
    "TOKEN_PUBKEY",
    "TOKEN_PUBKEY",
    "TOKEN_PUBKEY",
];

pub fn equip_ability_token<'a>(
    program_id: &Pubkey,
    accounts: &'a [AccountInfo<'a>],
    instruction_data: &[u8],
) -> ProgramResult {
    let accounts_iter = &mut accounts.iter();

    let sender_account = next_account_info(accounts_iter)?;
    let mint = next_account_info(accounts_iter)?;

    // PDA
    let mint_authority = next_account_info(accounts_iter)?;

    let token_account = next_account_info(accounts_iter)?;
    let rent = next_account_info(accounts_iter)?;
    let system_program = next_account_info(accounts_iter)?;
    let token_program = next_account_info(accounts_iter)?;
    let associated_token_program = next_account_info(accounts_iter)?;
    let metadata_program = next_account_info(accounts_iter)?;
    let metadata_account = next_account_info(accounts_iter)?;
    let master_edition = next_account_info(accounts_iter)?;

    // Accounts for mapping NFT to grizzly
    let mapping_account = next_account_info(accounts_iter)?;
    let grizzly_account = next_account_info(accounts_iter)?;

    let ability_mint = next_account_info(accounts_iter)?;
    let ability_token = next_account_info(accounts_iter)?;

    // Verify nft
    validate_bear_nft(program_id, sender_account, mint, token_account, metadata_account, grizzly_account, mapping_account)?;
    verify_ability_token(sender_account, ability_mint, ability_token)?;

    let (expected_mint_authority, bump) =
        Pubkey::find_program_address(&[AUTHORITY_SEED, program_id.as_ref()], &program_id);

    if *mint_authority.key != expected_mint_authority {
        return Err(ProgramError::InvalidArgument);
    }

    // Verify that ability index and key is correct
    let ability_index = instruction_data[1];
    if ability_mint.key.to_string() != ABILITY_TOKEN_IDS[ability_index as usize]{
        return Err(ProgramError::InvalidInstructionData);
    }

    // Pay out prize
    let mut grizzly_data = verify_and_get_mut_data(program_id, grizzly_account)?;
    if grizzly_data[0] == 0 && grizzly_data[grizzly_structure::AB.start] != 0{
        give_ability_token(program_id, sender_account, ability_mint, ability_token, token_program, associated_token_program, mint_authority, rent, 1, grizzly_data[grizzly_structure::AB.start])?;
        grizzly_data[grizzly_structure::AB.start] = 0;
    }

    let _ = invoke(
        &create_associated_token_account(
            &sender_account.key,
            &sender_account.key,
            &ability_mint.key,
            &spl_token::id(),
        ),
        &[
            ability_mint.clone(),
            token_account.clone(),
            sender_account.clone(),
            token_program.clone(),
            associated_token_program.clone(),
        ],
    );

    invoke_signed(
        &mint_to(
            &token_program.key,
            &ability_mint.key,
            &ability_token.key,
            &mint_authority.key,
            &[mint_authority.key],
            1,
        )?,
        &[
            ability_mint.clone(),
            mint_authority.clone(),
            ability_token.clone(),
            token_program.clone(),
            rent.clone(),
        ],
        &[&[AUTHORITY_SEED, program_id.as_ref(), &[bump]]],
    )?;

    // Increase the level.
    let mut grizzly_data = verify_and_get_mut_data(program_id, grizzly_account)?;
    if grizzly_data[ability_index as usize] == 255{
        return Err(ProgramError::MaxAccountsDataSizeExceeded);
    }
    grizzly_data[ability_index as usize] += 1;

    return Ok(());
}

pub fn give_ability_token<'a>(
    program_id: &Pubkey,
    sender_account: &AccountInfo<'a>,
    mint: &AccountInfo<'a>,
    token_account: &AccountInfo<'a>,
    token_program: &AccountInfo<'a>,
    associated_token_program: &AccountInfo<'a>,
    mint_authority: &AccountInfo<'a>,
    rent: &AccountInfo<'a>,
    amount: u64,
    index: u8,
) -> ProgramResult {

    if mint.key.to_string() != ABILITY_TOKEN_IDS[index as usize]{
        return Err(ProgramError::InvalidAccountData);
    }

    let (_expected_mint_authority, bump) =
        Pubkey::find_program_address(&[AUTHORITY_SEED, program_id.as_ref()], &program_id);

    let _ = invoke(
        &create_associated_token_account(
            &sender_account.key,
            &sender_account.key,
            &mint.key,
            &spl_token::id(),
        ),
        &[
            mint.clone(),
            token_account.clone(),
            sender_account.clone(),
            token_program.clone(),
            associated_token_program.clone(),
        ],
    );

    invoke_signed(
        &mint_to(
            &token_program.key,
            &mint.key,
            &token_account.key,
            &mint_authority.key,
            &[mint_authority.key],
            amount,
        )?,
        &[
            mint.clone(),
            mint_authority.clone(),
            token_account.clone(),
            token_program.clone(),
            rent.clone(),
        ],
        &[&[AUTHORITY_SEED, program_id.as_ref(), &[bump]]],
    )?;

    return Ok(());
}
