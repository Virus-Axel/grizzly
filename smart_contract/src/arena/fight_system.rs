use solana_program::{
    entrypoint::ProgramResult,
    msg,
    sysvar::{clock::Clock, Sysvar},
};

use oorandom::Rand32;

use crate::{
    data_structures::{
        grizzly_structure,
        grizzly_structure::MAX_EQUIPPED_ABILITIES,
    }
};

use super::abilities;

const MAX_FIGHT_ROUNDS: usize = 50;
const FIGHT_CONFIRMATION_TIME: i64 = 10;
const STAMINA_RECOVERY: f32 = 0.015;
const HEART_STAMINA_FACTOR: f32 = 0.1;
const PROGRESSION_FACTOR: f32 = 0.001;


pub fn is_battle_aborted(bear_data: &[u8]) -> bool {
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

fn push_action(bear_data: &mut [u8], opponent_data: &mut [u8], position: usize, action: u8, opponent_turn: bool){
    let offset = position / 2;
    if position % 2 == 0{
        if opponent_turn{
            bear_data[grizzly_structure::ACTION_LIST + offset] = action + MAX_EQUIPPED_ABILITIES as u8;
            opponent_data[grizzly_structure::ACTION_LIST + offset] = action;
        }
        else{
            bear_data[grizzly_structure::ACTION_LIST + offset] = action;
            opponent_data[grizzly_structure::ACTION_LIST + offset] = action + MAX_EQUIPPED_ABILITIES as u8;
        }
    }
    else{
        if opponent_turn{
            bear_data[grizzly_structure::ACTION_LIST + offset] |= (action + MAX_EQUIPPED_ABILITIES as u8) << 4;
            opponent_data[grizzly_structure::ACTION_LIST + offset] |= action << 4;
        }
        else{
            bear_data[grizzly_structure::ACTION_LIST + offset] |= action << 4;
            opponent_data[grizzly_structure::ACTION_LIST + offset] |= (action + MAX_EQUIPPED_ABILITIES as u8) << 4;
        }
    }
}

pub fn evaluate_winner(sender_bear: &mut [u8], opponent_bear: &mut [u8], randomness: u64) -> ProgramResult {
    // Handle aborted battle
    if sender_bear[grizzly_structure::ARENA_STATE] == grizzly_structure::STATE_CHALLENGING {
        sender_bear[grizzly_structure::PENALTY] += 1;
        sender_bear[grizzly_structure::ARENA_STATE] = grizzly_structure::STATE_NO_FIGHT;
        sender_bear[grizzly_structure::TARGET].copy_from_slice(&[0; 32]);

        opponent_bear[grizzly_structure::ARENA_STATE] = grizzly_structure::STATE_NO_FIGHT;
        opponent_bear[grizzly_structure::TARGET].copy_from_slice(&[0; 32]);
    } else if sender_bear[grizzly_structure::ARENA_STATE]
        == grizzly_structure::STATE_ACCEPTED_CHALLENGE
    {
        opponent_bear[grizzly_structure::PENALTY] += 1;
        opponent_bear[grizzly_structure::ARENA_STATE] = grizzly_structure::STATE_NO_FIGHT;
        opponent_bear[grizzly_structure::TARGET].copy_from_slice(&[0; 32]);

        sender_bear[grizzly_structure::ARENA_STATE] = grizzly_structure::STATE_NO_FIGHT;
        sender_bear[grizzly_structure::TARGET].copy_from_slice(&[0; 32]);
    } else {
        let mut sender_bear_stamina: f32 = 0.5;
        let mut opponent_bear_stamina: f32 = 0.5;

        let mut sender_bear_health: f32 = 1.0;
        let mut opponent_bear_health: f32 = 1.0;
        let mut position: usize = 0;

        let mut random_generator = Rand32::new(randomness);
        for _round in 0..MAX_FIGHT_ROUNDS {
            if random_generator.rand_float() < sender_bear_stamina{
                sender_bear_stamina += STAMINA_RECOVERY + HEART_STAMINA_FACTOR * f32::from_le_bytes(sender_bear[grizzly_structure::HEART_SIZE].try_into().unwrap());
            }
            else{
                let ability_index = (random_generator.rand_u32() as usize) % grizzly_structure::MAX_EQUIPPED_ABILITIES;
                let selected_ability_index = sender_bear[grizzly_structure::EQUIPPED_ABILITIES + ability_index];

                let ability_level = sender_bear[grizzly_structure::ABILITY_LEVELS + selected_ability_index as usize];
                opponent_bear_health -= abilities::ABILITIES[selected_ability_index as usize].calculate_damage(sender_bear, ability_level);

                abilities::ABILITIES[selected_ability_index as usize].train_bear(sender_bear, ability_level);

                sender_bear_stamina -= abilities::ABILITIES[selected_ability_index as usize].stamina_cost;

                push_action(sender_bear, opponent_bear, position, selected_ability_index, false);
                if opponent_bear_health <= 0.0{
                    return Ok(());
                }

                position += 1;
            }
            if random_generator.rand_float() < opponent_bear_stamina{
                opponent_bear_stamina += STAMINA_RECOVERY + HEART_STAMINA_FACTOR * f32::from_le_bytes(opponent_bear[grizzly_structure::HEART_SIZE].try_into().unwrap());
            }
            else{
                let ability_index = (random_generator.rand_u32() as usize) % grizzly_structure::MAX_EQUIPPED_ABILITIES;
                let selected_ability_index = opponent_bear[grizzly_structure::EQUIPPED_ABILITIES + ability_index];

                let ability_level = opponent_bear[grizzly_structure::ABILITY_LEVELS + selected_ability_index as usize];
                sender_bear_health -= abilities::ABILITIES[selected_ability_index as usize].calculate_damage(opponent_bear, ability_level);

                abilities::ABILITIES[selected_ability_index as usize].train_bear(opponent_bear, ability_level);

                opponent_bear_health -= abilities::ABILITIES[selected_ability_index as usize].stamina_cost;

                push_action(sender_bear, opponent_bear, position, selected_ability_index, true);
                if sender_bear_health <= 0.0{
                    return Ok(());
                }

                position += 1;
            }
        }
    }
    Ok(())
}
