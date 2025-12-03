/// @description Draw settings UI

draw_set_color(c_white);

// Draw title (large, centered)
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_text_transformed(room_width / 2, title_y, "Settings", 2, 2, 0);

// Draw volume label and percentage
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_text(room_width / 2, volume_y - 30, "Volume: " + string(volume_level) + "%");

// Draw volume slider background
var slider_left = slider_x - slider_width / 2;
var slider_top = volume_y - slider_height / 2;
var slider_right = slider_x + slider_width / 2;
var slider_bottom = volume_y + slider_height / 2;

draw_rectangle(slider_left, slider_top, slider_right, slider_bottom, true);

// Draw slider knob
var knob_pos = slider_left + (volume_level / 100) * slider_width;
draw_rectangle(knob_pos - slider_knob_width / 2, slider_top,
               knob_pos + slider_knob_width / 2, slider_bottom, false);

// Draw fullscreen label
draw_set_halign(fa_right);
draw_set_valign(fa_middle);
draw_text(checkbox_x - checkbox_size, fullscreen_y, "Fullscreen:");

// Draw checkbox
var checkbox_left = checkbox_x - checkbox_size / 2;
var checkbox_top = fullscreen_y - checkbox_size / 2;
var checkbox_right = checkbox_x + checkbox_size / 2;
var checkbox_bottom = fullscreen_y + checkbox_size / 2;

draw_rectangle(checkbox_left, checkbox_top, checkbox_right, checkbox_bottom, true);

// Draw checkmark if fullscreen is enabled
if (fullscreen) {
    // Draw an X inside the checkbox
    draw_line(checkbox_left + 4, checkbox_top + 4, checkbox_right - 4, checkbox_bottom - 4);
    draw_line(checkbox_right - 4, checkbox_top + 4, checkbox_left + 4, checkbox_bottom - 4);
}

// Reset draw settings
draw_set_halign(fa_left);
draw_set_valign(fa_top);
