function scr_console_clear_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [["clear", green], ["Очищает всю историю команд в консоли.", gray]];
    }
    if (_lang == 3)
    {
        return [["clear", green], ["清空控制台中的全部命令历史。", gray]];
    }
    return [["clear", green], ["Clears the entire command history in the console.", gray]];
}
