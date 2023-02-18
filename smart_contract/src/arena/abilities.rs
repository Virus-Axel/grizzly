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

    pub x0_factor: f32,
    pub x1_factor: f32,
    pub x2_factor: f32,
}

pub const ABILITIES: [Ability; 3] = [
    Ability{stamina_cost: 0.05, gain_brain: 0.0, gain_heart: 0.0, gain_lower_arm: 0.01, gain_upper_arm: 0.02, gain_lower_leg: 0.002, gain_upper_leg: 0.0, gain_lower_body: 0.0, gain_upper_body: 0.005, x0_factor: 0.01, x1_factor: 0.0, x2_factor: 0.01},
    Ability{stamina_cost: 0.04, gain_brain: 0.0, gain_heart: 0.0, gain_lower_arm: 0.0, gain_upper_arm: 0.01, gain_lower_leg: 0.0, gain_upper_leg: 0.0, gain_lower_body: 0.0, gain_upper_body: 0.0, x0_factor: 0.004, x1_factor: 0.001, x2_factor: 0.01},
    Ability{stamina_cost: 0.1, gain_brain: 0.0, gain_heart: 0.0, gain_lower_arm: 0.01, gain_upper_arm: 0.02, gain_lower_leg: 0.002, gain_upper_leg: 0.01, gain_lower_body: 0.04, gain_upper_body: 0.005, x0_factor: 0.02, x1_factor: 0.002, x2_factor: -0.02},
];

impl Ability{
    pub fn calculate_damage(&self, grizzly_data: &[u8], level: u8) -> f32{
        let mut ret: f32 = 0.0;

        ret += f32::from_le_bytes(grizzly_data[grizzly_structure::HEART_SIZE].try_into().unwrap()) * self.gain_heart;
        ret += f32::from_le_bytes(grizzly_data[grizzly_structure::BRAIN_SIZE].try_into().unwrap()) * self.gain_brain;
        ret += f32::from_le_bytes(grizzly_data[grizzly_structure::LOWER_ARM_SIZE].try_into().unwrap()) * self.gain_lower_arm;
        ret += f32::from_le_bytes(grizzly_data[grizzly_structure::UPPER_ARM_SIZE].try_into().unwrap()) * self.gain_upper_arm;
        ret += f32::from_le_bytes(grizzly_data[grizzly_structure::LOWER_LEG_SIZE].try_into().unwrap()) * self.gain_lower_leg;
        ret += f32::from_le_bytes(grizzly_data[grizzly_structure::UPPER_LEG_SIZE].try_into().unwrap()) * self.gain_upper_leg;
        ret += f32::from_le_bytes(grizzly_data[grizzly_structure::LOWER_BODY_SIZE].try_into().unwrap()) * self.gain_lower_body;
        ret += f32::from_le_bytes(grizzly_data[grizzly_structure::UPPER_BODY_SIZE].try_into().unwrap()) * self.gain_upper_body;

        // Second grade function for progression
        let x = (255.0 - level as f32) / 255.0;
        return ret * (self.x0_factor + x * (self.x1_factor + self.x2_factor * self.x2_factor));
    }
    pub fn train_bear(&self, grizzly_data: &mut [u8], level: u8){
        let x = (255.0 - level as f32) / 255.0;
        let factor = (self.x0_factor + x * (self.x1_factor + self.x2_factor * self.x2_factor));

        let heart_size = f32::from_le_bytes(grizzly_data[grizzly_structure::HEART_SIZE].try_into().unwrap());
        let brain_size = f32::from_le_bytes(grizzly_data[grizzly_structure::BRAIN_SIZE].try_into().unwrap());
        let lower_arm_size = f32::from_le_bytes(grizzly_data[grizzly_structure::LOWER_ARM_SIZE].try_into().unwrap());
        let upper_arm_size = f32::from_le_bytes(grizzly_data[grizzly_structure::UPPER_ARM_SIZE].try_into().unwrap());
        let lower_leg_size = f32::from_le_bytes(grizzly_data[grizzly_structure::LOWER_LEG_SIZE].try_into().unwrap());
        let upper_leg_size = f32::from_le_bytes(grizzly_data[grizzly_structure::UPPER_LEG_SIZE].try_into().unwrap());
        let lower_body_size = f32::from_le_bytes(grizzly_data[grizzly_structure::LOWER_BODY_SIZE].try_into().unwrap());
        let upper_body_size = f32::from_le_bytes(grizzly_data[grizzly_structure::UPPER_BODY_SIZE].try_into().unwrap());

        grizzly_data[grizzly_structure::HEART_SIZE].copy_from_slice(&(heart_size + factor * self.gain_heart).to_le_bytes());
        grizzly_data[grizzly_structure::BRAIN_SIZE].copy_from_slice(&(brain_size + factor * self.gain_brain).to_le_bytes());
        grizzly_data[grizzly_structure::LOWER_ARM_SIZE].copy_from_slice(&(lower_arm_size + factor * self.gain_lower_arm).to_le_bytes());
        grizzly_data[grizzly_structure::UPPER_ARM_SIZE].copy_from_slice(&(upper_arm_size + factor * self.gain_upper_arm).to_le_bytes());
        grizzly_data[grizzly_structure::LOWER_LEG_SIZE].copy_from_slice(&(lower_leg_size + factor * self.gain_lower_leg).to_le_bytes());
        grizzly_data[grizzly_structure::UPPER_LEG_SIZE].copy_from_slice(&(upper_leg_size + factor * self.gain_upper_leg).to_le_bytes());
        grizzly_data[grizzly_structure::LOWER_BODY_SIZE].copy_from_slice(&(lower_body_size + factor * self.gain_lower_body).to_le_bytes());
        grizzly_data[grizzly_structure::UPPER_BODY_SIZE].copy_from_slice(&(upper_body_size + factor * self.gain_upper_body).to_le_bytes());
    }
}