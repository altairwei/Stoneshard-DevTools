function scr_console_attr_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [
            ["setatr [id amount] | [reset]", green],
            ["Изменяет атрибуты персонажа: силу, ловкость, восприятие, живучесть, волю, опыт, уровень, очки навыков и атрибутов.", gray],
            ["Опции:", white],
            ["id: str (Сила), agl (Ловкость), prc (Восприятие), vit (Живучесть), wil (Воля), xp, lvl, sp, ap.", gray],
            ["amount: Новое значение атрибута (по умолчанию 1).", gray],
            ["reset: Сбрасывает характеристики к 10, уровень к 1, опыт к 0.", gray]
        ];
    }
    if (_lang == 3)
    {
        return [
            ["setatr [id amount] | [reset]", green],
            ["设置角色属性：力量、敏捷、感知、活力、意志、经验、等级、技能点与属性点。", gray],
            ["选项：", white],
            ["id: str（力量）、agl（敏捷）、prc（感知）、vit（活力）、wil（意志）、xp、lvl、sp、ap。", gray],
            ["amount: 属性的新值（默认 1）。", gray],
            ["reset: 属性重置为 10，等级重置为 1，经验重置为 0。", gray]
        ];
    }
    return [
        ["setatr [id amount] | [reset]", green],
        ["Sets a player attribute (stats, xp, level, skill/attribute points) or resets them.", gray],
        ["Options:", white],
        ["id: str/strength, agl/agility, prc/perception, vit/vitality, wil/willpower, xp, lvl/level, sp, ap.", gray],
        ["amount: New value for the attribute (default 1).", gray],
        ["reset: Resets stats to 10, level to 1 and xp to 0.", gray]
    ];
}
