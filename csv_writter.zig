const std = @import("std");

pub fn csvWritter(fileName: []const u8) !void {
    var cwd = try std.fs.cwd().openDir(".", .{ .iterate = true });
    defer cwd.close();

    const file = try cwd.createFile(fileName, .{ .read = true });
    const testCSV = "letter,number\na,1\nb,2";

    try file.writeAll(testCSV);
    defer file.close();
}
