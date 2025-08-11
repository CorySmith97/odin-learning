package main

import rl"vendor:raylib"
import "core:math"

Scene :: struct {
    camera: rl.Camera2D,
    tiles: [dynamic]Tile,
    entities: [dynamic]Entity,
}

scene_draw :: proc(s: ^Scene) {
    for i in s.tiles {
        tile_draw(i)
    }
    for i in s.entities {
        entity_draw(i)
    }
}

scene_serialize :: proc(s: Scene) {
}

mouse_to_world :: proc(cam: rl.Camera2D) -> rl.Vector2 {
    ms := rl.GetMousePosition();
    ws := rl.GetScreenToWorld2D(ms, cam);

    halfW := TILE_WIDTH  * 0.5
    halfH := TILE_HEIGHT * 0.5

    a := ws.x / f32(halfW)
    b := ws.y / f32(halfH)

    rawX := (a + b) * 0.5 - 1.0
    rawY := (b - a) * 0.5

    gx := rawX;
    gy := rawY;

    return { math.floor(f32(gx)), math.floor(f32(gy)) }
}


scene_mouse_collision :: proc(s: Scene) {
    mouse_to_world(s.camera)

    for tile in s.tiles {
    }
}
