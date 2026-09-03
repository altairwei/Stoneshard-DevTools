// DevTools command registry, filled into the two ds_maps created by the
// o_devconsole Create event. Values are script-name strings resolved at
// runtime via asset_get_index (see scr_devconsole_command) - the
// value-position bare-name pitfall (miscompiled into an instance-variable
// read) does not apply to strings.
// - help/clear and the 13 vanilla command bodies are GML-patched stubs
// - respec/export/dialog (+ their _help) and the JSON helpers are AddFunction
// - time lives under a new name: the vanilla entry crashes the decompiler
// argument[0]: command name -> implementation script name
// argument[1]: command name -> help script name (explicit, because e.g. the
//       `map` command's implementation and help scripts have different stems)
// NOTE: the old compiler does not support named parameters in declarations -
// read positional arguments via argument[0]/argument[1].
function scr_devconsole_commands_map()
{
    var _commandsMap = argument[0];
    var _helpMap = argument[1];

    ds_map_add(_commandsMap, "help", "scr_console_help");
    ds_map_add(_helpMap,"help", "scr_console_help_help");
    ds_map_add(_commandsMap,"clear", "scr_console_clear");
    ds_map_add(_helpMap,"clear", "scr_console_clear_help");
    ds_map_add(_commandsMap,"godmode", "scr_console_godmode");
    ds_map_add(_helpMap,"godmode", "scr_console_godmode_help");
    ds_map_add(_commandsMap,"nocd", "scr_console_nocd");
    ds_map_add(_helpMap,"nocd", "scr_console_nocd_help");
    ds_map_add(_commandsMap,"getxp", "scr_console_getxp");
    ds_map_add(_helpMap,"getxp", "scr_console_getxp_help");
    ds_map_add(_commandsMap,"spawn", "scr_console_spawn");
    ds_map_add(_helpMap,"spawn", "scr_console_spawn_help");
    ds_map_add(_commandsMap,"drop", "scr_console_drop");
    ds_map_add(_helpMap,"drop", "scr_console_drop_help");
    ds_map_add(_commandsMap,"buff", "scr_console_buff");
    ds_map_add(_helpMap,"buff", "scr_console_buff_help");
    ds_map_add(_commandsMap,"skills", "scr_console_allskills");
    ds_map_add(_helpMap,"skills", "scr_console_allskills_help");
    ds_map_add(_commandsMap,"save", "scr_console_save");
    ds_map_add(_helpMap,"save", "scr_console_save_help");
    ds_map_add(_commandsMap,"room", "scr_console_room");
    ds_map_add(_helpMap,"room", "scr_console_room_help");
    ds_map_add(_commandsMap,"killboss", "scr_console_killboss");
    ds_map_add(_helpMap,"killboss", "scr_console_killboss_help");
    ds_map_add(_commandsMap,"time", "scr_devtools_time_change");
    ds_map_add(_helpMap,"time", "scr_console_time_help");
    ds_map_add(_commandsMap,"map", "scr_console_minimap_visible");
    ds_map_add(_helpMap,"map", "scr_console_map_help");
    ds_map_add(_commandsMap,"debugmap", "scr_console_debugmap");
    ds_map_add(_helpMap,"debugmap", "scr_console_debugmap_help");
    ds_map_add(_commandsMap,"globalset", "scr_console_globalset");
    ds_map_add(_helpMap,"globalset", "scr_console_globalset_help");
    ds_map_add(_commandsMap,"respec", "scr_console_respec");
    ds_map_add(_helpMap,"respec", "scr_console_respec_help");
    ds_map_add(_commandsMap,"export", "scr_console_export");
    ds_map_add(_helpMap,"export", "scr_console_export_help");
    ds_map_add(_commandsMap,"dialog", "scr_console_dialog");
    ds_map_add(_helpMap,"dialog", "scr_console_dialog_help");
}
