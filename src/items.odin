package main

import rl"vendor:raylib"

global_items := map[string]Item{
}

Item :: struct {
    usable: bool,
    item_type: Item_Types,

    weight: i32,
    damage: i32,
    speed: i32,
    scale: i32,
    texture: rl.Texture2D,
}

Item_Types :: enum {
    spear,
    sword,
    javalin,
}
