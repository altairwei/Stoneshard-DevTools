function scr_console_setmp_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [
            ["setmp [amount]", green],
            ["Задает количество очков маны персонажа.", gray],
            ["Опции:", white],
            ["amount: Количество очков маны.", gray]
        ];
    }
    if (_lang == 3)
    {
        return [
            ["setmp [amount]", green],
            ["设置角色的魔法值。", gray],
            ["选项：", white],
            ["amount: 魔法值点数。", gray]
        ];
    }
    return [
        ["setmp [amount]", green],
        ["Sets player's mana to the provided value.", gray],
        ["Options:", white],
        ["amount: The amount of mana to set the player to.", gray]
    ];
}
