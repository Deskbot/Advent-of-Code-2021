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

    var buf: [1024]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const i = std.fmt.parseInt(i64, line, 10);

        _ = try stdout.print("{}", .{i});
        _ = try stdout.write("\n");
    }

    std.log.info("All your codebase are belong to us.", .{});
}
