function scr_console_refresh_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [["refresh", green], ["пересобирает реестр команд (как при запуске консоли).", gray]];
    }
    if (_lang == 3)
    {
        return [["refresh", green], ["重新执行命令注册（重建命令表）。", gray]];
    }
    return [["refresh", green], ["Re-runs the command registration (rebuilds the command table).", gray]];
}
