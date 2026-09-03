function scr_console_clear()
{
    var _argumentsArray = argument[0];

    if (_argumentsArray[0] != "")
    {
        scr_console_output_list("invalid argument number", red);
        return;
    }

    // self is the o_devconsole instance along the whole command chain
    ds_list_clear(output_list);
    ds_list_clear(color_list);
}
