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

pub fn filter(comptime T: type, arr: []const T, predicate: fn (elem: T) bool, allocator: *Allocator) ![]T {
    // create array big enough to hold all of the given values
    var newArr: []T = try allocator.alloc(T, arr.len);
    defer allocator.free(newArr);

    var elemsKept: usize = 0;

    for (arr) |elem, i| {
        if (predicate(elem)) {
            newArr[elemsKept] = elem;
            elemsKept += 1;
        }
    }

    // create an array that is the exact size needed to hold the filtered elements
    var returnedArr = try allocator.alloc(T, elemsKept);

    mem.copy(T, returnedArr, newArr[0..elemsKept]);

    return returnedArr;
}

fn isEven(elem: i64) bool {
    return @rem(elem, 2) == 0;
}

const expect = std.testing.expect;

test "filter" {
    var gpa = GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const arr = [_]i64{ 1, 2, 3, 4, 5, 6 };

    const result = try filter(i64, &arr, isEven, &gpa.allocator);
    defer gpa.allocator.free(result);

    try expect(result.len == 3);
}
