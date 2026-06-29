# vfglfw

vfglfw is a Zig-style wrapper for the GLFW library. It offers a more convenient API compared to directly using the C headers. This library wraps all 120 default GLFW APIs (without enabling feature macros), allows you to replace GLFW's memory allocator with your own implementation, and provides an easier way to handle window events.

```zig
const std = @import("std");
const glfw = @import("vfglfw");
const Event = glfw.Handle.Event;

// Customize window event handling functions.
pub fn handle(_: *anyopaque, event: Event) void {
    switch (event) {
        .cursor_pos => |info| {
            const x, const y = .{ info.x, info.y };
            std.debug.print("Pos({}, {})\n", .{ x, y });
        },
        else => {
            std.debug.print("{any}\n", .{event});
        },
    }
}

pub fn main(init: std.process.Init) !void {
    // Replace GLFW default allocator with `init.gpa`.
    try glfw.init(init.gpa, .{});
    defer glfw.deinit();

    var window = try glfw.Window.create(1600, 900, "Demo", .{});
    defer window.destroy();
    // Set `Handle` instance and the types of events to be handled.
    window.setHandle(.{
        .vptr = undefined,
        .vtable = .{ .handle = &handle },
    }, .{
        .cursor_pos = true,
        .pos = true,
    });

    // Event loop.
    while (!window.shouldClose()) {
        window.swapBuffer();
        glfw.event.poll();
    }
}
```

## Usage

Add `vfglfw` to your `build.zig.zon`:

```
zig fetch git+https://github.com/Verafahn/vfglfw --save
```

Then add the following to your `build.zig`:

```zig
const vfglfw = b.dependency("vfglfw", .{
    .target = target,
    .optimize = optimize,
});
...
    .imports = &.{
        .{ .name = "vfglfw", .module = vfglfw.module("vfglfw") },
    },
...
```

Now you can import it like the standard library:

```zig
const glfw = @import("vfglfw");
```

## Notes

vfglfw does not bundle any GLFW implementation. You are free to choose how to provide GLFW – whether by building from source, using official pre‑compiled binaries, or integrating a library like [glfw.zig](https://github.com/tiawl/glfw.zig).

## License

This repository is licensed under the MIT License.