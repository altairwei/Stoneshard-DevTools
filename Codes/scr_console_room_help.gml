function scr_console_room_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [["room [id]", green], ["Телепортирует персонажа в заданную комнату.", gray], ["Опции:", white], ["id: Идентификатор комнаты.", gray]];
    }
    if (_lang == 3)
    {
        return [["room [id]", green], ["将角色传送到指定房间。", gray], ["选项：", white], ["id: 房间标识。", gray]];
    }
    return [["room [id]", green], ["Teleports the character to the specified room.", gray], ["Options:", white], ["id: Room identifier.", gray]];
}
