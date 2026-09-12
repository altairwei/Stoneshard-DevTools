function scr_console_globalset()
{
    // 模式1: globalset x y       - 相对当前位置偏移 x,y 世界格
    // 模式2: globalset <location> - 按地名直跳（scr_glmap_getLocation）
    // 模式3: globalset mouse      - 传送到鼠标指向的世界格（需打开世界地图，
    //                               读取地图交互控制器的聚焦框格位，见文件尾 mode3 注释）
    var _argumentsArray = argument[0]
    var _argumentsArrayLength = array_length(_argumentsArray)
    if (_argumentsArray[0] == "" || _argumentsArrayLength > 2)
    {
        scr_console_output_list("invalid argument number", red)
        return;
    }

    var _terrainWidth = global.worldWidth - 1
    var _terrainHeight = global.worldHeight - 1

    // 模式3: 鼠标指向的世界格。不自己换算坐标——直接读地图交互控制器
    // 每帧维护的聚焦框格位 highlightGridX/Y（o_globalmapInteractiveBase_Step_1，
    // 用户看到的聚焦框就是它），所见即所得，平移/缩放/容器边距全部免算。
    if (_argumentsArrayLength == 1 && scr_stringTransform(_argumentsArray[0]) == "mouse")
    {
        if (!instance_exists(o_globalmap))
        {
            scr_console_output_list("open the global map first", red)
            return;
        }
        var _mouseGridX = -1
        var _mouseGridY = -1
        with (o_globalmap)
        {
            var _interactive = interactive;
            if (_interactive != -4 && instance_exists(_interactive))
            {
                _mouseGridX = _interactive.highlightGridX;
                _mouseGridY = _interactive.highlightGridY;
            }
        }
        if (_mouseGridX < 0 || _mouseGridY < 0)
        {
            scr_console_output_list("point at map terrain first", red)
            return;
        }
        if (_mouseGridX > _terrainWidth || _mouseGridY > _terrainHeight)
        {
            scr_console_output_list("mouse is outside the map", red)
            return;
        }
        with (o_controller)
            event_user(15)
        global.playerGridX = _mouseGridX
        global.playerGridY = _mouseGridY
        global.floor_counter = 0
        scr_atr_set_simple("localX", 2288 / 2)
        scr_atr_set_simple("localY", 2288 / 2)
        scr_smoothRoomChange(scr_globaltile_get_room(), [4])
        scr_console_output_list(("Player teleporting (X: " + string(global.playerGridX) + " Y: " + string(global.playerGridY) + ")"), green)
        return;
    }

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
