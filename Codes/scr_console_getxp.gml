function scr_console_getxp() //gml_Script_scr_console_getxp
{
    var _argumentsArray = argument[0]
    if (_argumentsArray[0] == "" || array_length(_argumentsArray) > 1)
    {
        scr_console_output_list("invalid argument number", red)
        return;
    }

    var _value = round(scr_console_string_to_real_with_nan(_argumentsArray[0]))
    if (is_nan(_value) || _value <= 0)
    {
        scr_console_output_list("amount value should greater than 0", red)
        return;
    }

    with (o_player)
        scr_get_XP(_value)

    scr_console_output_list(("Given " + string(_value) + " xp"), green)
}