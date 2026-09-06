function scr_console_respec_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [["respec", green], ["Сбрасывает все атрибуты к базовым значениям класса и убирает все выученные навыки, возвращая потраченные очки атрибутов и навыков.", gray]];
    }
    if (_lang == 3)
    {
        return [["respec", green], ["将所有属性重置为职业默认值，移除所有已学技能，并返还花费的属性点与技能点。", gray]];
    }
    return [["respec", green], ["Resets all attributes to their class defaults and removes every learned skill, refunding the spent attribute and skill points.", gray]];
}
