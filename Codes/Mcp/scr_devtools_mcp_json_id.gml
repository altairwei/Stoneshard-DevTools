// JSON text of a JSON-RPC id as json_decode returned it: strings are
// re-quoted, whole numbers printed without decimals - plain string conversion
// would add two - and a missing or null id becomes null.
function scr_devtools_mcp_json_id()
{
    var _v = argument[0];
    if (is_string(_v))
        return scr_devtools_mcp_json_str(_v);
    if (is_undefined(_v))
        return "null";
    if (is_numeric(_v))
    {
        if (_v == floor(_v))
            return string_format(_v, 1, 0);
    }
    return string(_v);
}
