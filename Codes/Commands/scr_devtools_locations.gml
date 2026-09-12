// Lists every location registered on the global map - the same name keys
// globalset accepts for its `globalset <location>` form. Names are read live
// from global.locationMapName (filled by the vanilla scr_glmap_addLocation
// family), so the list always matches what globalset can teleport to. With
// an optional [pattern], only matching names are shown (substring, like find).
// Empty result means no map is loaded yet (locationMapName is only populated
// once the global map exists).
function scr_devtools_locations()
{
    var _argumentsArray = argument[0]
    if (array_length(_argumentsArray) > 1 || (_argumentsArray[0] != "" && array_length(_argumentsArray) != 1))
    {
        scr_console_output_list("invalid argument number", red)
        return;
    }
    var _pattern = _argumentsArray[0]

    if (!variable_global_exists("locationMapName") || !ds_exists(global.locationMapName, ds_type_map))
    {
        scr_console_output_list("no global map loaded yet", gray)
        return;
    }

    var _found = 0
    var _key = ds_map_find_first(global.locationMapName)
    while (!is_undefined(_key))
    {
        if (_pattern == "" || string_pos(_pattern, _key) > 0)
        {
            scr_console_output_list(_key, green)
            _found++
        }
        _key = ds_map_find_next(global.locationMapName, _key)
    }
    if (_found == 0)
        scr_console_output_list("no location matches", gray)
    else
        scr_console_output_list(("Found " + string(_found) + " location(s)"), gray)
}
