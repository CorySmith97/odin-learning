package main

import rl"vendor:raylib"

// None playable objects within the world. Creatures, interactable objects, ect.

Entity :: struct {
    selected     : bool,
    position     : rl.Vector2,
    target       : rl.Vector2,
    velocity     : rl.Vector2,
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

update_entity :: proc(e: ^Entity) {
    dt := rl.GetFrameTime()
    // Animation
    if e.current_frame == e.frame_count - 1 {
        e.current_frame = 0
    }
    e.current_frame += 1

    // Movement
    if e.position != e.target {
        direction := e.target - e.position
        distance := rl.Vector2Length(direction)

        // If we're close enough, snap to target
        if distance < 1.0 {
            e.position = e.target
            e.velocity = {}
        } else {
            // Normalize direction and apply speed
            speed: f32 = 100.0  // pixels per second
            direction = rl.Vector2Normalize(direction)
            e.velocity = direction * speed

            // Update position
            movement := e.velocity * dt

            // Don't overshoot the target
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
