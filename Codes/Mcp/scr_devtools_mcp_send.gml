// Sends one HTTP/1.1 response: status line, extra header lines - each
// already ending in \r\n - and Content-Length, then the first n bytes of the
// body buffer. Header and body go out in a single network_send_raw so Nagle
// never holds back a small tail segment. A short or failed send would leave
// the client waiting for bytes that never come, so the connection is closed
// instead - the client fails fast. Returns the send result.
function scr_devtools_mcp_send()
{
    var _sock = argument[0];
    var _status = argument[1];
    var _headers = argument[2];
    var _body = argument[3];
    var _n = argument[4];
    var _out = buffer_create(1024, buffer_grow, 1);
    var _hn = 0;
    var _r = 0;
    buffer_write(_out, buffer_text, "HTTP/1.1 " + _status + "\r\n" + _headers + "Content-Length: " + string(_n) + "\r\n\r\n");
    _hn = buffer_tell(_out);
    if (_n > 0)
    {
        if (buffer_get_size(_out) < _hn + _n)
            buffer_resize(_out, _hn + _n);
        buffer_copy(_body, 0, _n, _out, _hn);
    }
    _r = network_send_raw(_sock, _out, _hn + _n);
    buffer_delete(_out);
    if (_r < _hn + _n)
        scr_devtools_mcp_drop(_sock, true);
    return _r;
}
