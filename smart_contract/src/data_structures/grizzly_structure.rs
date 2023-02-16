use std::ops::Range;

pub const STATE_NO_FIGHT: u8 = 0;
pub const STATE_CHALLENGING: u8 = 1;
pub const STATE_ACCEPTED_CHALLENGE: u8 = 2;
pub const STATE_CONFIRMED_CHALLENGE: u8 = 3;

pub const ARENA_STATE: usize = 0;
pub const PENALTY: usize = 1;
pub const TIMESTAMP: Range<usize> = 2..10;
pub const HEART_SIZE: Range<usize> = TIMESTAMP.end..TIMESTAMP.end + 4;
pub const BRAIN_SIZE: Range<usize> = HEART_SIZE.end..HEART_SIZE.end + 4;
pub const LOWER_ARM_SIZE: Range<usize> = BRAIN_SIZE.end..BRAIN_SIZE.end + 4;
pub const UPPER_ARM_SIZE: Range<usize> = LOWER_ARM_SIZE.end..LOWER_ARM_SIZE.end + 4;
pub const LOWER_LEG_SIZE: Range<usize> = UPPER_ARM_SIZE.end..UPPER_ARM_SIZE.end + 4;
pub const UPPER_LEG_SIZE: Range<usize> = LOWER_LEG_SIZE.end..LOWER_LEG_SIZE.end + 4;
pub const LOWER_BODY_SIZE: Range<usize> = UPPER_LEG_SIZE.end..UPPER_LEG_SIZE.end + 4;
pub const UPPER_BODY_SIZE: Range<usize> = LOWER_BODY_SIZE.end..LOWER_BODY_SIZE.end + 4;
pub const TARGET: Range<usize> = UPPER_BODY_SIZE.end..UPPER_BODY_SIZE.end + 32;
pub const SIZE: usize = TARGET.end;