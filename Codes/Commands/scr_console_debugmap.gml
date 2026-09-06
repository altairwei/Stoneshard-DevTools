function scr_console_debugmap()
{
    if (!variable_global_exists("globalmapDebug"))
        global.globalmapDebug = 0
    global.globalmapDebug = (!global.globalmapDebug)
    if global.globalmapDebug
        scr_console_output_list("Map debug is on", green)
    else
        scr_console_output_list("Map debug is off", red)
}
