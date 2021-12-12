const std = @import("std");

const debug = std.debug;
const fmt = std.fmt;
const fs = std.fs;
const os = std.os;
const io = std.io;
const math = std.math;
const mem = std.mem;
const sort = std.sort;

const Allocator = std.mem.Allocator;
const ArrayHashMap = std.ArrayHashMap;
const ArrayList = std.ArrayList;
const File = std.fs.File;
const GeneralPurposeAllocator = std.heap.GeneralPurposeAllocator;

const filter = @import("../utils/filter.zig").filter;
const arr = @import("../utils/arr.zig");

const stdout = std.io.getStdOut().writer();

const myInput = [_]i64{ 1, 2, 5, 1, 1, 4, 1, 5, 5, 5, 3, 4, 1, 2, 2, 5, 3, 5, 1, 3, 4, 1, 5, 2, 5, 1, 4, 1, 2, 2, 1, 5, 1, 1, 1, 2, 4, 3, 4, 2, 2, 4, 5, 4, 1, 2, 3, 5, 3, 4, 1, 1, 2, 2, 1, 3, 3, 2, 3, 2, 1, 2, 2, 3, 1, 1, 2, 5, 1, 2, 1, 1, 3, 1, 1, 5, 5, 4, 1, 1, 5, 1, 4, 3, 5, 1, 3, 3, 1, 1, 5, 2, 1, 2, 4, 4, 5, 5, 4, 4, 5, 4, 3, 5, 5, 1, 3, 5, 2, 4, 1, 1, 2, 2, 2, 4, 1, 2, 1, 5, 1, 3, 1, 1, 1, 2, 1, 2, 2, 1, 3, 3, 5, 3, 4, 2, 1, 5, 2, 1, 4, 1, 1, 5, 1, 1, 5, 4, 4, 1, 4, 2, 3, 5, 2, 5, 5, 2, 2, 4, 4, 1, 1, 1, 4, 4, 1, 3, 5, 4, 2, 5, 5, 4, 4, 2, 2, 3, 2, 1, 3, 4, 1, 5, 1, 4, 5, 2, 4, 5, 1, 3, 4, 1, 4, 3, 3, 1, 1, 3, 2, 1, 5, 5, 3, 1, 1, 2, 4, 5, 3, 1, 1, 1, 2, 5, 2, 4, 5, 1, 3, 2, 4, 5, 5, 1, 2, 3, 4, 4, 1, 4, 1, 1, 3, 3, 5, 1, 2, 5, 1, 2, 5, 4, 1, 1, 3, 2, 1, 1, 1, 3, 5, 1, 3, 2, 4, 3, 5, 4, 1, 1, 5, 3, 4, 2, 3, 1, 1, 4, 2, 1, 2, 2, 1, 1, 4, 3, 1, 1, 3, 5, 2, 1, 3, 2, 1, 1, 1, 2, 1, 1, 5, 1, 1, 2, 5, 1, 1, 4 };

pub fn day06() !void {
    var gpa = GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    _ = try stdout.write("Day 06\n");

    _ = try stdout.print("Part 1 {}\n", .{try part1(&myInput, &gpa.allocator)});
    _ = try stdout.print("Part 2 {}\n", .{try part2(&myInput, 256, &gpa.allocator)});
}

fn part1(input: []const i64, allocator: *Allocator) !i64 {
    var fish = try ArrayList(LanternFish).initCapacity(allocator, input.len);
    // give the ownership of this to school

    for (input) |num| {
        try fish.append(LanternFish.new(num));
    }

    var school = School.new(fish, allocator);
    defer school.deinit();

    try school.passDays(80);

    return @intCast(i64, school.size());
}

fn part2(input: []const i64, days: i64, allocator: *Allocator) !i64 {
    var fish = try ArrayList(LanternFish).initCapacity(allocator, input.len);
    defer fish.deinit();

    for (input) |num| {
        try fish.append(LanternFish.new(num));
    }

    var school = School2.new(fish);

    school.passDays(days);

    return @intCast(i64, school.size());
}

const LanternFish = struct {
    timer: i64,

    pub fn new(intialTimer: i64) @This() {
        return @This(){
            .timer = intialTimer,
        };
    }

    // returns whether the fish gave birth
    pub fn passOneDay(lanternFish: *LanternFish) bool {
        // increment the timer
        if (lanternFish.timer == 0) {
            lanternFish.timer = 6;
            return true;
        } else {
            lanternFish.timer -= 1;
            return false;
        }
    }
};

