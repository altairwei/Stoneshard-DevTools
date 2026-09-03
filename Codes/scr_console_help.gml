function scr_console_help()
{
    var _argumentsArray = argument[0];

    // help <command>: print the command's help rows. The help scripts return
    // an array whose items are [text, color] rows or plain strings.
    if (_argumentsArray[0] != "")
    {
        var _name = string_lower(string(_argumentsArray[0]));
        var _scriptName = ds_map_find_value(commandsMap, _name);

        if (is_undefined(_scriptName))
        {
            scr_console_output_list("Command '" + _name + "' not found", red);
            return;
        }

        var _helpName = ds_map_find_value(helpMap, _name);

        if (is_undefined(_helpName) || asset_get_index(_helpName) == -1)
        {
            scr_console_output_list("No further information available", gray);
            return;
        }

        var _list = script_execute(asset_get_index(_helpName));

        if (!is_array(_list))
        {
            scr_console_output_list("No further information available", gray);
            return;
        }

        for (var i = 0; i < array_length(_list); i++)
        {
            var _row = _list[i];

            if (is_array(_row))
            {
                if (array_length(_row) > 1)
                    scr_console_output_list(_row[0], _row[1]);
                else
                    scr_console_output_list(_row[0], white);
            }
            else if (is_string(_row))
            {
                scr_console_output_list(_row, white);
            }
        }

        return;
    }

    // no argument: list every registered command
    scr_console_output_list("Available commands (type 'help <command>' for details):", white);

    var _key = ds_map_find_first(commandsMap);

    while (!is_undefined(_key))
    {
        scr_console_output_list(_key, gray);
        _key = ds_map_find_next(commandsMap, _key);
    }
}
