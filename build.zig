const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const glfw3 = b.addTranslateC(.{
        .root_source_file = b.path("include/c.h"),
        .optimize = optimize,
        .target = target,
    });
    // Generate rename bind.
    const mod = b.createModule(.{
        .root_source_file = b.path("bin/glfw_gen.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "glfw3.c", .module = glfw3.createModule() },
        },
    });
    mod.addIncludePath(b.path("include/"));
    const gen = b.addExecutable(.{
        .name = "glfw_gen",
        .root_module = mod,
    });

    // Run rename program.
    const run_gen = b.addRunArtifact(gen);
    const step = b.step("gen", "Generator GLFW Warpper");
    step.dependOn(&run_gen.step);

    // Export module 'zglfw'.
    const zglfw = b.addModule("zglfw", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "glfw3.c", .module = glfw3.createModule() },
        },
    });
    _ = zglfw;
}
