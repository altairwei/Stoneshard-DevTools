// Copyright (C)
// See LICENSE file for extended copyright information.
// This file is part of the repository from .

using ModShardLauncher;
using ModShardLauncher.Mods;

namespace EnableConsole;
public class EnableConsole : Mod
{
    public override string Author => "Altair";
    public override string Name => "Enable Console";
    public override string Description => "Enable internal console.";
    public override string Version => "1.0.0.0";
    public override string TargetVersion => "0.8.2.10";

    public override void PatchMod()
    {
        Msl.LoadAssemblyAsString("gml_Object_o_console_controller_Draw_64")
            .MatchFromUntil(":[0]", "exit.i")
            .ReplaceBy("")
            .Save();
        
        // Msl.LoadAssemblyAsString("gml_GlobalScript_neoconsole_api")
        //     .MatchFrom("pop.v.b global.consoleEnabled")
        //     .InsertAbove("pushi.e 1")
        //     .Save();

        // Msl.LoadAssemblyAsString("gml_Object_o_dataLoader_Other_10")
        //     .MatchFrom("pop.v.b global.consoleEnabled")
        //     .InsertAbove("pushi.e 1")
        //     .Save();

        Msl.LoadGML("gml_Object_o_console_controller_KeyRelease_113")
            .MatchAll()
            .InsertBelow(@"
                global.consoleEnabled = !global.consoleEnabled
                visible = !visible
                if (global.consoleEnabled)
                    event_perform(ev_draw, ev_gui)
                scr_console_commands_map(global.consoleEnabled)")
            .Save();

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

        Msl.LoadGML("gml_GlobalScript_scr_console_help")
            .MatchFromUntil("function scr_console_help()", "{")
            .InsertBelow(ModFiles, "scr_console_help.gml")
            .Save();
    }
}
