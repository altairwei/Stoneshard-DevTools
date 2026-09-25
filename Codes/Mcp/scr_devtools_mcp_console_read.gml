// The newest n lines of the console output history, whoever printed them -
// oldest first, red lines prefixed with [error].
function scr_devtools_mcp_console_read()
{
    var _size = ds_list_size(output_list);
    var _first = 0;
    var _i = 0;
    var _text = "";
    if (_size == 0)
        return "(console is empty)";
    _first = max(0, _size - argument[0]);
    _i = _first;
    while (_i < _size)
    {
        if (_i > _first)
            _text += "\n";
        if (ds_list_find_value(color_list, _i) == red)
            _text += "[error] ";
        _text += ds_list_find_value(output_list, _i);
        _i++;
    }
    return _text;
}
