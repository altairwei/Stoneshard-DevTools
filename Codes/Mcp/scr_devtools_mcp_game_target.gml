// Resolves the target argument of game_event and game_click. argument[0] the
// argument value: an instance id - a number, or text such as "100234",
// "#100234" or "#ref 100234", the form getinstances prints - or an object
// name. Returns the instance id; for an object name the object's index, at
// least one of its instances existing; else a string saying why there is
// nothing to act on.
function scr_devtools_mcp_game_target()
{
    var _v = argument[0];
    var _s = "";
    var _obj = -1;
    if (is_string(_v))
    {
        _s = scr_devtools_mcp_trim(_v);
        if (string_char_at(_s, 1) == "#")
            _s = string_copy(_s, 2, string_length(_s) - 1);
        // string() spells instance ids "ref 100234"
        if (string_copy(_s, 1, 4) == "ref ")
        {
            _s = string_digits(_s);
            if (_s == "")
                return "argument 'target' has no instance id after 'ref'";
        }
        if (_s == "")
            return "argument 'target' is empty - pass an object name or an instance id";
        if (string_digits(_s) == _s)
            _v = real(_s);
    }
    if (is_numeric(_v))
    {
        _v = floor(real(_v));
        // below 100000 instance_exists would take the number for an object
        if (_v < 100000)
            return "instance ids start at 100000 - pass object names as text, e.g. \"o_player\"";
        if (!instance_exists(_v))
            return "there is no instance #" + string(_v) + " - it was destroyed, or is deactivated";
        if (_v == id)
            return "#" + string(_v) + " is the DevTools console itself";
        return _v;
    }
    if (!is_string(_v))
        return "missing argument 'target': an object name or an instance id";
    // asset_get_index finds assets of every type; only an object's own name
    // maps back to it through object_get_name
    _obj = asset_get_index(_s);
    if (_obj < 0)
        return "there is no object named '" + _s + "'";
    if (!object_exists(_obj))
        return "there is no object named '" + _s + "'";
    if (object_get_name(_obj) != _s)
        return "there is no object named '" + _s + "'";
    if (_obj == object_index)
        return _s + " is the DevTools console itself";
    if (instance_number(_obj) == 0)
        return "there is no instance of " + _s + " right now";
    return _obj;
}
