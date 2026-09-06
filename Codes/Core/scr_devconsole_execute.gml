// Command-line execution entry, ported from the 0.8.2.10
// o_console_controller user event 0. Called from the Step event, so self is
// the o_devconsole instance throughout the whole command chain.
// NOTE: the old compiler does not support named parameters in declarations -
// read positional arguments via argument[0].
function scr_devconsole_execute()
{
    var _commandLine = argument[0];

    ds_list_add(previous_command, _commandLine);
    previous_command_index = -1;
    scr_devconsole_command(_commandLine);
}
