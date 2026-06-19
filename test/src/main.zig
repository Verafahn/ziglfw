const std = @import("std");
const glfw = @import("zglfw");

pub fn main(init: std.process.Init) !void {
    try glfw.init(init.gpa, .{});
    defer glfw.deinit();

    var window = try glfw.Window.create(1600, 900, "Demo", .{});
    defer window.destroy();

    while (!window.shouldClose()) {
        window.swapBuffer();
        glfw.event.poll();
    }
}
