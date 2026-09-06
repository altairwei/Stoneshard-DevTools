function scr_console_rep()
{
    var _argumentsArray = argument[0]
    if (_argumentsArray[0] == "" || array_length(_argumentsArray) > 2)
    {
        scr_console_output_list("invalid argument number", red)
        return;
    }
    var _villageKey = string_lower(_argumentsArray[0])
    var _amount = 0
    if (array_length(_argumentsArray) > 1)
    {
        _amount = round(scr_console_string_to_real_with_nan(_argumentsArray[1]))
        if (is_nan(_amount))
        {
            scr_console_output_list("amount should be a number", red)
            return;
        }
    }
    // reputation helpers need the generated world map; outside of it (prologue
    // grid -4, menu) both the query and the update silently no-op, so refuse
    // upfront instead of printing stale values
    if (global.playerGridX == -4)
    {
        scr_console_output_list("world map is not available", red)
        return;
    }
    var _osbrook = scr_glmap_getLocation("Osbrook")
    var _mannshire = scr_glmap_getLocation("Mannshire")
    var _willow = scr_glmap_getLocation("RottenWillow")
    var _denbrie = scr_glmap_getLocation("Denbrie")
    if (is_undefined(_osbrook) || is_undefined(_mannshire) || is_undefined(_willow) || is_undefined(_denbrie))
    {
        scr_console_output_list("world map data is not available", red)
        return;
    }
    var _villageRep = []
    _villageRep[0] = ["osbrook", _osbrook.x, _osbrook.y]
    _villageRep[1] = ["mannshire", _mannshire.x, _mannshire.y]
    _villageRep[2] = ["willow", _willow.x, _willow.y]
    _villageRep[3] = ["denbrie", _denbrie.x, _denbrie.y]
    var _start = 0
    var _end = 0
    switch _villageKey
    {
        case "osbrook":
            _end = 1
            break
        case "mannshire":
            _start = 1
            _end = 2
            break
        case "willow":
            _start = 2
            _end = 3
            break
        case "denbrie":
            _start = 3
            _end = 4
            break
        case "all":
            _end = 4
            break
        default:
            scr_console_output_list(("village " + _villageKey + " not found"), red)
            return;
    }
    if (_amount != 0)
    {
        for (var _i = _start; _i < _end; _i++)
        {
            scr_globaltile_reputation_update(_amount, _villageRep[_i][1], _villageRep[_i][2])
            scr_console_output_list(("Reputation with " + _villageRep[_i][0] + " changed by " + string(_amount)), green)
        }
    }
    for (_i = _start; _i < _end; _i++)
        scr_console_output_list(("Current reputation with " + _villageRep[_i][0] + " : " + string(scr_globaltile_reputation_get(_villageRep[_i][1], _villageRep[_i][2]))), gray)
}
