const std = @import("std");
const glfw = @import("vfglfw");

pub fn main(init: std.process.Init) !void {
    try glfw.init(init.gpa, .{});
    defer glfw.deinit();

    var window = try glfw.Window.create(1600, 900, "Demo", .{});
    defer window.destroy();
    window.makeContextCurrent();

    while (!window.shouldClose()) {
        window.swapBuffer();
        glfw.event.poll();
    }
}
