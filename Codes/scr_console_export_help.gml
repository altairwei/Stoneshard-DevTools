function scr_console_export_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [["export [table] [separator]", green], ["Экспортирует внутреннюю таблицу данных в текстовый файл с разделителем.", gray], ["Опции:", white], ["table: table_items, table_weapons, table_armor, table_equipment, table_lines, table_speech, table_attributes, table_skills_stats и т.д.", gray], ["separator: Разделитель полей в файле (по умолчанию ';').", gray]];
    }
    if (_lang == 3)
    {
        return [["export [table] [separator]", green], ["将内部数据表导出为带分隔符的文本文件。", gray], ["选项：", white], ["table: table_items、table_weapons、table_armor、table_equipment、table_lines、table_speech、table_attributes、table_skills_stats 等。", gray], ["separator: 写入文件的分隔符（默认 ';'）。", gray]];
    }
    return [["export [table] [separator]", green], ["Exports an internal data table to a delimiter-separated text file.", gray], ["Options:", white], ["table: table_items, table_weapons, table_armor, table_equipment, table_lines, table_speech, table_attributes, table_skills_stats, etc.", gray], ["separator: field delimiter written to the file (default ';').", gray]];
}
