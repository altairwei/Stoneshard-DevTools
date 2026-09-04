function scr_console_questsettarget()
{
    var _argumentsArray = argument[0]
    if (array_length(_argumentsArray) < 3)
    {
        scr_console_output_list("Required 3 arguments", red)
        return;
    }
    var _questKey = _argumentsArray[0]
    var _targetKey = _argumentsArray[1]
    var _value = string_to_real(_argumentsArray[2])
    if (scr_quest_set_progress(_questKey, _targetKey, _value))
        scr_console_output_list(("Quest '" + string(_questKey) + "' target '" + string(_targetKey) + "' updated"), green)
    else
        scr_console_output_list("Quest's data incorrect", red)
}
