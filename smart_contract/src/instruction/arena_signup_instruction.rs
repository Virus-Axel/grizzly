use solana_program::{
    account_info::{next_account_info, AccountInfo},
    entrypoint::ProgramResult,
    msg,
    program_error::ProgramError,
    pubkey::Pubkey,
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
};

use mod_exp::mod_exp;

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
        P -
        G -
        AB -
        (shared_secret - if instruction_type is 1)

*/
pub fn arena_signup<'a>(
    program_id: &Pubkey,
    accounts: &'a [AccountInfo<'a>],
    instruction_data: &[u8],
) -> ProgramResult {
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

    msg!("Validating bear nft");
    match validate_bear_nft(program_id, sender_account, mint_account, token_account, metadata_account, grizzly_account, mapping_account){
        Ok(_) => (),
        Err(e) => return Err(ProgramError::IllegalOwner),
    }

    msg!("Checking arena account");
    if *arena_queue_account.key != arena_queue_id()
    {
        return Err(ProgramError::InvalidAccountData);
    }

    if mapping_account.owner != program_id{
        return Err(ProgramError::IllegalOwner)
    }

    msg!("Verifying grizzly owner");
    let mut grizzly_data = verify_and_get_mut_data(program_id, grizzly_account)?;
    let mut arena_queue_data = verify_and_get_mut_data(program_id, arena_queue_account)?;


    msg!("Checking if bear is ready for battle");
    // Check that bear is ready for battle.
    if is_battle_aborted(&grizzly_data) {
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

    msg!("Setting encryption keys");
    // Set encryption public keys.
    let secret = u64::from_le_bytes(instruction_data[17..25].try_into().unwrap());

    grizzly_data[grizzly_structure::P].copy_from_slice(&instruction_data[1..9]);
    grizzly_data[grizzly_structure::G].copy_from_slice(&instruction_data[9..17]);

    msg!("Preparing shared secret");
    let ab = mod_exp(u64::from_le_bytes(grizzly_data[grizzly_structure::G].try_into().unwrap()),
        secret,
        u64::from_le_bytes(grizzly_data[grizzly_structure::P].try_into().unwrap())
    );

    grizzly_data[grizzly_structure::AB].copy_from_slice(&ab.to_le_bytes());

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
        // Set challenging state.
        grizzly_data[grizzly_structure::ARENA_STATE] = grizzly_structure::STATE_CHALLENGING;

        arena_queue_data[arena_structure::HAS_CHALLENGER] = 1;
        arena_queue_data[arena_structure::LAST_BEAR].copy_from_slice(&grizzly_account.key.to_bytes());
    }

    Ok(())
}
