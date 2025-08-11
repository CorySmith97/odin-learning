package main

import rl"vendor:raylib"

Node :: struct {
    pos: rl.Vector2,
    color: rl.Color,
    audio: rl.AudioStream,
    dialog: string,
}

st_node_draw :: proc(node: ^Node) {
    rl.DrawRectangleRounded({node.pos.x, node.pos.y, 30, 10}, 12, 5, node.color);
}

EditorModes :: enum {
    node,
}

Editor :: struct {

}
