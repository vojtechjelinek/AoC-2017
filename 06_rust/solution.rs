use std::error::Error;
use std::fs::File;
use std::io::prelude::*;

fn solve() -> Result<[i32; 2], Box<Error>> {
    let mut file = File::open("input.txt")?;

    let mut s = String::new();
    file.read_to_string(&mut s)?;

    let iter = s.split_whitespace();
    let mut banks: [i8; 16] = [0; 16];

    let mut i = 0;
    for val in iter {
        banks[i] = val.parse::<i8>().unwrap();
        i += 1;
    }

    let mut prev_banks: Vec<[i8; 16]> = vec![];
    let mut cycles = 0;
    while !prev_banks.contains(&banks) {
        prev_banks.push(banks);
        let max_value = match banks.clone().iter().max() {
            None => panic!("couldn't get max"),
            Some(result) => result.clone(),
        };
        let max_index = match banks.clone().iter().position(|&x| x == max_value) {
            None => panic!("couldn't get max index"),
            Some(result) => result,
        };
        let mut value_to_distribute = banks[max_index];
        let mut current_index = (max_index + 1) % 16;
        banks[max_index] = 0;
        while value_to_distribute > 0 {
            banks[current_index] += 1;
            current_index = (current_index + 1) % 16;
            value_to_distribute -= 1;
        }
        cycles += 1;
    }
    let same_position = match prev_banks.iter().position(|&x| x == banks) {
        None => panic!("couldn't get position"),
        Some(result) => result as i32,
    };
    let loop_size: i32 = cycles - same_position;
    return Ok([cycles, loop_size]);
}

fn main() {
    match solve() {
        Err(why) => panic!("couldn't read: {}", why.description()),
        Ok(result) => print!("{:?}", result),
    }
}
