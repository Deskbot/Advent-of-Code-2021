const std = @import("std");

const debug = std.debug;
const fs = std.fs;
const os = std.os;
const io = std.io;

const File = std.fs.File;

const stdout = std.io.getStdOut().writer();

pub fn main() anyerror!void {
    var file = try std.fs.cwd().openFile("./input/Day01.txt", .{});
    defer file.close();

    try part1(&file.reader());
    try file.seekTo(0);
    try part2(&file.reader());
}

fn part1(reader: *File.Reader) !void {
    var increases: i64 = 0;
    var previous: ?i64 = null;

    var buf: [1024]u8 = undefined;
    while (try reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const i = try std.fmt.parseInt(i64, line, 10);

        if (previous != null and i > previous.?) {
            increases += 1;
        }

        previous = i;
    }

    _ = try stdout.print("Part 1 {}\n", .{increases});
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

fn part2(reader: *File.Reader) !void {
    var window = Window(3).new();
    var previousWindowSum: ?i64 = null;

    var increases: i64 = 0;

    var buf: [1024]u8 = undefined;
    while (try reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const nextInt = try std.fmt.parseInt(i64, line, 10);

        window.append(nextInt);

        const windowSum = sum(&window.arr);

        if (previousWindowSum != null and windowSum > previousWindowSum.?) {
            increases += 1;
        }

        previousWindowSum = windowSum;
    }

    _ = try stdout.print("Part 2 {}\n", .{increases});
}

fn sum(arr: []const i64) i64 {
    var result: i64 = 0;

    for (arr) |elem| {
        result += elem;
    }

    return result;
}
