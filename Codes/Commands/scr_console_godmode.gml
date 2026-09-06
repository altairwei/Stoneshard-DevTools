function scr_console_godmode()
{
    var _argumentsArray = argument[0];
    
    if (_argumentsArray[0] != "")
    {
        scr_console_output_list("invalid argument number", red);
        exit;
    }
    
    if (global.playerGodMode)
    {
        global.playerGodMode = 0;
        global.playerNoPain = 0;
        global.is_nocd = 0;
        scr_console_output_list("God mode is OFF", red);
    }
    else
    {
        global.playerGodMode = 1;
        global.playerNoPain = 1;
        global.is_nocd = 1;
        scr_console_output_list("God mode is ON", green);
    }
}