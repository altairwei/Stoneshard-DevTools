function scr_console_lvl()
{
    var _argumentsArray = argument[0]
    if (_argumentsArray[0] == "" || array_length(_argumentsArray) != 1)
    {
        scr_console_output_list("invalid argument number", red)
        return;
    }
    var _level = round(scr_console_string_to_real_with_nan(_argumentsArray[0]))
    if (is_nan(_level) || _level < 1 || _level > 30)
    {
        scr_console_output_list("level should be between 1 and 30", red)
        return;
    }
    // Delegates to the setatr implementation: scr_console_atr_set expects the
    // argument-array convention (argument[0] = args array), so pass one.
    scr_console_atr_set(["lvl", string(_level)])
}
