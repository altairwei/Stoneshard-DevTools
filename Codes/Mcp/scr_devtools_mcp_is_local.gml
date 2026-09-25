// True when a Host header value - or the host part of an Origin - names this
// machine: 127.0.0.1, localhost or [::1], with or without a port. This stops
// DNS rebinding: a web page can reach 127.0.0.1, but its requests carry the
// host name of the page.
function scr_devtools_mcp_is_local()
{
    var _h = string_lower(scr_devtools_mcp_trim(argument[0]));
    var _p = 0;
    if (_h == "")
        return false;
    if (string_char_at(_h, 1) == "[")
    {
        _p = string_pos("]", _h);
        if (_p == 0)
            return false;
        _h = string_copy(_h, 1, _p);
    }
    else
    {
        _p = string_pos(":", _h);
        if (_p > 0)
            _h = string_copy(_h, 1, _p - 1);
    }
    return _h == "127.0.0.1" || _h == "localhost" || _h == "[::1]";
}
