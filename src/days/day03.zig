const std = @import("std");

const debug = std.debug;
const fmt = std.fmt;
const fs = std.fs;
const os = std.os;
const io = std.io;
const mem = std.mem;

const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const File = std.fs.File;
const GeneralPurposeAllocator = std.heap.GeneralPurposeAllocator;

const stdout = std.io.getStdOut().writer();

pub fn day03() anyerror!void {
    _ = try stdout.print("Day 03\n", .{});

    var gpa = GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    var file = try std.fs.cwd().openFile("./input/Day03.txt", .{});
    defer file.close();

    const fileStr = try file.readToEndAlloc(&gpa.allocator, 1000 * 12 * 100);

    const inputList = try parseInput(fileStr, &gpa.allocator);
    defer inputList.deinit();

    const input = inputList.items;
    const numDigits = input[0].len;

    _ = try stdout.print("Part 1 {}\n", .{try part1(input, numDigits, &gpa.allocator)});

    // _ = try stdout.print("Part 1 {}\n", .{try part2(input, numDigits, &gpa.allocator)});
}

fn parseInput(fileStr: []const u8, allocator: *Allocator) !ArrayList([]const u8) {
    var lines = ArrayList([]const u8).init(allocator);

    var iter = mem.split(fileStr, "\n");

    while (iter.next()) |line| {
        if (!mem.eql(u8, line, "")) {
            try lines.append(line);
        }
    }

    return lines;
}

fn part1(nums: []const []const u8, numDigits: usize, allocator: *Allocator) !i64 {
    var zeroCounts: []i64 = try allocator.alloc(i64, numDigits);
    defer allocator.free(zeroCounts);

    var oneCounts: []i64 = try allocator.alloc(i64, numDigits);
    defer allocator.free(oneCounts);

    for (zeroCounts) |*zero| {
        zero.* = 0;
    }

    for (oneCounts) |*one| {
        one.* = 0;
    }

    for (nums) |num| {
        for (num) |digit, index| {
            if (digit == '0') {
                zeroCounts[index] += 1;
            } else {
                oneCounts[index] += 1;
            }
        }
    }

    var gammaStr: []u8 = try allocator.alloc(u8, numDigits);
    var epsilonStr: []u8 = try allocator.alloc(u8, numDigits);

    defer allocator.free(gammaStr);

    var i: usize = 0;
    while (i < numDigits) {
        if (zeroCounts[i] > oneCounts[i]) {
            gammaStr[i] = '0';
            epsilonStr[i] = '1';
        } else {
            gammaStr[i] = '1';
            epsilonStr[i] = '0';
        }

        i += 1;
    }

    const gamma = try fmt.parseInt(i64, gammaStr, 2);
    const epsilon = try fmt.parseInt(i64, epsilonStr, 2);

    return gamma * epsilon;
}

const expect = std.testing.expect;

test "part 1 example" {
    const inputStr =
        \\ 00100
        \\ 11110
        \\ 10110
        \\ 10111
        \\ 10101
        \\ 01111
        \\ 00111
        \\ 11100
        \\ 10000
        \\ 11001
        \\ 00010
        \\ 01010
    ;

    var gpa = GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const inputList = try parseInput(inputStr, &gpa.allocator);
    defer inputList.deinit();

    const input = inputList.items;
    const numDigits = input[0].len;

    const result = try part1(input, numDigits, &gpa.allocator);

    try expect(result == 198);
}
