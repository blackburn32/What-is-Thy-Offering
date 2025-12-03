/// @description Draw about screen

draw_set_color(c_white);

// Draw title (large, centered)
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_text_transformed(room_width / 2, title_y, title_text, 2, 2, 0);

// Draw body text (normal size, centered, wrapped)
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_text_ext(room_width / 2, body_y, body_text, -1, body_width);

// Reset draw settings
draw_set_halign(fa_left);
draw_set_valign(fa_top);
