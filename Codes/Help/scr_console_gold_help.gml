function scr_console_gold_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [
            ["gold [amount]", green],
            ["Добавляет игроку указанное количество золота (монетами и кошельками).", gray],
            ["Опции:", white],
            ["amount: Количество золота для добавления.", gray]
        ];
    }
    if (_lang == 3)
    {
        return [
            ["gold [amount]", green],
            ["向玩家背包添加指定数量的金币。", gray],
            ["选项：", white],
            ["amount: 金币数量。", gray]
        ];
    }
    return [
        ["gold [amount]", green],
        ["Adds the specified amount of gold to the player's inventory.", gray],
        ["Options:", white],
        ["amount: The amount of gold to add.", gray]
    ];
}
