function scr_devtools_find()
{
    var _argumentsArray = argument[0]
    if (_argumentsArray[0] == "" || array_length(_argumentsArray) != 1)
    {
        scr_console_output_list("invalid argument number", red)
        return;
    }
    var _found = 0
    var _key = ds_map_find_first(commandsMap)
    while (!is_undefined(_key))
    {
        if (string_pos(_argumentsArray[0], _key) > 0)
        {
            scr_console_output_list(_key, green)
            _found++
        }
        _key = ds_map_find_next(commandsMap, _key)
    }
    scr_console_output_list(("Found " + string(_found) + " command(s) with '" + _argumentsArray[0] + "'"), gray)
}
