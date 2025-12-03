/// @description Check mouse position and clicks

// Check if mouse is within button bounds
var mouse_over = point_in_rectangle(mouse_x, mouse_y,
                                     x - button_width/2, y - button_height/2,
                                     x + button_width/2, y + button_height/2);

// Update hover state
is_hovered = mouse_over;

// Check for click
if (mouse_over && mouse_check_button_pressed(mb_left)) {
    // Change room when clicked
    if (target_room != -1) {
        room_goto(target_room);
    }
}
