package main

import rl"vendor:raylib"

// None playable objects within the world. Creatures, interactable objects, ect.

Entity :: struct {
    selected     : bool,
    position     : rl.Vector2,
    target       : rl.Vector2,
    velocity     : rl.Vector2,
    speed        : f32,
    textures     : [dynamic]rl.Texture2D,
    current_frame: u32,
    frame_count  : u32,
    frame_speed  : u32,
    texture_tint : rl.Color,
}


draw_entity :: proc(e: Entity) {
    if e.selected {
        rl.DrawCircleV(e.position, 5, e.texture_tint)
    } else {
        rl.DrawCircleV(e.position, 5, rl.GRAY)
    }
    //rl.DrawTextureV(e.textures[e.current_frame], e.position, e.texture_tint)
}

update_entity :: proc(using e: ^Entity) {
    dt := rl.GetFrameTime()

    // Movement code
    if e.current_frame == e.frame_count - 1 {
        e.current_frame = 0
    }
    e.current_frame += 1

    if e.position != e.target {
        direction := e.target - e.position
        distance := rl.Vector2Length(direction)

        if distance < 1.0 {
            e.position = e.target
            e.velocity = {}
        } else {
            direction = rl.Vector2Normalize(direction)
            e.velocity = direction * speed

            movement := e.velocity * dt

            if rl.Vector2Length(movement) > distance {
                e.position = e.target
                e.velocity = {}
            } else {
                e.position += movement
            }
        }
    } else {
        e.velocity = {}
    }
}
