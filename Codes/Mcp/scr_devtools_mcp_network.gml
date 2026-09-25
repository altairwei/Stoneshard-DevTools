// Async Networking dispatch for the MCP server; argument[0] is async_load.
// The event fires in every instance with the event, so only sockets of this
// server are handled. Connect/disconnect carry the server socket as id and
// the client as socket; data carries the client socket as id.
function scr_devtools_mcp_network()
{
    var _map = argument[0];
    var _id = 0;
    var _type = 0;
    var _sock = 0;
    var _ip = 0;
    var _src = 0;
    var _size = 0;
    var _buf = -1;
    var _len = 0;
    if (_mcp_server < 0)
        return;
    _id = ds_map_find_value(_map, "id");
    if (is_undefined(_id))
        return;
    _type = ds_map_find_value(_map, "type");
    if (_id == _mcp_server)
    {
        _sock = ds_map_find_value(_map, "socket");
        if (is_undefined(_sock))
            return;
        if (_type == network_type_connect)
        {
            // loopback peers only - the listening socket is bound to all
            // interfaces
            _ip = ds_map_find_value(_map, "ip");
            if (is_string(_ip))
            {
                if (_ip == "127.0.0.1" || _ip == "::1" || _ip == "::ffff:127.0.0.1")
                {
                    ds_map_replace(_mcp_clients, _sock, buffer_create(4096, buffer_grow, 1));
                    ds_map_replace(_mcp_lens, _sock, 0);
                    ds_map_replace(_mcp_cont, _sock, 0);
                    return;
                }
            }
            network_destroy(_sock);
        }
        else if (_type == network_type_disconnect)
            scr_devtools_mcp_drop(_sock, false);
        return;
    }
    if (!ds_map_exists(_mcp_clients, _id))
        return;
    if (_type == network_type_disconnect)
    {
        scr_devtools_mcp_drop(_id, false);
        return;
    }
    if (_type != network_type_data)
        return;
    _src = ds_map_find_value(_map, "buffer");
    _size = ds_map_find_value(_map, "size");
    if (is_undefined(_src) || is_undefined(_size))
        return;
    if (_size <= 0)
        return;
    _buf = ds_map_find_value(_mcp_clients, _id);
    _len = ds_map_find_value(_mcp_lens, _id);
    if (_len + _size > 4194304)
    {
        scr_devtools_mcp_fail(_id, "413 Content Too Large");
        return;
    }
    if (buffer_get_size(_buf) < _len + _size)
        buffer_resize(_buf, max(2 * buffer_get_size(_buf), _len + _size));
    buffer_copy(_src, 0, _size, _buf, _len);
    ds_map_replace(_mcp_lens, _id, _len + _size);
    scr_devtools_mcp_http(_id);
}
