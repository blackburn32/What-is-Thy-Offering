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

// Initialize power map for lookups
init_power_map();