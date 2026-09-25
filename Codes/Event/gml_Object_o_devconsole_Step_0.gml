// Input engine, ported from the 0.8.2.10 o_console_controller Step event:
// runtime-managed keyboard_string (no dropped characters, native key repeat),
// cursor movement, command history and clipboard paste.
// F2 toggles global.consoleEnabled - the vanilla input gates still listen to
// it (o_player, oCamera, o_abilities, scr_keyboard_control, ...), so input
// isolation needs no other patch.
// Extensions on top of the 0.8.2.10 port:
//   - scrollback (neoconsole fullview port): mouse wheel, PgUp/PgDn (hold
//     works, throttled via alarm[0]) and the right-edge scrollbar drag
//     (scroll_hover_active state lives here; DrawGUI renders it)
//   - Tab autocomplete chip selector: unique match completes outright,
//     multiple matches open a cycable chip row (Tab/Shift+Tab, Up/Down,
//     Enter picks, Esc closes, typing closes)
if (keyboard_check_pressed(vk_f2))
{
    global.consoleEnabled = !global.consoleEnabled;
    keyboardString = "";
    pointerPos = 0;
    keyboard_string = "";
    scroll = 0;
    scroll_hover_active = false;
}

// MCP server housekeeping - deferred mcp start/stop, screenshot timeout.
// Runs every step, so it sits before the console-closed early exit.
scr_devtools_mcp_tick();

if (!global.consoleEnabled)
    exit;

var _keyboardStringLength = string_length(keyboardString);
var _numberCopy = 0;
var _previous_command_size = 0;

if (keyboard_string != "")
{
    // new characters typed while the chip selector is open -> close it
    if (autocomplete_active)
    {
        autocomplete_active = false;
        autocomplete_index = -1;
        ds_list_clear(autocomplete_list);
    }
    var _keyboardTyped = scr_devconsole_punto_switch(keyboard_string);
    var _keyboardTypedLength = string_length(_keyboardTyped);
    if ((_keyboardStringLength + _keyboardTypedLength) > keyboardStringLengthMax)
    {
        _numberCopy = keyboardStringLengthMax - _keyboardStringLength;
        _keyboardTyped = string_copy(_keyboardTyped, 1, _numberCopy);
        _keyboardTypedLength = string_length(_keyboardTyped);
    }
    keyboardString = string_insert(_keyboardTyped, keyboardString, pointerPos + 1);
    pointerPos += _keyboardTypedLength;
    keyboard_string = "";
    _keyboardStringLength = string_length(keyboardString);
}

// cursor movement and editing, throttled through alarm[0]
if (keyboard_check(vk_left) && alarm[0] == -1)
{
    if (pointerPos > 0)
        pointerPos--;
    alarm[0] = keyDelay;
}
if (keyboard_check(vk_right) && alarm[0] == -1)
{
    if (pointerPos < _keyboardStringLength)
        pointerPos++;
    alarm[0] = keyDelay;
}
if (keyboard_check(vk_backspace) && alarm[0] == -1)
{
    keyboardString = string_delete(keyboardString, pointerPos, 1);
    if (pointerPos > 0)
        pointerPos--;
    alarm[0] = keyDelay;
}
if (keyboard_check(vk_delete) && alarm[0] == -1)
{
    if (pointerPos < _keyboardStringLength)
        keyboardString = string_delete(keyboardString, pointerPos + 1, 1);
    alarm[0] = keyDelay;
}
if (keyboard_check_pressed(vk_home))
    pointerPos = 0;
if (keyboard_check_pressed(vk_end))
    pointerPos = _keyboardStringLength;

