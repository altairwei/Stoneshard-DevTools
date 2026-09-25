// Strips spaces, tabs, CR and LF from both ends - HTTP header values and
// command lines. string_trim is not in the game's function table.
function scr_devtools_mcp_trim()
{
    var _s = string(argument[0]);
    var _a = 1;
    var _b = string_length(_s);
    var _c = 0;
    while (_a <= _b)
    {
        _c = string_ord_at(_s, _a);
        if (_c != 32 && _c != 9 && _c != 13 && _c != 10)
            break;
        _a++;
    }
    while (_b >= _a)
    {
        _c = string_ord_at(_s, _b);
        if (_c != 32 && _c != 9 && _c != 13 && _c != 10)
            break;
        _b--;
    }
    if (_b < _a)
        return "";
    return string_copy(_s, _a, _b - _a + 1);
}
