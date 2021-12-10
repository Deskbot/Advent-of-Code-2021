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

const filter = @import("../utils/filter.zig").filter;
const arr = @import("../utils/arr.zig");

const stdout = std.io.getStdOut().writer();

pub fn day05() anyerror!void {
    var gpa = GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const inputFile = @embedFile("../../input/Day05.txt");

    const inputList = try parseInput(inputFile, &gpa.allocator);
    defer inputList.deinit();

    const input = inputList.items;

    _ = try stdout.print("{any}", .{input});

    _ = try stdout.write("Day 05\n");

    _ = try stdout.print("Part 1 {}\n", .{try part1(input, &gpa.allocator)});
}

const Line = struct {
    start: Point,
    end: Point,
};

const Point = struct {
    x: i64,
    y: i64,
};

fn parseInput(input: []const u8, allocator: *Allocator) !ArrayList(Line) {
    var iter = mem.split(input, "\n");

    var lines = ArrayList(Line).init(allocator);

    while (iter.next()) |line| {
        // don't try to parse an empty lines
        if (!mem.eql(u8, line, "")) {
            try lines.append(parseLine(line));
        }
    }

    return lines;
}

fn parseLine(line: []const u8) Line {
    var ends = mem.split(line, " -> ");
    const startStr = ends.next().?;
    const endStr = ends.next().?;

    var startParts = mem.split(startStr, ",");
    var endParts = mem.split(endStr, ",");

    return Line{
        .start = Point{
            .x = fmt.parseInt(i64, startParts.next().?, 10) catch unreachable,
            .y = fmt.parseInt(i64, startParts.next().?, 10) catch unreachable,
        },
        .end = Point{
            .x = fmt.parseInt(i64, endParts.next().?, 10) catch unreachable,
            .y = fmt.parseInt(i64, endParts.next().?, 10) catch unreachable,
        },
    };
}

fn part1(input: []Line, allocator: *Allocator) !i64 {
    return 0;
}
