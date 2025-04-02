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

fn isCellphoneColumn(
    columnName: []const u8,
) !bool {
    const name = [_]u8{ 112, 104, 111, 110, 101 };

    for (columnName, 0..) |symb, i| {
        if (symb == name[i]) {
            continue;
        } else {
            return false;
        }
    }

    return true;
}

fn findCellphoneColumn(rows: [][]const u8) !bool {
    var columnNumber: usize = 0;

    for (rows, 0..) |value, i| {
        if (i == 0) {
            var startIndex: usize = 0;

            for (value, 0..) |symb, si| {
                if (symb == 44) {
                    columnNumber += 1;
                    startIndex = si + 1;
                } else if (try isCellphoneColumn(value[startIndex .. startIndex + 5])) {
                    columnNumber = si + 1;
                    std.debug.print("{any}", .{columnNumber});
                    break;
                }
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
