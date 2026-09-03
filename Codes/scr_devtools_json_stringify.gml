function scr_devtools_json_stringify()
{
    var _value = argument[0];
    if (is_undefined(_value))
        return "null"

    if (is_string(_value))
        return scr_devtools_json_escape(_value)

    if (is_bool(_value))
    {
        if (_value)
            return "true"
        return "false"
    }

    if (is_real(_value))
        return string(_value)

    if (is_array(_value))
    {
        var _out = "["
        for (var i = 0; i < array_length(_value); i++)
        {
            if (i > 0)
                _out += ","
            _out += scr_devtools_json_stringify(_value[i])
        }
        return _out + "]"
    }

    if (is_struct(_value))
    {
        var _names = variable_struct_get_names(_value)
        var _out = "{"
        for (var i = 0; i < array_length(_names); i++)
        {
            if (i > 0)
                _out += ","
            _out += scr_devtools_json_escape(_names[i]) + ":" + scr_devtools_json_stringify(variable_struct_get(_value, _names[i]))
        }
        return _out + "}"
    }

    // methods and other exotic values are not serialized
    return "\"<unsupported>\""
}
