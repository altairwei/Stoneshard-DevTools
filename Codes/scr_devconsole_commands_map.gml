// DevTools command registry, filled into the two ds_maps created by the
// o_devconsole Create event. Values are script-name strings resolved at
// runtime via asset_get_index (see scr_devconsole_command) - the
// value-position bare-name pitfall (miscompiled into an instance-variable
// read) does not apply to strings.
// - the vanilla-stub commands and the vanilla-restored ones are GML-patched
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
    // time's vanilla help lives in scr_console_time_change, an entry the MSL
    // decompiler cannot touch (modern syntax) - standalone multi-language help.
    ds_map_add(_helpMap,"time", "scr_devtools_time_help");
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
    // vanilla-restored commands; their help is standalone (added via AddFunction,
    // except getroomlist's, which shares the vanilla file with its command)
    ds_map_add(_commandsMap,"getinstances", "scr_console_getinstances");
    ds_map_add(_helpMap,"getinstances", "scr_console_getinstances_help");
    ds_map_add(_commandsMap,"getroomlist", "scr_console_getroomlist");
    ds_map_add(_helpMap,"getroomlist", "scr_console_getroomlist_help");
    ds_map_add(_commandsMap,"getassetid", "scr_console_getassetid");
    ds_map_add(_helpMap,"getassetid", "scr_console_getassetid_help");
    ds_map_add(_commandsMap,"actionslog", "scr_console_actionslog");
    ds_map_add(_helpMap,"actionslog", "scr_console_actionslog_help");
    ds_map_add(_commandsMap,"questsettarget", "scr_console_questsettarget");
    ds_map_add(_helpMap,"questsettarget", "scr_console_questsettarget_help");
    ds_map_add(_commandsMap,"questnexttarget", "scr_console_questnexttarget");
    ds_map_add(_helpMap,"questnexttarget", "scr_console_questnexttarget_help");
    // NeoConsole ports; eight body patches on vanilla stubs + three standalone
    // implementations (gold/find/exit). Help is trilingual in all cases - the
    // eight vanilla *-patched entries carry their in-file *_help functions,
    // the three standalone ones are AddFunction.
    ds_map_add(_commandsMap,"sethp", "scr_console_sethp");
    ds_map_add(_helpMap,"sethp", "scr_console_sethp_help");
    ds_map_add(_commandsMap,"setmp", "scr_console_setmp");
    ds_map_add(_helpMap,"setmp", "scr_console_setmp_help");
    ds_map_add(_commandsMap,"setatr", "scr_console_atr_set");
    ds_map_add(_helpMap,"setatr", "scr_console_attr_help");
    ds_map_add(_commandsMap,"setlvl", "scr_console_lvl");
    ds_map_add(_helpMap,"setlvl", "scr_console_lvl_help");
    ds_map_add(_commandsMap,"gold", "scr_devtools_gold");
    ds_map_add(_helpMap,"gold", "scr_console_gold_help");
    ds_map_add(_commandsMap,"setcondition", "scr_console_change");
    ds_map_add(_helpMap,"setcondition", "scr_console_condition_help");
    ds_map_add(_commandsMap,"weather", "scr_console_weather_switch");
    ds_map_add(_helpMap,"weather", "scr_console_weather_help");
    ds_map_add(_commandsMap,"boost", "scr_console_boost");
    ds_map_add(_helpMap,"boost", "scr_console_boost_help");
    ds_map_add(_commandsMap,"getseed", "scr_console_getseed");
    ds_map_add(_helpMap,"getseed", "scr_console_getseed_help");
    ds_map_add(_commandsMap,"find", "scr_devtools_find");
    ds_map_add(_helpMap,"find", "scr_console_find_help");
    ds_map_add(_commandsMap,"exit", "scr_devtools_exit");
    ds_map_add(_helpMap,"exit", "scr_console_exit_help");
}
