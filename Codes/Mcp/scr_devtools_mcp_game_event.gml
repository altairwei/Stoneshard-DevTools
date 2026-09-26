// game_event: runs one event of instances with event_perform, the way the
// game's own code triggers events - GUI actions are user events, world
// objects react to mouse events, key handlers are KeyPress events. Only the
// event's code runs: Destroy does not destroy, and code that polls input
// still reads the real keyboard and mouse. argument[0] the arguments map or
// -1: target (see scr_devtools_mcp_game_target); event, a decompiled file
// name suffix such as "Other_25", "Mouse_4" or "KeyPress_27", "user_N" for
// user event N, or a bare type with number; all, to run it on every instance
// of an object. Returns the reply text and sets _mcp_exec_error.
function scr_devtools_mcp_game_event()
{
    var _args = argument[0];
    // event types by ev_* value, spelled as in the decompiled file names;
    // 11 is the obsolete trigger event
    var _types = ["Create", "Destroy", "Alarm", "Step", "Collision", "Keyboard", "Mouse", "Other", "Draw", "KeyPress", "KeyRelease", "", "CleanUp", "Gesture"];
    var _v = 0;
    var _raw = "";
    var _ev = "";
    var _num = 0;
    var _type = -1;
    var _i = 0;
    var _p = 0;
    var _all = false;
    var _t = 0;
    var _n = 0;
    var _name = "";
    var _count = 0;
    _mcp_exec_error = true;
    if (_args == -1)
        return "missing arguments 'target' and 'event'";
    _v = ds_map_find_value(_args, "event");
    if (!is_string(_v))
        return "missing text argument 'event', e.g. \"Other_10\" (user event 0), \"Mouse_4\" or \"KeyPress_27\"";
    _raw = scr_devtools_mcp_trim(_v);
    _ev = string_lower(_raw);
    _p = string_pos("_", _ev);
    if (_p > 0)
    {
        _v = string_copy(_ev, _p + 1, string_length(_ev) - _p);
        _ev = string_copy(_ev, 1, _p - 1);
        if (_v == "" || string_digits(_v) != _v)
            return "event '" + _raw + "': the part after '_' must be the event number";
        _num = real(_v);
    }
    else
    {
        _v = ds_map_find_value(_args, "number");
        if (is_numeric(_v))
            _num = floor(real(_v));
        else if (!is_undefined(_v))
            return "argument 'number' must be a whole number";
    }
    if (_num < 0)
        return "event numbers are not negative";
    if (_ev == "user")
    {
        if (_num > 15)
            return "user events are numbered 0 to 15";
        _type = 7;
        _num += 10;
    }
    else
    {
        for (_i = 0; _i < array_length(_types); _i++)
        {
            if (_types[_i] != "" && string_lower(_types[_i]) == _ev)
                _type = _i;
        }
        if (_type < 0)
            return "unknown event type in '" + _raw + "' - use Create, Destroy, Alarm, Step, Collision, Keyboard, Mouse, Other, Draw, KeyPress, KeyRelease, CleanUp, Gesture, or user_N for user event N";
        if (_type == 2 && _num > 11)
            return "alarms are numbered 0 to 11";
        if (_type == 3 && _num > 2)
            return "Step events are 0 (step), 1 (begin step) and 2 (end step)";
    }
    _t = scr_devtools_mcp_game_target(ds_map_find_value(_args, "target"));
    if (is_string(_t))
        return _t;
    _v = ds_map_find_value(_args, "all");
    if (is_numeric(_v))
    {
        if (_v)
            _all = true;
    }
    if (_t < 100000)
    {
        _name = object_get_name(_t);
        _n = instance_number(_t);
        if (_n > 1 && !_all)
            return _name + " has " + string(_n) + " instances - pass all: true to run the event on every one, or the id of one:" + scr_devtools_mcp_game_instances(_t);
    }
    else
        _name = object_get_name(_t.object_index) + " #" + string(_t);
    _ev = _types[_type] + "_" + string(_num);
    with (_t)
    {
        // never the console, which is running this very call
        if (id != other.id)
        {
            _count++;
            event_perform(_type, _num);
        }
    }
    if (_count == 0)
        return "no instance to run " + _ev + " on";
    _mcp_exec_error = false;
    if (_t < 100000)
        return "ran " + _ev + " on " + string(_count) + " instance(s) of " + _name;
    if (!instance_exists(_t))
        return "ran " + _ev + " on " + _name + " - the instance is gone now";
    return "ran " + _ev + " on " + _name;
}
