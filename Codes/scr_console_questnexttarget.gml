function scr_console_questnexttarget()
{
    var _argumentsArray = argument[0]
    var _questKey = _argumentsArray[0]
    if (scr_quest_next_target(_questKey))
        scr_console_output_list("Quest's target updated", green)
    else
        scr_console_output_list("Quest's key not found", red)
}
