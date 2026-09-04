function scr_console_nodeathmode()
{
    var _argumentsArray = argument[0]
    if (_argumentsArray[0] != "" || array_length(_argumentsArray) > 1)
    {
        scr_console_output_list("invalid argument number", red)
        return;
    }
    if (global.playerNoDeathMode)
    {
        global.playerNoDeathMode = false
        scr_console_output_list("No Death Mode is now OFF", green)
    }
    else
    {
        global.playerNoDeathMode = true
        scr_console_output_list("No Death Mode is now ON", green)
    }
}
