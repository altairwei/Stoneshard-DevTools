function scr_console_killall_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [["killall", green], ["Убивает всех враждебных существ в текущей локации.", gray]];
    }
    if (_lang == 3)
    {
        return [["killall", green], ["杀死当前房间中的所有敌对生物。", gray]];
    }
    return [["killall", green], ["Kills every hostile creature in the current room.", gray]];
}
