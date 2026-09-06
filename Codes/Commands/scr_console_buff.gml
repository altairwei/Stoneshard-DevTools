function scr_console_buff()
{
    var _argumentsArray = argument[0]
    if (_argumentsArray[0] == "" || array_length(_argumentsArray) > 4)
    {
        scr_console_output_list("invalid argument number", red)
        return;
    }

    var _argumentsArrayLength = array_length(_argumentsArray)

    var _buffName = _argumentsArray[0]
    var _steps = 1
    var _tier = 1
    var _target = o_player

    if (_argumentsArrayLength > 1)
    {
        _steps = scr_console_string_to_real_with_nan(_argumentsArray[1])
        if (is_nan(_steps) || _steps < 0)
        {
            scr_console_output_list("steps number must be great 0", red)
            return;
        }
    }

    if (_argumentsArrayLength > 2)
    {
        _tier = scr_console_string_to_real_with_nan(_argumentsArray[2])
        if (is_nan(_tier) || _tier < 0)
        {
            scr_console_output_list("tier number must be great 0", red)
            return;
        }
    }

    if (_argumentsArrayLength > 3)
    {
        _target = _argumentsArray[3]
        switch _target
        {
            case "true":
            case 1:
                _target = collision_point(mouse_x, mouse_y, o_unit, 0, 0)
                break
            case "false":
            case 0:
                _target = o_player
                break
            default:
                scr_console_output_list("target argument must be boolean", red)
                return;
        }

    }
    var _buff = asset_get_index("o_" + _buffName)
    if (!_target)
        scr_console_output_list("target not found", red)
    else if _buff
    {
        if scr_effect_create(_buff, _steps, _target, _target, _tier)
            scr_console_output_list(("Buff '" + _buffName + "' for " + string(_steps) + " steps created"), green)
        else
            scr_console_output_list("Buff not created", red)
    }
    else
        scr_console_output_list("Buff not found", red)
}
