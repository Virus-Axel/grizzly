use solana_program::{
    account_info::{next_account_info, AccountInfo},
    entrypoint::ProgramResult,
    msg,
    program::{invoke, invoke_signed},
    program_error::ProgramError,
    pubkey::Pubkey,
    system_instruction,
    system_instruction::create_account, config::program,
};

use spl_token::instruction::{
    initialize_mint,
    mint_to,
    burn,
};

use spl_associated_token_account::instruction::create_associated_token_account;

use mpl_token_metadata::instruction::{
    create_master_edition_v3, create_metadata_accounts_v3, sign_metadata,
};

use crate::{account_security::{validate_bear_nft, verify_ability_token, verify_bank_account, verify_and_get_mut_data}, data_structures::{grizzly_structure, arena_structure}, instruction};

pub const AUTHORITY_SEED: &[u8] = b"cryptoforts_mint_seed";

const ABILITY_TOKEN_IDS: [&str; 5] = [
    "GpB7uH8XkQA1bgW6jWyNH3PJsCG2F2DSKncDNXo4fRzU",
    "GpB7uH8XkQA1bgW6jWyNH3PJsCG2F2DSKncDNXo4fRzU",
    "GpB7uH8XkQA1bgW6jWyNH3PJsCG2F2DSKncDNXo4fRzU",
    "GpB7uH8XkQA1bgW6jWyNH3PJsCG2F2DSKncDNXo4fRzU",
    "GpB7uH8XkQA1bgW6jWyNH3PJsCG2F2DSKncDNXo4fRzU",
];

const LAMPORTS_PER_NATIVE: u64 = 50000;

pub fn create_ability_token<'a>(
    program_id: &Pubkey,
    accounts: &'a [AccountInfo<'a>],
) -> ProgramResult {
    let accounts_iter = &mut accounts.iter();

    let _sender_account = next_account_info(accounts_iter)?;
    let mint = next_account_info(accounts_iter)?;

    // PDA
    let mint_authority = next_account_info(accounts_iter)?;
    let token_account = next_account_info(accounts_iter)?;
    let rent = next_account_info(accounts_iter)?;
    let token_program = next_account_info(accounts_iter)?;

    let system_program = next_account_info(accounts_iter)?;

    
    let (expected_mint_authority, bump) = Pubkey::find_program_address(
        &[AUTHORITY_SEED, program_id.as_ref()],
        &program_id
    );

    msg!("Comparing {} with {}", mint_authority.key.to_string(), expected_mint_authority.to_string());

    if *mint_authority.key != expected_mint_authority{
        return Err(ProgramError::InvalidArgument);
    }

    msg!("Creating mint: {}", mint.key.to_string());
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
            //system_program.clone(),
            token_account.clone(),
        ],
        &[&[AUTHORITY_SEED, program_id.as_ref(), &[bump]]]
    )?;

    msg!("Initializing mint");
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

    Ok(())
}

pub fn equip_ability_token<'a>(
    program_id: &Pubkey,
    accounts: &'a [AccountInfo<'a>],
    instruction_data: &[u8],
) -> ProgramResult {
    let accounts_iter = &mut accounts.iter();

    let sender_account = next_account_info(accounts_iter)?;
    let mint = next_account_info(accounts_iter)?;

    // PDA
    let _dummy_signer = next_account_info(accounts_iter)?;
    let mint_authority = next_account_info(accounts_iter)?;

    let token_account = next_account_info(accounts_iter)?;
    let rent = next_account_info(accounts_iter)?;

    let token_program = next_account_info(accounts_iter)?;
    let associated_token_program = next_account_info(accounts_iter)?;
    let metadata_account = next_account_info(accounts_iter)?;

    // Accounts for mapping NFT to grizzly
    let mapping_account = next_account_info(accounts_iter)?;
    let grizzly_account = next_account_info(accounts_iter)?;

    let ability_mint = next_account_info(accounts_iter)?;
    let ability_token = next_account_info(accounts_iter)?;

    let system_program = next_account_info(accounts_iter)?;

    // Verify nft
    validate_bear_nft(program_id, sender_account, mint, token_account, metadata_account, grizzly_account, mapping_account)?;
    
    // Pay out prize
    let allocate_space = match instruction_data[1]{
        0 => false,
        _ => true,
    };
    let mut grizzly_data = verify_and_get_mut_data(program_id, grizzly_account)?;
    if grizzly_data[0] == 0 && grizzly_data[grizzly_structure::AB.start] != 0{
        give_ability_token(program_id, sender_account, ability_mint, ability_token, token_program, associated_token_program, mint_authority, rent, system_program, 1, grizzly_data[grizzly_structure::AB.start], allocate_space)?;
        grizzly_data[grizzly_structure::AB.start] = 0;
    }

    // Verify ability token
    verify_ability_token(sender_account, ability_mint, ability_token)?;

    let (expected_mint_authority, bump) =
        Pubkey::find_program_address(&[AUTHORITY_SEED, program_id.as_ref()], &program_id);

    if *mint_authority.key != expected_mint_authority {
        return Err(ProgramError::InvalidArgument);
    }

    // Verify that ability index and key is correct
    let ability_index = instruction_data[2];
    if ability_mint.key.to_string() != ABILITY_TOKEN_IDS[ability_index as usize]{
        return Err(ProgramError::InvalidInstructionData);
    }

    msg!("Burning this token {} {}", ability_token.key, ability_mint.key);
    msg!("token program is {}", token_program.key.to_string());
    invoke(
        &burn(
            &token_program.key,
            &ability_token.key,
            &ability_mint.key,
            &sender_account.key,
            &[],
            1,
        )?,
        &[
            ability_token.clone(),
            ability_mint.clone(),
            sender_account.clone(),
            token_program.clone(),
        ],
      //  &[&[AUTHORITY_SEED, program_id.as_ref(), &[bump]]],
    )?;

    // Increase the level.
    msg!("Increasing grizzly level");
    if grizzly_data[grizzly_structure::ABILITY_LEVELS + ability_index as usize] == 255{
        return Err(ProgramError::MaxAccountsDataSizeExceeded);
    }
    grizzly_data[grizzly_structure::ABILITY_LEVELS + ability_index as usize] += 1;

    return Ok(());
}

