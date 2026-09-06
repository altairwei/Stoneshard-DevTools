function scr_console_change()
{
    var _argumentsArray = argument[0]
    if (_argumentsArray[0] == "" || array_length(_argumentsArray) != 2)
    {
        scr_console_output_list("invalid argument number", red)
        return;
    }
    var _attributeName = _argumentsArray[0]
    var _amount = scr_console_string_to_real_with_nan(_argumentsArray[1])
    if (is_nan(_amount) || _amount < 0)
    {
        scr_console_output_list("amount should be greater than 0", red)
        return;
    }
    var _valid = 0
    switch _attributeName
    {
        case "Hunger":
        case "hunger":
            _attributeName = "Hunger"
            _valid = 1
            break
        case "Thirsty":
        case "thirsty":
            _attributeName = "Thirsty"
            _valid = 1
            break
        case "Intoxication":
        case "intoxication":
            _attributeName = "Intoxication"
            _valid = 1
            break
        case "Pain":
        case "pain":
            _attributeName = "Pain"
            _valid = 1
            break
        case "Morale":
        case "morale":
            _attributeName = "Morale"
            _valid = 1
            break
        case "Sanity":
        case "sanity":
            _attributeName = "Sanity"
            _valid = 1
            break
        case "Immunity":
        case "immunity":
            _attributeName = "Immunity"
            _valid = 1
            break
        case "Fatigue":
        case "fatigue":
            _attributeName = "Fatigue"
            _valid = 1
            break
        case "Sleep_Scale":
        case "sleep_scale":
            _attributeName = "Sleep_Scale"
            _valid = 1
            break
    }
    if (_valid)
    {
        if (_amount > 100)
            _amount = 100
        scr_atr_set(_attributeName, _amount)
        scr_console_output_list(("Condition " + _attributeName + " set to " + string(_amount)), green)
    }
    else
        scr_console_output_list(("Condition " + _attributeName + " not found"), red)
}
