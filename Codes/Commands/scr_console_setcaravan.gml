function scr_console_setcaravan()
{
    var _argumentsArray = argument[0]
    if (_argumentsArray[0] == "" || array_length(_argumentsArray) > 2)
    {
        scr_console_output_list("invalid argument number", red)
        return;
    }
    var _x = round(scr_console_string_to_real_with_nan(_argumentsArray[0]))
    var _y = round(scr_console_string_to_real_with_nan(_argumentsArray[1]))
    if (is_nan(_x) || is_nan(_y))
    {
        scr_console_output_list("coordinates should be numbers", red)
        return;
    }
    // scr_glmap_isInsideMapCoord safely returns false when the world map is
    // not generated yet (its globals are undefined), which lands here too
    if (!scr_glmap_isInsideMapCoord(_x, _y))
    {
        scr_console_output_list(("can't set caravan to coords " + string(_x) + ":" + string(_y)), red)
        return;
    }
    scr_caravanPositionSet(_x, _y)
    scr_console_output_list(("Set caravan to coords " + string(_x) + ":" + string(_y)), green)
}
