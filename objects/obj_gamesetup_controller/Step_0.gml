/// @description Handle scrolling and button clicks

// Smooth scrolling (only when not dragging)
if (!is_dragging) {
    scroll_offset = lerp(scroll_offset, target_scroll, 0.2);
}

// Mouse wheel scrolling
if (mouse_wheel_down()) {
    target_scroll = min(target_scroll + scroll_speed * 5, max_scroll);
    is_dragging = false; // Cancel drag if scrolling with wheel
}
if (mouse_wheel_up()) {
    target_scroll = max(target_scroll - scroll_speed * 5, 0);
    is_dragging = false; // Cancel drag if scrolling with wheel
}

// Check if mouse is over a button
var mouse_over_button = false;
var start_x = (room_width - total_width) / 2 + card_spacing - scroll_offset;

for (var i = 0; i < array_length(gods); i++) {
    var card_x = start_x + i * (card_width + card_spacing);
    var button_x = card_x + card_width / 2;
    var button_y = gods_y + card_height - 60;

    if (point_in_rectangle(mouse_x, mouse_y,
        button_x - button_width / 2, button_y - button_height / 2,
        button_x + button_width / 2, button_y + button_height / 2)) {
        mouse_over_button = true;
        break;
    }
}

// Start dragging (only if not over a button)
if (mouse_check_button_pressed(mb_left) && !mouse_over_button) {
    is_dragging = true;
    drag_start_x = mouse_x;
    drag_start_scroll = target_scroll;
}

// Update drag
if (is_dragging && mouse_check_button(mb_left)) {
    var drag_delta = drag_start_x - mouse_x;
    target_scroll = clamp(drag_start_scroll + drag_delta, 0, max_scroll);
    scroll_offset = target_scroll; // Immediate update while dragging
}

// Stop dragging
if (mouse_check_button_released(mb_left)) {
    // If we just released and were over a button (and didn't drag far), trigger button click
    if (!is_dragging || abs(mouse_x - drag_start_x) < 5) {
        for (var i = 0; i < array_length(gods); i++) {
            var card_x = start_x + i * (card_width + card_spacing);
            var button_x = card_x + card_width / 2;
            var button_y = gods_y + card_height - 60;

            var mouse_on_button = point_in_rectangle(mouse_x, mouse_y,
                button_x - button_width / 2, button_y - button_height / 2,
                button_x + button_width / 2, button_y + button_height / 2);

            if (mouse_on_button) {
                // Store selected god (could be used in Game room)
                global.selected_god = gods[i];
                room_goto(Game);
                break;
            }
        }
    }
    is_dragging = false;
}

// Clamp scroll
target_scroll = clamp(target_scroll, 0, max_scroll);