pub fn merge_ability_tokens<'a>(
    program_id: &Pubkey,
    accounts: &'a [AccountInfo<'a>],
    instruction_data: &[u8],
) -> ProgramResult {
    let accounts_iter = &mut accounts.iter();

    let sender_account = next_account_info(accounts_iter)?;
    let mint = next_account_info(accounts_iter)?;

    // PDA
    let _dummy_signer = next_account_info(accounts_iter)?;
    let mint_authority = next_account_info(accounts_iter)?;

    let token_account = next_account_info(accounts_iter)?;
    let rent = next_account_info(accounts_iter)?;

    let token_program = next_account_info(accounts_iter)?;
    let associated_token_program = next_account_info(accounts_iter)?;
    let metadata_account = next_account_info(accounts_iter)?;

    // Accounts for mapping NFT to grizzly
    let mapping_account = next_account_info(accounts_iter)?;
    let grizzly_account = next_account_info(accounts_iter)?;

    let ability_mint = next_account_info(accounts_iter)?;
    let ability_token = next_account_info(accounts_iter)?;

    let system_program = next_account_info(accounts_iter)?;
    

    // Verify nft
    validate_bear_nft(program_id, sender_account, mint, token_account, metadata_account, grizzly_account, mapping_account)?;
    
    // Pay out prize
    let allocate_space = match instruction_data[1]{
        0 => false,
        _ => true,
    };
    let mut grizzly_data = verify_and_get_mut_data(program_id, grizzly_account)?;
    if grizzly_data[0] == 0 && grizzly_data[grizzly_structure::AB.start] != 0 && instruction_data[2] == grizzly_data[grizzly_structure::AB.start]{
        give_ability_token(program_id, sender_account, ability_mint, ability_token, token_program, associated_token_program, mint_authority, rent, system_program, 1, grizzly_data[grizzly_structure::AB.start], allocate_space)?;
        grizzly_data[grizzly_structure::AB.start] = 0;
    }

    // Verify ability token
    verify_ability_token(sender_account, ability_mint, ability_token)?;

    let (expected_mint_authority, _bump) =
        Pubkey::find_program_address(&[AUTHORITY_SEED, program_id.as_ref()], &program_id);

    if *mint_authority.key != expected_mint_authority {
        return Err(ProgramError::InvalidArgument);
    }

    // Verify that ability index and key is correct
    let ability_index = instruction_data[2];
    if ability_mint.key.to_string() != ABILITY_TOKEN_IDS[ability_index as usize]{
        return Err(ProgramError::InvalidInstructionData);
    }

    msg!("Burning this token {} {}", ability_token.key, ability_mint.key);
    invoke(
        &burn(
            &token_program.key,
            &ability_token.key,
            &ability_mint.key,
            &sender_account.key,
            &[],
            2,
        )?,
        &[
            ability_token.clone(),
            ability_mint.clone(),
            sender_account.clone(),
            token_program.clone(),
        ],
      //  &[&[AUTHORITY_SEED, program_id.as_ref(), &[bump]]],
    )?;

    // Increase the level.
    msg!("Giving new ability token");
    if ability_index as usize >= ABILITY_TOKEN_IDS.len() - 1{
        return Err(ProgramError::MaxAccountsDataSizeExceeded);
    }
    if grizzly_data[grizzly_structure::ABILITY_LEVELS + 1 + ability_index as usize] == 255{
        return Err(ProgramError::MaxAccountsDataSizeExceeded);
    }
    if grizzly_data[grizzly_structure::ARENA_STATE] != 0{
        return Err(ProgramError::AccountAlreadyInitialized);
    }
    grizzly_data[grizzly_structure::AB.start] = ability_index + 1;

    return Ok(());
}

