function scr_console_save_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [["save [0 - sleep | 1 - auto | 2 - exit]", green], ["Сохраняет игру в заданный слот.", gray], ["Опции:", white], ["0 - sleep: Сохранение - сон.", gray], ["1 - auto: Автосохранение.", gray], ["2 - exit: Сохранение на выходе.", gray]];
    }
    if (_lang == 3)
    {
        return [["save [0 - sleep | 1 - auto | 2 - exit]", green], ["将游戏保存到指定槽位。", gray], ["选项：", white], ["0 - sleep: 睡觉存档。", gray], ["1 - auto: 自动存档。", gray], ["2 - exit: 退出时存档。", gray]];
    }
    return [["save [0 - sleep | 1 - auto | 2 - exit]", green], ["Saves the game to the given slot.", gray], ["Options:", white], ["0 - sleep: Sleep save.", gray], ["1 - auto: Autosave.", gray], ["2 - exit: Save on exit.", gray]];
}
