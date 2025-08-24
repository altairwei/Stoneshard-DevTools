function scr_console_allskills()
{
    var _argumentsArray = argument[0]
    if (_argumentsArray[0] == "" || array_length(_argumentsArray) > 1)
    {
        scr_console_output_list("invalid argument number", red)
        return;
    }

    if (_argumentsArray[0] != "all" && _argumentsArray[0] != "reset")
    {
        scr_console_output_list("wrong skills command name", red)
        return;
    }

    if (_argumentsArray[0] == "all")
    {
        scr_tier_all_free()
        scr_console_output_list("All skills unlocked", green)
    }

    if (_argumentsArray[0] == "reset")
    {
        with (o_skill_category)
        {
            var _skillsArrayLength = array_length(skill)
            for (var _i = 0; _i < _skillsArrayLength; _i++)
            {
                with (skill[_i])
                    is_open = 0
            }
        }
        with (o_skill_fast_panel)
        {
            var _skillsListSize = ds_list_size(skills)
            for (_i = 0; _i < _skillsListSize; _i++)
            {
                var _skillList = ds_list_find_value(skills, _i)
                var _skillListSize = ds_list_size(_skillList)
                for (var _j = 0; _j < _skillListSize; _j++)
                    ds_list_set(_skillList, _j, -4)
            }
        }
        with (o_skill)
        {
            if (object_index != o_skill_attack_mode_shot)
                instance_destroy()
        }
        scr_atr_set("SP", (scr_atr("LVL") + 1))
        scr_console_output_list("All skills reseted", green)
    }
}
