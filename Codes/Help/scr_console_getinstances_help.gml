function scr_console_getinstances_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [["getinstances [parent_object]", green], ["Выводит список всех экземпляров заданного объекта с их координатами.", gray], ["Опции:", white], ["parent_object: Идентификатор объекта, экземпляры которого нужно найти.", gray]];
    }
    if (_lang == 3)
    {
        return [["getinstances [parent_object]", green], ["列出指定对象类型的全部实例及其坐标。", gray], ["选项：", white], ["parent_object: 要查找实例的对象标识。", gray]];
    }
    return [["getinstances [parent_object]", green], ["Lists all instances of the given object with their coordinates.", gray], ["Options:", white], ["parent_object: Identifier of the object whose instances to find.", gray]];
}
