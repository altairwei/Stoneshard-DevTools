function scr_console_respec()
{
    with (o_player)
    {
        scr_atr_set_simple("STR", ds_map_find_value(ds_map_find_value(global.classesMap, object_get_name(object_index)), "STR"));
        scr_atr_set_simple("AGL", ds_map_find_value(ds_map_find_value(global.classesMap, object_get_name(object_index)), "AGL"));
        scr_atr_set_simple("PRC", ds_map_find_value(ds_map_find_value(global.classesMap, object_get_name(object_index)), "PRC"));
        scr_atr_set_simple("Vitality", ds_map_find_value(ds_map_find_value(global.classesMap, object_get_name(object_index)), "Vitality"));
        scr_atr_set_simple("WIL", ds_map_find_value(ds_map_find_value(global.classesMap, object_get_name(object_index)), "WIL"));
        var f_xp = scr_atr("XP");

        for (var _i = 0; _i < scr_atr("LVL"); _i++)
            f_xp = f_xp + (_i * 250);

        scr_atr_set_simple("XP", 0);
        scr_atr_set_simple("LVL", 1);
        scr_atr_set_simple("AP", 0);
        scr_atr_set_simple("SP", 2);

        with (o_skill_category)
        {
            var _skillsArrayLength = array_length(skill);

            for (var _i = 0; _i < _skillsArrayLength; _i++)
            {
                if (skill[_i] != o_skill_trap_search_ico && skill[_i] != o_pass_skill_Sudden_Attacks && skill[_i] != o_skill_craft_ico && skill[_i] != o_skill_butchering_ico)
                {
                    with (skill[_i])
                    {
                        is_open = 0;
                        can_learn = 1;
                    }
                }
            }
        }
        
        with (o_skill_fast_panel)
        {
            var _skillsListSize = ds_list_size(skills);
            
            for (var _i = 0; _i < _skillsListSize; _i++)
            {
                var _skillList = ds_list_find_value(skills, _i);
                var _skillListSize = ds_list_size(_skillList);
                
                for (var _j = 0; _j < _skillListSize; _j++)
                    ds_list_set(_skillList, _j, noone);
            }
        }
        
        with (o_skill)
        {
            if (object_index != o_skill_attack_mode_shot)
                instance_destroy();
        }

        scr_atr_incr_simple("XP", f_xp);
    }
}