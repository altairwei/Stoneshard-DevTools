function scr_console_sethp()
{
    var _argumentsArray = argument[0]
    if (_argumentsArray[0] == "" || array_length(_argumentsArray) > 1)
    {
        scr_console_output_list("invalid argument number", red)
        return;
    }
    var _value = round(scr_console_string_to_real_with_nan(_argumentsArray[0]))
    if (is_nan(_value))
    {
        scr_console_output_list("amount should be a number", red)
        return;
    }
    if (_value < 0)
    {
        scr_console_output_list("amount should be greater than 0", red)
        return;
    }
    if (!instance_exists(o_player))
    {
        scr_console_output_list("o_player doesn't exist", red)
        return;
    }
    with (o_player)
    {
        var _maxHP = round(((max_hp * Health_Threshold) / 100))
        if (_value > _maxHP)
            _value = _maxHP
        HP = _value
    }
    scr_console_output_list(("Set player's HP to " + string(_value)), green)
}
