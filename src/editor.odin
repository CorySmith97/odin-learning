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
        }
    }

    if editor_state.console_open {
        if mui.window(&ui_state.ctx, "Console", {10, 10, 200, 300}) {
            // @todo:cs Add console
        }
    }

}
