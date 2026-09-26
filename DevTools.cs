// Copyright (C)
// See LICENSE file for extended copyright information.
// This file is part of the repository from .

// NOTE: no XML doc (///) comments in this file - MSL's pack compilation
// fails on them with CS1569. If System.IO is ever needed again, add the
// using explicitly: MSL's pack-time compiler has no ImplicitUsings.

// Codes/ layout (since 2026-09-06): semantic subdirectories - Event/
// (o_devconsole events), Core/ (devconsole infrastructure + output pipeline),
// Commands/ (command implementations), Help/ (trilingual help), Support/
// (json helpers), Mcp/ (MCP server). The GetCode/ReplaceBy references below
// stay FLAT leaf names: MSL resolves them across the whole Codes/ tree, so
// leaf names must stay unique. Asset names are decided by AddFunction's
// second argument, not by file name (see scr_console_time_change.gml).
using ModShardLauncher;
using ModShardLauncher.Mods;
using UndertaleModLib.Models;

namespace DevTools;
public class DevTools : Mod
{
    public override string Author => "Altair";
    public override string Name => "DevTools";
    public override string Description => "Development tools for modders.";
    public override string Version => "1.2.0.0";
    public override string TargetVersion => "0.9.4.25";

    public override void PatchMod()
    {
        Msl.AddMenu(
            "DevTools",
            new UIComponent(
                name: "Debug print logger", associatedGlobal: "log_debug_print",
                UIComponentType.CheckBox, 0)
        );

        DebugPatching();

        // Table export is handled in-game by the `export` console command.
        PatchCommands();
        // After PatchCommands: the MCP scripts call scr_devconsole_execute and
        // scr_devtools_json_escape by bare name. Before EnableDevConsole: its
        // event code calls the MCP scripts by bare name.
        PatchMcp();
        EnableDevConsole();
    }

