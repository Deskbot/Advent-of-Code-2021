import os
import strconv

fn main() {
	// day 4

	file := os.read_file("./input/Day04.txt") ?

	nums, boards := parse_input(file)

	part1(nums, boards)
}

struct Board {
	grid [][]i64
	checks [][]bool
}

fn new_board(grid [][]i64) Board {
	mut checks := [][]bool{}

	for i, line in grid {
		for j in line {
			checks[i][j] = false
		}
	}

	return Board{grid, checks}
}

fn (mut b Board) check(num i64) {
	mut location := b.find(num) or { return }

	unsafe {
		*location = num
	}
}

fn (b Board) find(num i64) ?&i64 {
	for _, line in b.grid {
		for _, cell in line {
			if cell == num {
				unsafe {
					return &cell
				}
			}
		}
	}

	return none
}

fn parse_input(input string) ([]i64, []Board) {
	mut inp := input.clone()
	mut inps := inp.split("---") // yes I put this in

	numbers := inps[0]
		.trim(" \n")
		.split(",")
		.map(fn (num string) i64 {
			return strconv.parse_int(num.trim(" \n"), 10, 64)
				or { panic("Can't parse num: '" + num + "'") }
		})

	println(inps[1].split("\n\n"))

	grids := inps[1]
		.split("\n\n")
		.filter(fn (board_str string) bool {
			return board_str != ""
		})
		.map(fn (board_str string) [][]i64 {
			// println("'" + board_str + "'")
			return board_str.split("\n")

				// ignore empty lines
				.filter(fn (line string) bool {
					return line != ""
				})

				// turn every line into a list of ints
				.map(fn (line string) []i64 {
					mut digits := line.trim(" \n").split(" ")
					// println(digits)

					mut actual_digits := digits.filter(fn (digit string) bool {
						return digit != ""
					})
					// println("actual digits: " + actual_digits.str())

					return actual_digits.map(fn (digit string) i64 {
						// println("digit: " + digit)
						return strconv.parse_int(digit, 10, 64)
							or { panic("Can't parse digit: '" + digit + "'") }
					})
				})
		})

	boards := grids.map(new_board)

	return numbers, boards
}

fn part1(nums []i64, boards []Board) {

}
