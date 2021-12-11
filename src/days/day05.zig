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
    _ = try stdout.print("Part 2 {}\n", .{try part2(input, &gpa.allocator)});
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

    fn isNotDiagonal(line: *const Line) bool {
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

            // we know this isn't null now
            const last = it.last.?;

            // if we've already reached the end we're done
            if (Point.equals(&last, &it.line.end)) {
                return null;
            }

            // continue from the current point

            var peeked: Point = last;

            // diagonal
            if (!it.line.isNotDiagonal()) {
                if (last.x < it.line.end.x) {
                    peeked.x += 1;
                } else if (last.x > it.line.end.x) {
                    peeked.x -= 1;
                }

                if (last.y < it.line.end.y) {
                    peeked.y += 1;
                } else if (last.y > it.line.end.y) {
                    peeked.y -= 1;
                }

                return peeked;
            }

            // go right
            if (last.x < it.line.end.x) {
                peeked.x += 1;
            }

            // go left
            else if (last.x > it.line.end.x) {
                peeked.x -= 1;
            }

            // go down
            else if (last.y < it.line.end.y) {
                peeked.y += 1;
            }

            // go up
            else if (last.y > it.line.end.y) {
                peeked.y -= 1;
            }

            // already at the end, can't move the last point at all
            else {
                return null;
            }

            return peeked;
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

    pub fn equals(p1: *const Point, p2: *const Point) bool {
        return p1.x == p2.x and p1.y == p2.y;
    }
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

    var numberOfOverlaps: i64 = 0;

    for (floor.grid) |line| {
        for (line) |cell| {
            if (cell >= 2) {
                numberOfOverlaps += 1;
            }
        }
    }

    return numberOfOverlaps;
}

fn part2(input: []Line, allocator: *Allocator) !i64 {
    var floor = Floor(1000, 1000).new();

    for (input) |*line| {
        floor.draw(line);
    }

    var numberOfOverlaps: i64 = 0;

    for (floor.grid) |line| {
        for (line) |cell| {
            if (cell >= 2) {
                numberOfOverlaps += 1;
            }
        }
    }

    return numberOfOverlaps;
}
