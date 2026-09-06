function scr_console_getroomlist_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [["getroomlist", green], ["Возвращает список комнат которые могут заспавнится в текущем данже.", gray]];
    }
    if (_lang == 3)
    {
        return [["getroomlist", green], ["列出当前地牢中可能生成的房间。", gray]];
    }
    return [["getroomlist", green], ["Returns the list of rooms that can spawn in the current dungeon.", gray]];
}
