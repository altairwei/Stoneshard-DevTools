function scr_console_setmp()
{
    var _argumentsArray = argument[0]
    if (_argumentsArray[0] == "" || array_length(_argumentsArray) > 1)
    {
        scr_console_output_list("invalid argument number", red)
        return;
    }
    var _value = round(scr_console_string_to_real_with_nan(_argumentsArray[0]))
    if (is_nan(_value) || _value <= 1)
    {
        scr_console_output_list("amount should be greater than 1", red)
        return;
    }
    if (!instance_exists(o_player))
    {
        scr_console_output_list("o_player doesn't exist", red)
        return;
    }
    with (o_player)
    {
        if (_value > max_mp)
            _value = max_mp
        MP = _value
    }
    scr_console_output_list(("Set player's MP to " + string(_value)), green)
}
