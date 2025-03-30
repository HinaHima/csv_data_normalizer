const std = @import("std");

pub fn csvWritter(fileName: []const u8) !void {
    var cwd = try std.fs.cwd().openDir(".", .{ .iterate = true });
    defer cwd.close();

    const file = try cwd.createFile(fileName, .{ .read = true });
    const testCSV = "phone,number\nabc,1\nbcb,2";

    try file.writeAll(testCSV);
    defer file.close();
}
