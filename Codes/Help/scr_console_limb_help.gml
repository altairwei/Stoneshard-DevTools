function scr_console_limb_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [["inj [limb] [mode] [amount]", green], ["Наносит повреждение или кровотечение на заданную конечность игрока.", gray], ["Опции:", white], ["limb: Конечность, на которую накладывается эффект.", gray], ["\thead: Голова.", gray], ["\ttorso (tors): Торс.", gray], ["\tlleg (legs): Левая нога.", gray], ["\trleg (rlegs): Правая нога.", gray], ["\tlhand: Левая рука.", gray], ["\trhand: Правая рука.", gray], ["mode: Тип эффекта.", gray], ["\tinj: Задает состояние конечности в процентах.", gray], ["\t\tamount: Целевое состояние (по умолчанию 0).", gray], ["\tblood: Накладывает кровотечение на конечность.", gray], ["\t\tamount: Длительность в шагах (по умолчанию 1).", gray]];
    }
    if (_lang == 3)
    {
        return [["inj [limb] [mode] [amount]", green], ["对玩家指定部位施加伤害或流血效果。", gray], ["选项：", white], ["limb: 施加效果的部位。", gray], ["\thead: 头部。", gray], ["\ttorso (tors): 躯干。", gray], ["\tlleg (legs): 左腿。", gray], ["\trleg (rlegs): 右腿。", gray], ["\tlhand: 左手。", gray], ["\trhand: 右手。", gray], ["mode: 效果类型。", gray], ["\tinj: 设置部位状态（百分比）。", gray], ["\t\tamount: 目标状态（默认 0）。", gray], ["\tblood: 向部位施加流血。", gray], ["\t\tamount: 流血持续步数（默认 1）。", gray]];
    }
    return [["inj [limb] [mode] [amount]", green], ["Applies an injury or a bleed to the given limb of the player.", gray], ["Options:", white], ["limb: Limb to apply the effect to.", gray], ["\thead: Head.", gray], ["\ttorso (tors): Torso.", gray], ["\tlleg (legs): Left leg.", gray], ["\trleg (rlegs): Right leg.", gray], ["\tlhand: Left arm.", gray], ["\trhand: Right arm.", gray], ["mode: Effect type.", gray], ["\tinj: Sets the health of the limb in percent.", gray], ["\t\tamount: Target health (default 0).", gray], ["\tblood: Applies a bleed to the limb.", gray], ["\t\tamount: Bleed duration in steps (default 1).", gray]];
}
