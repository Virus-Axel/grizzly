use solana_program::{
    account_info::{next_account_info, AccountInfo},
    entrypoint::ProgramResult,
    msg,
    program::invoke,
    program_error::ProgramError,
    pubkey::Pubkey,
    sysvar::{
        clock::Clock,
        Sysvar,
    },
};

use crate::{
    account_security::{
        verify_and_get_mut_data,
        validate_bear_nft,
    },
    arena::fight_system::{
        evaluate_winner,
        is_battle_aborted,
    },
    arena_queue_id,
    data_structures::{arena_structure, grizzly_structure},
    token_handler::ability_token::{give_ability_token, give_native_token}, NATIVE_TOKEN_ID,
};

use spl_token::instruction::burn;

use crate::account_security::verify_ability_token;

use mod_exp::mod_exp;

const ARENA_PRIZE: usize = 100;
const SECONDS_UNTIL_PRIZE_REDUCTION: usize = 20;

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
        instruction type - length 1, already used
        allocate_space - length 1, 1 to create associated token account for reward ability
        moveset - length 5, five ability indices of the desired moveset
        P - Primitive root
        G - Prime
        AB - Primitive root to the power of a secret modulus the prime

*/
pub fn arena_signup<'a>(
    program_id: &Pubkey,
    accounts: &'a [AccountInfo<'a>],
    instruction_data: &[u8],
) -> ProgramResult {
    const CRYPTO_OFFSET: usize = 7;

    let accounts_iter = &mut accounts.iter();

    // Get the accounts
    let sender_account = next_account_info(accounts_iter)?;
    let mapping_account = next_account_info(accounts_iter)?;

    // NFT for verification
    let mint_account = next_account_info(accounts_iter)?;
    let token_account = next_account_info(accounts_iter)?;
    let metadata_account = next_account_info(accounts_iter)?;

    let grizzly_account = next_account_info(accounts_iter)?;
    let arena_queue_account = next_account_info(accounts_iter)?;

    let native_mint = next_account_info(accounts_iter)?;
    let native_token = next_account_info(accounts_iter)?;

    let system_program = next_account_info(accounts_iter)?;
    let token_program = next_account_info(accounts_iter)?;
    let associated_token_program = next_account_info(accounts_iter)?;
    let mint_authority = next_account_info(accounts_iter)?;
    let rent = next_account_info(accounts_iter)?;
    

    msg!("Validating bear nft");
    match validate_bear_nft(program_id, sender_account, mint_account, token_account, metadata_account, grizzly_account, mapping_account){
        Ok(_) => (),
        Err(_) => return Err(ProgramError::IllegalOwner),
    }

    msg!("Checking arena account");
    if *arena_queue_account.key != arena_queue_id()
    {
        return Err(ProgramError::InvalidAccountData);
    }

    if mapping_account.owner != program_id{
        return Err(ProgramError::IllegalOwner);
    }

    if native_mint.key.to_string() != NATIVE_TOKEN_ID{
        return Err(ProgramError::IllegalOwner);
    }


    // TODO: Give native tokens to cover fee

    msg!("Verifying grizzly owner");
    let mut grizzly_data = verify_and_get_mut_data(program_id, grizzly_account)?;
    let mut arena_queue_data = verify_and_get_mut_data(program_id, arena_queue_account)?;


    let timestamp = Clock::get().unwrap().unix_timestamp;
    let past_timestamp = i64::from_le_bytes(grizzly_data[grizzly_structure::TIMESTAMP].try_into().unwrap());

    let delta_time = timestamp - past_timestamp;
    give_native_token(program_id, sender_account, native_mint, native_token, token_program, associated_token_program, mint_authority, rent, system_program, (delta_time / SECONDS_UNTIL_PRIZE_REDUCTION as i64) as u64)?;

    verify_ability_token(sender_account, native_mint, native_token)?;
    grizzly_data[grizzly_structure::TIMESTAMP].copy_from_slice(&timestamp.to_le_bytes());

    invoke(
        &burn(
            &token_program.key,
            &native_token.key,
            &native_mint.key,
            &sender_account.key,
            &[],
            ARENA_PRIZE as u64,
        )?,
        &[
            native_token.clone(),
            native_mint.clone(),
            sender_account.clone(),
            token_program.clone(),
        ],
      //  &[&[AUTHORITY_SEED, program_id.as_ref(), &[bump]]],
    )?;

    if grizzly_data[0] == 0 && grizzly_data[grizzly_structure::AB.start] != 0{
        msg!("Claiming ability token");
        let _dummy_signer = next_account_info(accounts_iter)?;
        let mint_authority = next_account_info(accounts_iter)?;

        let ability_mint = next_account_info(accounts_iter)?;
        let ability_token = next_account_info(accounts_iter)?;
        let token_program = next_account_info(accounts_iter)?;
        let associated_token_program = next_account_info(accounts_iter)?;
        let rent = next_account_info(accounts_iter)?;
        let system_program = next_account_info(accounts_iter)?;
        

        let allocate_space = match instruction_data[1]{
            0 => false,
            _ => true,
        };
        give_ability_token(program_id, sender_account, ability_mint, ability_token, token_program, associated_token_program, mint_authority, rent, system_program, 1, grizzly_data[grizzly_structure::AB.start], allocate_space)?;
    }

    msg!("Updating moveset");
    for i in 0..5{
        const MOVESET_OFFSET: usize = 2;

        // Check if ability is learned
        if grizzly_data[grizzly_structure::ABILITY_LEVELS + instruction_data[MOVESET_OFFSET + i] as usize] > 0{
            grizzly_data[grizzly_structure::EQUIPPED_ABILITIES + i] = instruction_data[MOVESET_OFFSET + i];
        }
        else{
            return Err(ProgramError::InvalidAccountData);
        }
    }

    msg!("Checking if bear is ready for battle");
    // Check that bear is ready for battle.
    if is_battle_aborted(&grizzly_data) {
        msg!("Battle aborted");
        let past_challenging_bear = next_account_info(accounts_iter)?;
        let mut past_challenging_bear_data =
            verify_and_get_mut_data(program_id, past_challenging_bear)?;
        let past_challenging_key = Pubkey::new(&arena_queue_data[arena_structure::LAST_BEAR]);

        // Make sure we provided the correct past bear.
        if past_challenging_key != *past_challenging_bear.key {
            return Err(ProgramError::InvalidAccountData);
        }

        evaluate_winner(&mut grizzly_data, &mut past_challenging_bear_data, 0)?;
    } else if grizzly_data[grizzly_structure::ARENA_STATE] != grizzly_structure::STATE_NO_FIGHT {
        msg!("grizzly state is: {}", grizzly_data[grizzly_structure::ARENA_STATE]);
        msg!("grizzly account is: {}", grizzly_account.key.to_string());
        return Err(ProgramError::AccountAlreadyInitialized);
    }

    // Check if there is a challenger bear.
    if arena_queue_data[arena_structure::HAS_CHALLENGER] == 1 {
        let challenging_bear = next_account_info(accounts_iter)?;
        let latest_bear = Pubkey::new(&arena_queue_data[arena_structure::LAST_BEAR]);

        // Make sure we provided the previous bear.
        if latest_bear != *challenging_bear.key {
            return Err(ProgramError::InvalidAccountData);
        }

        let mut challenging_bear_data = verify_and_get_mut_data(program_id, challenging_bear)?;

        // Set targets.
        challenging_bear_data[grizzly_structure::TARGET]
            .copy_from_slice(&(*grizzly_account).key.to_bytes());
        grizzly_data[grizzly_structure::TARGET]
            .copy_from_slice(&(*challenging_bear).key.to_bytes());

        msg!("Setting encryption keys");
        // Set encryption public keys.
        let secret = u64::from_le_bytes(instruction_data[CRYPTO_OFFSET + 16..CRYPTO_OFFSET + 24].try_into().unwrap());
    
        grizzly_data[grizzly_structure::P].copy_from_slice(&challenging_bear_data[grizzly_structure::P]);
        grizzly_data[grizzly_structure::G].copy_from_slice(&challenging_bear_data[grizzly_structure::G]);
    
        msg!("Preparing shared secret");
        let ab = mod_exp(u64::from_le_bytes(grizzly_data[grizzly_structure::G].try_into().unwrap()),
            secret,
            u64::from_le_bytes(grizzly_data[grizzly_structure::P].try_into().unwrap())
        );
    
        grizzly_data[grizzly_structure::AB].copy_from_slice(&ab.to_le_bytes());

        // Calculate shared key
        let shared_key = mod_exp(
            u64::from_le_bytes(challenging_bear_data[grizzly_structure::AB].try_into().unwrap()),
            secret,
            u64::from_le_bytes(grizzly_data[grizzly_structure::P].try_into().unwrap()),
        );
        grizzly_data[grizzly_structure::SHARED_KEY].copy_from_slice(&shared_key.to_le_bytes());

        // Set the challenge accepted state.
        grizzly_data[grizzly_structure::ARENA_STATE] = grizzly_structure::STATE_ACCEPTED_CHALLENGE;

        arena_queue_data[arena_structure::HAS_CHALLENGER] = 0;
    }
    else{
        msg!("Setting encryption keys");
        // Set encryption public keys.
        let secret = u64::from_le_bytes(instruction_data[CRYPTO_OFFSET + 16..CRYPTO_OFFSET + 24].try_into().unwrap());
    
        grizzly_data[grizzly_structure::P].copy_from_slice(&instruction_data[CRYPTO_OFFSET..CRYPTO_OFFSET + 8]);
        grizzly_data[grizzly_structure::G].copy_from_slice(&instruction_data[CRYPTO_OFFSET + 8..CRYPTO_OFFSET + 16]);
    
        msg!("Preparing shared secret");
        let ab = u64::from_le_bytes(grizzly_data[grizzly_structure::AB].try_into().unwrap());
    
        grizzly_data[grizzly_structure::AB].copy_from_slice(&secret.to_le_bytes());
        // Set challenging state.
        grizzly_data[grizzly_structure::ARENA_STATE] = grizzly_structure::STATE_CHALLENGING;

        arena_queue_data[arena_structure::HAS_CHALLENGER] = 1;
        arena_queue_data[arena_structure::LAST_BEAR].copy_from_slice(&grizzly_account.key.to_bytes());
    }

    Ok(())
}

pub fn clear_bear_data<'a>(
    program_id: &Pubkey,
    accounts: &'a [AccountInfo<'a>],
) -> ProgramResult {
    let accounts_iter = &mut accounts.iter();

    // Get the accounts
    let _sender_account = next_account_info(accounts_iter)?;
    let grizzly_account = next_account_info(accounts_iter)?;
    let arena_account = next_account_info(accounts_iter)?;

    let mut grizzly_data = verify_and_get_mut_data(program_id, grizzly_account)?;
    let mut arena_data = verify_and_get_mut_data(program_id, arena_account)?;
    for i in 0..grizzly_structure::SIZE{
        grizzly_data[i] = 0;
    }
    for i in 0..arena_structure::SIZE{
        arena_data[i] = 0;
    }

    grizzly_data[90] = 2;

    Ok(())
}