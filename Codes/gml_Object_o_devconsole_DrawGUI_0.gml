// Rendering, ported from the 0.8.2.10 o_console_controller DrawGUI event:
// stretched sprite background, output history (newest at the bottom, one
// 25px line each), the input line and a blinking caret.
// Extensions on top of the port (neoconsole UI, old-GML subset):
//   - scrollback rendering: scroll > 0 (or the bar being dragged) shows
//     older lines; lines never auto-hide, they stay until 'clear'
//   - no per-line background blocks - text only on the panel
//   - head bar: solid near-black slab with a 1px bottom edge separating it
//     from the output area; the title is centered by measured font metrics
//     (the *_transformed text variants ignore vertical alignment, so the
//     centering is manual). The strip's right side is reserved for future
//     status widgets/panels.
//   - input line: the space-aware caret "_" (UI 2); the cursor-position
//     counter "07:100" + length slider (UI 1) are gated by the source-level
//     showCursorCounter option from the Create event
//   - Tab autocomplete chip row under the input line (UI 5)
//   - right-edge scrollbar (handle only, no track; official neoconsole
//     style), hover-expanded from scroll_hover_anim (drag state comes from
//     the Step event)
if (!global.consoleEnabled)
    exit;
var GAP = 50;
var _resolutionDataArray = scr_cameraResolutionGet();
var _width = _resolutionDataArray[0];
var _height = _resolutionDataArray[1];
var _scale = _resolutionDataArray[2];
var _offsetX = global.gameframe_offset_left * _scale;
var _offsetY = global.gameframe_offset_top * _scale;
var _xx = GAP + _offsetX;
var _yy = (_height - GAP) + _offsetY;
var _sbRight = _width + _offsetX - GAP;
var _sbWidth = 12;
var _sbY1 = GAP + _offsetY;
var _sbY2 = _yy;
var _outputListSize = ds_list_size(output_list);
var _pointerStringWidth = string_width(string_copy(keyboardString, 1, pointerPos));
var _headbarHeight = 32;
var _headbarY1 = _offsetY;
var _headbarY2 = _offsetY + _headbarHeight;
draw_sprite_ext(s_point, 0, _offsetX, _offsetY, _width, _height, 0, c_black, 0.8);
// head bar: solid near-black slab with a 1px bottom edge (its top edge is
// deliberately unlined). The title is centered-with-a-bias with measured
// metrics: the *_transformed text variants ignore the current vertical
// alignment, so string_height of the f_dmg set below gives the exact line
// height and the offset is computed manually (0.4 = slight upward bias,
// more breathing room below the title). The strip's right side is reserved
// for future status widgets - paint them here.
draw_set_alpha(0.95);
draw_set_color(make_color_rgb(20, 20, 20));
draw_rectangle(_offsetX, _headbarY1, _offsetX + _width, _headbarY2, false);
draw_set_color(merge_color(c_white, c_black, 0.75));
draw_rectangle(_offsetX, _headbarY2, _offsetX + _width, _headbarY2 + 1, false);
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_font(global.f_dmg);
var _titleHeight = string_height("DevTools Console");
draw_set_alpha(0.8);
draw_text_ext_transformed(32 + _offsetX, _offsetY + ((_headbarHeight - _titleHeight) * 0.4), "DevTools Console", 10, 300, 1, 1, 0);
draw_set_alpha(1);

// output lines, offset by the scrollback position; lines never auto-hide,
// they stay visible until 'clear' (no fade-out tick); font is f_dmg (set above)
for (var _commandItemIndex = 0; _commandItemIndex < _outputListSize; _commandItemIndex++)
{
    var _lineIndex = _outputListSize - 1 - scroll - _commandItemIndex;
    if (_lineIndex < 0)
        break;
    var _color = ds_list_find_value(color_list, _lineIndex);
    var _string = ds_list_find_value(output_list, _lineIndex);
    var _lineY = _yy - GAP - (_commandItemIndex * 25);
    if (_lineY < _offsetY + _headbarHeight)
        break;
    // NOTE: draw_text_colour only - the US spelling is absent from the game's
    // function table and would miscompile (same hazard as io_clear).
    draw_text_colour(_xx, _lineY, _string, _color, _color, _color, _color, 0.8);
}

