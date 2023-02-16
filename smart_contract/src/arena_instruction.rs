use solana_program::{
    account_info::{next_account_info, AccountInfo},
    entrypoint::ProgramResult,
    msg,
    program_error::ProgramError,
    pubkey::Pubkey,
    sysvar::{clock::Clock, Sysvar},
};

use crate::{
    account_security::verify_and_get_mut_data,
    arena_queue_id,
    data_structures::{arena_structure, grizzly_structure},
    arena::abilities::ABILITIES,
};

const MAX_FIGHT_ROUNDS: usize = 50;
const FIGHT_CONFIRMATION_TIME: i64 = 10;


fn get_mapping_keys(account_data: &[u8]) -> Result<(Pubkey, Pubkey), ProgramError> {
    let nft_pubkey = Pubkey::new(&account_data[0..32]);
    let grizzly_pubkey = Pubkey::new(&account_data[32..64]);
    Ok((nft_pubkey, grizzly_pubkey))
}

fn is_battle_aborted(bear_data: &[u8]) -> bool {
    let current_time = Clock::get().unwrap().unix_timestamp;
    let delta_time =
        i64::from_le_bytes(bear_data[grizzly_structure::TIMESTAMP].try_into().unwrap())
            - current_time;
    if (bear_data[grizzly_structure::ARENA_STATE] == grizzly_structure::STATE_ACCEPTED_CHALLENGE
        || bear_data[grizzly_structure::ARENA_STATE] == grizzly_structure::STATE_CHALLENGING)
        && delta_time > FIGHT_CONFIRMATION_TIME
    {
        return true;
    }
    false
}

fn evaluate_winner(sender_bear: &mut [u8], opponent_bear: &mut [u8]) -> ProgramResult {
    // Handle aborted battle
    if sender_bear[grizzly_structure::ARENA_STATE] == grizzly_structure::STATE_CHALLENGING{
        sender_bear[grizzly_structure::PENALTY] += 1;
        sender_bear[grizzly_structure::ARENA_STATE] = grizzly_structure::STATE_NO_FIGHT;
        sender_bear[grizzly_structure::TARGET].copy_from_slice(&[0; 32]);

        opponent_bear[grizzly_structure::ARENA_STATE] = grizzly_structure::STATE_NO_FIGHT;
        opponent_bear[grizzly_structure::TARGET].copy_from_slice(&[0; 32]);
    }
    else if sender_bear[grizzly_structure::ARENA_STATE] == grizzly_structure::STATE_ACCEPTED_CHALLENGE{
        opponent_bear[grizzly_structure::PENALTY] += 1;
        opponent_bear[grizzly_structure::ARENA_STATE] = grizzly_structure::STATE_NO_FIGHT;
        opponent_bear[grizzly_structure::TARGET].copy_from_slice(&[0; 32]);

        sender_bear[grizzly_structure::ARENA_STATE] = grizzly_structure::STATE_NO_FIGHT;
        sender_bear[grizzly_structure::TARGET].copy_from_slice(&[0; 32]);
    }
    else{
        for round in 0..MAX_FIGHT_ROUNDS {

        }
    }
    Ok(())
}

pub fn arena_signup<'a>(program_id: &Pubkey, accounts: &'a [AccountInfo<'a>]) -> ProgramResult {
    let accounts_iter = &mut accounts.iter();

    // Get the accounts
    let _sender_account = next_account_info(accounts_iter)?;
    let mapping_account = next_account_info(accounts_iter)?;
    let nft_account = next_account_info(accounts_iter)?;
    let grizzly_account = next_account_info(accounts_iter)?;
    let arena_queue_account = next_account_info(accounts_iter)?;

    // Verify owners and extract data
    let mut mapping_data = verify_and_get_mut_data(program_id, mapping_account)?;
    let (nft_pubkey, grizzly_pubkey) = get_mapping_keys(&mapping_data)?;
    if nft_pubkey != *nft_account.key
        || grizzly_pubkey != *grizzly_account.key
        || *arena_queue_account.key != arena_queue_id()
    {
        return Err(ProgramError::InvalidAccountData);
    }
    let mut grizzly_data = verify_and_get_mut_data(program_id, mapping_account)?;
    let mut nft_data = verify_and_get_mut_data(&mpl_token_metadata::ID, mapping_account)?;
    let mut arena_queue_data = verify_and_get_mut_data(program_id, arena_queue_account)?;

    // Check that bear is ready for battle.
    if is_battle_aborted(&grizzly_data) {
        let past_challenging_bear = next_account_info(accounts_iter)?;
        let mut past_challenging_bear_data = verify_and_get_mut_data(program_id, past_challenging_bear)?;
        let past_challenging_key = Pubkey::new(&arena_queue_data[arena_structure::LAST_BEAR]);

        // Make sure we provided the correct past bear.
        if past_challenging_key != *past_challenging_bear.key {
            return Err(ProgramError::InvalidAccountData);
        }

        evaluate_winner(&mut grizzly_data, &mut past_challenging_bear_data)?;
    } else if grizzly_data[grizzly_structure::ARENA_STATE] != grizzly_structure::STATE_NO_FIGHT {
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
    }

    Ok(())
}
