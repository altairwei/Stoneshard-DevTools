function scr_devtools_gold()
{
    var _argumentsArray = argument[0]
    if (_argumentsArray[0] == "" || array_length(_argumentsArray) > 1)
    {
        scr_console_output_list("invalid argument number", red)
        return;
    }
    var _amount = round(scr_console_string_to_real_with_nan(_argumentsArray[0]))
    if (is_nan(_amount))
    {
        scr_console_output_list("amount should be a number", red)
        return;
    }
    if (_amount <= 0)
    {
        scr_console_output_list("amount should be greater than 0", red)
        return;
    }
    if (!instance_exists(o_player))
    {
        scr_console_output_list("o_player doesn't exist", red)
        return;
    }
    with (o_inventory)
    {
        // NeoConsole looped `repeat(_amount / 2000)` unchecked; a full 2000
        // gold was lost (bags == 1 never entered the loop) and fractional
        // repeat counts are undefined - floor explicitly and always bank the
        // whole bags first.
        var _bags = floor(_amount / 2000)
        var _remainder = _amount % 2000
        if (_bags >= 1)
        {
            repeat(_bags)
            {
                with (scr_inventory_add_item(asset_get_index("o_inv_moneybag")))
                    ds_map_replace(data, "Stack", 2000)
            }
        }
        if (_remainder > 100)
        {
            with (scr_inventory_add_item(asset_get_index("o_inv_moneybag")))
                ds_map_replace(data, "Stack", _remainder)
        }
        else if (_remainder > 0)
        {
            scr_inventory_add_item(asset_get_index("o_inv_gold"), id, _remainder)
        }
    }
    scr_console_output_list(("Added " + string(_amount) + " gold to player's inventory"), green)
}
