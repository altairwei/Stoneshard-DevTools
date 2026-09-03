function scr_console_globalset_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [["globalset [x] [y]", green], ["При использовании команды игрока переносит по глобальной карте на x, y координат от его текущего местоположения.", gray], ["Опции:", white], ["x: Координаты смещения по оси x (по умолчанию 0).", gray], ["y: Координаты смещения по оси y (по умолчанию 0).", gray]];
    }
    if (_lang == 3)
    {
        return [["globalset [x] [y]", green], ["在世界地图上将玩家从其当前位置移动 (x, y) 格。", gray], ["选项：", white], ["x: X 轴偏移格数（默认 0）。", gray], ["y: Y 轴偏移格数（默认 0）。", gray]];
    }
    return [["globalset [x] [y]", green], ["Moves the player across the global map by x, y from their current location.", gray], ["Options:", white], ["x: Offset along the x axis (default 0).", gray], ["y: Offset along the y axis (default 0).", gray]];
}
