package main

import rl"vendor:raylib"

Entity :: struct {
    selected: bool,
    // Grid space
    pos: rl.Vector2,
    rotation: f32,
    texture: rl.Texture2D,
}

entity_draw :: proc(e: Entity) {
    rl.DrawTextureV(e.texture, e.pos, rl.WHITE);
}
