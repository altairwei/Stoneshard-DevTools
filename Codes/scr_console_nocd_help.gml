function scr_console_nocd_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [["nocd", green], ["Убирает кулдаун и манакост способностей. Моментально восстанавливает умения под кулдаун при активации.", gray]];
    }
    if (_lang == 3)
    {
        return [["nocd", green], ["移除技能的冷却与法力消耗。激活时立即刷新处于冷却中的技能。", gray]];
    }
    return [["nocd", green], ["Removes ability cooldowns and mana costs. Instantly refreshes abilities on cooldown when activated.", gray]];
}
