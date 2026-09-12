function scr_console_globalset_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [["globalset [x] [y] | [location] | mouse", green], ["Перемещает игрока по глобальной карте: на x, y клеток от текущей позиции, по имени локации, или в клетку под курсором.", gray], ["Опции:", white], ["x: Смещение по оси X (по умолчанию 0).", gray], ["y: Смещение по оси Y (по умолчанию 0).", gray], ["location: имя локации - телепорт сразу в неё.", gray], ["mouse: телепорт в клетку под курсором (нужно открыть глобальную карту).", gray]];
    }
    if (_lang == 3)
    {
        return [["globalset [x] [y] | [location] | mouse", green], ["在世界地图上移动玩家：按 x、y 偏移当前位置，按地名直跳，或传送到鼠标指向的格子。", gray], ["选项：", white], ["x: X 轴偏移格数（默认 0）。", gray], ["y: Y 轴偏移格数（默认 0）。", gray], ["location: 地名 - 直接传送到该地点。", gray], ["mouse: 传送到鼠标指向的格子（需先打开世界地图）。", gray]];
    }
    return [["globalset [x] [y] | [location] | mouse", green], ["Moves the player across the global map: by x, y from the current location, straight to a named location, or to the cell under the mouse cursor.", gray], ["Options:", white], ["x: Offset along the X axis (default 0).", gray], ["y: Offset along the Y axis (default 0).", gray], ["location: a location name - teleport directly to it.", gray], ["mouse: teleport to the cell under the cursor (open the global map first).", gray]];
}
