function scr_console_help()
{
    var _comandName = argument[0];
    
    if (array_length(_comandName) > 1)
    {
        scr_console_output_list("invalid argument number", red);
        exit;
    }
    
    if (_comandName[0] == "")
    {
        scr_console_output_list("help [comand]", gray);
        scr_console_output_list("clear", gray);
        scr_console_output_list("drop [inv] [id | name | [slot rarity... lvl]] [amount] [condition...] [durability]", gray);
        scr_console_output_list("devinfo", gray);
        scr_console_output_list("devcam", gray);
        scr_console_output_list("spawn [id | name][ai]", gray);
        scr_console_output_list("room [id]", gray);
        scr_console_output_list("buff [id] [steps] [tier] [target:bool]", gray);
        scr_console_output_list("steamclear", gray);
        scr_console_output_list("time [change [time...]] | [scale [amount]]", gray);
        scr_console_output_list("gui", gray);
        scr_console_output_list("map", gray);
        scr_console_output_list("fow", gray);
        scr_console_output_list("weather [rain | fog | info | clear]", gray);
        scr_console_output_list("enemyinfo", gray);
        scr_console_output_list("godmode", gray);
        scr_console_output_list("nodeath", gray);
        scr_console_output_list("getxp", gray);
        scr_console_output_list("sethp", gray);
        scr_console_output_list("setmp", gray);
        scr_console_output_list("save [0 - sleep | 1 - auto | 2 - exit]", gray);
        scr_console_output_list("load", gray);
        scr_console_output_list("killboss", gray);
        scr_console_output_list("skills [all | reset]", gray);
        scr_console_output_list("contract [num ...]", gray);
        scr_console_output_list("condition [state... amount]", gray);
        scr_console_output_list("psy [state... amount]", gray);
        scr_console_output_list("limb [limb… [inj amount] | [blood  steps]]", gray);
        scr_console_output_list("attr [id… amount] | [reset]", gray);
        scr_console_output_list("boost [id amount step]", gray);
        scr_console_output_list("lvl [level]", gray);
        scr_console_output_list("globalset [x | location ] [y]", gray);
        scr_console_output_list("nocd", gray);
        scr_console_output_list("getseed", gray);
    }
    else
    {
        switch (_comandName[0])
        {
            case "help":
                scr_console_output_list(_comandName[0] + " [command]", green);
                scr_console_output_list("Displays help information for a command in the console. (Default is the list of commands and arguments)", gray);
                scr_console_output_list("Options:", white);
                scr_console_output_list("command: The name of the command for a more detailed description.", gray);
                break;
            
            case "clear":
                scr_console_output_list(_comandName[0], green);
                scr_console_output_list("Clears the entire command history in the console.", gray);
                break;
            
            case "drop":
                scr_console_output_list(_comandName[0] + " [target...] [id | name | [slot rarity... lvl]] [amount] [condition...] [durability]", green);
                scr_console_output_list("Creates an item in the world with the specified parameters and drops it near the player.", gray);
                scr_console_output_list("If a slot is specified, a random item for that slot is generated.", gray);
                scr_console_output_list("You can also specify the rarity and item level in the slot parameter like 'drop slot legendary 30'.", gray);
                scr_console_output_list("Options:", white);
                scr_console_output_list("inv: Creates an item in the player's inventory (optional parameter)", gray);
                scr_console_output_list("id: Item identifier.", gray);
                scr_console_output_list("name: Name of the item. (Spaces in the filename are replaced by '_')", gray);
                scr_console_output_list("slot: Item type.", gray);
                scr_console_output_list("    common: Common rarity.", gray);
                scr_console_output_list("    unique: Unique rarity.", gray);
                scr_console_output_list("    legendary: Legendary rarity.", gray);
                scr_console_output_list("      lvl: The level of the dropped item, or 'max' to select all available.", gray);
                scr_console_output_list("            If the specified item level does not exist, it rounds down to the nearest available level (default max).", gray);
                scr_console_output_list("amount: Number of items to drop (default 1).", gray);
                scr_console_output_list("condition...: Item condition. Numeric values from 0 to 3 are allowed instead of condition names (default common).", gray);
                scr_console_output_list("    common: Common state (default).", gray);
                scr_console_output_list("    uncommon: Uncommon state (blue background).", gray);
                scr_console_output_list("    rare: Rare state (green background).", gray);
                scr_console_output_list("    curse: Cursed state (dark background with skull icon).", gray);
                scr_console_output_list("durability: Item durability in percentage (default 100).", gray);
                break;
            
            case "devinfo":
                scr_console_output_list(_comandName[0], green);
                scr_console_output_list("Activates developer mode. The player can teleport to cursor coordinates using the F1 key.", gray);
                scr_console_output_list("Additionally, pressing Shift and Ctrl keys toggles different display modes.", gray);
                break;
            
            case "devcam":
                scr_console_output_list(_comandName[0] + " [speed] [amount]", green);
                scr_console_output_list("Activates developer camera. Control with arrow keys.", gray);
                break;
            
            case "spawn":
                scr_console_output_list(_comandName[0] + " [id | name][ai]", green);
                scr_console_output_list("Creates an enemy mob at cursor coordinates.", gray);
                scr_console_output_list("Options:", white);
                scr_console_output_list("id: Mob identifier.", gray);
                scr_console_output_list("name: Mob name. (Spaces in the filename are replaced by '_').", gray);
                scr_console_output_list("ai: Enables or disables mob AI upon spawn (default 1).", gray);
                break;

            case "room":
                scr_console_output_list(_comandName[0] + " [id]", green);
                scr_console_output_list("Teleports the character to the specified room.", gray);
                scr_console_output_list("Options:", white);
                scr_console_output_list("id: Room identifier.", gray);
                break;

            case "buff":
                scr_console_output_list(_comandName[0] + " [id] [steps] [tier] [target:bool]", green);
                scr_console_output_list("Applies a modifier (buff) to the player.", gray);
                scr_console_output_list("Repeated calls stack with already active modifiers.", gray);
                scr_console_output_list("Options:", white);
                scr_console_output_list("id: Modifier identifier.", gray);
                scr_console_output_list("steps: Duration of the modifier (default 1).", gray);
                scr_console_output_list("tier: Sets the tier of effects, if applicable (default 1).", gray);
                scr_console_output_list("target: bool Determines buff target.", gray);
                scr_console_output_list("              If true, applies the buff to the mob under the cursor, if false, to the player (default false).", gray);
                break;
            
            case "steamclear":
                scr_console_output_list(_comandName[0], green);
                scr_console_output_list("Clears earned Steam achievements.", gray);
                break;

            case "time":
                scr_console_output_list(_comandName[0] + " [change [time...]] | [scale [amount]]", green);
                scr_console_output_list("Command for manipulating the in-game time.", gray);
                scr_console_output_list("Options:", white);
                scr_console_output_list("change: Adds specified amount to the current time.", gray);
                scr_console_output_list("time...: Amount of time to add.", gray);
                scr_console_output_list("    seconds: Number of seconds to add (default 0).", gray);
                scr_console_output_list("    minutes: Number of minutes to add (default 0).", gray);
                scr_console_output_list("    hours: Number of hours to add (default 0).", gray);
                scr_console_output_list("    days: Number of days to add (default 0).", gray);
                scr_console_output_list("    months: Number of months to add (default 0).", gray);
                scr_console_output_list("scale: Changes the game time scale.", gray);
                scr_console_output_list("amount: Amount to set the scale to.", gray);
                break;

            case "gui":
                scr_console_output_list(_comandName[0], green);
                scr_console_output_list("Removes all UI elements as well as damage indicators and outlines.", gray);
                break;

            case "map":
                scr_console_output_list(_comandName[0], green);
                scr_console_output_list("Reveals the map completely.", gray);
                break;

            case "fow":
                scr_console_output_list(_comandName[0], green);
                scr_console_output_list("Disables fog of war. Toggles on repeated use.", gray);
                break;

            case "weather":
                scr_console_output_list(_comandName[0] + " [rain | fog | info | clear]", green);
                scr_console_output_list("Command for weather control.", gray);
                scr_console_output_list("Options:", white);
                scr_console_output_list("rain: Starts rain or snow depending on biome.", gray);
                scr_console_output_list("fog: Starts fog.", gray);
                scr_console_output_list("info: Displays current weather status.", gray);
                scr_console_output_list("clear: Stops all weather effects.", gray);
                break;

            case "enemyinfo":
                scr_console_output_list(_comandName[0], green);
                scr_console_output_list("Displays enemy information.", gray);
                break;

            case "godmode":
                scr_console_output_list(_comandName[0], green);
                scr_console_output_list("Activates invincibility mode.", gray);
                scr_console_output_list("Player health and energy remain at 100, immune to negative effects.", gray);
                break;

            case "nodeath":
                scr_console_output_list(_comandName[0], green);
                scr_console_output_list("Disables player death.", gray);
                break;

            case "getxp":
                scr_console_output_list(_comandName[0] + " [amount]", green);
                scr_console_output_list("Adds specified amount of XP.", gray);
                scr_console_output_list("Options:", white);
                scr_console_output_list("amount: Amount of XP to add (default 0).", gray);
                break;

            case "sethp":
                scr_console_output_list(_comandName[0] + " [amount]", green);
                scr_console_output_list("Sets player's health points.", gray);
                scr_console_output_list("Options:", white);
                scr_console_output_list("amount: Amount of HP (default 0).", gray);
                break;

            case "setmp":
                scr_console_output_list(_comandName[0] + " [amount]", green);
                scr_console_output_list("Sets player's mana points.", gray);
                scr_console_output_list("Options:", white);
                scr_console_output_list("amount: Amount of MP (default 0).", gray);
                break;

            case "save":
                scr_console_output_list(_comandName[0] + " [0 - sleep | 1 - auto | 2 - exit]", green);
                scr_console_output_list("Saves the game to a specific slot.", gray);
                scr_console_output_list("Options:", white);
                scr_console_output_list("0 - sleep: Sleep save.", gray);
                scr_console_output_list("1 - auto: Auto-save.", gray);
                scr_console_output_list("2 - exit: Exit save.", gray);
                break;

            case "load":
                scr_console_output_list(_comandName[0], green);
                scr_console_output_list("Loads the latest save.", gray);
                break;

            case "killboss":
                scr_console_output_list(_comandName[0], green);
                scr_console_output_list("Instantly defeats the boss. Skips current stage if the boss has multiple stages.", gray);
                break;

            case "skills":
                scr_console_output_list(_comandName[0] + " [all | reset]", green);
                scr_console_output_list("Command for skill manipulation.", gray);
                scr_console_output_list("Options:", white);
                scr_console_output_list("all: Unlocks all available skills (default).", gray);
                scr_console_output_list("reset: Resets all active skills and refunds skill points.", gray);
                break;

            case "contract":
                scr_console_output_list(_comandName[0] + " [num ...]", green);
                scr_console_output_list("Command for generating a contract. Number of arguments is limited to dungeon count.", gray);
                scr_console_output_list("Options:", white);
                scr_console_output_list("num: Contract number to generate.", gray);
                break;

            case "condition":
                scr_console_output_list(_comandName[0] + " [state... amount]", green);
                scr_console_output_list("Changes player's physical states like hunger, thirst, pain, etc.", gray);
                scr_console_output_list("Options:", white);
                scr_console_output_list("state...: The physical state to change.", gray);
                scr_console_output_list("     hunger: Changes hunger level.", gray);
                scr_console_output_list("     thirsty: Changes thirst level.", gray);
                scr_console_output_list("     intoxication: Changes intoxication level.", gray);
                scr_console_output_list("     pain: Changes pain level.", gray);
                scr_console_output_list("     morale: Changes morale level.", gray);
                scr_console_output_list("     sanity: Changes sanity level.", gray);
                scr_console_output_list("amount: Amount of change (default 0).", gray);
                break;

            case "psy":
                scr_console_output_list(_comandName[0] + " [state... amount]", green);
                scr_console_output_list("Changes player's psychological states such as optimism, heroism, sadism, etc.", gray);
                scr_console_output_list("Options:", white);
                scr_console_output_list("state...: Psychological state to modify.", gray);
                scr_console_output_list("     optimism: Optimism level.", gray);
                scr_console_output_list("     heroism: Heroism level.", gray);
                scr_console_output_list("     secondwind: Second wind level.", gray);
                scr_console_output_list("     prudence: Prudence level.", gray);
                scr_console_output_list("     masochism: Masochism level.", gray);
                scr_console_output_list("     sadism: Sadism level.", gray);
                scr_console_output_list("     megalomania: Megalomania level.", gray);
                scr_console_output_list("     frenzy: Frenzy level.", gray);
                scr_console_output_list("     apathy: Apathy level.", gray);
                scr_console_output_list("     despair: Despair level.", gray);
                scr_console_output_list("     anxiety: Anxiety level.", gray);
                scr_console_output_list("     hypochondria: Hypochondria level.", gray);
                scr_console_output_list("amount: State value (default 0).", gray);
                break;

            case "limb":
                scr_console_output_list(_comandName[0] + " [limb… [inj amount] | [blood  steps]]", green);
                scr_console_output_list("Inflicts damage on the specified limb.", gray);
                scr_console_output_list("Options:", white);
                scr_console_output_list("limb…: Target limb.", gray);
                scr_console_output_list("     head: Left or right head.", gray);
                scr_console_output_list("     lhand: Left hand.", gray);
                scr_console_output_list("     rhand: Right hand.", gray);
                scr_console_output_list("     lleg: Left leg.", gray);
                scr_console_output_list("     blood: Inflicts bleeding on limb.", gray);
                scr_console_output_list("inj: Injury amount (default 0).", gray);
                scr_console_output_list("steps: Bleeding duration (default 1).", gray);
                break;

            case "attr":
                scr_console_output_list(_comandName[0] + " [id… amount] | [reset]", green);
                scr_console_output_list("Changes player's attributes.", gray);
                scr_console_output_list("Options:", white);
                scr_console_output_list("id...: Attribute identifier.", gray);
                scr_console_output_list("amount: Attribute value (default 0).", gray);
                scr_console_output_list("reset: Resets attributes.", gray);
                break;

            case "boost":
                scr_console_output_list(_comandName[0] + " [id amount step]", green);
                scr_console_output_list("Temporarily modifies an attribute.", gray);
                scr_console_output_list("Options:", white);
                scr_console_output_list("id: Identifier of the attribute to change.", gray);
                scr_console_output_list("amount: The value of the attribute change (default 0).", gray);
                scr_console_output_list("step: Duration of the attribute change.", gray);
                break;

            case "lvl":
                scr_console_output_list(_comandName[0] + " [level]", green);
                scr_console_output_list("Sets the player's level to the specified value.", gray);
                scr_console_output_list("Options:", white);
                scr_console_output_list("level: Level number to assign to the player.", gray);
                break;

            case "globalset":
                scr_console_output_list(_comandName[0] + " [x | location ] [y]", green);
                scr_console_output_list("Moves the player by specified coordinates on the global map.", gray);
                scr_console_output_list("Options:", white);
                scr_console_output_list("x: X-coordinate offset (default 0).", gray);
                scr_console_output_list("y: Y-coordinate offset (default 0).", gray);
                scr_console_output_list("location: Osbrook, Mannshire, Brynn, BanditFarm, etc. (see gml_GlobalScript_table_locations)", gray);
                // scr_console_output_list(string_join_ext("\n", array_sort(ds_map_keys_to_array(global.locationMapName))), gray);
                break;

            case "nocd":
                scr_console_output_list(_comandName[0], green);
                scr_console_output_list("Removes cooldown and mana costs from abilities.", gray);
                break;

            case "getseed":
                scr_console_output_list(_comandName[0], green);
                scr_console_output_list("Outputs the seed value used for world generation.", gray);
                break;

            case "debugmap":
                scr_console_output_list(_comandName[0], green);
                scr_console_output_list("Enables debug mode for the global map.", gray);
                break;

            case "respec":
                scr_console_output_list(_comandName[0], green);
                scr_console_output_list("Set all attribute to 10 and redistribute the excess points", gray);
                break;

            default:
                scr_console_output_list("invalid command name", red);
                break;
        }
    }
}