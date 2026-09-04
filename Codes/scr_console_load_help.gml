function scr_console_load_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [["load", green], ["Загружает последнее сохранение.", gray]];
    }
    if (_lang == 3)
    {
        return [["load", green], ["加载最近的存档。", gray]];
    }
    return [["load", green], ["Loads the latest save.", gray]];
}
