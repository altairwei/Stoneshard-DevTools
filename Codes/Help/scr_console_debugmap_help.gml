function scr_console_debugmap_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [["debugmap", green], ["Включает режим отладки для глобальной карты.", gray]];
    }
    if (_lang == 3)
    {
        return [["debugmap", green], ["为世界地图开启调试模式。", gray]];
    }
    return [["debugmap", green], ["Enables debug mode for the global map.", gray]];
}
