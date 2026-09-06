function scr_console_killboss_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [["killboss", green], ["Команда позволяющая быстро убивать босса.", gray], ["Если у босса больше 1 стадии пропускает текущую.", gray]];
    }
    if (_lang == 3)
    {
        return [["killboss", green], ["快速击杀 BOSS 的命令。", gray], ["若 BOSS 拥有多个阶段则跳过当前阶段。", gray]];
    }
    return [["killboss", green], ["Quickly kills the boss.", gray], ["If the boss has more than one stage, skips the current one.", gray]];
}
