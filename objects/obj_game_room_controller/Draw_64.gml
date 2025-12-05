/// @description Draw left sidebar UI

// Get the player state instance
var player = obj_player_state;

// Reset draw state
draw_set_color(global.color_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(NoAntiAliasing);

// === SECTION 1: AVATAR ===
var avatar_x = (sidebar_width / 2) - (avatar_size / 2);
var avatar_center_x = avatar_x + avatar_size / 2;
var avatar_center_y = avatar_y + avatar_size / 2;

// Draw avatar frame (black background, white border)
draw_set_color(global.color_white);
draw_rectangle(avatar_x - avatar_frame_thickness,
               avatar_y - avatar_frame_thickness,
               avatar_x + avatar_size + avatar_frame_thickness,
               avatar_y + avatar_size + avatar_frame_thickness,
               false);

draw_set_color(global.color_black);
draw_rectangle(avatar_x, avatar_y, avatar_x + avatar_size, avatar_y + avatar_size, false);

// Draw placeholder avatar (white square with black border)
draw_set_color(global.color_white);
draw_rectangle(avatar_x + 16, avatar_y + 16,
               avatar_x + avatar_size - 16, avatar_y + avatar_size - 16, false);

// Draw god name centered under avatar
draw_set_color(global.color_white);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
var god_name = "Unknown God";
if (variable_global_exists("selected_god") && global.selected_god != undefined) {
    god_name = global.selected_god.name;
}
draw_text(avatar_center_x, avatar_y + avatar_size + 4, god_name);

// Reset alignment
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Draw divider line after avatar section
draw_set_color(global.color_white);
var divider_y = avatar_y + avatar_size + god_name_height + (section_padding / 2);
draw_line(sidebar_padding, divider_y, sidebar_width, divider_y);

// === SECTION 2: RESOURCES ===
var resource_x = sidebar_padding;
var current_y = resource_start_y;

// Get resource values (order matches resource_names: Favor, Faith, Food, Relics)
var resource_values = [player.favor, player.faith, player.food, player.relics];

for (var i = 0; i < 4; i++) {
    // Draw resource icon placeholder (black square with white border)
    draw_set_color(global.color_white);
    draw_rectangle(resource_x, current_y,
                   resource_x + resource_icon_size, current_y + resource_icon_size,
                   true);

    draw_set_color(global.color_black);
    draw_rectangle(resource_x + 4, current_y + 4,
                   resource_x + resource_icon_size - 4, current_y + resource_icon_size - 4,
                   false);

    // Draw resource name and value
    draw_set_color(global.color_white);
    draw_text(resource_x + resource_icon_size + 8, current_y,
              resource_names[i] + ": " + string(resource_values[i]));

    current_y += resource_row_height + resource_spacing;
}

// Draw divider line after resources section
draw_set_color(global.color_white);
var divider2_y = resource_start_y + (resource_row_height + resource_spacing) * 4;
draw_line(sidebar_padding, divider2_y, sidebar_width, divider2_y);

// === SECTION 3: POWERS LIST ===

// Draw powers section header
draw_set_color(global.color_white);
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
                draw_set_color(global.color_white);
                draw_text(powers_x, draw_y, "- " + p.name);
            }
        }

        draw_y += powers_item_height;
    }

    // Disable scissor test
    gpu_set_scissor(-1, -1, -1, -1);
} else {
    // No powers yet
    draw_set_color(global.color_white);
    draw_text(powers_x, powers_clip_y, "(None)");
}

// Draw vertical separator line between sidebar and main area
draw_set_color(global.color_white);
draw_line(sidebar_width, 0, sidebar_width, room_height);

// Reset draw color
draw_set_color(global.color_white);

// === MAIN CONTENT AREA: EVENT DISPLAY ===

