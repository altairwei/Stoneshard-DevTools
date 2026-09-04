function scr_console_boost_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [
            ["boost [id amount duration]", green],
            ["Временно изменяет свойства заданного атрибута.", gray],
            ["Опции:", white],
            ["id: Идентификатор атрибута.", gray],
            ["amount: Значение изменения (по умолчанию 0).", gray],
            ["duration: Длительность в ходах (по умолчанию 1).", gray]
        ];
    }
    if (_lang == 3)
    {
        return [
            ["boost [id amount duration]", green],
            ["临时改变指定属性的数值。", gray],
            ["选项：", white],
            ["id: 属性名。", gray],
            ["amount: 增减值（默认 0）。", gray],
            ["duration: 持续回合数（默认 1）。", gray]
        ];
    }
    return [
        ["boost [id amount duration]", green],
        ["Temporarily adds the provided amount to the given attribute.", gray],
        ["Options:", white],
        ["id: The attribute to buff or debuff.", gray],
        ["amount: The value to add (default 0).", gray],
        ["duration: Duration in turns (default 1).", gray]
    ];
}
