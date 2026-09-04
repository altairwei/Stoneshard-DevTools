function scr_console_condition_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [
            ["setcondition [id amount]", green],
            ["Изменяет физические состояния игрока: голод, жажду, боль и т.д.", gray],
            ["Опции:", white],
            ["id: hunger (голод), thirsty (жажда), intoxication (интоксикация), pain (боль), morale (мораль), sanity (рассудок), immunity (иммунитет), fatigue (усталость), sleep_scale (шкала сна).", gray],
            ["amount: Значение состояния (от 0 до 100).", gray]
        ];
    }
    if (_lang == 3)
    {
        return [
            ["setcondition [id amount]", green],
            ["设置角色的生理状态：饥饿、口渴、中毒、疼痛、士气、理智、免疫、疲劳、睡眠。", gray],
            ["选项：", white],
            ["id: hunger（饥饿）、thirsty（口渴）、intoxication（中毒）、pain（疼痛）、morale（士气）、sanity（理智）、immunity（免疫）、fatigue（疲劳）、sleep_scale（睡眠）。", gray],
            ["amount: 状态数值（0-100）。", gray]
        ];
    }
    return [
        ["setcondition [id amount]", green],
        ["Changes the value of the provided condition (hunger, pain, sanity, etc.).", gray],
        ["Options:", white],
        ["id: hunger, thirsty, intoxication, pain, morale, sanity, immunity, fatigue, sleep_scale.", gray],
        ["amount: The new value for the condition (0-100).", gray]
    ];
}
