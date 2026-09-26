// game_click: clicks one instance the way the game dispatches a real click,
// without the real cursor. GUI elements that take clicks (c_GUI descendants
// with an interactive event, such as every o_button) get the GUI
// controller's state sequence through scr_guiInteractiveEventPerform: enter,
// press, release, leave - enter and leave only when the real cursor is not
// on the element already. Other instances get the press and release mouse
// events through scr_cursorInteract, vanilla's own click simulation (walking
// into an object with the keyboard, the context menu's Attack); world
// objects may also check the real cursor and then ignore it - an NPC does
// while the cursor rests on a window or the HUD. argument[0] the
// arguments map or -1: target (see scr_devtools_mcp_game_target), button
// ("left" or "right"). Returns the reply text and sets _mcp_exec_error.
function scr_devtools_mcp_game_click()
{
    var _args = argument[0];
    var _v = 0;
    var _button = "left";
    var _t = 0;
    var _n = 0;
    var _name = "";
    var _gui = false;
    var _hover = false;
    var _press = 2;
    var _release = 4;
    var _steps = "";
    var _note = "";
    var _cool = -1;
    var _gc = -4;
    _mcp_exec_error = true;
    if (_args == -1)
        return "missing argument 'target': an object name or an instance id";
    _v = ds_map_find_value(_args, "button");
    if (!is_undefined(_v))
    {
        if (!is_string(_v))
            return "argument 'button' must be \"left\" or \"right\"";
        if (_v != "left" && _v != "right")
            return "argument 'button' must be \"left\" or \"right\"";
        _button = _v;
    }
    _t = scr_devtools_mcp_game_target(ds_map_find_value(_args, "target"));
    if (is_string(_t))
        return _t;
    if (_t < 100000)
    {
        _n = instance_number(_t);
        if (_n > 1)
            return object_get_name(_t) + " has " + string(_n) + " instances - pass the id of one:" + scr_devtools_mcp_game_instances(_t);
        _t = instance_find(_t, 0);
    }
    // string() spells instance ids "ref 100234"
    _name = object_get_name(_t.object_index) + " #" + string_digits(string(_t));
    // scr_guiInteractiveInit sets guiInteractiveEvent, after guiType
    if (object_is_ancestor(_t.object_index, c_GUI))
    {
        if (variable_instance_exists(_t, "guiInteractiveEvent"))
        {
            if (_t.guiType == 1)
            {
                if (_t.guiInteractiveEvent != -4)
                    _gui = true;
            }
        }
    }
    if (_gui)
    {
        // the GUI controller never focuses hidden elements
        if (!_t.visible)
            return _name + " is hidden (visible is false; it may be scrolled out of view), so a player cannot click it - game_event runs its events regardless, such as Mouse_4 or its user events";
        if (_button == "right")
        {
            _press = 5;
            _release = 7;
        }
        if (!scr_guiInteractiveStateExists(_t, _press) && !scr_guiInteractiveStateExists(_t, _release))
            return _name + " does not react to the " + _button + " mouse button";
        // o_button ignores clicks while deactivated or in its cooldown
        if (_t.object_index == o_button || object_is_ancestor(_t.object_index, o_button))
        {
            with (_t)
                _cool = alarm[1];
            if (variable_instance_exists(_t, "is_activate"))
            {
                if (!_t.is_activate)
                    _note = " - but the button is deactivated (is_activate is false), so it ignored the click";
                else if (_cool != -1)
                    _note = " - but the button was in its cooldown (alarm[1] runs), so it ignored the click; try again in a moment";
            }
        }
        if (variable_global_exists("guiController"))
            _gc = global.guiController;
        if (instance_exists(_gc))
            _hover = _gc.interactiveFocusID == _t;
        if (!_hover && scr_guiInteractiveStateExists(_t, 0))
        {
            scr_guiInteractiveEventPerform(_t, 0);
            _steps += ", enter";
        }
        if (scr_guiInteractiveStateExists(_t, _press))
        {
            scr_guiInteractiveEventPerform(_t, _press);
            _steps += ", press";
        }
        if (scr_guiInteractiveStateExists(_t, _release))
        {
            scr_guiInteractiveEventPerform(_t, _release);
            _steps += ", release";
        }
        if (!_hover && scr_guiInteractiveStateExists(_t, 1))
        {
            scr_guiInteractiveEventPerform(_t, 1);
            _steps += ", leave";
        }
        // closing or rebuilding a window destroys its elements, which then
        // get no further states
        if (!instance_exists(_t))
            _note += " - the element is gone now, as when the click closes or rebuilds its window";
        _mcp_exec_error = false;
        return "clicked " + _name + " with the " + _button + " button (GUI states: " + string_delete(_steps, 1, 2) + ")" + _note;
    }
    _press = 4;
    _release = 7;
    if (_button == "right")
    {
        _press = 5;
        _release = 8;
    }
    // scr_cursorInteract does nothing without o_controller, as in the menus
    if (instance_exists(o_controller))
    {
        scr_cursorInteract(_t, 6, _press);
        scr_cursorInteract(_t, 6, _release);
    }
    else
    {
        with (_t)
            event_perform(6, _press);
        with (_t)
            event_perform(6, _release);
    }
    _mcp_exec_error = false;
    return "clicked " + _name + " with the " + _button + " button (mouse events Mouse_" + string(_press) + ", Mouse_" + string(_release) + "). It is no GUI element: world objects may also check where the real cursor is and then ignore the click - check the effect";
}
