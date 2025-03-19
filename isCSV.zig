const std = @import("std");

fn parseCSVRows(csvData: []const u8) ![]?[]const u8 {
    const allocator = std.heap.page_allocator;

    var rows = std.ArrayList(?[]const u8).init(allocator);
    rows.deinit();

    var counter: usize = 0;

    for (csvData, 0..) |v, i| {
        if (v == '\n') {
            try rows.append(csvData[counter..i]);
            counter = i + 1;
        } else if (i == csvData.len - 1) {
            try rows.append(csvData[counter..]);
        }
    }

    return rows.toOwnedSlice();
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

    _ = try parseCSVRows(buffer);

    return true;
}
