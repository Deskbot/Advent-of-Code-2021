const std = @import("std");

const debug = std.debug;
const fs = std.fs;
const os = std.os;
const io = std.io;

const ArrayList = std.ArrayList;
const File = std.fs.File;
const GeneralPurposeAllocator = std.heap.GeneralPurposeAllocator;

const stdout = std.io.getStdOut().writer();

pub fn main() anyerror!void {
    var file = try std.fs.cwd().openFile("./input/Day01.txt", .{});
    defer file.close();

    const input = try parseInput(&file.reader());

    const part1Result = try part1(&input);
    _ = try stdout.print("Part 1 {}\n", .{part1Result});

    const part2Result = try part2(&input);
    _ = try stdout.print("Part 2 {}\n", .{part2Result});
}

fn parseInput(reader: *File.Reader) !ArrayList(i64) {
    var gpa = GeneralPurposeAllocator(.{}){};

    var result = ArrayList(i64).init(&gpa.allocator);

    var buf: [1024]u8 = undefined;
    while (try reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const i = try std.fmt.parseInt(i64, line, 10);

        try result.append(i);
    }

    return result;
}

fn part1(arr: *const ArrayList(i64)) !i64 {
    var increases: i64 = 0;
    var previous: ?i64 = null;

    var buf: [1024]u8 = undefined;
    for (arr.items) |nextInt| {
        if (previous != null and nextInt > previous.?) {
            increases += 1;
        }

        previous = nextInt;
    }

    return increases;
}

fn Window(comptime size: i64) type {
    return struct {
        const Self = @This();

        arr: [size]i64,
        index: usize,

        fn new() Self {
            return Self{
                .arr = std.mem.zeroes([size]i64),
                .index = 0,
            };
        }

        fn append(self: *Self, val: i64) void {
            self.arr[self.index] = val;
            self.index = (self.index + 1) % size;
        }
    };
}

fn part2(arr: *const ArrayList(i64)) !i64 {
    var window = Window(3).new();
    var previousWindowSum: ?i64 = null;

    var increases: i64 = 0;

    var numbersRead: i64 = 0;

    var buf: [1024]u8 = undefined;
    for (arr.items) |nextInt| {
        window.append(nextInt);

        numbersRead += 1;

        if (numbersRead < 3) continue; // need a complete window to start with

        const windowSum = sum(&window.arr);

        if (previousWindowSum != null and windowSum > previousWindowSum.?) {
            increases += 1;
        }

        previousWindowSum = windowSum;
    }

    return increases;
}

fn sum(arr: []const i64) i64 {
    var result: i64 = 0;

    for (arr) |elem| {
        result += elem;
    }

    return result;
}

const expect = std.testing.expect;

test "part 2 example" {
    var gpa = GeneralPurposeAllocator(.{}){};

    var example = ArrayList(i64).init(&gpa.allocator);

    try example.append(199);
    try example.append(200);
    try example.append(208);
    try example.append(210);
    try example.append(200);
    try example.append(207);
    try example.append(240);
    try example.append(269);
    try example.append(260);
    try example.append(263);

    const result = try part2(&example);
    try expect(result == 5);
}
