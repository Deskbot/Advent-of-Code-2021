const std = @import("std");

const debug = std.debug;
const fmt = std.fmt;
const fs = std.fs;
const os = std.os;
const io = std.io;
const mem = std.mem;

const ArrayList = std.ArrayList;
const File = std.fs.File;
const GeneralPurposeAllocator = std.heap.GeneralPurposeAllocator;

const stdout = std.io.getStdOut().writer();

pub fn day02() anyerror!void {
    _ = try stdout.print("Day 02\n", .{});

    var file = try std.fs.cwd().openFile("./input/Day02.txt", .{});
    defer file.close();

    const input = try parseInput(&file.reader());

    _ = try stdout.print("Part 1 {}\n", .{part1(input)});

    // _ = try stdout.print("Part 2 {}\n", .{part2(&input)});
}

const Direction = enum {
    forward,
    up,
    down,
};

const Command = struct {
    direction: Direction,
    magnitude: i64,
};

fn parseInput(reader: *File.Reader) ![]Command {
    var gpa = GeneralPurposeAllocator(.{}){};

    var result = ArrayList(Command).init(&gpa.allocator);

    var buf: [1024]u8 = undefined;
    while (try reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var iter = mem.split(line, " ");

        const directionStr = iter.next().?;
        const magnitudeStr = iter.next().?;

        const direction = try parseDirection(directionStr);
        const magnitude = try fmt.parseInt(i64, magnitudeStr, 10);

        try result.append(Command{
            .direction = direction,
            .magnitude = magnitude,
        });
    }

    return result.items;
}

fn parseDirection(str: []const u8) !Direction {
    if (mem.eql(u8, str, "forward")) return Direction.forward;
    if (mem.eql(u8, str, "up")) return Direction.up;
    if (mem.eql(u8, str, "down")) return Direction.down;
    unreachable;
}

fn part1(commands: []const Command) i64 {
    var horizontalPosition: i64 = 0;
    var depth: i64 = 0;

    for (commands) |command| {
        switch (command.direction) {
            .forward => {
                horizontalPosition += command.magnitude;
            },
            .up => {
                depth -= command.magnitude;
            },
            .down => {
                depth += command.magnitude;
            },
        }
    }

    return horizontalPosition * depth;
}
