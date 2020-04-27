const std = @import("std");
usingnamespace @cImport({
    @cInclude("SDL.h");
});

pub fn main() anyerror!void {
    std.debug.warn("All your codebase are belong to us.\n", .{});
    var window: *SDL_Window = SDL_CreateWindow("Test", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, 300, 73, SDL_WINDOW_OPENGL) orelse {
        return error.SDLInitializationFailed;
    };
}