// command history (up/down, wrapping) - while the chip selector is open,
// up/down cycle the chips instead of the history
if (autocomplete_active && keyboard_check_pressed(vk_up))
{
    autocomplete_index--;
    if (autocomplete_index < 0)
        autocomplete_index = ds_list_size(autocomplete_list) - 1;
}
else if (keyboard_check_pressed(vk_up))
{
    _previous_command_size = ds_list_size(previous_command);
    if (_previous_command_size)
    {
        previous_command_index--;
        if (previous_command_index < 0)
            previous_command_index = _previous_command_size - 1;
        keyboardString = ds_list_find_value(previous_command, previous_command_index);
        pointerPos = string_length(keyboardString);
        _keyboardStringLength = string_length(keyboardString);
    }
}
if (autocomplete_active && keyboard_check_pressed(vk_down))
{
    autocomplete_index++;
    if (autocomplete_index >= ds_list_size(autocomplete_list))
        autocomplete_index = 0;
}
else if (keyboard_check_pressed(vk_down))
{
    _previous_command_size = ds_list_size(previous_command);
    if (_previous_command_size)
    {
        previous_command_index++;
        if (previous_command_index > (_previous_command_size - 1))
            previous_command_index = 0;
        keyboardString = ds_list_find_value(previous_command, previous_command_index);
        pointerPos = string_length(keyboardString);
        _keyboardStringLength = string_length(keyboardString);
    }
}

// clipboard paste
if (keyboard_check(vk_control) && keyboard_check_pressed(ord("V")) && clipboard_has_text())
{
    var _clipboardText = clipboard_get_text();
    _clipboardText = string_replace_all(_clipboardText, "\r", "");
    _clipboardText = string_replace_all(_clipboardText, "\n", "");
    var _clipboardStringLength = string_length(_clipboardText);
    if ((_keyboardStringLength + _clipboardStringLength) > keyboardStringLengthMax)
    {
        _numberCopy = keyboardStringLengthMax - _keyboardStringLength;
        _clipboardText = string_copy(_clipboardText, 1, _numberCopy);
        _clipboardStringLength = string_length(_clipboardText);
    }
    keyboardString = string_insert(_clipboardText, keyboardString, pointerPos + 1);
    pointerPos += _clipboardStringLength;
    _keyboardStringLength = string_length(keyboardString);
}

// Tab autocomplete: a unique prefix match completes the command outright;
// multiple matches open the chip selector. While it is open, Tab/Shift+Tab
// (and Up/Down, see above) cycle the chips.
if (keyboard_check_pressed(vk_tab))
{
    if (autocomplete_active)
    {
        var _candidateCount = ds_list_size(autocomplete_list);
        if (keyboard_check(vk_shift))
            autocomplete_index--;
        else
            autocomplete_index++;
        if (autocomplete_index >= _candidateCount)
            autocomplete_index = 0;
        if (autocomplete_index < 0)
            autocomplete_index = _candidateCount - 1;
    }
    else if (string_length(keyboardString) > 0)
    {
        var _matchCount = 0;
        var _key = ds_map_find_first(commandsMap);
        ds_list_clear(autocomplete_list);
        while (!is_undefined(_key))
        {
            if (string_copy(_key, 1, string_length(keyboardString)) == keyboardString)
            {
                ds_list_add(autocomplete_list, _key);
                _matchCount++;
            }
            _key = ds_map_find_next(commandsMap, _key);
        }
        if (_matchCount == 1)
        {
            keyboardString = ds_list_find_value(autocomplete_list, 0) + " ";
            pointerPos = string_length(keyboardString);
        }
        else if (_matchCount > 1)
        {
            autocomplete_active = true;
            autocomplete_index = 0;
            if (keyboard_check(vk_shift))
                autocomplete_index = _matchCount - 1;
        }
    }
}

// Esc closes the chip selector (without picking)
if (keyboard_check_pressed(vk_escape) && autocomplete_active)
{
    autocomplete_active = false;
    autocomplete_index = -1;
    ds_list_clear(autocomplete_list);
}

