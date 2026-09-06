function scr_console_killall()
{
    var _argumentsArray = argument[0]
    if (_argumentsArray[0] != "" || array_length(_argumentsArray) > 1)
    {
        scr_console_output_list("invalid argument number", red)
        return;
    }
    var _count = instance_number(o_enemy)
    if (_count > 0)
    {
        with (o_enemy)
            HP = 0
        scr_console_output_list(("Killed " + string(_count) + " creatures"), green)
    }
    else
        scr_console_output_list("There is no enemy to kill", gray)
}
