    var _create = argument[0];
    
    if (_create)
    {
        commandsMap = __dsDebuggerMapCreate();
        ds_map_add(commandsMap, "debugmap", scr_console_debugmap);
        ds_map_add(commandsMap, "help", scr_console_help);
        ds_map_add(commandsMap, "clear", scr_console_clear);
        ds_map_add(commandsMap, "drop", scr_console_drop);
        ds_map_add(commandsMap, "devinfo", scr_console_devinfo_set);
        ds_map_add(commandsMap, "devcam", scr_console_devcamera);
        ds_map_add(commandsMap, "spawn", scr_console_spawn);
        ds_map_add(commandsMap, "room", scr_console_room);
        ds_map_add(commandsMap, "buff", scr_console_buff);
        ds_map_add(commandsMap, "steamclear", scr_console_clear_steam);
        ds_map_add(commandsMap, "time", scr_console_time_change);
        ds_map_add(commandsMap, "gui", scr_console_UI_visible);
        ds_map_add(commandsMap, "map", scr_console_minimap_visible);
        ds_map_add(commandsMap, "fow", scr_console_FOG_visible);
        ds_map_add(commandsMap, "weather", scr_console_weather_switch);
        ds_map_add(commandsMap, "enemyinfo", scr_console_enemyinfo);
        ds_map_add(commandsMap, "godmode", scr_console_godmode);
        ds_map_add(commandsMap, "nodeath", scr_console_nodeathmode);
        ds_map_add(commandsMap, "getxp", scr_console_getxp);
        ds_map_add(commandsMap, "sethp", scr_console_sethp);
        ds_map_add(commandsMap, "setmp", scr_console_setmp);
        ds_map_add(commandsMap, "save", scr_console_save);
        ds_map_add(commandsMap, "load", scr_console_load);
        ds_map_add(commandsMap, "killboss", scr_console_killboss);
        ds_map_add(commandsMap, "skills", scr_console_allskills);
        ds_map_add(commandsMap, "contract", scr_console_contract);
        ds_map_add(commandsMap, "condition", scr_console_change);
        ds_map_add(commandsMap, "psy", scr_console_psy);
        ds_map_add(commandsMap, "limb", scr_console_inj);
        ds_map_add(commandsMap, "attr", scr_console_atr_set);
        ds_map_add(commandsMap, "lvl", scr_console_lvl);
        ds_map_add(commandsMap, "tp", scr_console_tp);
        ds_map_add(commandsMap, "nocd", scr_console_nocd);
        ds_map_add(commandsMap, "boost", scr_console_boost);
        ds_map_add(commandsMap, "globalset", scr_console_globalset);
        ds_map_add(commandsMap, "getobjectname", scr_console_getobjectname);
        ds_map_add(commandsMap, "mapstat", scr_console_mapstat);
        ds_map_add(commandsMap, "getseed", scr_console_getseed);
        ds_map_add(commandsMap, "preset", scr_console_presset);
        ds_map_add(commandsMap, "ds_debugger", scr_console_dsDebugger);
        ds_map_add(commandsMap, "npc", scr_console_spriteorigin);
        ds_map_add(commandsMap, "sight", scr_console_sightplacelist);
        ds_map_add(commandsMap, "damage", scr_console_damage);
        ds_map_add(commandsMap, "setcaravan", scr_console_setcaravan);
        ds_map_add(commandsMap, "overlay", scr_console_overlay);
        ds_map_add(commandsMap, "skill_test", scr_console_skill_test);
        ds_map_add(commandsMap, "locate_traps", scr_console_lacateTraps);
        ds_map_add(commandsMap, "respec", gml_Script_scr_console_respec);
    }
    else
    {
        __dsDebuggerMapDestroy(commandsMap);
    }
