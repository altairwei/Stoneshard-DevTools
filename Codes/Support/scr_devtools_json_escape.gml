function scr_devtools_json_escape()
{
    var _s = string(argument[0])
    _s = string_replace_all(_s, "\\", "\\\\")
    _s = string_replace_all(_s, "\"", "\\\"")
    _s = string_replace_all(_s, "\n", "\\n")
    _s = string_replace_all(_s, "\r", "\\r")
    _s = string_replace_all(_s, "\t", "\\t")
    return "\"" + _s + "\""
}
