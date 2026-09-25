// Drops the first n bytes of a client's receive buffer - a request that was
// just parsed - and moves any pipelined remainder to the front.
function scr_devtools_mcp_consume()
{
    var _sock = argument[0];
    var _n = argument[1];
    var _buf = ds_map_find_value(_mcp_clients, _sock);
    var _rest = ds_map_find_value(_mcp_lens, _sock) - _n;
    var _tmp = -1;
    if (_rest <= 0)
    {
        _rest = 0;
        // hand the memory back after a large request
        if (buffer_get_size(_buf) > 65536)
            buffer_resize(_buf, 4096);
    }
    else
    {
        _tmp = buffer_create(_rest, buffer_fixed, 1);
        buffer_copy(_buf, _n, _rest, _tmp, 0);
        buffer_copy(_tmp, 0, _rest, _buf, 0);
        buffer_delete(_tmp);
    }
    ds_map_replace(_mcp_lens, _sock, _rest);
    // the next request gets its own 100-continue
    ds_map_replace(_mcp_cont, _sock, 0);
}
