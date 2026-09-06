function scr_console_dialog()
{
    var _argumentsArray = argument[0]
    var _argumentsArrayLength = array_length(_argumentsArray)

    // get_save_filename_ext is the 4-arg variant - plain get_save_filename is
    // absent from the game's function table and miscompiles under MSL's UTMT.
    var _file_name = get_save_filename_ext("*", "dialogue_flow_data.json", "", "Export dialogue flow data")
    var _file = file_text_open_write(_file_name)

    if (_file == -1)
    {
        scr_console_output_list("can not write to file", red)
        return;
    }

    // json_stringify is absent from the game's function table (same miscompile
    // hazard), so a minimal local serializer is used instead. Output is compact
    // JSON (no pretty-printing).
    var _json_text = scr_devtools_json_stringify(global.__dialogue_flow_data)

    file_text_write_string(_file, _json_text)
    // file_text_writeln is absent from the game function table
    file_text_write_string(_file, "\r\n")

    file_text_close(_file)
    scr_console_output_list("dialogue_flow_data has been saved to " + _file_name, green)
}
