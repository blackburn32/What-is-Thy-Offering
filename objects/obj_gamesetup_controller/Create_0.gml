/// @description Initialize god selection

// Title and instruction text
title_text = "A God is Born";
instruction_text = "Nourish your disciples and they will reward you with faith\n\nMake sure you don't run out of faith or food\n\nSpend your divine favor to grow stronger\n\nWhat kind of god will you be?";

// Layout settings
title_y = 80;
instructions_y = 200;
gods_y = 400;

// God data - array of structs
gods = [
    {
        name: "Merciful One",
        power: "Show mercy during decisions to strengthen faith"
    },
    {
        name: "Harvest Lord",
        power: "Bountiful harvests provide extra food"
    },
    {
        name: "War Bringer",
        power: "Military victories grant divine favor"
    },
    {
        name: "Trickster",
        power: "Clever schemes improve resource exchanges"
    },
    {
        name: "Ancient Sage",
        power: "Wisdom reduces the impact of disasters"
    }
];

// God card layout
card_width = 250;
card_height = 300;
card_spacing = 30;
avatar_size = 64;
button_width = 120;
button_height = 40;

// Scrolling
scroll_offset = 0;
scroll_speed = 10;
target_scroll = 0;

// Drag scrolling
is_dragging = false;
drag_start_x = 0;
drag_start_scroll = 0;

// Calculate total width needed
total_width = array_length(gods) * (card_width + card_spacing);
max_scroll = max(0, total_width - room_width + 100);
