// Parses the buffered HTTP/1.1 requests of one client and answers each one -
// loops while complete requests are waiting. argument[0] socket.
function scr_devtools_mcp_http()
{
    var _sock = argument[0];
    var _buf = -1;
    var _len = 0;
    var _i = 0;
    var _lim = 0;
    var _hend = -1;
    var _head = "";
    var _line = "";
    var _rest = "";
    var _p = 0;
    var _method = "";
    var _target = "";
    var _key = "";
    var _val = "";
    var _clen = 0;
    var _bad = false;
    var _te = false;
    var _host = "";
    var _origin = "";
    var _hasOrigin = false;
    var _expect = "";
    var _ctype = "";
    var _total = 0;
    var _tmp = -1;
    var _body = "";
    while (true)
    {
        if (!_mcp_alive)
            return;
        if (!ds_map_exists(_mcp_clients, _sock))
            return;
        // requests queued behind a pending screenshot or game_wait wait for
        // its reply
        if (_mcp_shot_sock == _sock)
            return;
        if (_mcp_wait_sock == _sock)
            return;
        _buf = ds_map_find_value(_mcp_clients, _sock);
        _len = ds_map_find_value(_mcp_lens, _sock);
        // stray CR/LF bytes between pipelined requests
        _i = 0;
        while (_i < _len)
        {
            _p = buffer_peek(_buf, _i, buffer_u8);
            if (_p != 13 && _p != 10)
                break;
            _i++;
        }
        if (_i > 0)
        {
            scr_devtools_mcp_consume(_sock, _i);
            _len -= _i;
        }
        if (_len < 4)
            return;
        // the blank line ending the header block: CR LF CR LF read as one u32
        _hend = -1;
        _lim = min(_len, 16384) - 4;
        for (_i = 0; _i <= _lim; _i++)
        {
            if (buffer_peek(_buf, _i, buffer_u32) == 168626701)
            {
                _hend = _i;
                break;
            }
        }
        if (_hend < 0)
        {
            if (_len >= 16384)
                scr_devtools_mcp_fail(_sock, "431 Request Header Fields Too Large");
            return;
        }
        // header block as a string: a 0 byte ends the read, then the CR is
        // put back so a rescan still finds the blank line
        buffer_poke(_buf, _hend, buffer_u8, 0);
        buffer_seek(_buf, buffer_seek_start, 0);
        _head = buffer_read(_buf, buffer_string);
        buffer_poke(_buf, _hend, buffer_u8, 13);
        // request line: METHOD TARGET HTTP/x.y
        _p = string_pos("\r\n", _head);
        if (_p > 0)
        {
            _line = string_copy(_head, 1, _p - 1);
            _rest = string_delete(_head, 1, _p + 1);
        }
        else
        {
            _line = _head;
            _rest = "";
        }
        _p = string_pos(" ", _line);
        if (_p <= 1)
        {
            scr_devtools_mcp_fail(_sock, "400 Bad Request");
            return;
        }
        _method = string_copy(_line, 1, _p - 1);
        _line = string_delete(_line, 1, _p);
        _p = string_pos(" ", _line);
        if (_p <= 1)
        {
            scr_devtools_mcp_fail(_sock, "400 Bad Request");
            return;
        }
        _target = string_copy(_line, 1, _p - 1);
        if (string_copy(_line, _p + 1, 5) != "HTTP/")
        {
            scr_devtools_mcp_fail(_sock, "400 Bad Request");
            return;
        }
        _p = string_pos("?", _target);
        if (_p > 0)
            _target = string_copy(_target, 1, _p - 1);
        // header fields
        _clen = 0;
        _bad = false;
        _te = false;
        _host = "";
        _origin = "";
        _hasOrigin = false;
        _expect = "";
        _ctype = "";
        while (_rest != "")
        {
            _p = string_pos("\r\n", _rest);
            if (_p > 0)
            {
                _line = string_copy(_rest, 1, _p - 1);
                _rest = string_delete(_rest, 1, _p + 1);
            }
            else
            {
                _line = _rest;
                _rest = "";
            }
            _p = string_pos(":", _line);
            if (_p > 1)
            {
                _key = string_lower(scr_devtools_mcp_trim(string_copy(_line, 1, _p - 1)));
                _val = scr_devtools_mcp_trim(string_delete(_line, 1, _p));
                if (_key == "content-length")
                {
                    _clen = scr_devtools_mcp_uint(_val);
                    if (_clen < 0)
                    {
                        _clen = 0;
                        _bad = true;
                    }
                }
                else if (_key == "transfer-encoding")
                    _te = true;
                else if (_key == "host")
                    _host = _val;
                else if (_key == "origin")
                {
                    _origin = _val;
                    _hasOrigin = true;
                }
                else if (_key == "expect")
                    _expect = string_lower(_val);
                else if (_key == "content-type")
                    _ctype = string_lower(_val);
            }
        }
        if (_te)
        {
            scr_devtools_mcp_fail(_sock, "411 Length Required");
            return;
        }
        if (_bad)
        {
            scr_devtools_mcp_fail(_sock, "400 Bad Request");
            return;
        }
        if (_clen > 1048576)
        {
            scr_devtools_mcp_fail(_sock, "413 Content Too Large");
            return;
        }
        _total = _hend + 4 + _clen;
        if (_len < _total)
        {
            // body still arriving - answer Expect: 100-continue once
            if (_expect == "100-continue")
            {
                if (ds_map_find_value(_mcp_cont, _sock) == 0)
                {
                    _tmp = buffer_create(64, buffer_grow, 1);
                    buffer_write(_tmp, buffer_text, "HTTP/1.1 100 Continue\r\n\r\n");
                    network_send_raw(_sock, _tmp, buffer_tell(_tmp));
                    buffer_delete(_tmp);
                    ds_map_replace(_mcp_cont, _sock, 1);
                }
            }
            return;
        }
        _body = "";
        if (_clen > 0)
        {
            _tmp = buffer_create(_clen + 1, buffer_fixed, 1);
            buffer_copy(_buf, _hend + 4, _clen, _tmp, 0);
            buffer_poke(_tmp, _clen, buffer_u8, 0);
            buffer_seek(_tmp, buffer_seek_start, 0);
            _body = buffer_read(_tmp, buffer_string);
            buffer_delete(_tmp);
        }
        scr_devtools_mcp_consume(_sock, _total);
        // DNS rebinding and browser guards, then routing
        if (_host != "" && !scr_devtools_mcp_is_local(_host))
        {
            scr_devtools_mcp_send_text(_sock, "403 Forbidden", "Content-Type: text/plain\r\n", "forbidden - the Host header must be 127.0.0.1, localhost or [::1]");
            continue;
        }
        if (_hasOrigin)
        {
            _val = string_lower(_origin);
            if (string_pos("http://", _val) == 1)
                _val = string_delete(_val, 1, 7);
            else if (string_pos("https://", _val) == 1)
                _val = string_delete(_val, 1, 8);
            else
                _val = "";
            if (!scr_devtools_mcp_is_local(_val))
            {
                scr_devtools_mcp_send_text(_sock, "403 Forbidden", "Content-Type: text/plain\r\n", "forbidden - cross-origin requests are not allowed");
                continue;
            }
        }
        if (_target != "/mcp" && _target != "/mcp/" && _target != "/")
        {
            scr_devtools_mcp_send_text(_sock, "404 Not Found", "Content-Type: text/plain\r\n", "not found - the MCP endpoint is /mcp");
            continue;
        }
        if (_method != "POST")
        {
            scr_devtools_mcp_send_text(_sock, "405 Method Not Allowed", "Content-Type: text/plain\r\nAllow: POST\r\n", "method not allowed - send JSON-RPC messages with POST");
            continue;
        }
        if (string_pos("application/json", _ctype) != 1)
        {
            scr_devtools_mcp_send_text(_sock, "415 Unsupported Media Type", "Content-Type: text/plain\r\n", "unsupported media type - send Content-Type: application/json");
            continue;
        }
        scr_devtools_mcp_rpc(_sock, _body);
    }
}
