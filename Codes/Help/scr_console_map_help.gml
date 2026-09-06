function scr_console_map_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [["map", green], ["Раскрывает все спрятанные иконки точек интереса на локальной карте и показывает текущий чанк на котором находится игрок.", gray], ["При повторной активации возвращает игровое состояние иконок.", gray]];
    }
    if (_lang == 3)
    {
        return [["map", green], ["揭露本地地图上所有隐藏的兴趣点图标，并显示玩家当前所在区块。", gray], ["再次激活会恢复图标的游戏状态。", gray]];
    }
    return [["map", green], ["Reveals all hidden point-of-interest icons on the local map and shows the chunk the player is currently in.", gray], ["Activating again restores the game's icon state.", gray]];
}
