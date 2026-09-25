// MCP server state and the base64 lookup table, then listens on the default
// port. Called at the end of the o_devconsole Create event.
function scr_devtools_mcp_init()
{
    var _alpha = buffer_create(64, buffer_fixed, 1);
    var _v = 0;
    _mcp_alive = true;
    _mcp_server = -1;
    _mcp_port = 8765;
    // per client socket: receive buffer, bytes buffered, 100-continue sent
    _mcp_clients = ds_map_create();
    _mcp_lens = ds_map_create();
    _mcp_cont = ds_map_create();
    // pending screenshot: client socket or -1, JSON id, max width, start time
    _mcp_shot_sock = -1;
    _mcp_shot_idj = "null";
    _mcp_shot_maxw = 1280;
    _mcp_shot_t = 0;
    // mcp start/stop typed as a command, applied by scr_devtools_mcp_tick
    _mcp_pending = "";
    _mcp_pending_port = 8765;
    _mcp_exec_error = false;
    // console_execute output capture, read by scr_console_output_list
    global._mcp_capturing = false;
    global._mcp_capture = -1;
    global._mcp_capture_col = -1;
    // 12-bit value to its two base64 characters, one u16 per entry
    buffer_write(_alpha, buffer_text, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/");
    _mcp_b64tab = buffer_create(8192, buffer_fixed, 1);
    for (_v = 0; _v < 4096; _v++)
        buffer_poke(_mcp_b64tab, _v << 1, buffer_u16, buffer_peek(_alpha, _v >> 6, buffer_u8) | (buffer_peek(_alpha, _v & 63, buffer_u8) << 8));
    buffer_delete(_alpha);
    scr_devtools_mcp_start(_mcp_port);
}
