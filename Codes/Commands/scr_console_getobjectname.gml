function scr_console_getobjectname()
{
    var _argumentsArray = argument[0]
    if (_argumentsArray[0] == "" || array_length(_argumentsArray) > 1)
    {
        scr_console_output_list("invalid argument number", red)
        return;
    }
    // 模式2: 鼠标指向的对象。碰撞检测：取鼠标点上有碰撞掩码的实例
    // （instance_position 会跳过无掩码实例，如 o_devconsole）
    if (scr_stringTransform(_argumentsArray[0]) == "mouse")
    {
        var _target = instance_position(mouse_x, mouse_y, all)
        if (_target == -4)
        {
            scr_console_output_list("no object under the mouse", red)
            return;
        }
        scr_console_output_list(("Object under mouse has name " + object_get_name(_target.object_index) + " (id " + string(_target) + ")"), green)
        return;
    }
    var _id = round(scr_console_string_to_real_with_nan(_argumentsArray[0]))
    if (is_nan(_id) || _id < 0)
    {
        scr_console_output_list("id should be a number greater or equal to 0", red)
        return;
    }
    if (instance_exists(_id))
        scr_console_output_list(("Object with id " + string(_id) + " has name " + object_get_name(_id.object_index)), green)
    else
        scr_console_output_list(("Object with id " + string(_id) + " not found"), red)
}
