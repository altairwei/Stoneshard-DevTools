// Closes every MCP client and the listening socket. argument[0] true prints
// a console line when a running server was stopped.
function scr_devtools_mcp_stop()
{
    var _k = ds_map_find_first(_mcp_clients);
    var _buf = -1;
    while (!is_undefined(_k))
    {
        _buf = ds_map_find_value(_mcp_clients, _k);
        if (buffer_exists(_buf))
            buffer_delete(_buf);
        network_destroy(_k);
        _k = ds_map_find_next(_mcp_clients, _k);
    }
    ds_map_clear(_mcp_clients);
    ds_map_clear(_mcp_lens);
    ds_map_clear(_mcp_cont);
    _mcp_shot_sock = -1;
    _mcp_wait_sock = -1;
    if (_mcp_server >= 0)
    {
        network_destroy(_mcp_server);
        _mcp_server = -1;
        if (argument[0])
            scr_console_output_list("[MCP] server stopped", gray);
    }
}
