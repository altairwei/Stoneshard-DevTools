function scr_console_room()
{
    var _argumentsArray = argument[0]
    if (_argumentsArray[0] == "" || array_length(_argumentsArray) != 1)
    {
        scr_console_output_list("invalid argument number", red)
        return;
    }

    var _roomName = _argumentsArray[0]
    var _room = asset_get_index("r_" + _roomName)
    if room_exists(_room)
    {
        scr_console_output_list(("Teleporting in '" + string(_roomName) + "' room"), green)
        scr_smoothRoomChange(_room, [4], -1, -1)
        global.position_tag = ("r_" + _roomName)
    }
    else
        scr_console_output_list("Room not found", red)
}
