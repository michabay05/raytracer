const std = @import("std");
const dp = std.debug.print;
const assert = std.debug.assert;

const sdl = @cImport({
    @cInclude("SDL.h");
});

fn sdl_panic() noreturn {
    const str = @as(?[*:0]const u8, sdl.SDL_GetError()) orelse "unknown error";
    @panic(std.mem.sliceTo(str, 0));
}

pub fn main() void {
    if (sdl.SDL_Init(sdl.SDL_INIT_EVERYTHING) < 0) {
        sdl_panic();
    }
    defer sdl.SDL_Quit();

    var window = sdl.SDL_CreateWindow("Zig - SDL probe", sdl.SDL_WINDOWPOS_UNDEFINED, sdl.SDL_WINDOWPOS_UNDEFINED, 800, 600, 0) orelse sdl_panic();
    defer _ = sdl.SDL_DestroyWindow(window);

    var renderer = sdl.SDL_CreateRenderer(window, -1, sdl.SDL_RENDERER_ACCELERATED) orelse sdl_panic();
    defer _ = sdl.SDL_DestroyRenderer(renderer);

    main_loop: while (true) {
        // ================= UPDATE PHASE
        var event: sdl.SDL_Event = undefined;
        while (sdl.SDL_PollEvent(&event) != 0) {
            switch (event.type) {
                sdl.SDL_QUIT => break :main_loop,
                else => {},
            }
        }
        // ================= RENDER PHASE
        // Clear background
        _ = sdl.SDL_SetRenderDrawColor(renderer, 30, 30, 30, 255);
        _ = sdl.SDL_RenderClear(renderer);
        // Draw light blue rectangle
        _ = sdl.SDL_SetRenderDrawColor(renderer, 62, 94, 237, 255);
        _ = sdl.SDL_RenderDrawRect(renderer, &sdl.SDL_Rect{
            .x = 100,
            .y = 100,
            .w = 100,
            .h = 100,
        });

        // Present render
        sdl.SDL_RenderPresent(renderer);
    }
}
