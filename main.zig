const std = @import("std");

pub fn main() !void {
    var cwd = try std.fs.cwd().openDir(".", .{ .iterate = true });
    defer cwd.close();

    const file = try cwd.createFile("test.txt", .{ .read = true });
    try file.writeAll("Проверка");
    defer file.close();

    var iter = cwd.iterate();
    const extension = ".txt";

    while (try iter.next()) |entry| {
        if (entry.kind == .file and std.mem.endsWith(u8, entry.name, extension)) {
            std.debug.print("Имя: {s}, Тип: {}\n", .{ entry.name, entry.kind });

            const fileContent = cwd.readFileAlloc(std.heap.page_allocator, entry.name, 1024);
            std.debug.print("Файл {s} содержит следущее:\n {!s}\n", .{ entry.name, fileContent });
        }
    }

    // std.debug.print("{any}", .{metaData});
    // const stdIn = std.io.getStdIn().reader();

    // const text = try stdIn.readUntilDelimiterAlloc(std.heap.page_allocator, '\n', 8192);
}
