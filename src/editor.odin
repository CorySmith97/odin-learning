package main

import rl"vendor:raylib"
import mui"vendor:microui"
import "core:fmt"
import "core:os"

@(private="file")
editor_state := struct {
    current_console_index: i32,
    console_buf: [dynamic]string,
    console_input_len: int,
    console_open: bool,
    main_editor_open: bool,
    brush_active: bool,
    brush: Brush,
}{}

Brush_Type :: enum {
    erase,
    zoning,
}

Brush :: struct {
    type: Brush_Type,
    size: u32,
    position: rl.Vector2,
    active: bool,
}

editor_setup :: proc() {
    editor_state.current_console_index = 0
    editor_state.console_buf = make([dynamic]string)
}

editor_draw :: proc(gs: ^Game_State) {
    if rl.IsKeyPressed(.GRAVE) {
        editor_state.console_open = !editor_state.console_open
    }

    if mui.window(&ui_state.ctx, "Editor", {20, 40, 200, 200}) {
        mui.label(&ui_state.ctx, "Test label")
        mui.text(&ui_state.ctx, fmt.tprint("FPS: ", gs.delta * 1000 * 60))
        if .ACTIVE in mui.header(&ui_state.ctx, "Brush") {
            mui.checkbox(&ui_state.ctx, "Brush Active", &editor_state.brush_active)
            if mui.popup(&ui_state.ctx, "Brush Type") {
                mui.label(&ui_state.ctx, "YUM")
            }

            if .ACTIVE in mui.button(&ui_state.ctx, "Type") {
                mui.open_popup(&ui_state.ctx, "Brush Type")
            }
        }
    }

    if editor_state.console_open {
        if mui.window(&ui_state.ctx, "Console", {10, 10, 200, 300}) {
            // @todo:cs Add console
        }
    }

}

editor_draw_map_grid :: proc(using gs: ^Game_State, m: ^Map) {
    x: f32 = 0
    y: f32 = 0
    for &floor in m.walk_grid {
        switch (floor) {
        case .walk: {
            rl.DrawRectangleRec({x, y, GRID_SIZE, GRID_SIZE}, OPAQUE_GREEN)
            rl.DrawRectangleLinesEx({x, y, GRID_SIZE, GRID_SIZE}, 2, rl.BLACK)
        };
        case .blocked: {
            rl.DrawRectangleRec({x, y, GRID_SIZE, GRID_SIZE}, OPAQUE_RED)
            rl.DrawRectangleLinesEx({x, y, GRID_SIZE, GRID_SIZE}, 2, rl.BLACK)
        };
        }
        x += GRID_SIZE
        if x >= auto_cast m.width * GRID_SIZE {
            x = 0
            y += GRID_SIZE
        }
    }
}
