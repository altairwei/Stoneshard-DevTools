function scr_console_questnexttarget_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [["questnexttarget [quest_key]", green], ["Переводит задание на следующую цель.", gray], ["Опции:", white], ["quest_key: Ключ задания.", gray]];
    }
    if (_lang == 3)
    {
        return [["questnexttarget [quest_key]", green], ["将任务推进到下一个目标。", gray], ["选项：", white], ["quest_key: 任务键。", gray]];
    }
    return [["questnexttarget [quest_key]", green], ["Advances the quest to the next target.", gray], ["Options:", white], ["quest_key: Quest key.", gray]];
}
