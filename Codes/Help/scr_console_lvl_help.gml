function scr_console_lvl_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [
            ["setlvl [level]", green],
            ["Поднимает или опускает персонажа до заданного уровня.", gray],
            ["Опции:", white],
            ["level: Номер уровня (от 1 до 30).", gray]
        ];
    }
    if (_lang == 3)
    {
        return [
            ["setlvl [level]", green],
            ["将角色提升或降低到指定等级。", gray],
            ["选项：", white],
            ["level: 目标等级（1-30）。", gray]
        ];
    }
    return [
        ["setlvl [level]", green],
        ["Sets player's level to the provided value.", gray],
        ["Options:", white],
        ["level: The level to set the player to (1-30).", gray]
    ];
}
