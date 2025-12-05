/// @description Initialize game room controller

// Sidebar layout constants
sidebar_width = 200;
sidebar_padding = 10;
section_padding = 20; // Padding between major sections

// Avatar section
avatar_size = 64;
avatar_frame_thickness = 2;
avatar_y = sidebar_padding;
god_name_height = 16; // Space for god name text

// Resources section
resource_start_y = avatar_y + avatar_size + god_name_height + section_padding;
resource_icon_size = 32;
resource_row_height = 36;
resource_spacing = 4;

// Powers section
powers_start_y = resource_start_y + (resource_row_height + resource_spacing) * 4 + section_padding;
powers_list_height = room_height - powers_start_y - sidebar_padding;
powers_scroll_offset = 0;
powers_scroll_target = 0;
powers_item_height = 24;

// Resource labels
resource_names = ["Favor", "Faith", "Food", "Relics"];

// Reference to player state
if (!instance_exists(obj_player_state)) {
    instance_create_depth(0, 0, 0, obj_player_state);
}

// Initialize player's selected god from global
if (variable_global_exists("selected_god")) {
    obj_player_state.selected_god = global.selected_god;
}

// Initialize power map for lookups
init_power_map();

// === EVENT SYSTEM ===

// Main content area layout constants
main_content_x = sidebar_width + 20;
main_content_width = room_width - sidebar_width - 40;
main_content_center_x = sidebar_width + (room_width - sidebar_width) / 2;

// Event display layout
event_image_width = 160;
event_image_height = 120;
event_image_x = main_content_center_x - (3 * event_image_width / 2);
event_image_y = 50;

event_desc_x = main_content_x;
event_desc_y = event_image_y + event_image_height + 300;
event_desc_width = main_content_width;
event_desc_max_height = 100;

event_divider_y = event_desc_y + event_desc_max_height + 10;

event_options_x = main_content_x;
event_options_y = event_divider_y + 20;
event_options_width = main_content_width;
event_options_height = room_height - event_options_y - 20;

// Option display settings
option_height = 60;
option_padding = 10;
option_scroll_offset = 0;
option_scroll_target = 0;
hovered_option_index = -1;

// Event sequence and state
event_list = [];
var all_events = get_all_events();

// Filter to decision, boon, and disaster events for now
for (var i = 0; i < array_length(all_events); i++) {
    var evt = all_events[i];
    if (evt.type == "decision" || evt.type == "boon" || evt.type == "disaster") {
        array_push(event_list, evt);
    }
}

current_event_index = 0;
current_phase = 1; // 1 = description/options, 2 = outcome
selected_option_index = -1;
selected_option = undefined; // Store the actual option struct for phase 2
is_game_over = false; // Track if game over condition has been reached