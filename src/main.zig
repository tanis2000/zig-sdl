const std = @import("std");
const c = @cImport({
    @cInclude("SDL.h");
});

pub fn main() anyerror!void {
    std.debug.print("Starting up...\n", .{});

    if (c.SDL_Init(c.SDL_INIT_VIDEO) < 0) {
        c.SDL_Log("Unable to initialize SDL: %s", c.SDL_GetError());
        return error.SDLInitializationFailed;
    }
    defer c.SDL_Quit();

    var window: *c.SDL_Window = c.SDL_CreateWindow("Test", c.SDL_WINDOWPOS_UNDEFINED, c.SDL_WINDOWPOS_UNDEFINED, 640, 480, c.SDL_WINDOW_OPENGL) orelse {
        c.SDL_Log("Unable to create window: %s", c.SDL_GetError());
        return error.SDLInitializationFailed;
    };
    defer c.SDL_DestroyWindow(window);

    mainLoop: while(true) {
        var ev: c.SDL_Event = undefined;
        while (c.SDL_PollEvent(&ev) != 0) {
            switch (ev.type) {
                c.SDL_QUIT => {
                    break :mainLoop;
                },

                else => {},
            }
        }
    }
}
