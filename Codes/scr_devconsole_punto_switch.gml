// Russian-layout to English-layout transliteration, ported from the 0.8.2.10
// o_console_controller Create event (where it lived as a method - kept as a
// standalone script because the old GML subset has no method literals here).
function scr_devconsole_punto_switch()
{
    var _inputString = argument[0];
    var _finalString = "";
    var _rusKeyArray = ["й", "ц", "у", "к", "е", "н", "г", "ш", "щ", "з", "х", "ъ", "ф", "ы", "в", "а", "п", "р", "о", "л", "д", "ж", "э", "я", "ч", "с", "м", "и", "т", "ь", "б", "ю", ".", "Й", "Ц", "У", "К", "Е", "Н", "Г", "Ш", "Щ", "З", "Х", "Ъ", "Ф", "Ы", "В", "А", "П", "Р", "О", "Л", "Д", "Ж", "Э", "Я", "Ч", "С", "М", "И", "Т", "Ь", "Б", "Ю", ","];
    var _engKeyArray = ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "[", "]", "a", "s", "d", "f", "g", "h", "j", "k", "l", ";", "'", "z", "x", "c", "v", "b", "n", "m", ",", ".", "/", "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "{", "}", "A", "S", "D", "F", "G", "H", "J", "K", "L", ":", "'", "Z", "X", "C", "V", "B", "N", "M", "<", ">", "?"];
    var _keysArrayLength = array_length(_rusKeyArray);
    var _stringLength = string_length(_inputString);
    for (var _i = 1; _i <= _stringLength; _i++)
    {
        var _char = string_char_at(_inputString, _i);
        for (var _j = 0; _j < _keysArrayLength; _j++)
        {
            var _charRus = _rusKeyArray[_j];
            if (_char == _charRus)
            {
                _char = _engKeyArray[_j];
                break;
            }
        }
        _finalString += _char;
    }
    return _finalString;
}
