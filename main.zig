const std = @import("std");

fn isCSV(cwd: std.fs.Dir, filename: []const u8) bool {
    const fileContent = cwd.readFileAlloc(std.heap.page_allocator, filename, 1024);
    std.debug.print("Файл {s} содержит следущее:\n{!s}\n", .{ filename, fileContent });
    return true;
}

pub fn main() !void {
    var cwd = try std.fs.cwd().openDir(".", .{ .iterate = true });
    defer cwd.close();

    const file = try cwd.createFile("test.csv", .{ .read = true });
    const testCSV = "letter,number\na,1\nb,2";

    try file.writeAll(testCSV);
    defer file.close();

    var iter = cwd.iterate();
    const extension = ".csv";

    var CSVFound = false;

    while (try iter.next()) |entry| {
        if (entry.kind == .file and std.mem.endsWith(u8, entry.name, extension)) {
            CSVFound = true;

            const isSCV = isCSV(cwd, entry.name);
            _ = isSCV;
        }
    }

    if (!CSVFound) {
        std.debug.print("Не найден ни один CSV-файл", .{});
    } else {
        std.debug.print("CSV-файл найден", .{});
    }

    // std.debug.print("{any}", .{metaData});
    // const stdIn = std.io.getStdIn().reader();

    // const text = try stdIn.readUntilDelimiterAlloc(std.heap.page_allocator, '\n', 8192);
}