// input line
draw_text(_xx, _yy, keyboardString);
// caret (UI 2): a space (or end-of-line) position draws "_" instead of "|"
var _caretChar = "|";
var _caretCharAt = string_char_at(keyboardString, pointerPos + 1);
if (string_length(_caretCharAt) == 0 || _caretCharAt == " ")
    _caretChar = "_";
draw_text_colour((_xx + _pointerStringWidth) - 2, _yy, _caretChar, c_white, c_white, c_white, c_white, abs(sin(current_time / 300)));

// input line extras (UI 1): "光标位置:总长" counter + length slider;
// showCursorCounter is a source-level display option (set in the Create
// event) - flip it in code, it is intentionally not a console command
var _keyboardStringLength = string_length(keyboardString);
if (showCursorCounter && _keyboardStringLength > 0)
{
    var _digits = max(2, string_length(string(_keyboardStringLength)));
    var _cursorCounter = string_repeat("0", _digits - string_length(string(pointerPos))) + string(pointerPos) + ":" + string_repeat("0", _digits - string_length(string(_keyboardStringLength))) + string(_keyboardStringLength);
    var _counterWidth = string_width(_cursorCounter);
    draw_set_halign(fa_right);
    draw_text(_sbRight, _yy, _cursorCounter);
    draw_set_halign(fa_left);
    var _sliderRight = _sbRight - _counterWidth - 32;
    if ((_sliderRight - _xx) > 0 && string_width(keyboardString) > (_sliderRight - _xx))
    {
        var _sliderArea = _sliderRight - _xx;
        var _sliderSize = _sliderArea / _keyboardStringLength;
        var _sliderPos = _sliderArea * (pointerPos / _keyboardStringLength);
        var _sliderTrackY = _yy + 22;
        draw_set_color(make_color_rgb(31, 31, 31));
        draw_rectangle(_xx, _sliderTrackY, _sliderRight, _sliderTrackY + 1, false);
        draw_set_color(make_color_rgb(100, 100, 100));
        draw_rectangle(_xx + _sliderPos - _sliderSize, _sliderTrackY - 2, _xx + _sliderPos, _sliderTrackY + 5, false);
    }
}

// right-edge scrollbar: handle only, no track (official neoconsole style);
// the hover-expand animation is driven by the Step event, which also owns
// the drag mapping. No amount of lines -> no scrollbar at all.
var _scrollMax = max(0, _outputListSize - min_scroll_requirement);
if (_scrollMax > 0)
{
    var _trackHeight = _sbY2 - _sbY1;
    var _sliderSize = _trackHeight / _scrollMax;
    var _sliderPos = (scroll / _scrollMax) * (_trackHeight - _sliderSize);
    var _sliderY2 = _sbY2 - _sliderPos;
    var _sliderY1 = _sliderY2 - _sliderSize;
    var _sliderWidth = _sbWidth * (0.33 + 0.67 * scroll_hover_anim);
    draw_set_alpha(0.8);
    draw_set_color(merge_color(c_white, c_black, 0.45));
    draw_rectangle(_sbRight - _sliderWidth, _sliderY1, _sbRight, _sliderY2, false);
    draw_set_alpha(1);
}

// Tab autocomplete chip row (UI 5), drawn in the bottom margin under the
// input line; the highlighted chip is the Enter pick
if (autocomplete_active)
{
    var _chipCount = ds_list_size(autocomplete_list);
    var _chipX = _xx;
    var _chipY = _yy + 26;
    for (var _chipIndex = 0; _chipIndex < _chipCount; _chipIndex++)
    {
        var _chipName = ds_list_find_value(autocomplete_list, _chipIndex);
        var _chipW = string_width(_chipName) + 12;
        if (_chipX + _chipW > _sbRight)
            break;
        if (_chipIndex == autocomplete_index)
        {
            draw_set_color(c_white);
            draw_rectangle(_chipX, _chipY, _chipX + _chipW, _chipY + 18, false);
            draw_text_colour(_chipX + 6, _chipY + 2, _chipName, c_black, c_black, c_black, c_black, 1);
        }
        else
        {
            draw_set_color(merge_color(c_white, c_black, 0.75));
            draw_rectangle(_chipX, _chipY, _chipX + _chipW, _chipY + 18, false);
            draw_text_colour(_chipX + 6, _chipY + 2, _chipName, c_white, c_white, c_white, c_white, 1);
        }
        _chipX += _chipW + 4;
    }
}
