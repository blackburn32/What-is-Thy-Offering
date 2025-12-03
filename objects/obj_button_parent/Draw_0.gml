/// @description Draw button

// Set colors based on hover state
var bg_color = is_hovered ? c_white : c_black;
var border_color = c_white;
var text_color = is_hovered ? c_black : c_white;

// Draw button background
draw_set_color(bg_color);
draw_rectangle(x - button_width/2, y - button_height/2,
               x + button_width/2, y + button_height/2, false);

// Draw button border
draw_set_color(border_color);
draw_rectangle(x - button_width/2, y - button_height/2,
               x + button_width/2, y + button_height/2, true);

// Draw button text
draw_set_color(text_color);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(x, y, button_text);

// Reset draw settings
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