    // Builds a standalone dev console (o_devconsole), rebuilt from the
    // 0.8.2.10 o_console_controller infrastructure that 0.9.x removed.
    //
    // Design notes:
    //  - The object and every event is a PURE ADDITION: no vanilla code entry
    //    is GML-recompiled here except the tiny scr_console_output_list stub
    //    below, which becomes the output pipeline. This sidesteps every
    //    pitfall of MSL's bundled UTMT (whole-file recompilation of files
    //    containing modern syntax, function-table mismatches, ...).
    //  - Input uses the runtime-managed keyboard_string buffer (no dropped
    //    characters, native key repeat, paste support), with cursor movement,
    //    history and Tab autocomplete - the 0.8.2.10 console experience.
    //  - F2 toggles global.consoleEnabled: the vanilla input gates still
    //    listen to it (o_player, oCamera, o_abilities, scr_keyboard_control,
    //    ...), so input isolation needs no other patch.
    //  - The registry maps command names to script-name STRINGS, resolved at
    //    runtime via asset_get_index: bare function names in value position
    //    get miscompiled into instance-variable reads by the old compiler.
    //  - Event GML calls the AddFunction scripts by their bare names, so all
    //    AddFunction calls (PatchCommands, PatchMcp) must run BEFORE these
    //    AddNewEvent calls, which compile the event code.
    private void EnableDevConsole()
    {
        // Output pipeline: the vanilla scr_console_output_list stub just
        // forwards to the dead print(); replace its body with a direct
        // append to the o_devconsole instance's ds_lists.
        Msl.LoadGML("gml_GlobalScript_scr_console_output_list")
            .MatchAll()
            .ReplaceBy(ModFiles, "scr_console_output_list.gml")
            .Save();

        // The console object. Persistent so it survives room changes.
        UndertaleGameObject oDevConsole = Msl.AddObject("o_devconsole");
        oDevConsole.Persistent = true;
        oDevConsole.Visible = true;

        Msl.AddNewEvent("o_devconsole", ModFiles.GetCode("gml_Object_o_devconsole_Create_0.gml"), EventType.Create, 0);
        Msl.AddNewEvent("o_devconsole", ModFiles.GetCode("gml_Object_o_devconsole_Destroy_0.gml"), EventType.Destroy, 0);
        Msl.AddNewEvent("o_devconsole", ModFiles.GetCode("gml_Object_o_devconsole_Alarm_0.gml"), EventType.Alarm, 0);
        Msl.AddNewEvent("o_devconsole", ModFiles.GetCode("gml_Object_o_devconsole_Step_0.gml"), EventType.Step, 0);
        // Draw event subtype 64 = DrawGUI (the *_64.gml naming convention).
        Msl.AddNewEvent("o_devconsole", ModFiles.GetCode("gml_Object_o_devconsole_DrawGUI_0.gml"), EventType.Draw, 64);
        // Other 68 = Async Networking: MCP server socket events.
        Msl.AddNewEvent("o_devconsole", ModFiles.GetCode("gml_Object_o_devconsole_AsyncNetworking_0.gml"), EventType.Other, 68);
        // Draw 75 = Draw GUI End: MCP screenshots, taken once the frame is
        // fully rendered.
        Msl.AddNewEvent("o_devconsole", ModFiles.GetCode("gml_Object_o_devconsole_DrawGUIEnd_0.gml"), EventType.Draw, 75);

        // Nothing in vanilla creates the console; hook its creation next to
        // the render controller, for a new game or a loaded save. NOTE: the
        // bundled decompiler emits no semicolons - anchors must omit them.
        Msl.LoadGML("gml_GlobalScript_scr_sessionDataInit")
            .MatchFromUntil("if (!instance_exists(o_unitsRenderController))", "instance_create_depth(-50, -50, 0, o_unitsRenderController)")
            .InsertBelow(@"
    if (!instance_exists(o_devconsole))
        instance_create_depth(0, 0, 0, o_devconsole)")
            .Save();

        // The main menu too - both menu rooms call scr_mainMenuInit - so the
        // MCP server is up before any save is loaded and its game_* tools
        // can load one. The console persists from there into the session;
        // the guards keep it a single instance either way.
        Msl.LoadGML("gml_GlobalScript_scr_mainMenuInit")
            .MatchFrom("instance_create_depth(-50, -50, 0, o_mainmenusound)")
            .InsertBelow(@"
    if (!instance_exists(o_devconsole))
        instance_create_depth(0, 0, 0, o_devconsole)")
            .Save();
    }

    private void PatchCommands()
    {
        // Custom commands that do not exist in vanilla at all. JSON helpers must be
        // added before scr_console_dialog because the bundled UTMT compiler resolves
        // bare function names at compile time; otherwise the call is silently turned
        // into an instance-variable read and crashes on load.
        Msl.AddFunction(ModFiles.GetCode("scr_devtools_json_escape.gml"), "scr_devtools_json_escape");
        Msl.AddFunction(ModFiles.GetCode("scr_devtools_json_stringify.gml"), "scr_devtools_json_stringify");
        Msl.AddFunction(ModFiles.GetCode("scr_console_respec.gml"), "scr_console_respec");
        Msl.AddFunction(ModFiles.GetCode("scr_console_export.gml"), "scr_console_export");
        Msl.AddFunction(ModFiles.GetCode("scr_console_dialog.gml"), "scr_console_dialog");
        Msl.AddFunction(ModFiles.GetCode("scr_console_respec_help.gml"), "scr_console_respec_help");
        Msl.AddFunction(ModFiles.GetCode("scr_console_export_help.gml"), "scr_console_export_help");
        Msl.AddFunction(ModFiles.GetCode("scr_console_dialog_help.gml"), "scr_console_dialog_help");

        // Console infrastructure scripts. Same compile-order rule as above:
        // the o_devconsole event code (compiled later in EnableDevConsole)
        // calls these by their bare names, and scr_devconsole_execute calls
        // scr_devconsole_command by its bare name - so each callee must be
        // registered before its caller is compiled.
        Msl.AddFunction(ModFiles.GetCode("scr_devconsole_punto_switch.gml"), "scr_devconsole_punto_switch");
        Msl.AddFunction(ModFiles.GetCode("scr_devconsole_command.gml"), "scr_devconsole_command");
        Msl.AddFunction(ModFiles.GetCode("scr_devconsole_execute.gml"), "scr_devconsole_execute");
        Msl.AddFunction(ModFiles.GetCode("scr_devconsole_commands_map.gml"), "scr_devconsole_commands_map");

        // time is a special case: the vanilla gml_GlobalScript_scr_console_time_change
        // entry crashes MSL's bundled UTMT decompiler (nested closure / new / ?? in
        // scr_console_time_process), so it cannot be GML-patched. The implementation
        // is added under a new name instead; the vanilla stub stays untouched.
        Msl.AddFunction(ModFiles.GetCode("scr_console_time_change.gml"), "scr_devtools_time_change");
        // Its help text has the same problem (it lives in that same entry), so it
        // is provided standalone too - the commands map points `time` at it.
        Msl.AddFunction(ModFiles.GetCode("scr_devtools_time_help.gml"), "scr_devtools_time_help");
        // Batch-1 restored vanilla commands have no *_help function of their own,
        // so their (trilingual) help is added standalone under the standard name.
        Msl.AddFunction(ModFiles.GetCode("scr_console_getinstances_help.gml"), "scr_console_getinstances_help");
        Msl.AddFunction(ModFiles.GetCode("scr_console_getassetid_help.gml"), "scr_console_getassetid_help");
        Msl.AddFunction(ModFiles.GetCode("scr_console_actionslog_help.gml"), "scr_console_actionslog_help");
        Msl.AddFunction(ModFiles.GetCode("scr_console_questsettarget_help.gml"), "scr_console_questsettarget_help");
        Msl.AddFunction(ModFiles.GetCode("scr_console_questnexttarget_help.gml"), "scr_console_questnexttarget_help");

        // Batch-2 NeoConsole ports that have no vanilla script at all: gold, find
        // and exit are added under new names (their trilingual help follows the
        // same rule as the batch-1 restored commands above).
        Msl.AddFunction(ModFiles.GetCode("scr_devtools_gold.gml"), "scr_devtools_gold");
        Msl.AddFunction(ModFiles.GetCode("scr_devtools_find.gml"), "scr_devtools_find");
        Msl.AddFunction(ModFiles.GetCode("scr_devtools_exit.gml"), "scr_devtools_exit");
        Msl.AddFunction(ModFiles.GetCode("scr_console_gold_help.gml"), "scr_console_gold_help");
        Msl.AddFunction(ModFiles.GetCode("scr_console_find_help.gml"), "scr_console_find_help");
        Msl.AddFunction(ModFiles.GetCode("scr_console_exit_help.gml"), "scr_console_exit_help");

        // Batch-3 NeoConsole ports that have no vanilla script at all: butcher
        // is added under a new name. setcaravan/getobjectname/killall exist as
        // empty vanilla stubs (body-patched below), so only their help is
        // added here - same rule as the batches above.
        Msl.AddFunction(ModFiles.GetCode("scr_devtools_butcher.gml"), "scr_devtools_butcher");
        Msl.AddFunction(ModFiles.GetCode("scr_console_butcher_help.gml"), "scr_console_butcher_help");
        Msl.AddFunction(ModFiles.GetCode("scr_console_setcaravan_help.gml"), "scr_console_setcaravan_help");
        Msl.AddFunction(ModFiles.GetCode("scr_console_getobjectname_help.gml"), "scr_console_getobjectname_help");
        Msl.AddFunction(ModFiles.GetCode("scr_console_killall_help.gml"), "scr_console_killall_help");

        // DevTools self-service: `refresh` rebuilds the command maps at
        // runtime the same way the Create event does. Its body calls
        // scr_devconsole_commands_map by its bare name, so it must register
        // after that builder (registered above).
        Msl.AddFunction(ModFiles.GetCode("scr_devtools_refresh.gml"), "scr_devtools_refresh");
        Msl.AddFunction(ModFiles.GetCode("scr_console_refresh_help.gml"), "scr_console_refresh_help");
        // `locations` lists the global-map locations `globalset <location>`
        // can teleport to (read live from global.locationMapName).
        Msl.AddFunction(ModFiles.GetCode("scr_devtools_locations.gml"), "scr_devtools_locations");
        Msl.AddFunction(ModFiles.GetCode("scr_console_locations_help.gml"), "scr_console_locations_help");

        // Vanilla command bodies are empty stubs: fill them with the DevTools
        // implementations. The vanilla scr_console_*_help functions stay untouched.
        // The `until` anchor is the original function's last body line plus the
        // closing brace - for stubs that is just "}"; the restored vanilla
        // commands (getinstances/getassetid/actionslog/questsettarget/
        // questnexttarget/getroomlist) have real bodies, so their anchor is the
        // original final output line + the column-0 closing brace.
        foreach ((string script, string until, string fileName) in new (string, string, string)[]
        {
            ("scr_console_help", "}", "scr_console_help.gml"),
            ("scr_console_drop", "}", "scr_console_drop.gml"),
            ("scr_console_globalset", "}", "scr_console_globalset.gml"),
            ("scr_console_minimap_visible", "}", "scr_console_minimap_visible.gml"),
            ("scr_console_debugmap", "}", "scr_console_debugmap.gml"),
            ("scr_console_room", "}", "scr_console_room.gml"),
            ("scr_console_buff", "}", "scr_console_buff.gml"),
            ("scr_console_allskills", "}", "scr_console_allskills.gml"),
            ("scr_console_godmode", "}", "scr_console_godmode.gml"),
            ("scr_console_spawn", "}", "scr_console_spawn.gml"),
            ("scr_console_getxp", "}", "scr_console_getxp.gml"),
            ("scr_console_nocd", "}", "scr_console_nocd.gml"),
            ("scr_console_killboss", "}", "scr_console_killboss.gml"),
            ("scr_console_getinstances", "\"Parent object not found\", red)\n}", "scr_console_getinstances.gml"),
            ("scr_console_getassetid", "\"Invalid name\", red)\n}", "scr_console_getassetid.gml"),
            // braced else block: also consume its indented close brace
            ("scr_console_actionslog", "\"ActionsLog is visible\", green)\n    }\n}", "scr_console_actionslog.gml"),
            ("scr_console_questsettarget", "\"Quest's data incorrect\", red)\n}", "scr_console_questsettarget.gml"),
            ("scr_console_questnexttarget", "\"Quest's key not found\", red)\n}", "scr_console_questnexttarget.gml"),
            // the vanilla else ends with an explicit "return;" line before its
            // two closing braces - swallow it all so nothing survives the
            // replacement (a shorter anchor leaves the tail as an orphan and
            // the pack compile fails with "Malformed assignment statement")
            ("scr_console_getroomlist", "red)\n        return;\n    }\n}", "scr_console_getroomlist.gml"),
            // Batch-2 NeoConsole ports: the vanilla 0.9.4.25 bodies are stubs,
            // each with its Russian *_help function sitting above (kept intact
            // here, replaced separately below)
            ("scr_console_sethp", "}", "scr_console_sethp.gml"),
            ("scr_console_setmp", "}", "scr_console_setmp.gml"),
            ("scr_console_atr_set", "}", "scr_console_atr_set.gml"),
            ("scr_console_lvl", "}", "scr_console_lvl.gml"),
            ("scr_console_change", "}", "scr_console_change.gml"),
            ("scr_console_weather_switch", "}", "scr_console_weather_switch.gml"),
            ("scr_console_boost", "}", "scr_console_boost.gml"),
            ("scr_console_getseed", "}", "scr_console_getseed.gml"),
            // Batch-3 NeoConsole ports: world/state/cleanup. Seven of the
            // vanilla bodies are empty stubs (their Russian *_help functions
            // sit above them and are replaced separately below). load has a
            // parameter in its signature and is patched on its own below.
            ("scr_console_tp", "}", "scr_console_tp.gml"),
            ("scr_console_nodeathmode", "}", "scr_console_nodeathmode.gml"),
            ("scr_console_rep", "}", "scr_console_rep.gml"),
            ("scr_console_inj", "}", "scr_console_inj.gml"),
            ("scr_console_setcaravan", "}", "scr_console_setcaravan.gml"),
            ("scr_console_getobjectname", "}", "scr_console_getobjectname.gml"),
            ("scr_console_killall", "}", "scr_console_killall.gml"),
        })
        {
            Msl.LoadGML($"gml_GlobalScript_{script}")
                .MatchFromUntil($"function {script}()", until)
                .ReplaceBy(ModFiles, fileName)
                .Save();
        }

        // save is the only stub with a parameter in its signature, and the bundled
        // UTMT decompiler renders it as `argument0`.
        Msl.LoadGML("gml_GlobalScript_scr_console_save")
            .MatchFromUntil("function scr_console_save(argument0)", "}")
            .ReplaceBy(ModFiles, "scr_console_save.gml")
            .Save();

        // load has the same parameter-in-signature quirk as save.
        Msl.LoadGML("gml_GlobalScript_scr_console_load")
            .MatchFromUntil("function scr_console_load(argument0)", "}")
            .ReplaceBy(ModFiles, "scr_console_load.gml")
            .Save();

        // clear is implemented in vanilla but targets the removed old console
        // (__dsDebuggerListClear); replace the whole body. The bundled decompiler
        // renders the last body line as __dsDebuggerListClear(output_list)
        // with no trailing semicolon.
        Msl.LoadGML("gml_GlobalScript_scr_console_clear")
            .MatchFromUntil("function scr_console_clear()", "__dsDebuggerListClear(output_list)\n}")
            .ReplaceBy(ModFiles, "scr_console_clear.gml")
            .Save();

        // Vanilla help text is Russian-only (the *_help functions sitting in
        // the same files, inherited from the 0.8.x era). Each is replaced with
        // a language-aware body reading global.language (1=ru, 2=en, 3=zh)
        // and returning Russian, Chinese, or English rows - English falls
        // back for every other language. The game's font pipeline already
        // switches global.f_dmg per language (scr_fontsUpdate), so no
        // rendering change is needed. NOTE: run AFTER the command-body
        // patches above - both anchor in the same code entries, and the
        // *_help function text is preserved by those patches.
        foreach ((string codeEntry, string helpFunc, string fileName) in new (string, string, string)[]
        {
            ("scr_console_help", "scr_console_help_help", "scr_console_help_help.gml"),
            ("scr_console_clear", "scr_console_clear_help", "scr_console_clear_help.gml"),
            ("scr_console_godmode", "scr_console_godmode_help", "scr_console_godmode_help.gml"),
            ("scr_console_nocd", "scr_console_nocd_help", "scr_console_nocd_help.gml"),
            ("scr_console_getxp", "scr_console_getxp_help", "scr_console_getxp_help.gml"),
            ("scr_console_spawn", "scr_console_spawn_help", "scr_console_spawn_help.gml"),
            ("scr_console_drop", "scr_console_drop_help", "scr_console_drop_help.gml"),
            ("scr_console_buff", "scr_console_buff_help", "scr_console_buff_help.gml"),
            ("scr_console_allskills", "scr_console_allskills_help", "scr_console_allskills_help.gml"),
            ("scr_console_save", "scr_console_save_help", "scr_console_save_help.gml"),
            ("scr_console_room", "scr_console_room_help", "scr_console_room_help.gml"),
            ("scr_console_killboss", "scr_console_killboss_help", "scr_console_killboss_help.gml"),
            ("scr_console_globalset", "scr_console_globalset_help", "scr_console_globalset_help.gml"),
            // the vanilla file is named after minimap_visible but its help
            // function is scr_console_map_help (different stem)
            ("scr_console_minimap_visible", "scr_console_map_help", "scr_console_map_help.gml"),
            ("scr_console_debugmap", "scr_console_debugmap_help", "scr_console_debugmap_help.gml"),
            // restored command; its Russian-only *_help function lives in the
            // same vanilla file, right before the command body
            ("scr_console_getroomlist", "scr_console_getroomlist_help", "scr_console_getroomlist_help.gml"),
            // batch-2 NeoConsole ports; three of the help function names differ
            // from their file stems (attr_help inside atr_set, condition_help
            // inside change, weather_help inside weather_switch)
            ("scr_console_sethp", "scr_console_sethp_help", "scr_console_sethp_help.gml"),
            ("scr_console_setmp", "scr_console_setmp_help", "scr_console_setmp_help.gml"),
            ("scr_console_atr_set", "scr_console_attr_help", "scr_console_attr_help.gml"),
            ("scr_console_lvl", "scr_console_lvl_help", "scr_console_lvl_help.gml"),
            ("scr_console_change", "scr_console_condition_help", "scr_console_condition_help.gml"),
            ("scr_console_weather_switch", "scr_console_weather_help", "scr_console_weather_help.gml"),
            ("scr_console_boost", "scr_console_boost_help", "scr_console_boost_help.gml"),
            ("scr_console_getseed", "scr_console_getseed_help", "scr_console_getseed_help.gml"),
            // batch-3 NeoConsole ports; inj's in-file help function is named
            // scr_console_limb_help (different stem from the command)
            ("scr_console_tp", "scr_console_tp_help", "scr_console_tp_help.gml"),
            ("scr_console_load", "scr_console_load_help", "scr_console_load_help.gml"),
            ("scr_console_nodeathmode", "scr_console_nodeathmode_help", "scr_console_nodeathmode_help.gml"),
            ("scr_console_rep", "scr_console_rep_help", "scr_console_rep_help.gml"),
            ("scr_console_inj", "scr_console_limb_help", "scr_console_limb_help.gml"),
        })
        {
            Msl.LoadGML($"gml_GlobalScript_{codeEntry}")
                .MatchFromUntil($"function {helpFunc}()", "}")
                .ReplaceBy(ModFiles, fileName)
                .Save();
        }
    }

    // MCP server (Codes/Mcp/): a Streamable HTTP endpoint on
    // http://127.0.0.1:8765/mcp, hosted by o_devconsole in pure GML - raw TCP
    // sockets from the Async Networking event, HTTP/1.1 and JSON-RPC parsing,
    // and tools that run console commands, take screenshots, drive the game
    // from the main menu into a save, and run events of instances or click
    // them the way the game's own input dispatch does. The game_* tools are
    // MCP only, never console commands: the console is for people. The
    // network_* builtins the game never calls get forged function-table
    // entries at build time, like the Multiplayer mod's o_webchannel.
    // Registered in dependency order: the old compiler resolves bare function
    // names when each script compiles, so every callee comes before its
    // callers.
    private void PatchMcp()
    {
        foreach (string name in new[]
        {
            // leaf helpers
            "scr_devtools_mcp_trim",
            "scr_devtools_mcp_uint",
            "scr_devtools_mcp_json_str",
            "scr_devtools_mcp_json_id",
            "scr_devtools_mcp_json_bool",
            // connection bookkeeping and HTTP replies
            "scr_devtools_mcp_drop",
            "scr_devtools_mcp_send",
            "scr_devtools_mcp_send_text",
            "scr_devtools_mcp_consume",
            "scr_devtools_mcp_fail",
            "scr_devtools_mcp_reply",
            "scr_devtools_mcp_reply_error",
            "scr_devtools_mcp_tool_reply",
            "scr_devtools_mcp_is_local",
            // the game_* tools: phase and state reports, saves, loading,
            // events and clicks
            "scr_devtools_mcp_game_phase",
            "scr_devtools_mcp_game_state",
            "scr_devtools_mcp_game_save_problem",
            "scr_devtools_mcp_game_saves",
            "scr_devtools_mcp_game_load",
            "scr_devtools_mcp_game_wait_check",
            "scr_devtools_mcp_game_target",
            "scr_devtools_mcp_game_instances",
            "scr_devtools_mcp_game_event",
            "scr_devtools_mcp_game_click",
            // tools, JSON-RPC dispatch, HTTP parser
            "scr_devtools_mcp_base64",
            "scr_devtools_mcp_console_execute",
            "scr_devtools_mcp_console_read",
            "scr_devtools_mcp_tools_list",
            "scr_devtools_mcp_tools_call",
            "scr_devtools_mcp_rpc",
            "scr_devtools_mcp_http",
            // entry points called from the o_devconsole events
            "scr_devtools_mcp_screenshot",
            "scr_devtools_mcp_network",
            "scr_devtools_mcp_stop",
            "scr_devtools_mcp_start",
            "scr_devtools_mcp_tick",
            "scr_devtools_mcp_init",
            "scr_devtools_mcp_cleanup",
            // the `mcp` console command and its trilingual help
            "scr_devtools_mcp",
            "scr_console_mcp_help",
        })
        {
            Msl.AddFunction(ModFiles.GetCode(name + ".gml"), name);
        }
    }

    private void DebugPatching()
    {
        Msl.LoadGML("gml_GlobalScript_debug_print")
            .MatchFromUntil("function debug_print()", "{")
            .InsertBelow(@"
    if (global.log_debug_print)
    {
        var _str = """";
        for (var i = 0; i < argument_count; i ++)
        {
            _str += "" "" + string(argument[i]);
        }
        scr_msl_log(_str)
    }")
            .Save();
    }
}
