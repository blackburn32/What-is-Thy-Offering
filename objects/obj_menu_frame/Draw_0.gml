/// @description Draw menu frame sprite and title

// Ensure proper rendering with custom colors
draw_set_color(global.color_white);

// Draw the assigned sprite
draw_self();

// Draw the game title below the frame
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(global.color_white);

// Calculate title position (below the frame)
var title_y = y + 359 + 20; // Adjust based on sprite height
draw_text_transformed(x + 318.5, title_y, "What is Thy Offering?", 2, 2, 0);

// Reset draw settings
draw_set_halign(fa_left);
draw_set_valign(fa_top);
