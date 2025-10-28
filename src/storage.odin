#+feature dynamic-literals
package main

import rl"vendor:raylib"
import "core:strings"

Texture :: struct {
    rltex: rl.Texture2D,
    pos  : rl.Vector2,
}

textures: map[string]rl.Texture2D
models: map[string]rl.Model

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

load_model :: proc(path: string) -> rl.Model {
    if t, t_ok := models[path]; t_ok {
        return t
    }

    t := rl.LoadModel(strings.clone_to_cstring(path, context.temp_allocator))

    models[path] = t

    return t
}
