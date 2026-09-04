function scr_console_butcher_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [["butcher", green], ["Убивает всех враждебных существ в текущей локации.", gray]];
    }
    if (_lang == 3)
    {
        return [["butcher", green], ["杀死当前房间中的所有敌对生物。", gray]];
    }
    return [["butcher", green], ["Kills every hostile creature in the current room.", gray]];
}
