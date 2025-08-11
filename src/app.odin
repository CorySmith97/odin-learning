package main

import rl "vendor:raylib"
import "core:prof/spall"

App_Mode :: enum {
	editor,
	game,
}

App :: struct {
	tick_delta: f64,
	mode:       App_Mode,
	scene:      Scene,
}

app_init :: proc(app: ^App) {
	app^ = {
		tick_delta = 0,
	}

    n := Node{
        pos = {10, 10},
        color = rl.BLUE,
    }
	rl.InitWindow(1200, 720, "RPG")
	rl.SetTargetFPS(60)

    s: Scene
    s.tiles = make([dynamic]Tile)
    s.camera = rl.Camera2D {
        offset = {f32(rl.GetScreenWidth()/2), f32(rl.GetScreenHeight()/2)},
        target = {},
        rotation = 0.0,
        zoom = 1.0
    }

    //editor_init()

    for i in 0..<100 {
        append(&s.tiles, Tile{
            pos = {f32(i % 10), f32(i / 10)},
            texture = load_texture("tile_001.png")
        })
    }

    ui_setup()

	for !rl.WindowShouldClose() {
        if rl.IsKeyPressed(rl.KeyboardKey.EIGHT) {
            app.mode = .game
        }
        if rl.IsKeyPressed(rl.KeyboardKey.NINE) {
            app.mode = .editor
        }
        camera_movement(&s.camera)

        // UI Handling/ prep
        ui_handle_input()
        ui_new_frame()
        if app.mode == .editor {
            editor_draw(&s)
        }
        ui_end_frame()

        // Drawing
		rl.ClearBackground(PALETTE_BASE_1)
		rl.BeginDrawing()
        rl.BeginMode2D(s.camera)
        scene_draw(&s)
        rl.EndMode2D()
        //editor_draw_available_textures(rl.Rectangle{30, 100, 200, 300})
        ui_render()
		rl.EndDrawing()
	}
}

camera_movement :: proc(camera: ^rl.Camera2D) {
    if rl.IsKeyDown(rl.KeyboardKey.UP) {
        camera.target.y -= 5.0
    }
    if rl.IsKeyDown(rl.KeyboardKey.DOWN) {
        camera.target.y += 5.0
    }
    if rl.IsKeyDown(rl.KeyboardKey.LEFT) {
        camera.target.x -= 5.0
    }
    if rl.IsKeyDown(rl.KeyboardKey.RIGHT) {
        camera.target.x += 5.0
    }

    if rl.IsMouseButtonDown(rl.MouseButton.MIDDLE) {
        delta := rl.GetMouseDelta()
        camera.offset += delta
    }

    mouse_wheel := rl.GetMouseWheelMove()
    if mouse_wheel != 0 {
        // Apply zoom change first
        camera.zoom += CAMERA_MOVEMENT_SPEED * mouse_wheel

        // Clamp to a minimum zoom
        if camera.zoom < 0.1 {
            camera.zoom = 0.1
        }
    }
}
