/// @description Handle scrolling and input

// Get the player state instance
var player = obj_player_state;

// Handle mouse wheel scrolling for powers list
if (mouse_x < sidebar_width && mouse_y >= powers_start_y) {
    var wheel = mouse_wheel_down() - mouse_wheel_up();
    if (wheel != 0) {
        powers_scroll_target += wheel * powers_item_height * 2;

        // Clamp scroll target
        var total_powers_height = array_length(player.owned_powers) * powers_item_height;
        var max_scroll = max(0, total_powers_height - powers_list_height);
        powers_scroll_target = clamp(powers_scroll_target, 0, max_scroll);
    }
}

// Smooth lerp to target scroll position
powers_scroll_offset = lerp(powers_scroll_offset, powers_scroll_target, 0.2);
