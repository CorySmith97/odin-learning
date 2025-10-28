package main

import rl"vendor:raylib"
import "core:math"

SelectorGreen :: rl.Color{0, 255, 0, 100}

Formation :: struct {
    grid: [10 * 10]u8,
}

Party :: struct {
    main_target: rl.Vector2,
    rotation: f32,
    leader: u32,
    entities: [dynamic]Entity,
    formation: Formation,
    start_select: bool,
    selector_start: rl.Vector2,
}

// This should update party member target positions based off the main target
update_party :: proc(using p: ^Party, camera: rl.Camera2D) {
    for &ent in entities {
        update_entity(&ent)
    }
    mouse_pos := rl.GetMousePosition()
    world_space_pos := rl.GetScreenToWorld2D(mouse_pos, camera)

    if rl.IsMouseButtonPressed(.RIGHT) {
        for &ent in p.entities {
            if ent.selected {
                ent.target = world_space_pos
            }
        }
    }
    if rl.IsMouseButtonPressed(.LEFT) {
        if p.start_select != true {
            p.start_select = true
            p.selector_start = world_space_pos
        }
    }
    if rl.IsMouseButtonReleased(.LEFT) {
        min_x := min(p.selector_start.x, world_space_pos.x)
        min_y := min(p.selector_start.y, world_space_pos.y)
        max_x := max(p.selector_start.x, world_space_pos.x)
        max_y := max(p.selector_start.y, world_space_pos.y)

        computed_rec := rl.Rectangle{
            min_x,
            min_y,
            max_x - min_x,
            max_y - min_y,
        }
        for &ent in p.entities {
            if rl.CheckCollisionPointRec(ent.position, computed_rec) {
                ent.selected = true
            } else {
                ent.selected = false
            }
        }
        p.start_select = false
        p.selector_start = {}
    }

    // Update positions based off position grid
    for &ent, i in entities {
        if i == auto_cast leader {

        }
    }
}

draw_party :: proc(p: ^Party, camera: rl.Camera2D) {
    if p.start_select {
        mouse_pos := rl.GetMousePosition()
        world_space_pos := rl.GetScreenToWorld2D(mouse_pos, camera)
        rl.DrawRectangleRec({
            p.selector_start.x,
            p.selector_start.y,
            (world_space_pos.x - p.selector_start.x),
            (world_space_pos.y - p.selector_start.y),
        }, SelectorGreen)
    }
}
