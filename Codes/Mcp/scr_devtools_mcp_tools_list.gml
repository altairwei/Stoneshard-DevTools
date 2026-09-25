// tools/list result: the three tools with their input schemas.
function scr_devtools_mcp_tools_list()
{
    var _s = "{\"tools\":[";
    _s += "{\"name\":\"console_execute\",\"title\":\"Run console command\",\"description\":\"Run one DevTools console command in the running game, exactly as if typed into the F2 console, and return the lines it printed. Use 'help' to list all commands and 'help <command>' for the usage of a command. Commands act on the live game state; most need a character in the world. Lines the console printed in red are prefixed with [error].\",\"inputSchema\":{\"type\":\"object\",\"properties\":{\"command\":{\"type\":\"string\",\"description\":\"The command line, e.g. 'help' or 'gold 500'.\"}},\"required\":[\"command\"]}},";
    _s += "{\"name\":\"console_read\",\"title\":\"Read console output\",\"description\":\"Return the most recent lines of the console output history, including output from commands typed by the player.\",\"inputSchema\":{\"type\":\"object\",\"properties\":{\"lines\":{\"type\":\"integer\",\"minimum\":1,\"maximum\":1000,\"default\":50,\"description\":\"How many of the newest lines to return.\"}}}},";
    _s += "{\"name\":\"screenshot\",\"title\":\"Screenshot\",\"description\":\"Capture the game window as a PNG image, including the HUD and menus. Takes one rendered frame; fails if the game is not drawing, e.g. while minimized.\",\"inputSchema\":{\"type\":\"object\",\"properties\":{\"max_width\":{\"type\":\"integer\",\"minimum\":0,\"default\":1280,\"description\":\"Downscale to at most this width in pixels, keeping the aspect ratio; 0 keeps the full resolution.\"}}}}";
    _s += "]}";
    return _s;
}
