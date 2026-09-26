// Lists the instances of an object for the replies of game_event and
// game_click, so that one of them can be picked: a line each with the id,
// the label if the instance has one (the text of buttons), its position and
// whether it is hidden; at most 20 lines. argument[0] the object index.
// Returns the lines, each starting with a line break.
function scr_devtools_mcp_game_instances()
{
    var _obj = argument[0];
    var _out = "";
    var _n = 0;
    with (_obj)
    {
        if (_n < 20)
        {
            // string() spells instance ids "ref 100234"
            _out += "\n#" + string_digits(string(id)) + " " + object_get_name(object_index);
            if (variable_instance_exists(id, "text"))
            {
                if (is_string(text))
                    _out += " '" + text + "'";
            }
            _out += " (x " + string(round(x)) + ", y " + string(round(y));
            if (!visible)
                _out += ", hidden";
            _out += ")";
        }
        _n++;
    }
    if (_n > 20)
        _out += "\n... and " + string(_n - 20) + " more";
    return _out;
}
