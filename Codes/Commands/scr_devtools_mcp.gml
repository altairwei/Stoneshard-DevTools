// mcp [status | start [port] | stop] - controls the built-in MCP server, the
// scr_devtools_mcp_* scripts. start and stop only set a pending action that
// scr_devtools_mcp_tick applies on the next step, so when an MCP client sends
// this command through console_execute its reply still goes out before the
// connection closes.
function scr_devtools_mcp()
{
    var _argumentsArray = argument[0]
    var _count = array_length(_argumentsArray)
    var _sub = string_lower(_argumentsArray[0])
    var _port = 0

    if (_sub == "" || _sub == "status")
    {
        if (_count != 1)
        {
            scr_console_output_list("invalid argument number", red)
            return;
        }
        if (_mcp_server >= 0)
            scr_console_output_list("MCP server listening on http://127.0.0.1:" + string(_mcp_port) + "/mcp - open connections: " + string(ds_map_size(_mcp_clients)), green)
        else
            scr_console_output_list("MCP server stopped - use 'mcp start [port]'", gray)
        return;
    }

    if (_sub == "start")
    {
        if (_count > 2)
        {
            scr_console_output_list("invalid argument number", red)
            return;
        }
        _port = _mcp_port
        if (_count == 2)
        {
            _port = scr_devtools_mcp_uint(_argumentsArray[1])
            if (_port < 1 || _port > 65535)
            {
                scr_console_output_list("port must be a number from 1 to 65535", red)
                return;
            }
        }
        _mcp_pending = "start"
        _mcp_pending_port = _port
        scr_console_output_list("starting MCP server on port " + string(_port) + "...", gray)
        return;
    }

    if (_sub == "stop")
    {
        if (_count != 1)
        {
            scr_console_output_list("invalid argument number", red)
            return;
        }
        if (_mcp_server < 0)
        {
            scr_console_output_list("MCP server is not running", gray)
            return;
        }
        _mcp_pending = "stop"
        scr_console_output_list("stopping MCP server...", gray)
        return;
    }

    scr_console_output_list("unknown subcommand '" + _sub + "' - use status, start or stop", red)
}
