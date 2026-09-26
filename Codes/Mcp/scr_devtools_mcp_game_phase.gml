// Where the game is, for the game_* tools: "loading" while any transition
// runs - a room changer, its black overlay (vanilla is_allow_actions blocks
// the player on it too), the main menu fade-in - then "session" with a
// character in the world, "menu" on the main menu, "save_error" on the
// screen shown when a save failed to load, and "other" anywhere else.
function scr_devtools_mcp_game_phase()
{
    if (instance_exists(o_smoothRoomChanger) || instance_exists(o_black_overlay) || instance_exists(o_menuTransition))
        return "loading";
    if (instance_exists(o_player))
        return "session";
    if (variable_global_exists("mainMenuRoom"))
    {
        if (room == global.mainMenuRoom)
            return "menu";
    }
    if (room == r_save_error)
        return "save_error";
    return "other";
}
