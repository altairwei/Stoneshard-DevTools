function scr_console_help()
{
    var _argumentsArray = argument[0];
    var _lang = global.language;

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

    // no argument: list every registered command in alphabetical order, each
    // followed by a one-line summary. Every *_help script returns rows where
    // [0] is the usage line and [1] is the summary (all three language
    // branches share this layout), so the list follows the current game
    // language automatically. Commands without a usable summary fall back to
    // a bare name.
    if (_lang == 1)
    {
        scr_console_output_list("Доступные команды (введите 'help <команда>' для подробностей):", white);
    }
    else if (_lang == 3)
    {
        scr_console_output_list("可用命令（输入 'help <命令名>' 查看详情）：", white);
    }
    else
    {
        scr_console_output_list("Available commands (type 'help <command>' for details):", white);
    }

    var _names = ds_list_create();
    var _maxName = 0;
    var _key = ds_map_find_first(commandsMap);

    while (!is_undefined(_key))
    {
        ds_list_add(_names, _key);

        if (string_length(_key) > _maxName)
            _maxName = string_length(_key);

        _key = ds_map_find_next(commandsMap, _key);
    }

    // insertion sort by name - ds_list_sort is NOT in this game's function
    // table (verified against vallina.win), and the old compiler cannot emit
    // the predicate array_sort needs; the command names are all lowercase so
    // a plain lexicographic compare is enough.
    for (var i = 1; i < ds_list_size(_names); i++)
    {
        var _v = ds_list_find_value(_names, i);
        var j = i - 1;

        while (j >= 0 && ds_list_find_value(_names, j) > _v)
        {
            ds_list_set(_names, j + 1, ds_list_find_value(_names, j));
            j--;
        }

        ds_list_set(_names, j + 1, _v);
    }

    for (var i = 0; i < ds_list_size(_names); i++)
    {
        var _cmd = ds_list_find_value(_names, i);
        var _summary = "";
        var _helpName = ds_map_find_value(helpMap, _cmd);

        if (!is_undefined(_helpName) && asset_get_index(_helpName) != -1)
        {
            var _rows = script_execute(asset_get_index(_helpName));

            if (is_array(_rows) && array_length(_rows) > 1)
            {
                var _desc = _rows[1];

                if (is_array(_desc))
                    _summary = string(_desc[0]);
                else if (is_string(_desc))
                    _summary = _desc;
            }
        }

        if (_summary != "")
        {
            scr_console_output_list(_cmd + string_repeat(" ", _maxName - string_length(_cmd) + 2) + _summary, gray);
        }
        else
        {
            scr_console_output_list(_cmd, gray);
        }
    }

    ds_list_destroy(_names);
}
