// tools/call: runs one tool. argument[0] socket, argument[1] JSON id text,
// argument[2] params map or -1. The screenshot reply is deferred to Draw GUI
// End, where the frame is complete.
function scr_devtools_mcp_tools_call()
{
    var _sock = argument[0];
    var _idj = argument[1];
    var _params = argument[2];
    var _name = 0;
    var _args = -1;
    var _v = 0;
    var _cmd = "";
    var _text = "";
    var _n = 0;
    if (_params != -1)
    {
        _name = ds_map_find_value(_params, "name");
        if (ds_map_exists(_params, "arguments"))
        {
            if (ds_map_is_map(_params, "arguments"))
                _args = ds_map_find_value(_params, "arguments");
        }
    }
    if (!is_string(_name))
    {
        scr_devtools_mcp_reply_error(_sock, "200 OK", _idj, -32602, "Invalid params: tools/call needs a tool name");
        return;
    }
    if (_name == "console_execute")
    {
        _v = 0;
        if (_args != -1)
            _v = ds_map_find_value(_args, "command");
        if (!is_string(_v))
        {
            scr_devtools_mcp_tool_reply(_sock, _idj, "missing string argument 'command'", true);
            return;
        }
        _cmd = scr_devtools_mcp_trim(string_replace_all(_v, chr(9), " "));
        if (_cmd == "")
        {
            scr_devtools_mcp_tool_reply(_sock, _idj, "empty command - try 'help'", true);
            return;
        }
        if (string_pos(chr(10), _cmd) > 0 || string_pos(chr(13), _cmd) > 0)
        {
            scr_devtools_mcp_tool_reply(_sock, _idj, "command must be a single line - call console_execute once per command", true);
            return;
        }
        _text = scr_devtools_mcp_console_execute(_cmd);
        // the command may have destroyed the console or closed this client
        if (!_mcp_alive)
            return;
        if (!ds_map_exists(_mcp_clients, _sock))
            return;
        scr_devtools_mcp_tool_reply(_sock, _idj, _text, _mcp_exec_error);
        return;
    }
    if (_name == "console_read")
    {
        _n = 50;
        if (_args != -1)
        {
            _v = ds_map_find_value(_args, "lines");
            if (is_numeric(_v))
                _n = max(1, min(1000, floor(real(_v))));
        }
        scr_devtools_mcp_tool_reply(_sock, _idj, scr_devtools_mcp_console_read(_n), false);
        return;
    }
    if (_name == "screenshot")
    {
        if (_mcp_shot_sock != -1)
        {
            scr_devtools_mcp_tool_reply(_sock, _idj, "another screenshot is in progress - try again", true);
            return;
        }
        _n = 1280;
        if (_args != -1)
        {
            _v = ds_map_find_value(_args, "max_width");
            if (is_numeric(_v))
                _n = max(0, floor(real(_v)));
        }
        // answered by scr_devtools_mcp_screenshot from Draw GUI End, or by
        // the timeout in scr_devtools_mcp_tick
        _mcp_shot_sock = _sock;
        _mcp_shot_idj = _idj;
        _mcp_shot_maxw = _n;
        _mcp_shot_t = get_timer();
        return;
    }
    scr_devtools_mcp_reply_error(_sock, "200 OK", _idj, -32602, "Unknown tool: " + _name);
}
