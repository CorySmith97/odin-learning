#+feature dynamic-literals
package main

import rl"vendor:raylib"
import "core:strings"

textures: map[string]rl.Texture2D

load_texture :: proc(path: string) -> rl.Texture2D {
    if t, t_ok := textures[path]; t_ok {
        return t
    }

    t := rl.LoadTexture(strings.clone_to_cstring(path, context.temp_allocator))

    if t.id != 0 {
        textures[path] = t
    }

    return t
}
