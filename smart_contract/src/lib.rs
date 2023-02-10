use solana_program::{
    entrypoint,
    pubkey::Pubkey,
    account_info::AccountInfo,
    entrypoint::ProgramResult,
};


pub fn add(left: usize, right: usize) -> usize {
    left + right
}

// Declare and export the program's entrypoint
entrypoint!(process_instruction);

// Program entrypoint's implementation
pub fn process_instruction(
    program_id: &Pubkey, // Public key of the account the hello world program was loaded into
    accounts: &[AccountInfo], // The accounts
    mut instruction_data: &[u8],
) -> ProgramResult {
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        let result = add(2, 2);
        assert_eq!(result, 4);
    }
}
