function scr_console_allskills_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [["skills [all | reset]", green], ["Команда для манипуляции скиллами игрока.", gray], ["Опции:", white], ["all: Разблокирует все доступные скиллы. (по умолчанию).", gray], ["reset: Сбрасывает все активные скиллы и возвращает скилл поинты игроку.", gray]];
    }
    if (_lang == 3)
    {
        return [["skills [all | reset]", green], ["操作玩家技能的命令。", gray], ["选项：", white], ["all: 解锁所有可用技能（默认）。", gray], ["reset: 重置所有已激活技能并将技能点返还给玩家。", gray]];
    }
    return [["skills [all | reset]", green], ["Manipulates the player's skills.", gray], ["Options:", white], ["all: Unlocks all available skills (default).", gray], ["reset: Resets all active skills and returns the skill points to the player.", gray]];
}
