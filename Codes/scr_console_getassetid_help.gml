function scr_console_getassetid_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [["getassetid [asset_name]", green], ["Возвращает идентификатор ресурса по его имени.", gray], ["Опции:", white], ["asset_name: Имя ресурса.", gray]];
    }
    if (_lang == 3)
    {
        return [["getassetid [asset_name]", green], ["按资源名返回其标识符。", gray], ["选项：", white], ["asset_name: 资源名称。", gray]];
    }
    return [["getassetid [asset_name]", green], ["Returns the asset id of the given asset name.", gray], ["Options:", white], ["asset_name: Name of the asset.", gray]];
}
