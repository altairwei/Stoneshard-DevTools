// DevTools standalone dev console - rebuilt from the 0.8.2.10
// o_console_controller infrastructure (removed from the game in 0.9.x).
// Old GML subset only (MSL's bundled UTMT compiler).
keyboardString = "";
keyboardStringLengthMax = 100;
pointerPos = 0;
keyDelay = 4;
previous_command = ds_list_create();
previous_command_index = -1;
output_list = ds_list_create();
color_list = ds_list_create();
white = 16777215;
red = make_color_rgb(194, 0, 0);
green = make_color_rgb(89, 219, 76);
gray = make_color_rgb(150, 150, 150);
commandsMap = ds_map_create();
helpMap = ds_map_create();
scr_devconsole_commands_map(commandsMap, helpMap);
scr_console_output_list("[DevTools] " + string(ds_map_size(commandsMap)) + " commands loaded.", gray);
scr_console_output_list("[DevTools] F2 toggles, Tab autocompletes, Up/Down recalls history.", gray);
