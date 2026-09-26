// Forgets a client: frees its receive buffer and per-socket state, cancels
// its pending screenshot or game_wait. close = true also closes the socket -
// false when the peer has already disconnected.
function scr_devtools_mcp_drop()
{
    var _sock = argument[0];
    var _buf = -1;
    if (ds_map_exists(_mcp_clients, _sock))
    {
        _buf = ds_map_find_value(_mcp_clients, _sock);
        if (buffer_exists(_buf))
            buffer_delete(_buf);
        ds_map_delete(_mcp_clients, _sock);
    }
    ds_map_delete(_mcp_lens, _sock);
    ds_map_delete(_mcp_cont, _sock);
    if (_mcp_shot_sock == _sock)
        _mcp_shot_sock = -1;
    if (_mcp_wait_sock == _sock)
        _mcp_wait_sock = -1;
    if (argument[1])
        network_destroy(_sock);
}
