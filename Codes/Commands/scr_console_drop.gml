function scr_console_drop()
{
    var _argumentsArray = argument[0];
    var _argumentsArrayLength = array_length(_argumentsArray);
    
    if (_argumentsArray[0] == "" || (_argumentsArray[0] != "inv" && _argumentsArrayLength > 4))
    {
        scr_console_output_list("invalid argument number", red);
        exit;
    }
    
    var MAXWEAPONLEVEL = 30;
    var _nameId = 0;
    var _amount = 1;
    var _amountId = 1;
    var _condition = 1;
    var _conditionId = 2;
    var _durability = 100;
    var _durabilityId = 3;
    var _lvl = MAXWEAPONLEVEL;
    var _target = o_player;
    var _rarity = 1;
    var _dropInstance = noone;
    var _isSlot = 0;
    var _isInventory = 0;
    
    if (_argumentsArray[0] == "inv")
    {
        if (_argumentsArrayLength < 2 || _argumentsArray[1] == "" || _argumentsArrayLength > 5)
        {
            scr_console_output_list("invalid argument number", red);
            exit;
        }
        
        _target = o_inventory;
        _isInventory = 1;
        _nameId += 1;
        _amountId += 1;
        _conditionId += 1;
        _durabilityId += 1;
    }
    
    var _name = _argumentsArray[_nameId];
    
    if (_name == "sword" || _name == "axe" || _name == "mace" || _name == "dagger" || _name == "gsword" || _name == "bow" || _name == "bow" || _name == "crossbow" || _name == "staff" || _name == "spear" || _name == "head" || _name == "chest" || _name == "arms" || _name == "shield" || _name == "legs" || _name == "waist" || _name == "ring" || _name == "amulet" || _name == "back")
    {
        _isSlot = 1;
        _amountId += 2;
        _conditionId += 2;
        _durabilityId += 2;
    }
    
    switch (_name)
    {
        case "arrows01":
            _name = "arrows";
            break;
        
        case "arrows02":
            _name = "broadhead_arrows";
            break;
        
        case "arrows03":
            _name = "bodkin_arrows";
            break;
        
        case "bolts":
        case "bolts01":
            _name = "leafshaped_bolts";
            break;
        
        case "bolts02":
            _name = "broadhead_bolts";
            break;
        
        case "bolts03":
            _name = "bodkin_bolts";
            break;
        
        case "scroll01":
            _name = "scroll_identification";
            break;
        
        case "scroll02":
            _name = "scroll_enchant";
            break;
        
        case "scroll03":
            _name = "scroll_disenchant";
            break;
    }
    
    if (_isSlot)
    {
        if (_argumentsArrayLength > 1)
        {
            _rarity = _argumentsArray[1];
            
            switch (_rarity)
            {
                case "common":
                    _rarity = (1 << 0);
                    break;
                
                case "legendary":
                case "unique":
                    _rarity = (6 << 0);
                    break;
                
                default:
                    _rarity = scr_console_string_to_real_with_nan(_argumentsArray[1]);
                    break;
            }
            
            if (is_nan(_rarity) || _rarity != (1 << 0) || _rarity != (6 << 0))
            {
                scr_console_output_list("invalid argument exception", red);
                exit;
            }
        }
        
        if (_argumentsArrayLength > 2)
        {
            _lvl = _argumentsArray[2];
            
            switch (_lvl)
            {
                case "max":
                    _lvl = MAXWEAPONLEVEL;
                    break;
                
                default:
                    _lvl = scr_console_string_to_real_with_nan(_argumentsArray[2]);
                    break;
            }
            
            if (is_nan(_lvl) || _lvl < 1)
            {
                scr_console_output_list("level value should greater than 0", red);
                exit;
            }
            else if (_lvl > MAXWEAPONLEVEL)
            {
                _lvl = MAXWEAPONLEVEL;
            }
        }
    }
    
    if (_argumentsArrayLength > _amountId)
    {
        _amount = scr_console_string_to_real_with_nan(_argumentsArray[_amountId]);
        
        if (is_nan(_amount) || _amount < 0)
        {
            scr_console_output_list("amount value should greater than 0", red);
            exit;
        }
        else if (_name != "gold")
        {
            if (_amount > 10)
                _amount = 10;
        }
        else
        {
            _amount = floor(_amount / 100);
        }
    }
    
    if (_argumentsArrayLength > _conditionId)
    {
        _condition = _argumentsArray[_conditionId];
        
        switch (_condition)
        {
            case "common":
                _condition = (1 << 0);
                break;
            
            case "uncommon":
                _condition = (2 << 0);
                break;
            
            case "rare":
                _condition = (3 << 0);
                break;
            
            case "cursed":
                _condition = (5 << 0);
                break;
            
            default:
                _condition = scr_console_string_to_real_with_nan(_argumentsArray[_conditionId]);
                break;
        }
        
        if (is_nan(_condition) || _condition < (1 << 0) || _condition > (5 << 0))
        {
            scr_console_output_list("invalid argument exception", red);
            exit;
        }
    }
    
    if (_argumentsArrayLength > _durabilityId)
    {
        _durability = scr_console_string_to_real_with_nan(_argumentsArray[_durabilityId]);
        
        if (is_nan(_durability) || _durability < 0 || _durability > 100)
        {
            scr_console_output_list("durability should be in the range from 1 to 100", red);
            exit;
        }
    }
    
    with (_target)
    {
        repeat (_amount)
        {
            var _determined_quality = !_isSlot ? _condition : _rarity;
            
            if (_isInventory)
            {
                _dropInstance = scr_inventory_add_weapon(string_replace_all(_name, "_", " "), _determined_quality);
                
                if (!_dropInstance)
                    _dropInstance = scr_inventory_add_weapon(scr_weapon_id_get_name(_name), _determined_quality);
            }
            else
            {
                _dropInstance = scr_weapon_loot(string_replace_all(_name, "_", " "), x, y, 100, _determined_quality);
                
                if (!_dropInstance)
                    _dropInstance = scr_weapon_loot(scr_weapon_id_get_name(_name, 1), x, y, 100, _determined_quality);
            }
            
            if (_dropInstance)
            {
                with (_dropInstance)
                    ds_map_replace(data, "Duration", (_durability * scr_inv_atr("MaxDuration")) / 100);
            }
            else if (_isInventory)
            {
                if (asset_get_index("o_inv_" + string(_name)))
                    _dropInstance = scr_inventory_add_item(asset_get_index("o_inv_" + string(_name)));
            }
            else
            {
                _dropInstance = scr_loot(asset_get_index("o_loot_" + string(_name)), x, y, 100);
            }
        }
    }
    
    if (_dropInstance)
    {
        if (_isInventory)
            scr_console_output_list("Item '" + string(_name) + "' dropped in your inventory", green);
        else
            scr_console_output_list("Item '" + string(_name) + "' dropped", green);
    }
    else
    {
        scr_console_output_list("Item '" + string(_name) + "' not found", red);
    }
}