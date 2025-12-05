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

// === EVENT INTERACTION ===

if (current_event_index < array_length(event_list)) {
    var evt = event_list[current_event_index];

    // Handle mouse wheel scrolling for options area
    if (mouse_x >= event_options_x &&
        mouse_x <= event_options_x + event_options_width &&
        mouse_y >= event_options_y &&
        mouse_y <= event_options_y + event_options_height) {

        var wheel = mouse_wheel_down() - mouse_wheel_up();
        if (wheel != 0) {
            option_scroll_target += wheel * option_height;

            // Calculate max scroll based on number of options
            var num_options = 0;
            if (current_phase == 1 && evt.type == "decision") {
                num_options = array_length(evt.options);
            } else {
                num_options = 1; // Just the continue button
            }

            var total_options_height = num_options * (option_height + option_padding);
            var max_scroll = max(0, total_options_height - event_options_height);
            option_scroll_target = clamp(option_scroll_target, 0, max_scroll);
        }
    }

    // Smooth lerp to target scroll position
    option_scroll_offset = lerp(option_scroll_offset, option_scroll_target, 0.2);

    // Check for hover on options
    hovered_option_index = -1;

    if (mouse_x >= event_options_x &&
        mouse_x <= event_options_x + event_options_width &&
        mouse_y >= event_options_y &&
        mouse_y <= event_options_y + event_options_height) {

        var check_y = event_options_y - option_scroll_offset;

        if (current_phase == 1 && evt.type == "decision") {
            // Check each decision option
            for (var i = 0; i < array_length(evt.options); i++) {
                if (mouse_y >= check_y &&
                    mouse_y <= check_y + option_height) {
                    hovered_option_index = i;
                    break;
                }
                check_y += option_height + option_padding;
            }
        } else {
            // Check continue button
            if (mouse_y >= check_y &&
                mouse_y <= check_y + option_height) {
                hovered_option_index = 0;
            }
        }
    }

    // Handle clicks on options
    if (mouse_check_button_pressed(mb_left) && hovered_option_index != -1) {
        if (current_phase == 1) {
            // Phase 1: Select option or continue
            if (evt.type == "decision") {
                // Selected a decision option
                selected_option_index = hovered_option_index;
                selected_option = evt.options[selected_option_index];

                // Apply the outcome to player state
                player.apply_outcome(selected_option);

                // Check if game over
                if (player.is_game_over()) {
                    is_game_over = true;
                }

                // Move to phase 2
                current_phase = 2;
            } else {
                // Boon/Disaster: Apply outcome and move to phase 2
                player.apply_outcome(evt.outcome);

                // Check if game over
                if (player.is_game_over()) {
                    is_game_over = true;
                }

                current_phase = 2;
            }

            // Reset scroll for phase 2
            option_scroll_offset = 0;
            option_scroll_target = 0;

        } else {
            // Phase 2: Continue to next event or go to game over
            if (is_game_over) {
                // Game is over, go to GameOver room
                room_goto(GameOver);
            } else {
                // Continue to next event
                current_event_index++;

                // Loop back to start if we've reached the end
                if (current_event_index >= array_length(event_list)) {
                    current_event_index = 0;
                }

                // Reset for next event
                current_phase = 1;
                selected_option_index = -1;
                selected_option = undefined;
                option_scroll_offset = 0;
                option_scroll_target = 0;
            }
        }
    }
}