pub fn give_native_token<'a>(
    program_id: &Pubkey,
    sender_account: &AccountInfo<'a>,
    mint: &AccountInfo<'a>,
    token_account: &AccountInfo<'a>,
    token_program: &AccountInfo<'a>,
    associated_token_program: &AccountInfo<'a>,
    mint_authority: &AccountInfo<'a>,
    rent: &AccountInfo<'a>,
    system_program: &AccountInfo<'a>,
    amount: u64,
) -> ProgramResult{
    let (_expected_mint_authority, bump) =
        Pubkey::find_program_address(&[AUTHORITY_SEED, program_id.as_ref()], &program_id);


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

    msg!("Token claimed");
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
    system_program: &AccountInfo<'a>,
    amount: u64,
    index: u8,
    allocate_space: bool,
) -> ProgramResult {

    msg!("Checking ability token {} == {}", mint.key.to_string(), ABILITY_TOKEN_IDS[index as usize]);
    if mint.key.to_string() != ABILITY_TOKEN_IDS[index as usize]{
        return Err(ProgramError::InvalidAccountData);
    }

    let (_expected_mint_authority, bump) =
        Pubkey::find_program_address(&[AUTHORITY_SEED, program_id.as_ref()], &program_id);

    //msg!("Mint auth: {}", mint_authority.key.to_string());
    //msg!("Sender: {}", sender_account.key.to_string());
    msg!("Ability mint: {}", mint.key.to_string());
    msg!("Ability token: {}", token_account.key.to_string());
    //msg!("Rent: {}", rent.key.to_string());
    //msg!("Token program: {}", token_program.key.to_string());
    //msg!("Atoken program: {}", associated_token_program.key.to_string());

    if allocate_space{
    msg!("Creating associated token account");
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
                system_program.clone(),
            ],
        )?;
    }

    msg!("Minting token");
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

    msg!("Token claimed");
    return Ok(());
}

