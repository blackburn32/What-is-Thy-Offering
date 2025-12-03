/// @description Initialize global game settings

// Disable texture filtering globally for crisp 1-bit rendering
gpu_set_texfilter(false);

// Disable interpolation on the application surface
surface_resize(application_surface, room_width, room_height);
application_surface_draw_enable(true);

// Set the global font to NoAntiAliasing for crisp 1-bit text
draw_set_font(NoAntiAliasing);
