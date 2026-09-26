// game_saves result: every character with its saves, both newest first as
// the save menu orders them. A save carries its folder, type, date, location
// and whether the game can load it - with the reason when it cannot. Names
// and locations are looked up the way the save menu does, falling back to
// the raw key.
function scr_devtools_mcp_game_saves()
{
    var _chars = scr_slotsGetOrderList();
    var _saves = -1;
    var _m = -1;
    var _n = ds_list_size(_chars);
    var _c = 0;
    var _i = 0;
    var _ch = "";
    var _sv = "";
    var _v = 0;
    var _problem = "";
    var _s = "{\"last_save\":{\"character\":" + scr_devtools_mcp_json_str(ds_map_find_value(global.slotsMap, "lastCharacter")) + ",\"save\":" + scr_devtools_mcp_json_str(ds_map_find_value(global.slotsMap, "lastSave")) + "},\"characters\":[";
    for (_c = 0; _c < _n; _c++)
    {
        _ch = ds_list_find_value(_chars, _c);
        if (_c > 0)
            _s += ",";
        _s += "{\"character\":" + scr_devtools_mcp_json_str(_ch);
        _m = scr_slotMapLoad(_ch);
        if (_m != -4)
        {
            _v = ds_map_find_value(_m, "nameKey");
            if (is_string(_v))
            {
                if (variable_global_exists("char_name"))
                {
                    if (ds_map_exists(global.char_name, _v))
                        _v = ds_map_find_value(global.char_name, _v);
                }
                _s += ",\"name\":" + scr_devtools_mcp_json_str(_v);
            }
            _v = ds_map_find_value(_m, "permadeath");
            if (is_numeric(_v))
            {
                if (_v != -4)
                    _s += ",\"permadeath\":" + scr_devtools_mcp_json_bool(_v);
            }
            ds_map_destroy(_m);
        }
        _s += ",\"saves\":[";
        _saves = scr_slotSavesGetOrderList(_ch);
        for (_i = 0; _i < ds_list_size(_saves); _i++)
        {
            _sv = ds_list_find_value(_saves, _i);
            if (_i > 0)
                _s += ",";
            _v = scr_slotSaveGetType(_sv);
            if (_v == 0)
                _v = "save";
            else if (_v == 1)
                _v = "autosave";
            else if (_v == 2)
                _v = "exitsave";
            else
                _v = "unknown";
            _s += "{\"save\":" + scr_devtools_mcp_json_str(_sv) + ",\"type\":\"" + _v + "\"";
            _m = scr_slotSaveMapLoad(_ch, _sv);
            if (_m == -4)
                _problem = "its save.map cannot be read";
            else
            {
                _v = ds_map_find_value(_m, "dateTime");
                if (is_numeric(_v))
                {
                    if (_v != -4)
                        _s += ",\"date\":" + scr_devtools_mcp_json_str(date_date_string(_v) + " - " + date_time_string(_v));
                }
                _v = ds_map_find_value(_m, "locationTitleKey");
                if (is_string(_v))
                {
                    if (variable_global_exists("location_titles"))
                    {
                        if (ds_map_exists(global.location_titles, _v))
                            _v = ds_map_find_value(global.location_titles, _v);
                    }
                    _s += ",\"location\":" + scr_devtools_mcp_json_str(_v);
                }
                _problem = scr_devtools_mcp_game_save_problem(_m);
                ds_map_destroy(_m);
            }
            if (_problem == "")
                _s += ",\"loadable\":true}";
            else
                _s += ",\"loadable\":false,\"problem\":" + scr_devtools_mcp_json_str(_problem) + "}";
        }
        ds_list_destroy(_saves);
        _s += "]}";
    }
    ds_list_destroy(_chars);
    return _s + "]}";
}
