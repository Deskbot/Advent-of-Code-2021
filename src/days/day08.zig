const std = @import("std");

const fmt = std.fmt;
const math = std.math;
const mem = std.mem;

const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const GeneralPurposeAllocator = std.heap.GeneralPurposeAllocator;

const debug = std.log.debug;

const stdout = std.io.getStdOut().writer();

const myInputFile = @embedFile("../../input/Day08.txt");

pub fn day08() !void {
    var gpa = GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    _ = try stdout.write("Day 08\n");

    const nums = try parseInput(myInputFile, &gpa.allocator);
    defer nums.deinit();

    _ = try stdout.print("Part 1 {}\n", .{try part1(nums.items)});
    // _ = try stdout.print("Part 2 {}\n", .{try part2(nums.items)});
}

fn parseInput(input: []const u8, allocator: *Allocator) ArrayList(Display) {
    var arr = ArrayList(Display).init();
}

fn part1(input: []const i64) !i64 {


    return 0;
}