const School = struct {
    allocator: *Allocator,
    fish: ArrayList(LanternFish),

    pub fn new(fish: ArrayList(LanternFish), allocator: *Allocator) @This() {
        return @This(){
            .allocator = allocator,
            .fish = fish,
        };
    }

    pub fn deinit(school: *@This()) void {
        school.fish.deinit();
    }

    pub fn passOneDay(school: *@This()) !void {
        // create a list of new fish and append them when the list is complete
        // don't add to the list while iterating through it
        var newFishArr = ArrayList(LanternFish).init(school.allocator);
        defer newFishArr.deinit();

        for (school.fish.items) |*fish| {
            if (fish.passOneDay()) {
                // create new fish with a timer of 8
                try newFishArr.append(LanternFish.new(8));
            }
        }

        try school.fish.appendSlice(newFishArr.items);
    }

    pub fn passDays(school: *@This(), daysToPass: i64) !void {
        const days = daysToPass;

        _ = try stdout.print("days ", .{});

        var daysDone: i64 = 0;
        while (daysDone < days) {
            try school.passOneDay();
            daysDone += 1;
            _ = try stdout.print("day {} count {} \n", .{ daysDone, school.size() });
        }
    }

    pub fn size(school: @This()) usize {
        return school.fish.items.len;
    }
};

const School2 = struct {
    fishMap: [9]i64, // 0 through 8 included

    pub fn new(fish: ArrayList(LanternFish)) @This() {
        var fishMap: [9]i64 = mem.zeroes([9]i64);

        for (fish.items) |f| {
            fishMap[@intCast(usize, f.timer)] += 1;
        }

        return @This(){
            .fishMap = fishMap,
        };
    }

    pub fn passDays(school: *@This(), daysToPass: i64) void {
        const weeks = @divFloor(daysToPass, 7);
        const days = @rem(daysToPass, 7);

        var weeksDone: i64 = 0;
        while (weeksDone < weeks) {
            school.passWeek();
            weeksDone += 1;
        }

        var daysDone: i64 = 0;
        while (daysDone < days) {
            school.passOneDay();
            daysDone += 1;
        }
    }

    pub fn passOneDay(school: *@This()) void {
        const fishToGiveBirth = school.fishMap[0];

        school.fishMap[0] = school.fishMap[1];
        school.fishMap[1] = school.fishMap[2];
        school.fishMap[2] = school.fishMap[3];
        school.fishMap[3] = school.fishMap[4];
        school.fishMap[4] = school.fishMap[5];
        school.fishMap[5] = school.fishMap[6];
        school.fishMap[6] = school.fishMap[7] + fishToGiveBirth; // every fish at 0 becomes at 6
        school.fishMap[7] = school.fishMap[8];

        // every fish at 0 creates a fish at 8
        school.fishMap[8] = fishToGiveBirth;
    }

    pub fn passWeek(school: *@This()) void {
        const eights = school.fishMap[8];
        const sevens = school.fishMap[7];

        // fish with a timer of n, produce a fish with timer n+2
        school.fishMap[8] += school.fishMap[6];
        school.fishMap[7] += school.fishMap[5];
        school.fishMap[6] += school.fishMap[4];
        school.fishMap[5] += school.fishMap[3];
        school.fishMap[4] += school.fishMap[2];
        school.fishMap[3] += school.fishMap[1];
        school.fishMap[2] += school.fishMap[0];

        // unless the fish's timer is 7 or 8
        // in which case their timer goes down by 7

        school.fishMap[1] += eights;
        school.fishMap[0] += sevens;
    }

    pub fn size(school: @This()) i64 {
        var sum: i64 = 0;

        for (school.fishMap) |amount| {
            sum += amount;
        }

        return sum;
    }
};

const expect = std.testing.expect;

test "part 1 works with part 2 solution" {
    var gpa = GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const input = myInput;

    const actual = try part2(&input, 80, &gpa.allocator);
    const expected = 356190;

    _ = try stdout.print("\n\nexpected {} actual {} \n\n", .{ expected, actual });
    try expect(expected == actual);
}

test "part 2 example" {
    var gpa = GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const input = [_]i64{ 3, 4, 3, 1, 2 };

    const actual = try part2(&input, 256, &gpa.allocator);
    const expected = 26984457539;

    _ = try stdout.print("\n\nexpected {} actual {} \n\n", .{ expected, actual });
    try expect(expected == actual);
}

// too high 72141502659417871
// too high 71513736741905388
