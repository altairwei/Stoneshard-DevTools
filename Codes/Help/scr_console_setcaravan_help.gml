function scr_console_setcaravan_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [["setcaravan [x] [y]", green], ["Перемещает караван на указанные координаты мировой карты.", gray], ["Опции:", white], ["x: Координата по горизонтали.", gray], ["y: Координата по вертикали.", gray]];
    }
    if (_lang == 3)
    {
        return [["setcaravan [x] [y]", green], ["将商队移动到指定的世界地图坐标。", gray], ["选项：", white], ["x: 横向坐标。", gray], ["y: 纵向坐标。", gray]];
    }
    return [["setcaravan [x] [y]", green], ["Moves the caravan to the given world-map coordinates.", gray], ["Options:", white], ["x: Horizontal coordinate.", gray], ["y: Vertical coordinate.", gray]];
}
