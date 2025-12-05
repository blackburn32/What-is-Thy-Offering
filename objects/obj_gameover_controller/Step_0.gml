/// @description Handle button interaction

// Check hover state for each button
hovered_button = -1;

// Button 0: High Scores
if (point_in_rectangle(mouse_x, mouse_y,
    button_highscores_x, button_y,
    button_highscores_x + button_width, button_y + button_height)) {
    hovered_button = 0;
}

// Button 1: Powers
if (point_in_rectangle(mouse_x, mouse_y,
    button_powers_x, button_y,
    button_powers_x + button_width, button_y + button_height)) {
    hovered_button = 1;
}

// Button 2: Try Again
if (point_in_rectangle(mouse_x, mouse_y,
    button_tryagain_x, button_y,
    button_tryagain_x + button_width, button_y + button_height)) {
    hovered_button = 2;
}

// Handle button clicks
if (mouse_check_button_pressed(mb_left) && hovered_button != -1) {
    switch (hovered_button) {
        case 0: // High Scores
            room_goto(HighScores);
            break;
        case 1: // Powers
            room_goto(Powers);
            break;
        case 2: // Try Again
            room_goto(MainMenu);
            break;
    }
}
