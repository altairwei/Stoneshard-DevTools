function scr_console_locations_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [["locations [pattern]", green], ["Выводит все локации глобальной карты - их имена можно использовать в globalset <location>.", gray], ["Опции:", white], ["pattern: необязательный фильтр по имени (подстрока).", gray]];
    }
    if (_lang == 3)
    {
        return [["locations [pattern]", green], ["列出世界地图上的所有地点 - 这些名字可用于 globalset <location>。", gray], ["选项：", white], ["pattern: 可选的名称过滤（子串匹配）。", gray]];
    }
    return [["locations [pattern]", green], ["Lists every global-map location - use these names with globalset <location>.", gray], ["Options:", white], ["pattern: optional name filter (substring match).", gray]];
}
