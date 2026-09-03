function scr_console_export_help()
{
    return [["export [table] [separator]", green], ["Exports an internal data table to a delimiter-separated text file.", gray], ["Options:", white], ["table: table_items, table_weapons, table_armor, table_equipment, table_lines, table_speech, table_attributes, table_skills_stats, etc.", gray], ["separator: field delimiter written to the file (default ';').", gray]];
}
