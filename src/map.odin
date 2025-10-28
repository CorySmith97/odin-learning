package main

import rl"vendor:raylib"

Floor_Condition :: enum {
    walk,
    blocked,
}

Map :: struct {
    width: u32,
    height: u32,
    texture_layers: [dynamic]Texture,
    walk_grid: [dynamic]Floor_Condition,
    entities: [dynamic]Entity,
    party: Party,
}

draw_map :: proc(m: ^Map) {
    for tlayer in m.texture_layers {
        rl.DrawTextureV(tlayer.rltex, tlayer.pos, rl.WHITE)
    }
    for ent in m.entities {
        draw_entity(ent)
    }

    // Always render party on top
    for ent in m.party.entities {
        draw_entity(ent)
    }
}
