use solana_program::{
    account_info::{next_account_info, AccountInfo},
    entrypoint::ProgramResult,
    msg,
    program_error::ProgramError,
    pubkey::Pubkey,
    program::{
        invoke_signed,
        invoke,
    },
    system_instruction,
    system_instruction::create_account,
};

use spl_token::instruction::{
    initialize_mint,
    mint_to,
};

use spl_associated_token_account::instruction::{
    create_associated_token_account
};

use mpl_token_metadata::instruction::{
    create_metadata_accounts_v3,
    create_master_edition_v3,
    sign_metadata,
};

use crate::account_security::{verify_bank_account, verify_and_get_mut_data};

const AUTHORITY_SEED: &[u8] = b"GRIZZLY_SEED";
const NFT_COST: u64 = 100000000;

pub fn get_mapping_keys(account_data: &[u8]) -> Result<(Pubkey, Pubkey), ProgramError> {
    let nft_pubkey = Pubkey::new(&account_data[0..32]);
    let grizzly_pubkey = Pubkey::new(&account_data[32..64]);
    Ok((nft_pubkey, grizzly_pubkey))
}

fn set_mapping_keys(account_data: &mut [u8], nft_key: &Pubkey, grizzly_key: &Pubkey){
    account_data[0..32].copy_from_slice(&nft_key.to_bytes());
    account_data[32..64].copy_from_slice(&grizzly_key.to_bytes());
}

pub fn create_grizzly_token<'a>(
    program_id: &Pubkey,
    accounts: &'a [AccountInfo<'a>],
    instruction_data: &[u8],
) -> ProgramResult{
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

    let bank_account = next_account_info(accounts_iter)?;

    // Accounts for mapping NFT to grizzly
    let mapping_account = next_account_info(accounts_iter)?;
    let grizzly_account = next_account_info(accounts_iter)?;

    // Verify mapping accounts and set internal keys
    let mut mapping_data = verify_and_get_mut_data(program_id, mapping_account)?;
    set_mapping_keys(&mut mapping_data, mint.key, grizzly_account.key);

    verify_bank_account(program_id, bank_account)?;

    let (expected_mint_authority, bump) = Pubkey::find_program_address(
        &[AUTHORITY_SEED, program_id.as_ref()],
        &program_id
    );

    if *mint_authority.key != expected_mint_authority{
        return Err(ProgramError::InvalidArgument);
    }

    invoke_signed(
        &create_account(
            &mint_authority.key,
            &mint.key,
            4593600,
            82,
            &token_program.key,
        ),
        &[
            mint.clone(),
            mint_authority.clone(),
            token_account.clone(),
        ],
        &[&[AUTHORITY_SEED, program_id.as_ref(), &[bump]]]
    )?;

    invoke(
        &initialize_mint(
            &token_program.key,
            &mint.key,
            &mint_authority.key,
            Some(&mint_authority.key),
            0,
        )?,
        &[
            mint.clone(),
            mint_authority.clone(),
            token_program.clone(),
            rent.clone(),
        ],
    )?;

    invoke(
        &create_associated_token_account(
            &sender_account.key,
            &sender_account.key,
            &mint.key,
            &spl_token::id()
        ),
        &[
            mint.clone(),
            token_account.clone(),
            sender_account.clone(),
            token_program.clone(),
            associated_token_program.clone(),
        ],
    )?;

    invoke_signed(
        &mint_to(
            &token_program.key,
            &mint.key,
            &token_account.key,
            &mint_authority.key,
            &[mint_authority.key],
            1,
        )?,
        &[
            mint.clone(),
            mint_authority.clone(),
            token_account.clone(),
            token_program.clone(),
            rent.clone(),
        ],
        &[&[AUTHORITY_SEED, program_id.as_ref(), &[bump]]]
    )?;

    // Pay for token.
    invoke(
        &system_instruction::transfer(sender_account.key, bank_account.key, NFT_COST),
        &[sender_account.clone(), bank_account.clone(), system_program.clone()],
    )?;

    // Set metadata.
    let name_length = instruction_data[1];
    let name = String::from_utf8(instruction_data[2..2+name_length as usize].to_vec()).unwrap();
    let symbol = "GRIZZLY".to_string();
    let url = "http://www.cryptoforts.com/grizzly/".to_string() + &mint.key.to_string() + &"/".to_string() + &name;
    let creators = Some(vec![mpl_token_metadata::state::Creator{
        address: *mint_authority.key,
        verified: false,
        share: 100,
    }]);

    // Create metadata account.
    invoke_signed(
        &create_metadata_accounts_v3(
            *metadata_program.key,
            *metadata_account.key,
            *mint.key,
            *mint_authority.key,
            *sender_account.key,
            *mint_authority.key,
            name,
            symbol,
            url,
            creators,
            1,
            true,
            false,
            None,
            None,
            None,
        ),
        &[
            metadata_account.clone(),
            mint.clone(),
            mint_authority.clone(),
            sender_account.clone(),
            mint_authority.clone(),
            system_program.clone(),
            rent.clone(),
        ],
        &[&[AUTHORITY_SEED, program_id.as_ref(), &[bump]]],
    )?;

    // Create master edition.
    invoke_signed(
        &create_master_edition_v3(
            *metadata_program.key,
            *master_edition.key,
            *mint.key,
            *mint_authority.key,
            *mint_authority.key,
            *metadata_account.key,
            *mint_authority.key,
            Some(0),
        ),
        &[
            master_edition.clone(),
            metadata_account.clone(),
            mint.clone(),
            token_account.clone(),
            mint_authority.clone(), // Maybe should be sender
            rent.clone(),
        ],
        &[&[AUTHORITY_SEED, program_id.as_ref(), &[bump]]]
    )?;

    // Sign this metadata to prove it is legit.
    invoke_signed(
        &sign_metadata(
            *metadata_program.key,
            *metadata_account.key,
            *mint_authority.key,
        ),
        &[
            mint_authority.clone(),
            metadata_account.clone(),
            metadata_program.clone(),
        ],
        &[&[AUTHORITY_SEED, program_id.as_ref(), &[bump]]]
    )?;

    return Ok(());
}