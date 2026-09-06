function scr_console_boost()
{
    var _argumentsArray = argument[0]
    if (_argumentsArray[0] == "" || array_length(_argumentsArray) > 3)
    {
        scr_console_output_list("invalid argument number", red)
        return;
    }
    var _attributeName = _argumentsArray[0]
    var _amount = 0
    var _duration = 1
    if (array_length(_argumentsArray) > 1)
        _amount = scr_console_string_to_real_with_nan(_argumentsArray[1])
    if (array_length(_argumentsArray) > 2)
        _duration = scr_console_string_to_real_with_nan(_argumentsArray[2])
    if (is_nan(_amount))
    {
        scr_console_output_list("amount should be a number", red)
        return;
    }
    if (is_nan(_duration) || _duration < 1)
    {
        scr_console_output_list("duration should be greater than 0", red)
        return;
    }
    if (!instance_exists(o_player))
    {
        scr_console_output_list("o_player doesn't exist", red)
        return;
    }
    // NeoConsole validated the attribute name against global.attribute, a
    // registry that 0.9.4.25 does not appear to ship - when it is absent,
    // apply the boost as-is.
    var _valid = true
    if (variable_global_exists("attribute"))
        _valid = !(is_undefined(ds_map_find_value(global.attribute, _attributeName)))
    if (!_valid)
    {
        scr_console_output_list(("Attribute " + _attributeName + " not found"), red)
        return;
    }
    with (scr_temp_incr_atr(_attributeName, _amount, _duration))
        can_save = 0
    scr_console_output_list(("Attribute " + _attributeName + " set to " + string(_amount) + " for " + string(_duration) + " turns"), green)
}
