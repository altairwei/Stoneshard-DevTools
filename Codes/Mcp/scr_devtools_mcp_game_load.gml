// game_load: loads a save the way the save menu's Load button does, from the
// main menu or from a session - which is dropped without saving. Only starts
// the room change; game_wait follows it. argument[0] the arguments map or -1:
// character and save folder names, both optional (neither: the save the main
// menu's Continue loads; no save: the character's newest), allow_exitsave.
// Returns the reply text and sets _mcp_exec_error.
function scr_devtools_mcp_game_load()
{
    var _args = argument[0];
    var _phase = scr_devtools_mcp_game_phase();
    var _ch = undefined;
    var _sv = undefined;
    var _allow = false;
    var _v = 0;
    var _i = -1;
    var _list = -1;
    var _m = -1;
    var _problem = "";
    var _changer = -4;
    _mcp_exec_error = true;
    if (_phase == "loading")
        return "a transition is in progress - game_wait for it to finish first";
    if (_phase != "menu" && _phase != "session")
        return "cannot load a save here (phase '" + _phase + "', room " + room_get_name(room) + ")";
    if (!variable_global_exists("slotsMap"))
        return "the save slots are not initialized yet";
    if (_args != -1)
    {
        _ch = ds_map_find_value(_args, "character");
        _sv = ds_map_find_value(_args, "save");
        _v = ds_map_find_value(_args, "allow_exitsave");
        if (is_numeric(_v))
        {
            if (_v)
                _allow = true;
        }
    }
    if (!is_undefined(_ch) && !is_string(_ch))
        return "'character' must be a folder name such as \"character_1\" - game_saves lists them";
    if (!is_undefined(_sv) && !is_string(_sv))
        return "'save' must be a folder name such as \"autosave_1\" - game_saves lists them";
    if (is_undefined(_ch))
    {
        _ch = ds_map_find_value(global.slotsMap, "lastCharacter");
        if (is_undefined(_sv))
            _sv = ds_map_find_value(global.slotsMap, "lastSave");
        if (!is_string(_ch))
            _ch = "N/A";
        if (_ch == "N/A")
            return "there is no last save to continue - pass character and save (game_saves lists them)";
    }
    // only folders the game lists: the names end up in file paths
    _list = scr_slotsGetOrderList();
    _i = ds_list_find_index(_list, _ch);
    ds_list_destroy(_list);
    if (_i < 0)
        return "there is no character '" + _ch + "' - game_saves lists them";
    _list = scr_slotSavesGetOrderList(_ch);
    if (is_undefined(_sv))
    {
        if (ds_list_size(_list) > 0)
            _sv = ds_list_find_value(_list, 0);
    }
    _i = -1;
    if (is_string(_sv))
        _i = ds_list_find_index(_list, _sv);
    ds_list_destroy(_list);
    if (_i < 0)
    {
        if (is_string(_sv))
            return _ch + " has no save '" + _sv + "' - game_saves lists them";
        return _ch + " has no saves";
    }
    _m = scr_slotSaveMapLoad(_ch, _sv);
    if (_m == -4)
        return "cannot read the save.map of " + _ch + "/" + _sv;
    _problem = scr_devtools_mcp_game_save_problem(_m);
    ds_map_destroy(_m);
    if (_problem != "")
        return "the game refuses to load " + _ch + "/" + _sv + ": " + _problem;
    if (scr_slotSaveGetType(_sv) == 2 && !_allow)
        return _ch + "/" + _sv + " is an exit save: the game deletes it once loaded, and the whole character when no other save is left - pass allow_exitsave: true to load it anyway";
    if (_phase == "menu")
    {
        // the menu the player would reach first; its Destroy event also
        // creates o_mouseLockController (edge scrolling), made nowhere else
        if (instance_exists(o_mainMenuPressAnyKey))
            instance_destroy(o_mainMenuPressAnyKey);
        _changer = scr_smoothRoomChange(-4, [2]);
    }
    else
        _changer = scr_smoothRoomChange(-4, [14, 2]);
    if (_changer == -4)
        return "a room change is already in progress - game_wait for it to finish first";
    global.slotLoaded = false;
    ds_map_set(global.slotsMap, "lastCharacter", _ch);
    ds_map_set(global.slotsMap, "lastSave", _sv);
    _mcp_exec_error = false;
    return "loading " + _ch + "/" + _sv + " - game_wait for phase 'session'";
}