// Get current event
if (current_event_index < array_length(event_list)) {
    var evt = event_list[current_event_index];

    // Draw event image (sprite or placeholder)
    var event_sprite = noone;

    // Determine which sprite to use based on event type
    switch(evt.type) {
        case "boon":
            event_sprite = sp_boon;
            break;
        case "disaster":
            event_sprite = sp_disaster;
            break;
        case "store":
            event_sprite = sp_store;
            break;
        case "decision":
            event_sprite = sp_decision;
            break;
        case "resource_exchange":
            event_sprite = sp_resource_exchange;
            break;
        case "offering":
            // Keep as placeholder for now
            event_sprite = noone;
            break;
    }

    if (event_sprite != noone) {
        // Draw the sprite at 2x scale
        draw_set_color(global.color_white);
        var sprite_x = event_image_x;
        var sprite_y = event_image_y;
        draw_sprite_ext(event_sprite, 0, sprite_x, sprite_y, 3, 3, 0, c_white, 1);
    } else {
        // Draw placeholder frame for offering events
        draw_set_color(global.color_white);
        draw_rectangle(event_image_x - 2, event_image_y - 2,
                       event_image_x + event_image_width + 2, event_image_y + event_image_height + 2,
                       false);
        draw_set_color(global.color_black);
        draw_rectangle(event_image_x, event_image_y,
                       event_image_x + event_image_width, event_image_y + event_image_height,
                       false);

        // Draw event type label in center of placeholder
        draw_set_color(global.color_white);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(event_image_x + event_image_width / 2,
                  event_image_y + event_image_height / 2,
                  "[" + string_upper(evt.type) + " EVENT]");

        // Reset alignment
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }

    // Draw description or outcome text
    draw_set_color(global.color_white);
    var text_y = event_desc_y;

    if (current_phase == 1) {
        // Phase 1: Show description lines
        for (var i = 0; i < array_length(evt.descriptionLines); i++) {
            draw_text_ext(event_desc_x, text_y, evt.descriptionLines[i],
                         16, event_desc_width);
            // Approximate height for each line (accounting for word wrap)
            var line_height = string_height_ext(evt.descriptionLines[i], 16, event_desc_width);
            text_y += line_height + 8;
        }
    } else {
        // Phase 2: Show outcome text
        var outcome_text = "";
        if (evt.type == "decision") {
            outcome_text = selected_option.outcome_text;
        } else {
            outcome_text = evt.outcome.text;
        }

        draw_text_ext(event_desc_x, text_y, outcome_text, 16, event_desc_width);
        text_y += string_height_ext(outcome_text, 16, event_desc_width) + 16;

        // Show resource changes
        draw_set_color(global.color_white);
        draw_text(event_desc_x, text_y, "Resource Changes:");
        text_y += 20;

        var delta = (evt.type == "decision") ? selected_option.delta : evt.outcome.delta;

        if (delta.faith != 0) {
            var plusOrMinusSign = (delta.faith > 0) ? "+" : "";
            draw_text(event_desc_x + 20, text_y, plusOrMinusSign + string(delta.faith) + " Faith");
            text_y += 18;
        }
        if (delta.food != 0) {
            var plusOrMinusSign = (delta.food > 0) ? "+" : "";
            draw_text(event_desc_x + 20, text_y, plusOrMinusSign + string(delta.food) + " Food");
            text_y += 18;
        }
        if (delta.relics != 0) {
            var plusOrMinusSign = (delta.relics > 0) ? "+" : "";
            draw_text(event_desc_x + 20, text_y, plusOrMinusSign + string(delta.relics) + " Relics");
            text_y += 18;
        }
        if (delta.favor != 0) {
            var plusOrMinusSign = (delta.favor > 0) ? "+" : "";
            draw_text(event_desc_x + 20, text_y, plusOrMinusSign + string(delta.favor) + " Favor");
            text_y += 18;
        }
    }

    // Draw divider line
    draw_set_color(global.color_white);
    draw_line(event_options_x, event_divider_y,
              event_options_x + event_options_width, event_divider_y);

    // === OPTIONS/CONTINUE BUTTONS AREA ===

    // Set up clipping for scrollable area
    var clip_x1 = event_options_x;
    var clip_y1 = event_options_y - 10;
    var clip_x2 = event_options_x + event_options_width;
    var clip_y2 = event_options_y + event_options_height;

    gpu_set_scissor(clip_x1, clip_y1, clip_x2 - clip_x1, clip_y2 - clip_y1);

    var draw_y = event_options_y - option_scroll_offset;

    if (current_phase == 1) {
        // Phase 1: Show options or continue button
        if (evt.type == "decision") {
            // Draw decision options
            for (var i = 0; i < array_length(evt.options); i++) {
                var opt = evt.options[i];
                var is_hovered = (hovered_option_index == i);

                // Option button background
                var bg_color = is_hovered ? global.color_white : global.color_black;
                var text_color = is_hovered ? global.color_black : global.color_white;
                var border_color = global.color_white;

                draw_set_color(bg_color);
                draw_rectangle(event_options_x + option_padding,
                              draw_y,
                              event_options_x + event_options_width - option_padding,
                              draw_y + option_height,
                              false);

                draw_set_color(border_color);
                draw_rectangle(event_options_x + option_padding,
                              draw_y,
                              event_options_x + event_options_width - option_padding,
                              draw_y + option_height,
                              true);

                // Option text
                draw_set_color(text_color);
                draw_text_ext(event_options_x + option_padding + 10,
                             draw_y + 10,
                             opt.text,
                             16,
                             event_options_width - option_padding * 2 - 20);

                // Show cost if any
                var has_cost = (opt.cost.faith != 0 || opt.cost.food != 0 ||
                               opt.cost.relics != 0 || opt.cost.favor != 0);
                if (has_cost) {
                    var cost_text = "Costs: ";
                    var cost_parts = [];
                    if (opt.cost.faith != 0) array_push(cost_parts, string(opt.cost.faith) + " Faith");
                    if (opt.cost.food != 0) array_push(cost_parts, string(opt.cost.food) + " Food");
                    if (opt.cost.relics != 0) array_push(cost_parts, string(opt.cost.relics) + " Relics");
                    if (opt.cost.favor != 0) array_push(cost_parts, string(opt.cost.favor) + " Favor");

                    for (var j = 0; j < array_length(cost_parts); j++) {
                        cost_text += cost_parts[j];
                        if (j < array_length(cost_parts) - 1) cost_text += ", ";
                    }

                    draw_text(event_options_x + option_padding + 10,
                             draw_y + option_height - 22,
                             cost_text);
                }

                draw_y += option_height + option_padding;
            }
        } else {
            // Boon/Disaster: Show continue button
            var is_hovered = (hovered_option_index == 0);
            var bg_color = is_hovered ? global.color_white : global.color_black;
            var text_color = is_hovered ? global.color_black : global.color_white;

            draw_set_color(bg_color);
            draw_rectangle(event_options_x + option_padding,
                          draw_y,
                          event_options_x + event_options_width - option_padding,
                          draw_y + option_height,
                          false);

            draw_set_color(global.color_white);
            draw_rectangle(event_options_x + option_padding,
                          draw_y,
                          event_options_x + event_options_width - option_padding,
                          draw_y + option_height,
                          true);

            draw_set_color(text_color);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text(event_options_x + event_options_width / 2,
                     draw_y + option_height / 2,
                     "Continue");
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
        }
    } else {
        // Phase 2: Show continue to next event or game over button
        var is_hovered = (hovered_option_index == 0);
        var bg_color = is_hovered ? global.color_white : global.color_black;
        var text_color = is_hovered ? global.color_black : global.color_white;

        draw_set_color(bg_color);
        draw_rectangle(event_options_x + option_padding,
                      draw_y,
                      event_options_x + event_options_width - option_padding,
                      draw_y + option_height,
                      false);

        draw_set_color(global.color_white);
        draw_rectangle(event_options_x + option_padding,
                      draw_y,
                      event_options_x + event_options_width - option_padding,
                      draw_y + option_height,
                      true);

        draw_set_color(text_color);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        var button_text = is_game_over ? "Continue" : "Continue to Next Event";
        draw_text(event_options_x + event_options_width / 2,
                 draw_y + option_height / 2,
                 button_text);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }

    // Disable scissor test
    gpu_set_scissor(-1, -1, -1, -1);
}

// Reset draw state
draw_set_color(global.color_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
