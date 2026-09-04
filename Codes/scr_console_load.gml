function scr_console_load(argument0)
{
    var _argumentsArray = argument[0]
    if (_argumentsArray[0] != "" || array_length(_argumentsArray) > 1)
    {
        scr_console_output_list("invalid argument number", red)
        return;
    }
    if (!variable_global_exists("slotsMap"))
    {
        scr_console_output_list("no save data in this session", red)
        return;
    }
    var _characterName = ds_map_find_value(global.slotsMap, "lastCharacter")
    var _saveName = ds_map_find_value(global.slotsMap, "lastSave")
    if (!scr_slotSaveExists(_characterName, _saveName))
    {
        scr_console_output_list("no save found", red)
        return;
    }
    // same flow as clicking a slot in the save menu (o_saveMenuSlotSave):
    // start a smooth room change to the load event, then drop slotLoaded
    var _smoothChanger = -4
    if (room == global.mainMenuRoom)
        _smoothChanger = scr_smoothRoomChange(-4, [2])
    else
        _smoothChanger = scr_smoothRoomChange(-4, [14, 2])
    if (_smoothChanger == noone)
    {
        scr_console_output_list("a room change is already in progress", red)
        return;
    }
    global.slotLoaded = false
    scr_console_output_list("Loading save...", green)
}
