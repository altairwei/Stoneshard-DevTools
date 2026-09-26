// Why the game refuses to load a save, or "" - the checks behind the main
// menu's Continue button (o_mainMenuNavContainer): the save is marked
// invalid, or was written by another wipe version or compiler build.
// argument[0] the save.map from scr_slotSaveMapLoad.
function scr_devtools_mcp_game_save_problem()
{
    var _m = argument[0];
    var _v = ds_map_find_value(_m, "valid");
    if (!is_numeric(_v))
        return "its save.map has no valid flag";
    if (!_v)
        return "the save is marked invalid - it failed to load before";
    _v = ds_map_find_value(_m, "wipeVersion");
    if (is_undefined(_v))
        _v = global.slotsWipeVersionInit;
    if (string(_v) != string(global.slotsWipeVersion))
        return "it was saved by an incompatible game version (wipe version " + string(_v) + ", this game " + string(global.slotsWipeVersion) + ")";
    _v = ds_map_find_value(_m, "compiler");
    if (is_undefined(_v))
        _v = global.slotsCompilerInit;
    if (string(_v) != string(global.slotsCompiler))
        return "it was saved by a " + string(_v) + " build of the game, this one is " + string(global.slotsCompiler);
    return "";
}
