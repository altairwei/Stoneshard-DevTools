// The pending game_wait's answer once it is due, "" while it is not: the game
// reached the awaited phase, landed on the save error screen or ran out of
// time. Sets _mcp_exec_error; the caller sends the reply - tools/call right
// away, scr_devtools_mcp_tick later.
function scr_devtools_mcp_game_wait_check()
{
    var _phase = scr_devtools_mcp_game_phase();
    _mcp_exec_error = true;
    if (_phase == _mcp_wait_phase)
    {
        _mcp_exec_error = false;
        return scr_devtools_mcp_game_state();
    }
    if (_phase == "save_error")
        return "the save failed to load - the game shows its save error screen\n" + scr_devtools_mcp_game_state();
    if (get_timer() - _mcp_wait_t >= _mcp_wait_us)
        return "timeout: still '" + _phase + "' after " + string(_mcp_wait_us div 1000000) + " s, waiting for '" + _mcp_wait_phase + "'\n" + scr_devtools_mcp_game_state();
    return "";
}
