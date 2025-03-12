    var _string = argument0;
    var _argumentsArray = string_split(_string, " ", true);
    var _command = "";

    if (array_length(_argumentsArray) > 0)
    {
        _command = string_lower(_argumentsArray[0])
        array_delete(_argumentsArray, 0, 1)
    }
    
    if (array_length(_argumentsArray) == 0)
        array_push(_argumentsArray, "")

    var _foundCommand = ds_map_find_value(commandsMap, _command);
    
    if (is_undefined(_foundCommand))
        scr_console_output_list("Command '" + _command + "' not found, use 'help'", red);
    else
        script_execute(_foundCommand, _argumentsArray);
