// Step housekeeping: applies a deferred mcp start/stop - deferred so the
// reply to an MCP client that sent the command still goes out - and times
// out a screenshot the game never rendered.
function scr_devtools_mcp_tick()
{
    var _sock = -1;
    if (_mcp_pending == "stop")
    {
        _mcp_pending = "";
        scr_devtools_mcp_stop(true);
    }
    else if (_mcp_pending == "start")
    {
        _mcp_pending = "";
        scr_devtools_mcp_start(_mcp_pending_port);
    }
    if (_mcp_shot_sock != -1)
    {
        if (get_timer() - _mcp_shot_t > 3000000)
        {
            _sock = _mcp_shot_sock;
            _mcp_shot_sock = -1;
            if (ds_map_exists(_mcp_clients, _sock))
            {
                scr_devtools_mcp_tool_reply(_sock, _mcp_shot_idj, "screenshot timed out: the game did not render a frame within 3 seconds - is the window minimized?", true);
                scr_devtools_mcp_http(_sock);
            }
        }
    }
}
