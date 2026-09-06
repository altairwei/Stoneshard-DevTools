function scr_console_actionslog_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [["actionslog", green], ["Включает или выключает отображение журнала действий.", gray]];
    }
    if (_lang == 3)
    {
        return [["actionslog", green], ["切换动作日志的显示。", gray]];
    }
    return [["actionslog", green], ["Toggles the action log display.", gray]];
}
