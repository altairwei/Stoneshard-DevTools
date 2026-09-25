// Takes the pending MCP screenshot and sends the tool result. Called from
// Draw GUI End, once the frame is complete. screen_save gives the window
// image; it is redrawn opaque - and downscaled when max_width asks for it -
// then sent as base64 PNG inside the JSON body.
function scr_devtools_mcp_screenshot()
{
    var _sock = _mcp_shot_sock;
    var _idj = _mcp_shot_idj;
    var _maxw = _mcp_shot_maxw;
    var _full = "devtools_mcp_full.png";
    var _file = "devtools_mcp_screenshot.png";
    var _spr = -1;
    var _w = 0;
    var _h = 0;
    var _tw = 0;
    var _th = 0;
    var _scaled = false;
    var _surf = -1;
    var _png = -1;
    var _pn = 0;
    var _body = -1;
    _mcp_shot_sock = -1;
    if (!ds_map_exists(_mcp_clients, _sock))
        return;
    if (file_exists(_full))
        file_delete(_full);
    if (file_exists(_file))
        file_delete(_file);
    screen_save(_full);
    if (file_exists(_full))
        _spr = sprite_add(_full, 1, false, false, 0, 0);
    if (!sprite_exists(_spr))
    {
        if (file_exists(_full))
            file_delete(_full);
        scr_devtools_mcp_tool_reply(_sock, _idj, "screenshot failed: screen_save produced no image", true);
        scr_devtools_mcp_http(_sock);
        return;
    }
    _w = sprite_get_width(_spr);
    _h = sprite_get_height(_spr);
    _tw = _w;
    _th = _h;
    if (_maxw > 0 && _maxw < _w)
    {
        _tw = _maxw;
        _th = max(1, floor(_h * _maxw / _w + 0.5));
        _scaled = true;
    }
    _surf = surface_create(_tw, _th);
    if (!surface_exists(_surf))
    {
        sprite_delete(_spr);
        file_delete(_full);
        scr_devtools_mcp_tool_reply(_sock, _idj, "screenshot failed: could not create a " + string(_tw) + "x" + string(_th) + " surface", true);
        scr_devtools_mcp_http(_sock);
        return;
    }
    // opaque copy: alpha writes off over an opaque black clear, like the
    // vanilla o_screenshotSaver; bilinear filtering only when downscaling
    surface_set_target(_surf);
    draw_clear_alpha(c_black, 1);
    gpu_push_state();
    gpu_set_blendenable(false);
    gpu_set_colorwriteenable(true, true, true, false);
    gpu_set_tex_filter(_scaled);
    draw_sprite_ext(_spr, 0, 0, 0, _tw / _w, _th / _h, 0, c_white, 1);
    gpu_pop_state();
    surface_reset_target();
    surface_save(_surf, _file);
    surface_free(_surf);
    sprite_delete(_spr);
    file_delete(_full);
    if (file_exists(_file))
        _png = buffer_load(_file);
    if (_png < 0)
    {
        scr_devtools_mcp_tool_reply(_sock, _idj, "screenshot failed: could not write the PNG", true);
        scr_devtools_mcp_http(_sock);
        return;
    }
    _pn = buffer_get_size(_png);
    _body = buffer_create(floor(_pn / 3) * 4 + 2048, buffer_grow, 1);
    buffer_write(_body, buffer_text, "{\"jsonrpc\":\"2.0\",\"id\":" + _idj + ",\"result\":{\"content\":[{\"type\":\"image\",\"mimeType\":\"image/png\",\"data\":\"");
    scr_devtools_mcp_base64(_png, _pn, _body);
    buffer_delete(_png);
    buffer_write(_body, buffer_text, "\"},{\"type\":\"text\",\"text\":" + scr_devtools_mcp_json_str("Screenshot " + string(_tw) + "x" + string(_th) + ", captured at " + string(_w) + "x" + string(_h) + ". PNG saved to " + game_save_id + _file) + "}],\"isError\":false}}");
    scr_devtools_mcp_send(_sock, "200 OK", "Content-Type: application/json\r\n", _body, buffer_tell(_body));
    buffer_delete(_body);
    scr_devtools_mcp_http(_sock);
}
