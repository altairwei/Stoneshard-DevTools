function scr_console_atr_set()
{
    var _argumentsArray = argument[0]
    if (_argumentsArray[0] == "" || array_length(_argumentsArray) > 2)
    {
        scr_console_output_list("invalid argument number", red)
        return;
    }
    var _attributeName = _argumentsArray[0]
    var _amount = 1
    var _valid = 0
    switch _attributeName
    {
        case "str":
        case "STR":
        case "strength":
            _attributeName = "STR"
            _valid = 1
            break
        case "agl":
        case "AGL":
        case "agility":
            _attributeName = "AGL"
            _valid = 1
            break
        case "prc":
        case "PRC":
        case "perception":
            _attributeName = "PRC"
            _valid = 1
            break
        case "vit":
        case "VIT":
        case "vitality":
            _attributeName = "Vitality"
            _valid = 1
            break
        case "wil":
        case "WIL":
        case "willpower":
            _attributeName = "WIL"
            _valid = 1
            break
        case "xp":
        case "XP":
            _attributeName = "XP"
            _valid = 1
            break
        case "lvl":
        case "LVL":
        case "level":
            _attributeName = "LVL"
            _valid = 1
            break
        case "sp":
        case "SP":
            _attributeName = "SP"
            _valid = 1
            break
        case "ap":
        case "AP":
            _attributeName = "AP"
            _valid = 1
            break
    }
    if (!_valid && _attributeName != "reset")
    {
        scr_console_output_list(("Attribute " + _attributeName + " not found"), red)
        return;
    }
    if (_attributeName == "reset")
    {
        // NeoConsole notes that reset should restore the character-class
        // defaults; it currently sets stats to 10, level to 1.
        scr_atr_set_simple("STR", 10)
        scr_atr_set_simple("AGL", 10)
        scr_atr_set_simple("PRC", 10)
        scr_atr_set_simple("Vitality", 10)
        scr_atr_set_simple("WIL", 10)
        scr_atr_set_simple("LVL", 1)
        scr_atr_set_simple("XP", 0)
        scr_atr_set("SP", 2)
        scr_atr_set("AP", 0)
        scr_console_output_list("Attributes reset", green)
        return;
    }
    if (array_length(_argumentsArray) > 1)
        _amount = scr_console_string_to_real_with_nan(_argumentsArray[1])
    if (is_nan(_amount) || _amount <= 0)
    {
        scr_console_output_list("amount should be greater than 0", red)
        return;
    }
    // NeoConsole: in the character data map the SP and AP keys are swapped
    // relative to the UI (the displayed skill points live under "AP" and vice
    // versa) - keep the original command's behavior.
    if (_attributeName == "SP")
        scr_atr_set("AP", _amount)
    else if (_attributeName == "AP")
        scr_atr_set("SP", _amount)
    else
        scr_atr_set(_attributeName, _amount)
    scr_console_output_list(("Attribute " + _attributeName + " set to " + string(_amount)), green)
}
