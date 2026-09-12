function scr_console_getobjectname_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [["getobjname [id] | mouse", green], ["Показывает имя объекта экземпляра с указанным id или объекта под курсором мыши.", gray], ["Опции:", white], ["id: Идентификатор экземпляра.", gray], ["mouse: объект под курсором мыши.", gray]];
    }
    if (_lang == 3)
    {
        return [["getobjname [id] | mouse", green], ["显示指定 id 实例、或鼠标指向对象的对象名。", gray], ["选项：", white], ["id: 实例标识。", gray], ["mouse: 取鼠标指向的对象。", gray]];
    }
    return [["getobjname [id] | mouse", green], ["Shows the object name of the instance with the given id, or of the object under the mouse cursor.", gray], ["Options:", white], ["id: Instance identifier.", gray], ["mouse: The object under the cursor.", gray]];
}
