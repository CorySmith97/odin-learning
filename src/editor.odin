package main

import rl"vendor:raylib"
import mui"vendor:microui"
import "core:fmt"
import "core:os"

editor_state := struct {
    tile_selected: bool,
    selected_tile: ^Tile,
}{}

editor_draw :: proc(s: ^Scene) {
    // Main menu
    if mui.window(&ui_state.ctx, "Main menu", {0, 0, rl.GetScreenWidth(), 30}, {.NO_TITLE, .NO_RESIZE}) {
        if .SUBMIT in mui.button(&ui_state.ctx, "File") {
        }
    }

    if mui.window(&ui_state.ctx, "App Info", {10, 80, 200, 200}, {}) {
        if .ACTIVE in mui.header(&ui_state.ctx, "Mouse State") {
            mouse_world_pos := mouse_to_world(s.camera)
            mui.text(&ui_state.ctx, fmt.tprint("Grid Space\n", mouse_world_pos.x, mouse_world_pos.y))
        }

        if .ACTIVE in mui.header(&ui_state.ctx, "Scene") {
            mui.text(&ui_state.ctx, fmt.tprint("This is scene info"))
        }
    }
}

editor_init :: proc () {
        tile_dir, tile_ok := os.open("assets/tiles")
        if tile_ok != nil {
            panic("Failed to open assets dir")
        }
        rl.ChangeDirectory("assets/tiles")
        tiles, _ := os.read_dir(tile_dir, 0)
        for file in tiles {
            load_texture(file.name)
        }
        fmt.printf("texture count: %d\n", len(textures))
        assets_dir, ok := os.open("../entities")
        if ok != nil {
            panic("Failed to open assets dir")
        }
        rl.ChangeDirectory("../entities")
        entities, _ := os.read_dir(assets_dir, 0)
        for file in entities {
            load_texture(file.name)
        }
}

editor_draw_available_textures :: proc(rec: rl.Rectangle) {
    rl.DrawRectangleRec(rec, PALETTE_BASE_2)
}
