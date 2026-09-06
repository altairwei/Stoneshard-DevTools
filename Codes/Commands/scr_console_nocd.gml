function scr_console_nocd()
{
    var _argumentsArray = argument[0]
    if (_argumentsArray[0] != "")
    {
        scr_console_output_list("invalid argument number", red)
        return;
    }
    if global.is_nocd
    {
        global.is_nocd = 0
        scr_console_output_list("nocd mode is OFF", red)
    }
    else
    {
        global.is_nocd = 1
        scr_console_output_list("nocd mode is ON", green)
    }
}
