function scr_console_spawn_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [["spawn [id | name][ai]", green], ["Создает вражеского моба в координатах курсора.", gray], ["Опции:", white], ["id: Идентификатор моба.", gray], ["name: Имя моба. (Пробел в названии файла заменяется знаком '_').", gray], ["ai: Включает или выключает ии моба при спавне. (по умолчанию 1).", gray]];
    }
    if (_lang == 3)
    {
        return [["spawn [id | name][ai]", green], ["在光标位置生成一个敌对生物。", gray], ["选项：", white], ["id: 生物标识。", gray], ["name: 生物名称。（文件名中的空格用 '_' 代替）", gray], ["ai: 生成时启用或禁用生物 AI（默认 1）。", gray]];
    }
    return [["spawn [id | name][ai]", green], ["Spawns an enemy mob at the cursor position.", gray], ["Options:", white], ["id: Mob identifier.", gray], ["name: Mob name. (Spaces in the file name are replaced with '_').", gray], ["ai: Enables or disables the mob's AI on spawn (default 1).", gray]];
}
