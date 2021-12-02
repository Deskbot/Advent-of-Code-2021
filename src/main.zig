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

fn part2(reader: *File.Reader) !void {}
