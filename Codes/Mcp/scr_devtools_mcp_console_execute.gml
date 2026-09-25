// Runs one console command line exactly like pressing Enter in the console -
// history entry, echo line, dispatch - while scr_console_output_list copies
// every printed line into capture lists. Returns the printed lines joined
// with newlines, without the echo; lines printed in red get an [error]
// prefix and set _mcp_exec_error.
function scr_devtools_mcp_console_execute()
{
    var _cmd = argument[0];
    var _cap = ds_list_create();
    var _capc = ds_list_create();
    var _text = "";
    var _err = false;
    var _i = 1;
    var _n = 0;
    global._mcp_capture = _cap;
    global._mcp_capture_col = _capc;
    global._mcp_capturing = true;
    scr_devconsole_execute(_cmd);
    global._mcp_capturing = false;
    _n = ds_list_size(_cap);
    // line 0 is the echo of the command line itself
    while (_i < _n)
    {
        if (_i > 1)
            _text += "\n";
        if (ds_list_find_value(_capc, _i) == red)
        {
            _text += "[error] ";
            _err = true;
        }
        _text += ds_list_find_value(_cap, _i);
        _i++;
    }
    ds_list_destroy(_cap);
    ds_list_destroy(_capc);
    if (_text == "")
        _text = "(no output)";
    _mcp_exec_error = _err;
    return _text;
}
