/// @description Draw god selection UI

draw_set_color(global.color_white);

// Draw title (large, centered)
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_text_transformed(room_width / 2, title_y, title_text, 2, 2, 0);

// Draw instructions (normal size, centered)
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_text_ext(room_width / 2, instructions_y, instruction_text, -1, 600);

// Draw god cards
var start_x = (room_width - total_width) / 2 + card_spacing - scroll_offset;

for (var i = 0; i < array_length(gods); i++) {
    var card_x = start_x + i * (card_width + card_spacing);
    var card_y = gods_y;

    // Skip if card is completely off screen
    if (card_x + card_width < 0 || card_x > room_width) {
        continue;
    }

    // Reset color for each card
    draw_set_color(global.color_white);

    // Draw card border
    draw_rectangle(card_x, card_y, card_x + card_width, card_y + card_height, true);

    // Draw avatar frame (centered at top of card)
    var avatar_x = card_x + card_width / 2;
    var avatar_y = card_y + 40;
    draw_rectangle(avatar_x - avatar_size / 2, avatar_y - avatar_size / 2,
                   avatar_x + avatar_size / 2, avatar_y + avatar_size / 2, true);

    // Draw placeholder text in avatar
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(avatar_x, avatar_y, "Avatar\n64x64");

    // Draw god name (underlined)
    var name_y = avatar_y + avatar_size / 2 + 30;
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_text(avatar_x, name_y, gods[i].name);

    // Draw underline for name
    var name_width = string_width(gods[i].name);
    draw_line(avatar_x - name_width / 2, name_y + 20,
              avatar_x + name_width / 2, name_y + 20);

    // Draw power description (wrapped)
    var power_y = name_y + 30;
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_text_ext(avatar_x, power_y, gods[i].power, -1, card_width - 20);

    // Draw Choose button
    var button_x = avatar_x;
    var button_y = card_y + card_height - 60;

    // Check if mouse is hovering over button
    var mouse_on_button = point_in_rectangle(mouse_x, mouse_y,
        button_x - button_width / 2, button_y - button_height / 2,
        button_x + button_width / 2, button_y + button_height / 2);

    // Draw button background (inverted if hovered)
    var bg_color = mouse_on_button ? global.color_white : global.color_black;
    var text_color = mouse_on_button ? global.color_black : global.color_white;

    draw_set_color(bg_color);
    draw_rectangle(button_x - button_width / 2, button_y - button_height / 2,
                   button_x + button_width / 2, button_y + button_height / 2, false);

    draw_set_color(global.color_white);
    draw_rectangle(button_x - button_width / 2, button_y - button_height / 2,
                   button_x + button_width / 2, button_y + button_height / 2, true);

    // Draw button text
    draw_set_color(text_color);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(button_x, button_y, "Choose");
}

// Reset draw settings
draw_set_color(global.color_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Draw scroll hint if there are more gods off screen
if (max_scroll > 0) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_text(room_width / 2, room_height - 20, "Drag or use mouse wheel to scroll");
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
