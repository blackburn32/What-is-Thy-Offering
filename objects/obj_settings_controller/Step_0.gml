/// @description Handle user input

// Volume slider interaction
var slider_left = slider_x - slider_width / 2;
var slider_right = slider_x + slider_width / 2;
var slider_top = volume_y - slider_height / 2;
var slider_bottom = volume_y + slider_height / 2;

var mouse_on_slider = point_in_rectangle(mouse_x, mouse_y,
    slider_left, slider_top, slider_right, slider_bottom);

// Start dragging slider
if (mouse_on_slider && mouse_check_button_pressed(mb_left)) {
    slider_dragging = true;
}

// Stop dragging slider
if (mouse_check_button_released(mb_left)) {
    slider_dragging = false;
}

// Update volume while dragging
if (slider_dragging) {
    var slider_pos = clamp((mouse_x - slider_left) / slider_width, 0, 1);
    volume_level = round(slider_pos * 100);
    audio_master_gain(volume_level / 100);
}

// Fullscreen checkbox interaction
var checkbox_left = checkbox_x - checkbox_size / 2;
var checkbox_right = checkbox_x + checkbox_size / 2;
var checkbox_top = fullscreen_y - checkbox_size / 2;
var checkbox_bottom = fullscreen_y + checkbox_size / 2;

var mouse_on_checkbox = point_in_rectangle(mouse_x, mouse_y,
    checkbox_left, checkbox_top, checkbox_right, checkbox_bottom);

if (mouse_on_checkbox && mouse_check_button_pressed(mb_left)) {
    fullscreen = !fullscreen;
    window_set_fullscreen(fullscreen);
}
