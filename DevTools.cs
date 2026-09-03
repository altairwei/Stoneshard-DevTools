// Copyright (C)
// See LICENSE file for extended copyright information.
// This file is part of the repository from .

// NOTE: no XML doc (///) comments in this file - MSL's pack compilation
// fails on them with CS1569. If System.IO is ever needed again, add the
// using explicitly: MSL's pack-time compiler has no ImplicitUsings.
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
    //    AddFunction calls (PatchCommands) must run BEFORE these
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

        // Nothing in vanilla creates the console; hook its creation next to
        // the render controller. NOTE: the bundled decompiler emits no
        // semicolons - anchors must omit them.
        Msl.LoadGML("gml_GlobalScript_scr_sessionDataInit")
            .MatchFromUntil("if (!instance_exists(o_unitsRenderController))", "instance_create_depth(-50, -50, 0, o_unitsRenderController)")
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

        // Vanilla command bodies are empty stubs: fill them with the DevTools
        // implementations. The vanilla scr_console_*_help functions stay untouched.
        foreach ((string script, string fileName) in new (string, string)[]
        {
            ("scr_console_help", "scr_console_help.gml"),
            ("scr_console_drop", "scr_console_drop.gml"),
            ("scr_console_globalset", "scr_console_globalset.gml"),
            ("scr_console_minimap_visible", "scr_console_minimap_visible.gml"),
            ("scr_console_debugmap", "scr_console_debugmap.gml"),
            ("scr_console_room", "scr_console_room.gml"),
            ("scr_console_buff", "scr_console_buff.gml"),
            ("scr_console_allskills", "scr_console_allskills.gml"),
            ("scr_console_godmode", "scr_console_godmode.gml"),
            ("scr_console_spawn", "scr_console_spawn.gml"),
            ("scr_console_getxp", "scr_console_getxp.gml"),
            ("scr_console_nocd", "scr_console_nocd.gml"),
            ("scr_console_killboss", "scr_console_killboss.gml"),
        })
        {
            Msl.LoadGML($"gml_GlobalScript_{script}")
                .MatchFromUntil($"function {script}()", "}")
                .ReplaceBy(ModFiles, fileName)
                .Save();
        }

        // save is the only stub with a parameter in its signature, and the bundled
        // UTMT decompiler renders it as `argument0`.
        Msl.LoadGML("gml_GlobalScript_scr_console_save")
            .MatchFromUntil("function scr_console_save(argument0)", "}")
            .ReplaceBy(ModFiles, "scr_console_save.gml")
            .Save();

        // clear is implemented in vanilla but targets the removed old console
        // (__dsDebuggerListClear); replace the whole body. The bundled decompiler
        // renders the last body line as __dsDebuggerListClear(output_list)
        // with no trailing semicolon.
        Msl.LoadGML("gml_GlobalScript_scr_console_clear")
            .MatchFromUntil("function scr_console_clear()", "__dsDebuggerListClear(output_list)\n}")
            .ReplaceBy(ModFiles, "scr_console_clear.gml")
            .Save();
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
