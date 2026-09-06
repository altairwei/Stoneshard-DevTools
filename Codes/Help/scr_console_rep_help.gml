function scr_console_rep_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [["setrep [city] [amount]", green], ["Изменяет репутацию игрока с выбранным городом. Если значение не задано, показывает текущую репутацию.", gray], ["Опции:", white], ["city: Город, с которым следует изменить репутацию.", gray], ["\tall: Все города.", gray], ["\tosbrook: Осбрук.", gray], ["\tmannshire: Маншир.", gray], ["\twillow: Гнилая ива.", gray], ["\tdenbrie: Денбри.", gray], ["amount: Изменение репутации. (по умолчанию 0).", gray]];
    }
    if (_lang == 3)
    {
        return [["setrep [city] [amount]", green], ["更改与所选城市的声誉；省略数值时显示当前声誉。", gray], ["选项：", white], ["city: 要更改声誉的城市。", gray], ["\tall: 所有城市。", gray], ["\tosbrook: Osbrook。", gray], ["\tmannshire: Mannshire。", gray], ["\twillow: Rotten Willow。", gray], ["\tdenbrie: Denbrie。", gray], ["amount: 声誉变化值（默认 0）。", gray]];
    }
    return [["setrep [city] [amount]", green], ["Changes the player's reputation with the given city, or shows the current value if the amount is omitted.", gray], ["Options:", white], ["city: City to change the reputation with.", gray], ["\tall: All cities.", gray], ["\tosbrook: Osbrook.", gray], ["\tmannshire: Mannshire.", gray], ["\twillow: Rotten Willow.", gray], ["\tdenbrie: Denbrie.", gray], ["amount: The reputation change value (default 0).", gray]];
}
