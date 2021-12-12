const std = @import("std");

const debug = std.debug;
const fmt = std.fmt;
const math = std.math;
const mem = std.mem;

const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const GeneralPurposeAllocator = std.heap.GeneralPurposeAllocator;

const stdout = std.io.getStdOut().writer();

const myInputFile = @embedFile("../../input/Day07.txt");

pub fn day07() !void {
    var gpa = GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    _ = try stdout.write("Day 07\n");

    const nums = try parseInput(myInputFile, &gpa.allocator);
    defer nums.deinit();

    _ = try stdout.print("Part 1 {}\n", .{try part1(nums.items)});
    _ = try stdout.print("Part 2 {}\n", .{try part2(nums.items)});
}

fn part1(input: []const i64) !i64 {
    const min = mem.min(i64, input);
    const max = mem.max(i64, input);

    var bestScore: i64 = math.maxInt(i64); // lower is better
    var bestPosition: i64 = undefined;

    var n: i64 = min;
    while (n <= max) {
        const score = try getScorePart1(input, n);

        if (score < bestScore) {
            bestScore = score;
            bestPosition = n;
        }

        n += 1;
    }

    return bestScore;
}

fn part2(input: []const i64) !i64 {
    const min = mem.min(i64, input);
    const max = mem.max(i64, input);

    var bestScore: i64 = math.maxInt(i64); // lower is better
    var bestPosition: i64 = undefined;

    var n: i64 = min;
    while (n <= max) {
        const score = try getScorePart2(input, n);

        if (score < bestScore) {
            bestScore = score;
            bestPosition = n;
        }

        n += 1;
    }

    return bestScore;
}

fn getScorePart1(nums: []const i64, targetPosition: i64) !i64 {
    var score: i64 = 0;

    for (nums) |num| {
        score += try math.absInt(targetPosition - num);
    }

    return score;
}

fn getScorePart2(nums: []const i64, targetPosition: i64) !i64 {
    var score: i64 = 0;

    for (nums) |num| {
        score += triangleNumber(try math.absInt(targetPosition - num));
    }

    return score;
}

fn triangleNumber(n: i64) i64 {
    return @divFloor(n * (n + 1), 2);
}

fn parseInput(file: []const u8, allocator: *Allocator) !ArrayList(i64) {
    const commas = mem.count(u8, file, ",");

    var it = mem.split(file, ",");

    var arr = try ArrayList(i64).initCapacity(allocator, commas + 1);

    while (it.next()) |str| {
        try arr.append(try fmt.parseInt(i64, str, 10));
    }

    return arr;
}
