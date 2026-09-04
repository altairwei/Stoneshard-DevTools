function scr_console_getroomlist()
{
    if (instance_exists(o_dungeon_controller))
    {
        var _roomArray = o_dungeon_controller.settings.Rooms.roomsArray
        var _size = array_length(_roomArray)
        var _roomsArrayList = array_create(0)
        for (var i = 0; i < _size; i++)
        {
            var _rooms = _roomArray[i].Rooms
            var _roomsArraySize = array_length(_rooms)
            for (var k = 0; k < _roomsArraySize; k++)
                array_push(_roomsArrayList, room_get_name(_rooms[k]))
        }
        _size = array_length(_roomsArrayList)
        for (i = 0; i < _size; i += 5)
        {
            var _lineString = _roomsArrayList[i]
            for (var g = 1; g < 5; g++)
            {
                var _newIndex = i + g
                if (_newIndex < _size)
                    _lineString += ("     " + _roomsArrayList[_newIndex])
            }
            scr_console_output_list(_lineString, gray)
        }
    }
    else
        scr_console_output_list("This command works only inside a dungeon", red)
}
