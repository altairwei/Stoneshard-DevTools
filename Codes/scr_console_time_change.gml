function scr_console_time_change()
{
    var _argumentsArray = argument[0]
    var _argumentsArrayLength = array_length(_argumentsArray)
    if (_argumentsArray[0] == "change")
    {
        if (_argumentsArrayLength < 2 || _argumentsArrayLength > 6)
        {
            scr_console_output_list("invalid argument number", red)
            return;
        }
        var _seconds = abs(scr_console_string_to_real_with_nan(_argumentsArray[1]))
        var _minutes = 0
        var _hours = 0
        var _days = 0
        var _months = 0
        if (_argumentsArrayLength > 2)
            _minutes = abs(scr_console_string_to_real_with_nan(_argumentsArray[2]))
        if (_argumentsArrayLength > 3)
            _hours = abs(scr_console_string_to_real_with_nan(_argumentsArray[3]))
        if (_argumentsArrayLength > 4)
            _days = abs(scr_console_string_to_real_with_nan(_argumentsArray[4]))
        if (_argumentsArrayLength > 5)
            _months = abs(scr_console_string_to_real_with_nan(_argumentsArray[5]))
        if (is_nan(_seconds) || is_nan(_minutes) || is_nan(_hours) || is_nan(_days) || is_nan(_months) || _seconds < 0)
        {
            scr_console_output_list("arguments must be a number greater than 0", red)
            return;
        }
        scr_timeUpdate(_seconds, _minutes, _hours, _days, _months)
        scr_console_output_list(("Time changed (seconds +" + string(_seconds) + ", minutes +" + string(_minutes) + ", hours +" + string(_hours) + ", days +" + string(_days) + ", months +" + string(_months) + ")"), green)
    }
    else if (_argumentsArray[0] == "scale")
    {
        if (_argumentsArrayLength != 2)
        {
            scr_console_output_list("invalid argument number", red)
            return;
        }
        var _setScale = scr_console_string_to_real_with_nan(_argumentsArray[1])
        if ((!is_nan(_setScale)) && _setScale > 0)
        {
            var _scale = abs(_setScale)
            global.timeScale = _scale
            scr_console_output_list(("Time scale changed to " + string(_scale)), green)
        }
        else
        {
            scr_console_output_list("scale value should greater than 0", red)
            return;
        }
    }
    else
        scr_console_output_list("wrong time command name", red)
}
