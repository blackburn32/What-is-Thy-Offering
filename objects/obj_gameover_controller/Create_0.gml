/// @description Initialize GameOver screen

// Reference to player state
if (!instance_exists(obj_player_state)) {
    instance_create_depth(0, 0, 0, obj_player_state);
}

var player = obj_player_state;

// Determine win/loss status
// Player wins if they still have faith > 0 AND food > 0 (completed 30 events)
// Player loses if faith <= 0 OR food <= 0
player_won = (player.faith > 0 && player.food > 0);

// Store final faith for display
final_faith = player.faith;

// Layout constants
image_width = 560;
image_height = 420;
image_x = (room_width / 2) - (image_width / 2);
image_y = 60;

title_y = image_y + image_height + 30;
status_y = title_y + 50;
score_y = status_y + 40;

// Button layout - 3 buttons in a row at bottom
button_width = 180;
button_height = 50;
button_spacing = 20;
button_y = room_height - 100;

// Calculate button positions to center them
total_buttons_width = (button_width * 3) + (button_spacing * 2);
buttons_start_x = (room_width / 2) - (total_buttons_width / 2);

button_highscores_x = buttons_start_x;
button_powers_x = buttons_start_x + button_width + button_spacing;
button_tryagain_x = buttons_start_x + (button_width + button_spacing) * 2;

// Hover state
hovered_button = -1; // -1 = none, 0 = high scores, 1 = powers, 2 = try again

// Faith icon placeholder size
faith_icon_size = 32;
