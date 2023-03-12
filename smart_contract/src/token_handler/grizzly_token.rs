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

use crate::{
    data_structures::grizzly_structure,
    NATIVE_TOKEN_ID,
    account_security::{
        verify_bank_account,
        verify_and_get_mut_data
    },
};

pub const AUTHORITY_SEED: &[u8] = b"cryptoforts_mint_seed";
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

    // Accounts for native currency
    let native_mint = next_account_info(accounts_iter)?;
    let native_token = next_account_info(accounts_iter)?;
 //   let grizzly_program = next_account_info(accounts_iter)?;

    // Verify native mint
    if native_mint.key.to_string() != NATIVE_TOKEN_ID{
        return Err(ProgramError::IllegalOwner);
    }

    //msg!("Trying to create mapping account: {}", &mapping_account.key.to_string());
    // Create Mapping account and grizzly account
    invoke(
        &create_account(
            &sender_account.key,
            &mapping_account.key,
            4593600,
            64,
            &program_id,
        ),
        &[
            mapping_account.clone(),
            sender_account.clone(),
            //grizzly_program.clone(),
        ],
    )?;


    //msg!("Creating grizzly account {}", grizzly_account.key.to_string());
    invoke(
        &create_account(
            &sender_account.key,
            &grizzly_account.key,
            6000000,
            grizzly_structure::SIZE as u64,
            &program_id,
        ),
        &[
            grizzly_account.clone(),
            sender_account.clone(),
            //grizzly_program.clone(),
        ],
    )?;
    //let mut grizzly_data = verify_and_get_mut_data(program_id, grizzly_account)?;
    //grizzly_data[grizzly_structure::HEART_SIZE].copy_from_slice(&1_u32.to_le_bytes());

    //msg!("Verifying mapping accounts");

    // Verify mapping accounts and set internal keys
    let mut mapping_data = verify_and_get_mut_data(program_id, mapping_account)?;
    set_mapping_keys(&mut mapping_data, mint.key, grizzly_account.key);

    //msg!("Verifying bank account");
    verify_bank_account(program_id, bank_account)?;

    //msg!("Verifying that mint authority is PDA");
    let (expected_mint_authority, bump) = Pubkey::find_program_address(
        &[AUTHORITY_SEED, program_id.as_ref()],
        &program_id
    );

    if *mint_authority.key != expected_mint_authority{
        return Err(ProgramError::InvalidArgument);
    }

    //msg!("Creating mint with payer: {}", mint_authority.key.to_string());
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

    //msg!("Initializing mint");
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

    //msg!("Creating associated token account");
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

    if instruction_data[2] == 1{
        //msg!("Creating associated native account");
        invoke(
            &create_associated_token_account(
                &sender_account.key,
                &sender_account.key,
                &native_mint.key,
                &spl_token::id()
            ),
            &[
                native_mint.clone(),
                native_token.clone(),
                sender_account.clone(),
                token_program.clone(),
                associated_token_program.clone(),
            ],
        )?;
    }

    //msg!("Minting a token");
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

    //msg!("Paying bank for token");
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

    //msg!("Creating metadata accounts");
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
    //msg!("Creating master edition");
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
    //msg!("Signing metadata");
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