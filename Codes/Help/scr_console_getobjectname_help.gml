function scr_console_getobjectname_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [["getobjname [id]", green], ["Показывает имя объекта экземпляра с указанным id.", gray], ["Опции:", white], ["id: Идентификатор экземпляра.", gray]];
    }
    if (_lang == 3)
    {
        return [["getobjname [id]", green], ["显示指定 id 实例的对象名。", gray], ["选项：", white], ["id: 实例标识。", gray]];
    }
    return [["getobjname [id]", green], ["Shows the object name of the instance with the given id.", gray], ["Options:", white], ["id: Instance identifier.", gray]];
}
