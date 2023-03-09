use std::ops::Range;

use crate::data_structures::grizzly_structure::AMOUNT_OF_ABILITIES;

pub const HAS_CHALLENGER: usize = 0;
pub const LAST_BEAR: Range<usize> = 1..33;
pub const PRIZES: usize = LAST_BEAR.end;
pub const SIZE: usize = PRIZES +  8 * AMOUNT_OF_ABILITIES;