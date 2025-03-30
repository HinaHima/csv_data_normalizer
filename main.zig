const std = @import("std");
const csvWritter = @import("csv_writter.zig").csvWritter;
const parseCSV = @import("isCSV.zig").parseCSV;

// fn isCSV(cwd: std.fs.Dir, filename: []const u8) bool {
//     const fileContent = cwd.readFileAlloc(std.heap.page_allocator, filename, 1024);
//     defer fileContent.close();
//     defer std.heap.page_allocator.free(fileContent);

//     var gpa = std.heap.GeneralPurposeAllocator(.{}){};
//     const allocator = gpa.allocator();

//     var list = std.ArrayList(u8).init(allocator);
//     defer list.deinit();

//     try list.appendSlice(fileContent);

//     // std.debug.print("Файл {s} содержит следущее:\n{!s}\n", .{ filename, fileContent });
//     std.debug.print("File Content: {s}\n", .{list.items});
//     return true;
// }

pub fn main() !void {
    const fileName = "test.csv";

    const writeCsv = try csvWritter(fileName);
    _ = writeCsv; // autofix
    const ensureCSV = try parseCSV(fileName);
    _ = ensureCSV; // autofix

    // var iter = cwd.iterate();
    // const extension = ".csv";

    // var CSVFound = false;

    // while (try iter.next()) |entry| {
    //     if (entry.kind == .file and std.mem.endsWith(u8, entry.name, extension)) {
    //         CSVFound = true;

    //         const isSCV = isCSV(cwd, entry.name);
    //         _ = isSCV;
    //     }
    // }

    // if (!CSVFound) {
    //     std.debug.print("Не найден ни один CSV-файл", .{});
    // } else {
    //     std.debug.print("CSV-файл найден", .{});
    // }

    // std.debug.print("{any}", .{metaData});
    // const stdIn = std.io.getStdIn().reader();

    // const text = try stdIn.readUntilDelimiterAlloc(std.heap.page_allocator, '\n', 8192);
}
