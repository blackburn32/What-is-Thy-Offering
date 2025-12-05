/// @description Draw GameOver screen

// Reset draw state
draw_set_color(global.color_white);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_font(NoAntiAliasing);

// === IMAGE PLACEHOLDER (4:3 ratio) ===
draw_set_color(global.color_white);
draw_rectangle(image_x - 2, image_y - 2,
               image_x + image_width + 2, image_y + image_height + 2,
               false);
draw_set_color(global.color_black);
draw_rectangle(image_x, image_y,
               image_x + image_width, image_y + image_height,
               false);

// Draw placeholder label
draw_set_color(global.color_white);
draw_text(room_width / 2, image_y + image_height / 2, "[GAME OVER IMAGE]");

// === GAME OVER TITLE ===
draw_set_color(global.color_white);
draw_text(room_width / 2, title_y, "Game Over");

// === WIN/LOSS STATUS ===
var status_text = player_won ? "You won!" : "You lost.";
draw_text(room_width / 2, status_y, status_text);

// === FINAL SCORE (only if won) ===
if (player_won) {
    draw_text(room_width / 2, score_y, "You ended with:");

    // Draw faith amount with icon
    var faith_display_y = score_y + 30;

    // Draw faith icon placeholder
    var icon_x = (room_width / 2) - 60;
    draw_set_color(global.color_white);
    draw_rectangle(icon_x, faith_display_y,
                   icon_x + faith_icon_size, faith_display_y + faith_icon_size,
                   true);
    draw_set_color(global.color_black);
    draw_rectangle(icon_x + 4, faith_display_y + 4,
                   icon_x + faith_icon_size - 4, faith_display_y + faith_icon_size - 4,
                   false);

    // Draw faith text
    draw_set_color(global.color_white);
    draw_set_halign(fa_left);
    draw_text(icon_x + faith_icon_size + 10, faith_display_y + 6, string(final_faith) + " Faith");
    draw_set_halign(fa_center);
}

// === BUTTONS ===
draw_set_valign(fa_middle);

// Button 0: High Scores
var hs_bg = (hovered_button == 0) ? global.color_white : global.color_black;
var hs_text = (hovered_button == 0) ? global.color_black : global.color_white;

draw_set_color(hs_bg);
draw_rectangle(button_highscores_x, button_y,
               button_highscores_x + button_width, button_y + button_height,
               false);
draw_set_color(global.color_white);
draw_rectangle(button_highscores_x, button_y,
               button_highscores_x + button_width, button_y + button_height,
               true);
draw_set_color(hs_text);
draw_text(button_highscores_x + button_width / 2, button_y + button_height / 2, "High Scores");

// Button 1: Powers
var pow_bg = (hovered_button == 1) ? global.color_white : global.color_black;
var pow_text = (hovered_button == 1) ? global.color_black : global.color_white;

draw_set_color(pow_bg);
draw_rectangle(button_powers_x, button_y,
               button_powers_x + button_width, button_y + button_height,
               false);
draw_set_color(global.color_white);
draw_rectangle(button_powers_x, button_y,
               button_powers_x + button_width, button_y + button_height,
               true);
draw_set_color(pow_text);
draw_text(button_powers_x + button_width / 2, button_y + button_height / 2, "Powers");

// Button 2: Try Again
var try_bg = (hovered_button == 2) ? global.color_white : global.color_black;
var try_text = (hovered_button == 2) ? global.color_black : global.color_white;

draw_set_color(try_bg);
draw_rectangle(button_tryagain_x, button_y,
               button_tryagain_x + button_width, button_y + button_height,
               false);
draw_set_color(global.color_white);
draw_rectangle(button_tryagain_x, button_y,
               button_tryagain_x + button_width, button_y + button_height,
               true);
draw_set_color(try_text);
draw_text(button_tryagain_x + button_width / 2, button_y + button_height / 2, "Try Again");

// Reset draw state
draw_set_color(global.color_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
