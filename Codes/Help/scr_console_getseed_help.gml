function scr_console_getseed_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [
            ["getseed", green],
            ["Возвращает ключ генерации глобальной карты.", gray]
        ];
    }
    if (_lang == 3)
    {
        return [
            ["getseed", green],
            ["输出世界生成种子。", gray]
        ];
    }
    return [
        ["getseed", green],
        ["Prints the seed of the current world.", gray]
    ];
}
