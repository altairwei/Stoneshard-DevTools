// game_state result: phase, room, console visibility, the save the main
// menu's Continue loads, and on the save error screen the game's message.
function scr_devtools_mcp_game_state()
{
    var _phase = scr_devtools_mcp_game_phase();
    var _s = "{\"phase\":\"" + _phase + "\",\"room\":" + scr_devtools_mcp_json_str(room_get_name(room));
    _s += ",\"console_open\":" + scr_devtools_mcp_json_bool(global.consoleEnabled);
    if (_phase == "menu")
        _s += ",\"press_any_key\":" + scr_devtools_mcp_json_bool(instance_exists(o_mainMenuPressAnyKey));
    if (_phase == "save_error")
    {
        if (variable_global_exists("saveErrorText"))
            _s += ",\"save_error\":" + scr_devtools_mcp_json_str(global.saveErrorText);
    }
    if (variable_global_exists("slotsMap"))
        _s += ",\"last_save\":{\"character\":" + scr_devtools_mcp_json_str(ds_map_find_value(global.slotsMap, "lastCharacter")) + ",\"save\":" + scr_devtools_mcp_json_str(ds_map_find_value(global.slotsMap, "lastSave")) + "}";
    return _s + "}";
}