pub fn trade_ability_token<'a>(
    program_id: &Pubkey,
    accounts: &'a [AccountInfo<'a>],
    instruction_data: &[u8],
) -> ProgramResult {
    let accounts_iter = &mut accounts.iter();

    let sender_account = next_account_info(accounts_iter)?;
    let mint = next_account_info(accounts_iter)?;

    // PDA
    let _dummy_signer = next_account_info(accounts_iter)?;
    let mint_authority = next_account_info(accounts_iter)?;

    let token_account = next_account_info(accounts_iter)?;
    let rent = next_account_info(accounts_iter)?;

    let token_program = next_account_info(accounts_iter)?;
    let associated_token_program = next_account_info(accounts_iter)?;
    let metadata_account = next_account_info(accounts_iter)?;

    // Accounts for mapping NFT to grizzly
    let mapping_account = next_account_info(accounts_iter)?;
    let grizzly_account = next_account_info(accounts_iter)?;

    let ability_mint = next_account_info(accounts_iter)?;
    let ability_token = next_account_info(accounts_iter)?;

    let native_mint = next_account_info(accounts_iter)?;
    let native_token = next_account_info(accounts_iter)?;

    let bank_account = next_account_info(accounts_iter)?;
    let arena_account = next_account_info(accounts_iter)?;

    let system_program = next_account_info(accounts_iter)?;

    // Verify nft
    validate_bear_nft(program_id, sender_account, mint, token_account, metadata_account, grizzly_account, mapping_account)?;
    
    // Pay out prize
    //msg!("Paying out old prizes");
    let allocate_space = match instruction_data[1]{
        0 => false,
        _ => true,
    };
    let mut grizzly_data = verify_and_get_mut_data(program_id, grizzly_account)?;
    if grizzly_data[0] == 0 && grizzly_data[grizzly_structure::AB.start] != 0 && instruction_data[2] == grizzly_data[grizzly_structure::AB.start]{
        give_ability_token(program_id, sender_account, ability_mint, ability_token, token_program, associated_token_program, mint_authority, rent, system_program, 1, grizzly_data[grizzly_structure::AB.start], allocate_space)?;
        grizzly_data[grizzly_structure::AB.start] = 0;
    }

    // Verify ability token
    //msg!("Verify ability token");
    verify_ability_token(sender_account, ability_mint, ability_token)?;

    //msg!("Verifying mint authority");
    let (expected_mint_authority, bump) =
        Pubkey::find_program_address(&[AUTHORITY_SEED, program_id.as_ref()], &program_id);

    if *mint_authority.key != expected_mint_authority {
        return Err(ProgramError::InvalidArgument);
    }

    // Verify that ability index and key is correct
    //msg!("Verifying ability index");
    let ability_index = instruction_data[2];
    if ability_mint.key.to_string() != ABILITY_TOKEN_IDS[ability_index as usize]{
        return Err(ProgramError::InvalidInstructionData);
    }

    // Figure out prize rate
    msg!("Getting prize rate");
    let mut arena_data = verify_and_get_mut_data(program_id, arena_account)?;
    let prize_rate = u64::from_le_bytes(arena_data[arena_structure::PRIZES + 8 * ability_index as usize..arena_structure::PRIZES + 8 + 8 * ability_index as usize].try_into().unwrap());

    // Sell
    if instruction_data[3] == 0{
        msg!("Burning this token {} {}", ability_token.key, ability_mint.key);
        msg!("token program is {}", token_program.key.to_string());
        invoke(
            &burn(
                &token_program.key,
                &ability_token.key,
                &ability_mint.key,
                &sender_account.key,
                &[],
                1,
            )?,
            &[
                ability_token.clone(),
                ability_mint.clone(),
                sender_account.clone(),
                token_program.clone(),
            ],
        //  &[&[AUTHORITY_SEED, program_id.as_ref(), &[bump]]],
        )?;
        // User wants to get native tokens
        if instruction_data[4] == 0{
            give_native_token(program_id, sender_account, native_mint, native_token, token_program, associated_token_program, mint_authority, rent, system_program, (LAMPORTS_PER_NATIVE - 5000) * prize_rate)?;
        }
        // User wants to get solana
        else{
            msg!("Paying money from bank");
            /*invoke_signed(
                &system_instruction::transfer(bank_account.key, sender_account.key, LAMPORTS_PER_NATIVE * prize_rate),
                &[bank_account.clone(), sender_account.clone(), system_program.clone()],
                &[&[AUTHORITY_SEED, program_id.as_ref(), &[bump]]],
            )?;*/
            let mut bank_lamports = bank_account.lamports.borrow_mut();
            let mut sender_lamports = sender_account.lamports.borrow_mut();
            **bank_lamports -= LAMPORTS_PER_NATIVE * prize_rate;
            **sender_lamports += LAMPORTS_PER_NATIVE * prize_rate;
        }
        // Decrease rates
        arena_data[arena_structure::PRIZES + 8 * ability_index as usize..arena_structure::PRIZES + 8 + 8 * ability_index as usize].copy_from_slice(&(prize_rate - 1).to_le_bytes());
    }
    // Buy
    else {
        if instruction_data[4] == 0{
            // User wants to spend native tokens
            invoke(
                &burn(
                    &token_program.key,
                    &native_token.key,
                    &native_mint.key,
                    &sender_account.key,
                    &[],
                    prize_rate,
                )?,
                &[
                    native_token.clone(),
                    native_mint.clone(),
                    sender_account.clone(),
                    token_program.clone(),
                ],
            //  &[&[AUTHORITY_SEED, program_id.as_ref(), &[bump]]],
            )?;
        }
        else{
            if prize_rate == 0{
                msg!("Sending money to bank: {}", LAMPORTS_PER_NATIVE * prize_rate);
                invoke(
                    &system_instruction::transfer(sender_account.key, bank_account.key, LAMPORTS_PER_NATIVE * prize_rate),
                    &[sender_account.clone(), bank_account.clone(), system_program.clone()],
                )?;
            }
        }
        give_ability_token(program_id, sender_account, ability_mint, ability_token, token_program, associated_token_program, mint_authority, rent, system_program, 1, ability_index, allocate_space)?;
       
        // Increase rates
        arena_data[arena_structure::PRIZES + 8 * ability_index as usize..arena_structure::PRIZES + 8 + 8 * ability_index as usize].copy_from_slice(&(prize_rate + 1).to_le_bytes());

    }

    return Ok(());
}