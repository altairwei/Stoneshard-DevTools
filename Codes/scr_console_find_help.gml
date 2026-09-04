function scr_console_find_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [
            ["find [string]", green],
            ["Находит команды, в названии которых содержится заданная строка.", gray],
            ["Опции:", white],
            ["string: Текст для поиска в названиях команд.", gray]
        ];
    }
    if (_lang == 3)
    {
        return [
            ["find [string]", green],
            ["按名称查找包含指定文本的命令。", gray],
            ["选项：", white],
            ["string: 用于匹配命令名的文本。", gray]
        ];
    }
    return [
        ["find [string]", green],
        ["Searches the list of commands for names containing the given text.", gray],
        ["Options:", white],
        ["string: Text to search for in command names.", gray]
    ];
}
