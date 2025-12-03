/// @description Draw image frame

// Draw frame border (white rectangle outline)
draw_set_color(c_white);
draw_rectangle(x - frame_width/2, y - frame_height/2,
               x + frame_width/2, y + frame_height/2, true);

// Draw a placeholder text
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(x, y, "Image placeholder\n(4:3 aspect ratio)");

// Reset draw settings
draw_set_halign(fa_left);
draw_set_valign(fa_top);
