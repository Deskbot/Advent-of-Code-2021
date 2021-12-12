const day01 = @import("./days/day01.zig").day01;
const day02 = @import("./days/day02.zig").day02;
const day03 = @import("./days/day03.zig").day03;
const day04 = @import("./days/day04.zig").day04;
const day05 = @import("./days/day05.zig").day05;
const day06 = @import("./days/day06.zig").day06;
const day07 = @import("./days/day07.zig").day07;

pub fn main() anyerror!void {
    try day01();
    try day02();
    try day03();
    try day04();
    try day05();
    try day06();
    try day07();
}
