// Parses a plain unsigned decimal of 1-9 digits - Content-Length values and
// port numbers. Anything else - sign, spaces, exponent, empty - returns -1.
function scr_devtools_mcp_uint()
{
    var _s = string(argument[0]);
    var _n = string_length(_s);
    var _v = 0;
    var _i = 1;
    var _c = 0;
    if (_n < 1 || _n > 9)
        return -1;
    while (_i <= _n)
    {
        _c = string_ord_at(_s, _i) - 48;
        if (_c < 0 || _c > 9)
            return -1;
        _v = _v * 10 + _c;
        _i++;
    }
    return _v;
}
