package main

import "core:fmt"
import rl "vendor:raylib"

main :: proc() {
    gs: Game_State
    game_run(&gs)
}
