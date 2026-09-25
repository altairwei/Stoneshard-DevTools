// DevTools standalone dev console - rebuilt from the 0.8.2.10
// o_console_controller infrastructure (removed from the game in 0.9.x).
// Old GML subset only (MSL's bundled UTMT compiler).
keyboardString = "";
keyboardStringLengthMax = 100;
pointerPos = 0;
keyDelay = 4;
// display option, source-level only (no console command - rarely used):
// true shows the caret-position:total-length counter and the length slider
// next to the input line in DrawGUI (neoconsole UI 1)
showCursorCounter = false;
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
// scrollback state (neoconsole fullview port): 0 = newest at the bottom,
// larger = looking further back; the right-edge bar mirrors the scroll
// position and can be dragged. mouse wheel/PgUp/PgDn scroll, Enter resets.
scroll = 0;
scroll_hover_anim = 0;
scroll_hover_active = false;
min_scroll_requirement = 25;
// autocomplete chip selector state (Tab opens/cycles, Enter picks)
autocomplete_list = ds_list_create();
autocomplete_active = false;
autocomplete_index = -1;
scr_devconsole_commands_map(commandsMap, helpMap);
scr_console_output_list("[DevTools] " + string(ds_map_size(commandsMap)) + " commands loaded.", gray);
scr_console_output_list("[DevTools] F2 toggles, Tab autocompletes, Up/Down recalls history, wheel/PgUp scrolls.", gray);
// MCP server: its state, then listen on 127.0.0.1:8765 - see scr_devtools_mcp_init
scr_devtools_mcp_init();
