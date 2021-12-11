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

    _ = try stdout.write("Day 05\n");

    _ = try stdout.print("Part 1 {}\n", .{try part1(input, &gpa.allocator)});
}

fn Floor(comptime xSize: usize, comptime ySize: usize) type {
    return struct {
        grid: [xSize][ySize]i64,

        pub fn new() @This() {
            return @This(){
                .grid = mem.zeroes([xSize][ySize]i64),
            };
        }

        pub fn draw(floor: *@This(), line: *Line) void {
            var it: Line.Iterator = line.iter();

            while (it.next()) |point| {
                const x = @intCast(usize, point.x);
                const y = @intCast(usize, point.y);
                floor.grid[x][y] += 1;
            }
        }
    };
}

const Line = struct {
    start: Point,
    end: Point,

    fn isNotDiagonal(line: *Line) bool {
        return line.start.x == line.end.x or line.start.y == line.end.y;
    }

    pub const Iterator = struct {
        line: Line,
        last: ?Point,

        // returns null when done
        pub fn next(it: *Iterator) ?Point {
            it.last = it.peekNext();
            return it.last;
        }

        // returns null when done
        pub fn peekNext(it: *const Iterator) ?Point {
            // start at the start
            if (it.last == null) {
                return it.line.start;
            }

            // continue from the current point
            const last = it.last.?;

            // go right
            if (last.x < it.line.end.x) {
                return Point{
                    .x = last.x + 1,
                    .y = last.y,
                };
            }

            // go left
            if (last.x > it.line.end.x) {
                return Point{
                    .x = last.x - 1,
                    .y = last.y,
                };
            }

            // go down
            if (last.y < it.line.end.y) {
                return Point{
                    .x = last.x,
                    .y = last.y + 1,
                };
            }

            // go up
            if (last.y > it.line.end.y) {
                return Point{
                    .x = last.x,
                    .y = last.y - 1,
                };
            }

            return null;
        }
    };

    pub fn iter(line: Line) Iterator {
        return Iterator{
            .last = null,
            .line = line,
        };
    }
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
    var floor = Floor(1000, 1000).new();

    for (input) |*line| {
        if (line.isNotDiagonal()) {
            floor.draw(line);
        }
    }

    return 0;
}
