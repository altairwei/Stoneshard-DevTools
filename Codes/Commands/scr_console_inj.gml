function scr_console_inj()
{
    var _argumentsArray = argument[0]
    var _argumentsArrayLength = array_length(_argumentsArray)
    if (_argumentsArray[0] == "" || _argumentsArrayLength < 2 || _argumentsArrayLength > 3)
    {
        scr_console_output_list("invalid argument number", red)
        return;
    }
    var _limb = string_lower(_argumentsArray[0])
    switch _limb
    {
        case "rleg":
            _limb = "rlegs"
            break
        case "lleg":
            _limb = "legs"
            break
        case "torso":
            _limb = "tors"
            break
    }
    if (_limb != "head" && _limb != "tors" && _limb != "legs" && _limb != "rlegs" && _limb != "lhand" && _limb != "rhand")
    {
        scr_console_output_list(("limb " + _limb + " not found"), red)
        return;
    }
    var _mode = string_lower(_argumentsArray[1])
    if (_mode != "inj" && _mode != "blood")
    {
        scr_console_output_list(("mode " + _mode + " not found"), red)
        return;
    }
    var _amount = 0
    if (_mode == "blood")
        _amount = 1
    if (_argumentsArrayLength > 2)
    {
        _amount = round(scr_console_string_to_real_with_nan(_argumentsArray[2]))
        if (is_nan(_amount) || _amount < 0)
        {
            scr_console_output_list("amount should be a number greater than 0", red)
            return;
        }
    }
    if (!instance_exists(o_player))
    {
        scr_console_output_list("player not found", red)
        return;
    }
    if (_mode == "inj")
    {
        // scr_injuryChange takes an instance and applies a delta clamped to
        // [0, injury_point] - convert the wanted value into a delta
        var _player = instance_find(o_player, 0)
        var _current = ds_map_find_value(_player.Body_Parts_map, _limb)
        if (is_undefined(_current))
        {
            scr_console_output_list(("limb " + _limb + " not found"), red)
            return;
        }
        scr_injuryChange(_player, _limb, (_amount - _current))
        scr_console_output_list(("Bodypart " + _limb + " set to " + string(ds_map_find_value(_player.Body_Parts_map, _limb)) + "%"), green)
    }
    else
    {
        // bleed buffs are o_db_bleed_<limb> assets; delegate to the buff
        // command which prefixes the id with "o_" and applies it to the player
        var _buffArguments = ["db_bleed_" + _limb, string(_amount)]
        scr_console_buff(_buffArguments)
    }
}
