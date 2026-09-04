function scr_console_tp()
{
    var _argumentsArray = argument[0]
    if (_argumentsArray[0] != "" || array_length(_argumentsArray) > 1)
    {
        scr_console_output_list("invalid argument number", red)
        return;
    }
    if (!instance_exists(o_player))
    {
        scr_console_output_list("player not found", red)
        return;
    }
    var _cellX = scr_round_cell(mouse_x)
    var _cellY = scr_round_cell(mouse_y)
    // mirror the two destroy checks of the vanilla o_teleport alarm chain
    // (Alarm_1 works within a 50px margin, Alarm_0 within 26px and off
    // pattern tiles), so a doomed teleport reports an error instead of
    // silently destroying itself
    if (_cellX < 50 || _cellY < 50 || _cellX > (room_width - 50) || _cellY > (room_height - 50) || scr_full_patern(_cellX, _cellY) || scr_pat_prototype(_cellX, _cellY, 0, 0))
    {
        scr_console_output_list("can't teleport to this cell", red)
        return;
    }
    var _teleport = instance_create_depth(_cellX, _cellY, 0, o_teleport)
    with (_teleport)
    {
        owner = instance_find(o_player, 0)
        alarm[0] = alarm0_delay
    }
    scr_console_output_list(("Teleporting to " + string((_cellX div 26)) + ":" + string((_cellY div 26))), green)
}
