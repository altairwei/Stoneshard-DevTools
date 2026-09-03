// Input engine, ported from the 0.8.2.10 o_console_controller Step event:
// runtime-managed keyboard_string (no dropped characters, native key repeat),
// cursor movement, command history and clipboard paste.
// F2 toggles global.consoleEnabled - the vanilla input gates still listen to
// it (o_player, oCamera, o_abilities, scr_keyboard_control, ...), so input
// isolation needs no other patch.
if (keyboard_check_pressed(vk_f2))
{
    global.consoleEnabled = !global.consoleEnabled;
    keyboardString = "";
    pointerPos = 0;
    keyboard_string = "";
}

if (!global.consoleEnabled)
    exit;

var _keyboardStringLength = string_length(keyboardString);
var _numberCopy = 0;
var _previous_command_size = 0;

if (keyboard_string != "")
{
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

// command history (up/down, wrapping)
if (keyboard_check_pressed(vk_up))
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
if (keyboard_check_pressed(vk_down))
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

// Tab autocomplete: unique prefix match -> complete the command;
// multiple matches -> list the candidates in the output area.
if (keyboard_check_pressed(vk_tab) && string_length(keyboardString) > 0)
{
    var _match = "";
    var _matchCount = 0;
    var _key = ds_map_find_first(commandsMap);
    while (!is_undefined(_key))
    {
        if (string_copy(_key, 1, string_length(keyboardString)) == keyboardString)
        {
            _match = _key;
            _matchCount++;
        }
        _key = ds_map_find_next(commandsMap, _key);
    }
    if (_matchCount == 1)
    {
        keyboardString = _match + " ";
        pointerPos = string_length(keyboardString);
    }
    else if (_matchCount > 1)
    {
        _key = ds_map_find_first(commandsMap);
        while (!is_undefined(_key))
        {
            if (string_copy(_key, 1, string_length(keyboardString)) == keyboardString)
                scr_console_output_list("  " + _key, gray);
            _key = ds_map_find_next(commandsMap, _key);
        }
    }
}

// execute the command line
if (keyboard_check_pressed(vk_enter) && _keyboardStringLength > 0)
{
    scr_devconsole_execute(keyboardString);
    keyboardString = "";
    pointerPos = 0;
}
