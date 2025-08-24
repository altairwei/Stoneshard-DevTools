function scr_console_export()
{
    var _argumentsArray = argument[0]
    var _argumentsArrayLength = array_length(_argumentsArray)
    if (_argumentsArrayLength < 1)
    {
        scr_console_output_list("invalid argument number", red)
        return;
    }

    var _table_name = _argumentsArray[0]

    var _delimiter = ";"
    if (_argumentsArrayLength >= 2)
        _delimiter = _argumentsArray[1]

    var _func = asset_get_index(_table_name)
    if (_func == -1)
    {
        scr_console_output_list("can not find given table", red)
        return;
    }

    var _file_name = get_save_filename("*", _table_name)
    var _file = file_text_open_write(_file_name)

    if (_file == -1)
    {
        scr_console_output_list("can not write to file", red)
        return;
    }

    var _array = script_execute(_func)

    for (var i = 0; i < array_length(_array); i++)
    {
        var _line = _array[i]
        var _record = string_split(_line, ";")
        file_text_write_string(_file, string_join_ext(_delimiter, _record))
        file_text_writeln(_file)
    }

    file_text_close(_file)
    scr_console_output_list(string_concat(_table_name, " has been saved to ", _file_name), green)
}
