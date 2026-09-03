function scr_console_buff_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [["buff [id] [steps] [tier] [target:bool]", green], ["Кидает на игрока указанный модификатор.", gray], ["При повторном вызове суммируется с уже активными модификаторами.", gray], ["Опции:", white], ["id: Идентификатор модификатора.", gray], ["steps: Длительность модификатора. (по умолчанию 1).", gray], ["tier: Задает ступень эффектам если они есть. (по умолчанию 1).", gray], ["target: bool Определяет цель наложения бафа.", gray], ["\tЕсли значение true то баф кидается на моба указанного курсором если false на игрока (по умолчанию false).", gray]];
    }
    if (_lang == 3)
    {
        return [["buff [id] [steps] [tier] [target:bool]", green], ["对玩家施加指定的修饰效果。", gray], ["重复施放会与已激活的修饰效果叠加。", gray], ["选项：", white], ["id: 修饰效果标识。", gray], ["steps: 修饰效果的持续步数（默认 1）。", gray], ["tier: 修饰效果的等级（若有）（默认 1）。", gray], ["target: 布尔值，指定施放目标。", gray], ["\t为 true 时对光标所指的生物施放，为 false 则对玩家（默认 false）。", gray]];
    }
    return [["buff [id] [steps] [tier] [target:bool]", green], ["Applies the given modifier to the player.", gray], ["Repeated casts stack with already active modifiers.", gray], ["Options:", white], ["id: Modifier identifier.", gray], ["steps: Modifier duration in steps (default 1).", gray], ["tier: Sets the effect tier if the modifier has one (default 1).", gray], ["target: A bool that determines the buff's target.", gray], ["\tIf true the buff is applied to the mob under the cursor; if false to the player (default false).", gray]];
}
