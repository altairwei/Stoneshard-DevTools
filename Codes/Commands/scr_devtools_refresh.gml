// DevTools self-service command `refresh`: re-runs the command registration
// exactly as the o_devconsole Create event does. Both maps are destroyed and
// rebuilt from scr_devconsole_commands_map, so stray or tampered entries are
// dropped and every registered command is back. self is the o_devconsole
// instance along the command chain (see scr_devconsole_command), so
// commandsMap/helpMap here are its instance variables - and no other code
// caches their ds_map ids, so destroy-and-recreate is safe.
// The bare-name call to scr_devconsole_commands_map below resolves because
// this script's AddFunction registration runs after the map builder's
// (compile order = registration order, see DevTools.cs PatchCommands).
function scr_devtools_refresh()
{
    var _argumentsArray = argument[0]
    if (_argumentsArray[0] != "" || array_length(_argumentsArray) > 1)
    {
        scr_console_output_list("invalid argument number", red)
        return;
    }
    ds_map_destroy(commandsMap)
    ds_map_destroy(helpMap)
    commandsMap = ds_map_create()
    helpMap = ds_map_create()
    scr_devconsole_commands_map(commandsMap, helpMap)
    scr_console_output_list(("[DevTools] " + string(ds_map_size(commandsMap)) + " commands reloaded."), gray)
}
