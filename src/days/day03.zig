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

    // const fileStr = try file.readToEndAlloc(gpa.allocator, 1000 * 12 * 100);

    const inputList = try parseInput(&file.reader(), &gpa.allocator);
    // defer gpa.allocator.free(&inputList);

    const input = inputList.items;
    const numDigits = input[0].len;

    _ = try stdout.print("Part 1 {}\n", .{try part1(input, numDigits, &gpa.allocator)});

    // _ = try stdout.print("Part 1 {}\n", .{try part2(input, numDigits, &gpa.allocator)});
}

fn parseInput(reader: *File.Reader, allocator: *Allocator) !ArrayList([]u8) {
    var list = ArrayList([]u8).init(allocator);

    var buf: [1024]u8 = undefined;
    while (try reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        try list.append(line);
    }

    return list;
}

fn part1(nums: []const []u8, numDigits: usize, allocator: *Allocator) !i64 {
    var zeroCounts: []i64 = try allocator.alloc(i64, nums.len);
    defer allocator.free(zeroCounts);

    var oneCounts: []i64 = try allocator.alloc(i64, nums.len);
    defer allocator.free(oneCounts);

    for (zeroCounts) |*zero| {
        zero.* = 0;
    }

    for (oneCounts) |*one| {
        one.* = 1;
    }

    for (nums) |num, index| {
        for (num) |digit| {
            if (digit == '0') {
                zeroCounts[index] += 1;
            } else {
                oneCounts[index] += 1;
            }
        }
    }

    var result: []u8 = try allocator.alloc(u8, numDigits);

    defer allocator.free(result);

    var i: usize = 0;
    while (i < numDigits) {
        if (zeroCounts[i] > oneCounts[i]) {
            result[i] = '0';
        } else {
            result[i] = '1';
        }

        i += 1;
    }

    return try fmt.parseInt(i64, result, 2);
}
