// Rendering, ported from the 0.8.2.10 o_console_controller DrawGUI event:
// stretched sprite background, output history (newest at the bottom, one
// 25px line each), the input line and a blinking caret.
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
var _colorsListSize = ds_list_size(color_list);
var _outputListSize = ds_list_size(output_list);
var _pointerStringWidth = string_width(string_copy(keyboardString, 1, pointerPos));
draw_sprite_ext(s_point, 0, _offsetX, _offsetY, _width, _height, 0, c_black, 0.8);
draw_set_alpha(0.8);
draw_text_ext_transformed(32 + _offsetX, 15 + _offsetY, "DevTools Console", 10, 300, 1, 1, 0);
draw_set_alpha(1);
draw_set_font(global.f_dmg);
for (var _commandItemIndex = 0; _commandItemIndex < _outputListSize; _commandItemIndex++)
{
    var _color = ds_list_find_value(color_list, _colorsListSize - 1 - _commandItemIndex);
    var _string = ds_list_find_value(output_list, _outputListSize - 1 - _commandItemIndex);
    draw_text_colour(_xx, _yy - GAP - (_commandItemIndex * 25), _string, _color, _color, _color, _color, 0.8);
}
draw_text(_xx, _yy, keyboardString);
// NOTE: draw_text_colour only - the US spelling is absent from the game's
// function table and would miscompile (same hazard as io_clear).
draw_text_colour((_xx + _pointerStringWidth) - 2, _yy, "|", c_white, c_white, c_white, c_white, abs(sin(current_time / 300)));
