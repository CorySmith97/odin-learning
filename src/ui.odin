#+feature dynamic-literals
package main

import rl "vendor:raylib"
import "core:fmt"
import "core:unicode/utf8"
import "core:c"
import "core:math/rand"
import mui"vendor:microui"

ui_state := struct {
    ctx: mui.Context,
    log_buf:         [1<<16]byte,
    log_buf_len:     int,
    log_buf_updated: bool,
    bg: mui.Color,

    atlas_texture: rl.Texture2D,
}{
}

ui_setup :: proc() {
    ui_state.bg = transmute(mui.Color)PALETTE_BASE_2
    pixels := make([][4]u8, mui.DEFAULT_ATLAS_WIDTH*mui.DEFAULT_ATLAS_HEIGHT)
    for alpha, i in mui.default_atlas_alpha {
        pixels[i] = {0xff, 0xff, 0xff, alpha}
    }
    defer delete(pixels)

    image := rl.Image{
        data = raw_data(pixels),
        width   = mui.DEFAULT_ATLAS_WIDTH,
        height  = mui.DEFAULT_ATLAS_HEIGHT,
        mipmaps = 1,
        format  = .UNCOMPRESSED_R8G8B8A8,
    }
    ui_state.atlas_texture = rl.LoadTextureFromImage(image)
    //defer rl.UnloadTexture(ui_state.atlas_texture)

    mui.init(&ui_state.ctx)
    ui_state.ctx.text_width = mui.default_atlas_text_width
    ui_state.ctx.text_height = mui.default_atlas_text_height
}

ui_new_frame :: proc() {
    mui.begin(&ui_state.ctx)
}

ui_end_frame :: proc() {
    mui.end(&ui_state.ctx)
}

ui_handle_input :: proc() {
    ctx := &ui_state.ctx
    { // text input
        text_input: [512]byte = ---
        text_input_offset := 0
        for text_input_offset < len(text_input) {
            ch := rl.GetCharPressed()
            if ch == 0 {
                break
            }
            b, w := utf8.encode_rune(ch)
            copy(text_input[text_input_offset:], b[:w])
            text_input_offset += w
        }
        mui.input_text(ctx, string(text_input[:text_input_offset]))
    }

    // mouse coordinates
    mouse_pos := [2]i32{rl.GetMouseX(), rl.GetMouseY()}
    mui.input_mouse_move(ctx, mouse_pos.x, mouse_pos.y)
    mui.input_scroll(ctx, 0, i32(rl.GetMouseWheelMove() * -30))

    // mouse buttons
    @static buttons_to_key := [?]struct{
        rl_button: rl.MouseButton,
        mui_button: mui.Mouse,
        }{
        {.LEFT, .LEFT},
        {.RIGHT, .RIGHT},
        {.MIDDLE, .MIDDLE},
    }
    for button in buttons_to_key {
        if rl.IsMouseButtonPressed(button.rl_button) {
            mui.input_mouse_down(ctx, mouse_pos.x, mouse_pos.y, button.mui_button)
        } else if rl.IsMouseButtonReleased(button.rl_button) {
            mui.input_mouse_up(ctx, mouse_pos.x, mouse_pos.y, button.mui_button)
        }

    }
}

ui_render :: proc() {
    render_texture :: proc(rect: mui.Rect, pos: [2]i32, color: mui.Color) {
        source := rl.Rectangle{
            f32(rect.x),
            f32(rect.y),
            f32(rect.w),
            f32(rect.h),
        }
        position := rl.Vector2{f32(pos.x), f32(pos.y)}

        rl.DrawTextureRec(ui_state.atlas_texture, source, position, transmute(rl.Color)color)
    }

    rl.BeginScissorMode(0, 0, rl.GetScreenWidth(), rl.GetScreenHeight())
    defer rl.EndScissorMode()
    command_backing: ^mui.Command
    for variant in mui.next_command_iterator(&ui_state.ctx, &command_backing) {
        switch cmd in variant {
        case ^mui.Command_Text:
			pos := [2]i32{cmd.pos.x, cmd.pos.y}
			for ch in cmd.str do if ch&0xc0 != 0x80 {
				r := min(int(ch), 127)
				rect := mui.default_atlas[mui.DEFAULT_ATLAS_FONT + r]
				render_texture(rect, pos, cmd.color)
				pos.x += rect.w
			}
		case ^mui.Command_Rect:
			rl.DrawRectangle(cmd.rect.x, cmd.rect.y, cmd.rect.w, cmd.rect.h, transmute(rl.Color)cmd.color)
		case ^mui.Command_Icon:
			rect := mui.default_atlas[cmd.id]
			x := cmd.rect.x + (cmd.rect.w - rect.w)/2
			y := cmd.rect.y + (cmd.rect.h - rect.h)/2
			render_texture(rect, {x, y}, cmd.color)
		case ^mui.Command_Clip:
			rl.EndScissorMode()
			rl.BeginScissorMode(cmd.rect.x, cmd.rect.y, cmd.rect.w, cmd.rect.h)
		case ^mui.Command_Jump:
			unreachable()}
    }
}
