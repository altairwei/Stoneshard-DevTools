// Copyright (C)
// See LICENSE file for extended copyright information.
// This file is part of the repository from .

using System;
using System.IO;

using ModShardLauncher;
using ModShardLauncher.Mods;

namespace DevTools;
public class DevTools : Mod
{
    public override string Author => "Altair";
    public override string Name => "DevTools";
    public override string Description => "Development tools for modders.";
    public override string Version => "1.0.0.0";
    public override string TargetVersion => "0.8.2.10";

    public override void PatchMod()
    {
        Msl.AddMenu(
            "DevTools",
            new UIComponent(
                name: "Debug print logger", associatedGlobal: "log_debug_print",
                UIComponentType.CheckBox, 0)
        );

        DebugPatching();
        ExportTable("gml_GlobalScript_table_items");
        ExportTable("gml_GlobalScript_table_curses");
        ExportTable("gml_GlobalScript_table_weapons");
        ExportTable("gml_GlobalScript_table_armor");
        ExportTable("gml_GlobalScript_table_equipment");
        ExportTable("gml_GlobalScript_table_lines");
        ExportTable("gml_GlobalScript_table_attributes");

        // Console

        Msl.LoadAssemblyAsString("gml_Object_o_console_controller_Draw_64")
            .MatchFromUntil(":[0]", "exit.i")
            .ReplaceBy("")
            .Save();

        Msl.LoadGML("gml_Object_o_console_controller_KeyRelease_113")
            .MatchAll()
            .InsertBelow(@"
                global.consoleEnabled = !global.consoleEnabled
                visible = !visible
                if (global.consoleEnabled)
                    event_perform(ev_draw, ev_gui)
                scr_console_commands_map(global.consoleEnabled)
                keyboard_string = """"")
            .Save();

        PatchCommands();

        // Msl.LoadAssemblyAsString("gml_Object_o_console_controller_Step_0")
        //     .MatchFrom(":[4]")
        //     .InsertBelow("pushbltn.v builtin.keyboard_string\ncall.i gml_Script_scr_actionsLogUpdate(argc=1)")
        //     .Save();

        Msl.LoadGML("gml_GlobalScript_scr_console_commands_map")
            .MatchFromUntil("function scr_console_commands_map()", "{")
            .InsertBelow(ModFiles, "commands.gml")
            .Save();

        Msl.LoadGML("gml_GlobalScript_scr_console_command")
            .MatchFromUntil("function scr_console_command(argument0)", "{")
            .InsertBelow(ModFiles, "executes.gml")
            .Save();

        Msl.LoadAssemblyAsString("gml_GlobalScript_scr_console_output_list")
            .MatchAll()
            .ReplaceBy(ModFiles, "scr_console_output_list.gml")
            .Save();
    }

    private void PatchCommands()
    {
        // Commands

        Msl.LoadGML("gml_GlobalScript_scr_console_help")
            .MatchFromUntil("function scr_console_help()", "}")
            .ReplaceBy(ModFiles, "scr_console_help.gml")
            .Save();
        
        Msl.LoadGML("gml_GlobalScript_scr_console_drop")
            .MatchFromUntil("function scr_console_drop()", "}")
            .ReplaceBy(ModFiles, "scr_console_drop.gml")
            .Save();
        
        Msl.LoadGML("gml_GlobalScript_scr_console_time_change")
            .MatchFromUntil("function scr_console_time_change", "}")
            .ReplaceBy(ModFiles, "scr_console_time_change.gml")
            .Save();
        
        Msl.AddFunction(ModFiles.GetCode("scr_console_respec.gml"), "scr_console_respec");

        Msl.LoadGML("gml_GlobalScript_scr_console_globalset")
            .MatchFromUntil("function scr_console_globalset()", "}")
            .ReplaceBy(ModFiles, "scr_console_globalset.gml")
            .Save();
        
        Msl.LoadGML("gml_GlobalScript_scr_console_minimap_visible")
            .MatchFromUntil("function scr_console_minimap_visible()", "}")
            .ReplaceBy(ModFiles, "scr_console_minimap_visible.gml")
            .Save();
        
        Msl.LoadGML("gml_GlobalScript_scr_console_debugmap")
            .MatchFromUntil("function scr_console_debugmap()", "}")
            .ReplaceBy(ModFiles, "scr_console_debugmap.gml")
            .Save();

        Msl.LoadGML("gml_GlobalScript_scr_console_room")
            .MatchFromUntil("function scr_console_room()", "}")
            .ReplaceBy(ModFiles, "scr_console_room.gml")
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

        Msl.LoadAssemblyAsString("gml_GlobalScript_neoconsole_api")
            .MatchFromUntil("> gml_Script_print (locals=3, argc=0)", ":[145]")
            .InsertBelow(@"push.s ""print: ""@121330
pop.v.s local._str
pushi.e 0
pop.v.i local.i

:[1002]
pushloc.v local.i
pushbltn.v builtin.argument_count
cmp.v.v LT
bf [1004]

:[1003]
push.v local._str
push.s "" ""@2874
pushi.e -15
pushloc.v local.i
conv.v.i
push.v [array]self.argument
call.i string(argc=1)
add.v.s
add.v.v
pop.v.v local._str
push.v local.i
push.e 1
add.i.v
pop.v.v local.i
b [1002]

:[1004]
pushloc.v local._str
call.i gml_Script_scr_msl_log(argc=1)
popz.v");
    }


    private static void ExportTable(string table)
    {
        DirectoryInfo dir = new("ModSources/Z-DevTools/tmp");
        if (!dir.Exists) dir.Create();
        List<string>? lines = ModLoader.GetTable(table);
        if (lines != null)
        {
            File.WriteAllLines(
                Path.Join(dir.FullName, Path.DirectorySeparatorChar.ToString(), table + ".tsv"),
                lines.Select(x => string.Join('\t', x.Split(';')))
            );
        }
    }
}
