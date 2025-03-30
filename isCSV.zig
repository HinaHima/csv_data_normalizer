const std = @import("std");

fn getRows(csvData: []const u8) ![][]const u8 {
    const allocator = std.heap.page_allocator;

    var rows = std.ArrayList([]const u8).init(allocator);
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

fn findCellphoneColumn(rows: [][]const u8) !bool {
    var columnNumber: u8 = 0;

    for (rows, 0..) |value, i| {
        if (i == 0) {
            const columnName = [_]u8{ 112, 104, 111, 110, 101 };
            const startIndex = 0;

            if (value[startIndex .. startIndex + 5] == columnName) {
                std.debug.print("{any}", .{"true"});
            }

            for (value, 0..) |symb, si| {
                if (symb == 44) {
                    columnNumber += 1;
                    startIndex = si + 1;
                } else {}
            }
        }
    }

    return true;
}

pub fn parseCSV(fileName: []const u8) !bool {
    const allocator = std.heap.page_allocator;

    const file = try std.fs.cwd().openFile(fileName, .{});
    defer file.close();

    const fileStat = try file.stat();
    const fileSize = fileStat.size;

    const buffer = try allocator.alloc(u8, fileSize);
    defer allocator.free(buffer);

    _ = try file.readAll(buffer);

    const rows = try getRows(buffer);

    _ = try findCellphoneColumn(rows);
    // std.debug.print("{any}", .{","});

    return true;
}
