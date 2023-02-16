use crate::data_structures::grizzly_structure;

pub struct Ability{
    pub stamina_cost: f32,

    pub gain_brain: f32,
    pub gain_heart: f32,
    pub gain_lower_arm: f32,
    pub gain_upper_arm: f32,
    pub gain_lower_leg: f32,
    pub gain_upper_leg: f32,
    pub gain_lower_body: f32,
    pub gain_upper_body: f32,
}

pub const ABILITIES: [Ability; 3] = [
    Ability{stamina_cost: 0.05, gain_brain: 0.0, gain_heart: 0.0, gain_lower_arm: 0.01, gain_upper_arm: 0.02, gain_lower_leg: 0.002, gain_upper_leg: 0.0, gain_lower_body: 0.0, gain_upper_body: 0.005,},
    Ability{stamina_cost: 0.04, gain_brain: 0.0, gain_heart: 0.0, gain_lower_arm: 0.0, gain_upper_arm: 0.01, gain_lower_leg: 0.0, gain_upper_leg: 0.0, gain_lower_body: 0.0, gain_upper_body: 0.0,},
    Ability{stamina_cost: 0.1, gain_brain: 0.0, gain_heart: 0.0, gain_lower_arm: 0.01, gain_upper_arm: 0.02, gain_lower_leg: 0.002, gain_upper_leg: 0.01, gain_lower_body: 0.04, gain_upper_body: 0.005,},
];

impl Ability{
    fn calculate_damage(self, grizzly_data: &[u8]) -> f32{
        let mut ret: f32 = 0.0;

        ret += f32::from_le_bytes(grizzly_data[grizzly_structure::HEART_SIZE].try_into().unwrap()) * self.gain_heart;
        ret += f32::from_le_bytes(grizzly_data[grizzly_structure::BRAIN_SIZE].try_into().unwrap()) * self.gain_brain;
        ret += f32::from_le_bytes(grizzly_data[grizzly_structure::LOWER_ARM_SIZE].try_into().unwrap()) * self.gain_lower_arm;
        ret += f32::from_le_bytes(grizzly_data[grizzly_structure::UPPER_ARM_SIZE].try_into().unwrap()) * self.gain_upper_arm;
        ret += f32::from_le_bytes(grizzly_data[grizzly_structure::LOWER_LEG_SIZE].try_into().unwrap()) * self.gain_lower_leg;
        ret += f32::from_le_bytes(grizzly_data[grizzly_structure::UPPER_LEG_SIZE].try_into().unwrap()) * self.gain_upper_leg;
        ret += f32::from_le_bytes(grizzly_data[grizzly_structure::LOWER_BODY_SIZE].try_into().unwrap()) * self.gain_lower_body;
        ret += f32::from_le_bytes(grizzly_data[grizzly_structure::UPPER_BODY_SIZE].try_into().unwrap()) * self.gain_upper_body;
    
        return ret;
    }
}