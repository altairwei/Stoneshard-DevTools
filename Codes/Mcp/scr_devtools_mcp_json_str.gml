// Quoted JSON string literal for any text. scr_devtools_json_escape covers
// backslash, quote, \n, \r and \t; the other control characters - JSON
// forbids them raw, and console output can carry them - become \u00XX.
function scr_devtools_mcp_json_str()
{
    var _s = scr_devtools_json_escape(string(argument[0]));
    var _hex = "0123456789abcdef";
    var _c = 1;
    while (_c < 32)
    {
        if (_c != 9 && _c != 10 && _c != 13)
        {
            if (string_pos(chr(_c), _s) > 0)
                _s = string_replace_all(_s, chr(_c), "\\u00" + string_char_at(_hex, (_c >> 4) + 1) + string_char_at(_hex, (_c & 15) + 1));
        }
        _c++;
    }
    return _s;
}
