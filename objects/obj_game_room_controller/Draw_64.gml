/// @description Draw left sidebar UI

// Get the player state instance
var player = obj_player_state;

// Reset draw state
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(NoAntiAliasing);

// === SECTION 1: AVATAR ===
var avatar_x = (sidebar_width / 2) - (avatar_size / 2);
var avatar_center_x = avatar_x + avatar_size / 2;
var avatar_center_y = avatar_y + avatar_size / 2;

// Draw avatar frame (black background, white border)
draw_set_color(c_white);
draw_rectangle(avatar_x - avatar_frame_thickness,
               avatar_y - avatar_frame_thickness,
               avatar_x + avatar_size + avatar_frame_thickness,
               avatar_y + avatar_size + avatar_frame_thickness,
               false);

draw_set_color(c_black);
draw_rectangle(avatar_x, avatar_y, avatar_x + avatar_size, avatar_y + avatar_size, false);

// Draw placeholder avatar (white square with black border)
draw_set_color(c_white);
draw_rectangle(avatar_x + 16, avatar_y + 16,
               avatar_x + avatar_size - 16, avatar_y + avatar_size - 16, false);

// Draw god name centered under avatar
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
var god = variable_global_exists("selected_god") ? global.selected_god : "Unknown God";
draw_text(avatar_center_x, avatar_y + avatar_size + 4, god.name);

// Reset alignment
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Draw divider line after avatar section
draw_set_color(c_white);
var divider_y = avatar_y + avatar_size + god_name_height + (section_padding / 2);
draw_line(sidebar_padding, divider_y, sidebar_width, divider_y);

// === SECTION 2: RESOURCES ===
var resource_x = sidebar_padding;
var current_y = resource_start_y;

// Get resource values
var resource_values = [player.faith, player.food, player.relics, player.favor];

for (var i = 0; i < 4; i++) {
    // Draw resource icon placeholder (black square with white border)
    draw_set_color(c_white);
    draw_rectangle(resource_x, current_y,
                   resource_x + resource_icon_size, current_y + resource_icon_size,
                   true);

    draw_set_color(c_black);
    draw_rectangle(resource_x + 4, current_y + 4,
                   resource_x + resource_icon_size - 4, current_y + resource_icon_size - 4,
                   false);

    // Draw resource name and value
    draw_set_color(c_white);
    draw_text(resource_x + resource_icon_size + 8, current_y,
              resource_names[i] + ": " + string(resource_values[i]));

    current_y += resource_row_height + resource_spacing;
}

// Draw divider line after resources section
draw_set_color(c_white);
var divider2_y = resource_start_y + (resource_row_height + resource_spacing) * 4;
draw_line(sidebar_padding, divider2_y, sidebar_width, divider2_y);

// === SECTION 3: POWERS LIST ===

// Draw powers section header
draw_set_color(c_white);
draw_text(sidebar_padding, powers_start_y - 16, "Powers:");

// Set up clipping region for scrollable area
var powers_x = sidebar_padding;
var powers_clip_y = powers_start_y;

// Only draw if player has powers
if (array_length(player.owned_powers) > 0) {
    // Enable scissor test for clipping
    var clip_x1 = 0;
    var clip_y1 = powers_clip_y;
    var clip_x2 = sidebar_width;
    var clip_y2 = powers_clip_y + powers_list_height;

    gpu_set_scissor(clip_x1, clip_y1, clip_x2 - clip_x1, clip_y2 - clip_y1);

    // Draw each power name
    var draw_y = powers_clip_y - powers_scroll_offset;

    for (var i = 0; i < array_length(player.owned_powers); i++) {
        var power_id = player.owned_powers[i];
        var p = get_power_by_id(power_id);

        if (p != undefined) {
            // Only draw if visible in clipped region
            if (draw_y + powers_item_height >= clip_y1 && draw_y <= clip_y2) {
                draw_set_color(c_white);
                draw_text(powers_x, draw_y, "- " + p.name);
            }
        }

        draw_y += powers_item_height;
    }

    // Disable scissor test
    gpu_set_scissor(-1, -1, -1, -1);
} else {
    // No powers yet
    draw_set_color(c_white);
    draw_text(powers_x, powers_clip_y, "(None)");
}

// Draw vertical separator line between sidebar and main area
draw_set_color(c_white);
draw_line(sidebar_width, 0, sidebar_width, room_height);

// Reset draw color
draw_set_color(c_white);
