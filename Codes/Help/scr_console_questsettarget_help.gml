function scr_console_questsettarget_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [["questsettarget [quest_key] [target_key] [value]", green], ["Устанавливает значение прогресса цели задания.", gray], ["Опции:", white], ["quest_key: Ключ задания.", gray], ["target_key: Ключ цели задания.", gray], ["value: Значение прогресса.", gray]];
    }
    if (_lang == 3)
    {
        return [["questsettarget [quest_key] [target_key] [value]", green], ["设置任务目标的进度值。", gray], ["选项：", white], ["quest_key: 任务键。", gray], ["target_key: 目标键。", gray], ["value: 进度值。", gray]];
    }
    return [["questsettarget [quest_key] [target_key] [value]", green], ["Sets the progress value of a quest target.", gray], ["Options:", white], ["quest_key: Quest key.", gray], ["target_key: Target key.", gray], ["value: Progress value.", gray]];
}
