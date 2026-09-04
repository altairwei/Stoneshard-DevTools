function scr_console_sethp_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [
            ["sethp [amount]", green],
            ["Задает количество очков здоровья у персонажа.", gray],
            ["Опции:", white],
            ["amount: Количество очков здоровья.", gray]
        ];
    }
    if (_lang == 3)
    {
        return [
            ["sethp [amount]", green],
            ["设置角色的生命值。", gray],
            ["选项：", white],
            ["amount: 生命值点数。", gray]
        ];
    }
    return [
        ["sethp [amount]", green],
        ["Sets player's health to the provided value.", gray],
        ["Options:", white],
        ["amount: The amount of health to set the player to.", gray]
    ];
}
