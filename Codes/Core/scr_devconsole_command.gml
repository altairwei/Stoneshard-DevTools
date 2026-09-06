// Command dispatcher, ported from the old Z-DevTools executes.gml. The
// registry maps command names to script-name STRINGS and is resolved at
// runtime through asset_get_index - the value-position bare-name pitfall
// (miscompiled into an instance-variable read) does not apply to strings.
// self stays the o_devconsole instance across script_execute, so commands
// can keep reading white/red/green/gray and calling scr_console_output_list.
// NOTE: the old compiler does not support named parameters in declarations -
// read positional arguments via argument[0].
function scr_devconsole_command()
{
    var _commandLine = argument[0];
    var _argumentsArray = string_split(_commandLine, " ", true);
    var _command = "";

    if (array_length(_argumentsArray) > 0)
    {
        _command = string_lower(_argumentsArray[0]);
        array_delete(_argumentsArray, 0, 1);
    }

    if (array_length(_argumentsArray) == 0)
        array_push(_argumentsArray, "");

    var _scriptName = ds_map_find_value(commandsMap, _command);

    scr_console_output_list(_commandLine, white);
    if (is_undefined(_scriptName))
        scr_console_output_list("Command '" + _command + "' not found, use 'help'", red);
    else
        script_execute(asset_get_index(_scriptName), _argumentsArray);
}
