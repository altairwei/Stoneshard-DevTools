function scr_console_weather_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [
            ["weather [rain | info | clear]", green],
            ["Команда позволяющая работать с внутриигровыми погодными эффектами.", gray],
            ["Опции:", white],
            ["rain: Запускает дождь или снег в зависимости от биома.", gray],
            ["info: Включает отображение статуса погодных условий.", gray],
            ["clear: Останавливает все погодные эффекты.", gray]
        ];
    }
    if (_lang == 3)
    {
        return [
            ["weather [rain | info | clear]", green],
            ["控制游戏内天气效果。", gray],
            ["选项：", white],
            ["rain: 根据生物群落下雨或下雪。", gray],
            ["info: 开启天气状态显示。", gray],
            ["clear: 停止所有天气效果。", gray]
        ];
    }
    return [
        ["weather [rain | info | clear]", green],
        ["Controls in-game weather effects.", gray],
        ["Options:", white],
        ["rain: Starts rain or snow depending on the biome.", gray],
        ["info: Toggles the weather status display.", gray],
        ["clear: Stops all weather effects.", gray]
    ];
}
