const std = @import("std");
const os = std.os;
const io = std.io;
const warn = @import("std").debug.warn;

pub fn main() anyerror!void {
    var file = try std.fs.cwd().openFile("./input/Day01.txt", .{});
    defer file.close();

    var buf_reader = io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    const stdout = std.io.getStdOut().writer();

    var increases: i64 = 0;

    var previous: ?i64 = null;

    var buf: [1024]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const i = try std.fmt.parseInt(i64, line, 10);

        if (previous != null and i > previous.?) {
            increases += 1;
        }

        previous = i;
    }

    _ = try stdout.print("Part 1 {}\n", .{increases});
}
