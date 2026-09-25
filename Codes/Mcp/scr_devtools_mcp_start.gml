// Opens the listening socket on port argument[0], closing any previous
// server first. Returns true when the server is listening.
function scr_devtools_mcp_start()
{
    scr_devtools_mcp_stop(false);
    _mcp_port = argument[0];
    _mcp_server = network_create_server_raw(network_socket_tcp, _mcp_port, 8);
    if (_mcp_server < 0)
    {
        _mcp_server = -1;
        scr_console_output_list("[MCP] cannot listen on port " + string(_mcp_port) + " - is it already in use? Try 'mcp start <port>'.", red);
        return false;
    }
    scr_console_output_list("[MCP] listening on http://127.0.0.1:" + string(_mcp_port) + "/mcp", gray);
    return true;
}
