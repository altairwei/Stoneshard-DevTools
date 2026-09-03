// Time help, standalone: the vanilla scr_console_time_change entry contains
// modern syntax (closure / new / ??) that crashes MSL's bundled decompiler,
// so its help cannot be GML-patched in place - registered under a new name.
// The commands map points the `time` command at this script.
function scr_devtools_time_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [["time [change [time...]] | [scale [amount]]", green], ["Команда позволяющая работать с внутриигровым временем.", gray], ["Опции:", white], ["change: Команда добавляет к текущему времени заданное.", gray], ["time...: Количество времени которое следует добавить в формате [seconds,minutes,hours,days,months].", gray], ["\tseconds: Количество секунд.(по умолчанию 0).", gray], ["\tminutes: Количество минут.(по умолчанию 0).", gray], ["\thours: Количество часов.(по умолчанию 0).", gray], ["\tdays: Количество дней.(по умолчанию 0).", gray], ["\t months: Количество месяцев.(по умолчанию 0).", gray], ["scale: Команда позволяет изменить скорость течения времени в игре.", gray], ["\tamount: Коэффициент скорости.(по умолчанию 1).", gray]];
    }
    if (_lang == 3)
    {
        return [["time [change [time...]] | [scale [amount]]", green], ["操作游戏内时间的命令。", gray], ["选项：", white], ["change: 在当前时间上增加指定时长。", gray], ["time...: 要增加的时长，格式 [seconds,minutes,hours,days,months]（秒,分,时,天,月）。", gray], ["\tseconds: 秒数（默认 0）。", gray], ["\tminutes: 分钟数（默认 0）。", gray], ["\thours: 小时数（默认 0）。", gray], ["\tdays: 天数（默认 0）。", gray], ["\tmonths: 月数（默认 0）。", gray], ["scale: 改变游戏内时间流速。", gray], ["\tamount: 流速倍率（默认 1）。", gray]];
    }
    return [["time [change [time...]] | [scale [amount]]", green], ["Manipulates the in-game time.", gray], ["Options:", white], ["change: Adds the given amount to the current time.", gray], ["time...: The time to add, in the format [seconds,minutes,hours,days,months].", gray], ["\tseconds: Seconds (default 0).", gray], ["\tminutes: Minutes (default 0).", gray], ["\thours: Hours (default 0).", gray], ["\tdays: Days (default 0).", gray], ["\tmonths: Months (default 0).", gray], ["scale: Changes the speed of the in-game time flow.", gray], ["\tamount: Speed multiplier (default 1).", gray]];
}
