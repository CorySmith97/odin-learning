package main

import rl "vendor:raylib"

tile_types : map[string]Tile

Tile :: struct {
    // Grid position
	pos:     rl.Vector2,
	texture: rl.Texture2D,
}

tile_draw :: proc(t: Tile){
    gx := i32(t.pos.x)
    gy := i32(t.pos.y)

    halfw := i32(TILE_WIDTH / 2)
    halfh := i32(TILE_HEIGHT / 2)

    worldx := (gx - gy) * halfw
    worldy := (gx + gy) * halfh

    rl.DrawTexture(t.texture, worldx, worldy, rl.WHITE)
}

