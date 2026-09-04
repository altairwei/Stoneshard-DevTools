function scr_console_exit_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [
            ["exit", green],
            ["Завершает игру.", gray]
        ];
    }
    if (_lang == 3)
    {
        return [
            ["exit", green],
            ["退出游戏。", gray]
        ];
    }
    return [
        ["exit", green],
        ["Exits the game.", gray]
    ];
}
