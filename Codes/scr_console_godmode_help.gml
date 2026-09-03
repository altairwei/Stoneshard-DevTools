function scr_console_godmode_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [["godmode", green], ["Включает режим бессмертия игрока.", gray], ["Во время бессмертия здоровье и энергия игрока всегда равняются 100.", gray], ["Также на игрока не действуют никакие негативные эффекты.", gray]];
    }
    if (_lang == 3)
    {
        return [["godmode", green], ["开启玩家的无敌模式。", gray], ["无敌期间玩家的生命与能量始终为 100。", gray], ["同时免疫所有负面效果。", gray]];
    }
    return [["godmode", green], ["Enables the player's immortality mode.", gray], ["While immortal, the player's health and energy are always 100.", gray], ["Negative effects do not affect the player either.", gray]];
}
