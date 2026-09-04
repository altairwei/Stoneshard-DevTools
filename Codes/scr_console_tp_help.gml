function scr_console_tp_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [["tp", green], ["Телепортирует игрока к позиции курсора.", gray]];
    }
    if (_lang == 3)
    {
        return [["tp", green], ["将玩家传送到光标所在位置。", gray]];
    }
    return [["tp", green], ["Teleports the player to the cursor position.", gray]];
}
