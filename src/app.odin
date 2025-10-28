package main

import "core:thread"
import rl "vendor:raylib"

Game_Mode :: enum {
    player,
    editor,
}

Game_State :: struct {
    width: i32,
    height: i32,
    delta: f32,
    camera: rl.Camera2D,
}

game_run :: proc(gs: ^Game_State) {
    gs.width = DEFAULT_WIDTH
    gs.height = DEFAULT_HEIGHT
    rl.InitWindow(gs.width, gs.height, "Name")

    gs.camera = {
        target = {},
        offset = {},
        rotation = 0,
        zoom = 1.0,
    }

    test_map := Map{
        width = 10,
        height = 10,
        texture_layers = make([dynamic]Texture),
        entities = make([dynamic]Entity),
        walk_grid = make([dynamic]Floor_Condition),
        party = {entities = make([dynamic]Entity)},
    }

    append(&test_map.party.entities, Entity{position = {10, 10},texture_tint=rl.RED})

    ui_setup()
    editor_setup()
    //audio_init()

    for !rl.WindowShouldClose() {

        gs.delta = rl.GetFrameTime()
        if rl.IsKeyPressed(rl.KeyboardKey.EIGHT) {
            rl.EnableCursor()
        }
        if rl.IsKeyPressed(rl.KeyboardKey.NINE) {
            rl.DisableCursor()
        }

        if rl.IsMouseButtonDown(.MIDDLE) {
            mouse_delta := rl.GetMouseDelta()
            gs.camera.offset += mouse_delta
        }

        update_party(&test_map.party, gs.camera)

        ui_handle_input()
        ui_new_frame()
        editor_draw(gs)
        ui_end_frame()

        rl.BeginDrawing()
        rl.ClearBackground(rl.RAYWHITE)
        rl.BeginMode2D(gs.camera)

        draw_map(&test_map)
        draw_party(&test_map.party, gs.camera)
        rl.EndMode2D()
        ui_render()
        rl.EndDrawing()
    }
}
