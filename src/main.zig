const day01 = @import("./days/day01.zig").day01;
const day02 = @import("./days/day02.zig").day02;

pub fn main() anyerror!void {
    try day01();
    try day02();
}
