/// @description Initialize global game settings

// Define custom color palette
// #CAC0B7 (light beige) for white
// #161616 (dark gray) for black
global.color_white = make_color_rgb(202, 192, 183);
global.color_black = make_color_rgb(22, 22, 22);

// Disable texture filtering globally for crisp 1-bit rendering
gpu_set_texfilter(false);

// Disable interpolation on the application surface
surface_resize(application_surface, room_width, room_height);
application_surface_draw_enable(true);

// Set the global font to NoAntiAliasing for crisp 1-bit text
draw_set_font(NoAntiAliasing);