// ---- scrollback: mouse wheel / PgUp / PgDn / right-edge bar drag ----
// (neoconsole fullview port; Up/Down stay command history, no conflict)
var GAP = 50;
// full-window geometry, same basis as the DrawGUI event (see there): the
// GUI layer reports the camera-resolution preset size, which can be smaller
// than the actual window/display - keyed off global.displayMode like the
// official console (window_get_fullscreen()/gameframe flags are transient)
var _scrollWidth = display_get_gui_width();
var _scrollHeight = display_get_gui_height();
if (global.displayMode == "fullscreenBorderless" || global.displayMode == "fullscreenExclusive")
{
    _scrollWidth = global.window_width;
    _scrollHeight = global.window_height;
}
var _scrollOffsetX = global.gameframe_offset_left * global.cameraScale;
var _scrollOffsetY = global.gameframe_offset_top * global.cameraScale;
var _sbRight = _scrollWidth + _scrollOffsetX - GAP;
var _sbWidth = 12;
var _sbTrackY1 = GAP + _scrollOffsetY;
var _sbTrackY2 = (_scrollHeight - GAP) + _scrollOffsetY;
var _scrollMax = max(0, ds_list_size(output_list) - min_scroll_requirement);
if (scroll < 0)
    scroll = 0;
if (scroll > _scrollMax)
    scroll = _scrollMax;

// mouse wheel (1 line), PgUp/PgDn (half screen, hold throttled by alarm[0])
var _scrollDiff = mouse_wheel_down() - mouse_wheel_up();
if (_scrollDiff == 0)
{
    if (keyboard_check(vk_pagedown) && alarm[0] == -1)
    {
        _scrollDiff = min_scroll_requirement;
        alarm[0] = keyDelay;
    }
    else if (keyboard_check(vk_pageup) && alarm[0] == -1)
    {
        _scrollDiff = -min_scroll_requirement;
        alarm[0] = keyDelay;
    }
}
if (_scrollDiff != 0 && !scroll_hover_active)
{
    scroll -= _scrollDiff;
    if (scroll < 0)
        scroll = 0;
    if (scroll > _scrollMax)
        scroll = _scrollMax;
}

// right-edge scrollbar: the hover zone is the handle itself; while it is
// hovered (or actively dragged, scroll_hover_active) the handle stays wide -
// dragging never shrinks it, matching the official neoconsole.
var _mouseX = device_mouse_x_to_gui(0);
var _mouseY = device_mouse_y_to_gui(0);
var _trackHeight = _sbTrackY2 - _sbTrackY1;
var _hoverScrollbar = false;
if (_scrollMax > 0)
{
    var _sliderSize = _trackHeight / _scrollMax;
    var _sliderPos = (scroll / _scrollMax) * (_trackHeight - _sliderSize);
    var _sliderY2 = _sbTrackY2 - _sliderPos;
    var _sliderY1 = _sliderY2 - _sliderSize;
    _hoverScrollbar = _mouseX >= (_sbRight - _sbWidth - 4) && _mouseX <= (_sbRight + 4) && _mouseY >= _sliderY1 && _mouseY <= _sliderY2;
}
if ((_hoverScrollbar || scroll_hover_active) && _scrollMax > 0)
{
    scroll_hover_anim = lerp(scroll_hover_anim, 1, 0.2);
}
else
{
    scroll_hover_anim = lerp(scroll_hover_anim, 0, 0.35);
}
if ((_hoverScrollbar || scroll_hover_active) && mouse_check_button(mb_left) && _scrollMax > 0)
{
    scroll = _scrollMax * (1 - (max(0, _mouseY - _sbTrackY1) / _trackHeight));
    scroll_hover_active = true;
    if (scroll < 0)
        scroll = 0;
    if (scroll > _scrollMax)
        scroll = _scrollMax;
}
if (!mouse_check_button(mb_left))
    scroll_hover_active = false;

// execute the command line; Enter also resets the scrollback to the bottom.
// While the chip selector is open, Enter first picks the highlighted chip.
if (keyboard_check_pressed(vk_enter) && autocomplete_active)
{
    keyboardString = ds_list_find_value(autocomplete_list, autocomplete_index) + " ";
    pointerPos = string_length(keyboardString);
    autocomplete_active = false;
    autocomplete_index = -1;
    ds_list_clear(autocomplete_list);
}
else if (keyboard_check_pressed(vk_enter) && _keyboardStringLength > 0)
{
    scroll = 0;
    scr_devconsole_execute(keyboardString);
    keyboardString = "";
    pointerPos = 0;
}
