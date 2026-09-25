// o_devconsole Destroy: closes the server and frees the MCP state.
function scr_devtools_mcp_cleanup()
{
    scr_devtools_mcp_stop(false);
    _mcp_alive = false;
    ds_map_destroy(_mcp_clients);
    ds_map_destroy(_mcp_lens);
    ds_map_destroy(_mcp_cont);
    if (buffer_exists(_mcp_b64tab))
        buffer_delete(_mcp_b64tab);
    global._mcp_capturing = false;
}
