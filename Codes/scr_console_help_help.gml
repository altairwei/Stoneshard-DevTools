function scr_console_help_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [["help [comand]", green], ["Выводит подсказку для команды в консоли. (По умолчанию список команд и аргументов)", gray], ["Опции:", white], ["comand: Имя команды для более подробного описания.", gray]];
    }
    if (_lang == 3)
    {
        return [["help [command]", green], ["显示控制台命令的帮助。（默认列出全部命令及参数）", gray], ["选项：", white], ["command: 要查看详细说明的命令名。", gray]];
    }
    return [["help [command]", green], ["Shows help for a console command. (By default lists all commands and arguments)", gray], ["Options:", white], ["command: Name of the command to describe in detail.", gray]];
}
