const std = @import("std");

fn parseCSVRows(csvData: []const u8) !void {
    const allocator = std.heap.page_allocator;

    const rows = std.ArrayList(?[*]u8).init(allocator);
    rows.deinit();

    for (csvData, 0..) |v, i| {
        _ = v; // autofix
        _ = i; // autofix
        std.debug.print("The first row is {any}\n", .{rows.getLastOrNull()});
    }
}

pub fn isCSV(fileName: []const u8) !bool {
    const allocator = std.heap.page_allocator;

    const file = try std.fs.cwd().openFile(fileName, .{});
    defer file.close();

    const fileStat = try file.stat();
    const fileSize = fileStat.size;

    const buffer = try allocator.alloc(u8, fileSize);
    defer allocator.free(buffer);

    _ = try file.readAll(buffer);

    try parseCSVRows(buffer);

    return true;
}
