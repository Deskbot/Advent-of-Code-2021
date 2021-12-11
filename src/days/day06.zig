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
const ArrayList = std.ArrayList;
const File = std.fs.File;
const GeneralPurposeAllocator = std.heap.GeneralPurposeAllocator;

const filter = @import("../utils/filter.zig").filter;
const arr = @import("../utils/arr.zig");

const stdout = std.io.getStdOut().writer();

pub fn day06() !void {
    var gpa = GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const myIput = [_]i64{ 1, 2, 5, 1, 1, 4, 1, 5, 5, 5, 3, 4, 1, 2, 2, 5, 3, 5, 1, 3, 4, 1, 5, 2, 5, 1, 4, 1, 2, 2, 1, 5, 1, 1, 1, 2, 4, 3, 4, 2, 2, 4, 5, 4, 1, 2, 3, 5, 3, 4, 1, 1, 2, 2, 1, 3, 3, 2, 3, 2, 1, 2, 2, 3, 1, 1, 2, 5, 1, 2, 1, 1, 3, 1, 1, 5, 5, 4, 1, 1, 5, 1, 4, 3, 5, 1, 3, 3, 1, 1, 5, 2, 1, 2, 4, 4, 5, 5, 4, 4, 5, 4, 3, 5, 5, 1, 3, 5, 2, 4, 1, 1, 2, 2, 2, 4, 1, 2, 1, 5, 1, 3, 1, 1, 1, 2, 1, 2, 2, 1, 3, 3, 5, 3, 4, 2, 1, 5, 2, 1, 4, 1, 1, 5, 1, 1, 5, 4, 4, 1, 4, 2, 3, 5, 2, 5, 5, 2, 2, 4, 4, 1, 1, 1, 4, 4, 1, 3, 5, 4, 2, 5, 5, 4, 4, 2, 2, 3, 2, 1, 3, 4, 1, 5, 1, 4, 5, 2, 4, 5, 1, 3, 4, 1, 4, 3, 3, 1, 1, 3, 2, 1, 5, 5, 3, 1, 1, 2, 4, 5, 3, 1, 1, 1, 2, 5, 2, 4, 5, 1, 3, 2, 4, 5, 5, 1, 2, 3, 4, 4, 1, 4, 1, 1, 3, 3, 5, 1, 2, 5, 1, 2, 5, 4, 1, 1, 3, 2, 1, 1, 1, 3, 5, 1, 3, 2, 4, 3, 5, 4, 1, 1, 5, 3, 4, 2, 3, 1, 1, 4, 2, 1, 2, 2, 1, 1, 4, 3, 1, 1, 3, 5, 2, 1, 3, 2, 1, 1, 1, 2, 1, 1, 5, 1, 1, 2, 5, 1, 1, 4 };

    _ = try stdout.write("Day 06\n");

    _ = try stdout.print("Part 1 {}\n", .{try part1(&myIput, &gpa.allocator)});
    _ = try stdout.print("Part 2 {}\n", .{try part2(&myIput, &gpa.allocator)});
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

fn part2(input: []const i64, allocator: *Allocator) !i64 {
    var fish = try ArrayList(LanternFish).initCapacity(allocator, input.len);
    // give the ownership of this to school

    for (input) |num| {
        try fish.append(LanternFish.new(num));
    }

    var school = School.new(fish, allocator);
    defer school.deinit();

    try school.passDays(256);

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

    pub fn passSevenDays(school: *@This()) !void {
        // create a list of new fish and append them when the list is complete
        // don't add to the list while iterating through it
        var newFishArr = ArrayList(LanternFish).init(school.allocator);
        defer newFishArr.deinit();

        for (school.fish.items) |*fish| {
            // only fish with a timer of 6 or less will actually have a child in the next week
            if (fish.timer <= 6) {
                try newFishArr.append(LanternFish.new(fish.timer + 2));
            }

            // fish that won't loop back round to having the same timer will have had their timer reduced 7 times
            else {
                fish.timer -= 7;
            }
        }

        try school.fish.appendSlice(newFishArr.items);
    }

    pub fn passDays(school: *@This(), daysToPass: i64) !void {
        const weeks = @divFloor(daysToPass, 7);
        const days = @rem(daysToPass, 7);

        _ = try stdout.print("weeks ", .{});

        var weeksDone: i64 = 0;
        while (weeksDone < weeks) {
            try school.passSevenDays();
            weeksDone += 1;
            _ = try stdout.print("{} ", .{weeksDone});
        }

        _ = try stdout.print("days ", .{});

        var daysDone: i64 = 0;
        while (daysDone < days) {
            try school.passOneDay();
            daysDone += 1;
            _ = try stdout.print("{} ", .{daysDone});
        }
    }

    pub fn size(school: @This()) usize {
        return school.fish.items.len;
    }
};
