function scr_console_getseed()
{
    var _argumentsArray = argument[0]
    if (_argumentsArray[0] != "" || array_length(_argumentsArray) > 1)
    {
        scr_console_output_list("invalid argument number", red)
        return;
    }
    // variable_global_exists guard: global.seed is created during world
    // generation and does not exist in the menu room.
    if (!variable_global_exists("seed"))
    {
        scr_console_output_list("global.seed doesn't exist", red)
        return;
    }
    scr_console_output_list(string(global.seed), green)
}
