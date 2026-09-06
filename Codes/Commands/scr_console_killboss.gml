function scr_console_killboss()
{
    var _argumentsArray = argument[0];
    
    if (_argumentsArray[0] != "")
    {
        scr_console_output_list("invalid argument number", red);
        exit;
    }
    
    with (o_statueofsacrifice)
        HP = 0;
    
    with (o_vampire_archont_beast)
        HP = 0;
    
    with (o_ancientTroll)
        HP = 0;
    
    with (o_manticore)
        HP = 0;
}