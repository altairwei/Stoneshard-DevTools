function scr_console_globalset()
{
    // 添加一个根据名称自动寻找坐标的功能
    var _argumentsArray = argument[0]
    var _argumentsArrayLength = array_length(_argumentsArray)
    if (_argumentsArray[0] == "" || _argumentsArrayLength > 2)
    {
        scr_console_output_list("invalid argument number", red)
        return;
    }

    var _terrainWidth = global.worldWidth - 1
    var _terrainHeight = global.worldHeight - 1

    var _xx = scr_console_string_to_real_with_nan(_argumentsArray[0])
    var _yy = 0
    if (_argumentsArrayLength >= 2)
        _yy = scr_console_string_to_real_with_nan(_argumentsArray[1])

    if (is_nan(_xx) && _argumentsArrayLength == 1)
    {
        var _location = scr_glmap_getLocation(_argumentsArray[0])
        if is_undefined(_location)
        {
            scr_console_output_list("can not find given location", red)
            return;
        }

        with (o_controller)
            event_user(15)

        global.playerGridX = _location.x
        global.playerGridY = _location.y
    }
    else if (is_nan(_xx) || is_nan(_yy))
    {
        scr_console_output_list("coordinate value must be a number", red)
        return;
    }
    else
    {
        _xx = round(_xx)
        _yy = round(_yy)

        with (o_controller)
            event_user(15)

        if ((global.playerGridX + _xx) > _terrainWidth)
            global.playerGridX = _terrainWidth
        else if ((global.playerGridX + _xx) < 0)
            global.playerGridX = 0
        else
            global.playerGridX += _xx

        if ((global.playerGridY + _yy) > _terrainHeight)
            global.playerGridY = _terrainHeight
        else if ((global.playerGridY + _yy) < 0)
            global.playerGridY = 0
        else
            global.playerGridY += _yy
    }

    global.floor_counter = 0

    scr_atr_set_simple("localX", 2288 / 2)
    scr_atr_set_simple("localY", 2288 / 2)
    scr_smoothRoomChange(scr_globaltile_get_room(), [4])

    scr_console_output_list(("Player teleporting (X: " + string(global.playerGridX) + " Y: " + string(global.playerGridY) + ")"), green)
}