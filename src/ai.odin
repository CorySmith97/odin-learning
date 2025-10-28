#+feature dynamic-literals
package main

// AI is a series of state machines basically

AI :: struct {
    states: map[string]proc(^Entity)
}

global_ai_list := map[string]AI {
}
