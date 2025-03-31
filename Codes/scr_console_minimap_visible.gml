function scr_console_minimap_visible()
{
    var _argumentsArray = argument[0]
    if (_argumentsArray[0] != "")
    {
        scr_console_output_list("invalid argument number", red)
        return;
    }

    scr_globalmapPaperUpdateRegion("map_aldor")
}