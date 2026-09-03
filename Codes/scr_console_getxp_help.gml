function scr_console_getxp_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [["getxp [amount]", green], ["Добавляет к текущему количеству опыта в заданное значение.", gray], ["Опции:", white], ["amount: Количество опыта.(по умолчанию 0).", gray]];
    }
    if (_lang == 3)
    {
        return [["getxp [amount]", green], ["为当前经验值增加指定数量。", gray], ["选项：", white], ["amount: 经验数量（默认 0）。", gray]];
    }
    return [["getxp [amount]", green], ["Adds the given amount to the current experience.", gray], ["Options:", white], ["amount: Amount of experience (default 0).", gray]];
}
