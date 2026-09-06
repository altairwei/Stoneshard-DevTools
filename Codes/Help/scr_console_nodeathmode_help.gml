function scr_console_nodeathmode_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [["nodeath", green], ["Отключает у игрока возможность погибнуть. Игрок по-прежнему будет получать урон и негативные эффекты.", gray]];
    }
    if (_lang == 3)
    {
        return [["nodeath", green], ["开关免死模式：开启后玩家不会死亡，但仍会受到伤害和负面效果。", gray]];
    }
    return [["nodeath", green], ["Toggles death: while the mode is on the player cannot die, but still takes damage and negative effects.", gray]];
}
