// Appends the base64 encoding of the first n bytes of src to dst at its
// current write position - the PNG bytes of a screenshot. There is no
// buffer_base64_encode in the game's function table, so this runs on the
// 4096-entry pair table from scr_devtools_mcp_init: each 3-byte group is two
// 12-bit values, and the u16 at offset 2*v holds both base64 characters of
// v. The main loop reads the group as a little-endian u32 and writes all
// four characters in one u32.
function scr_devtools_mcp_base64()
{
    var _src = argument[0];
    var _n = argument[1];
    var _dst = argument[2];
    var _tab = _mcp_b64tab;
    var _full = floor(_n / 3) * 3;
    var _i = 0;
    var _w = 0;
    var _g = 0;
    while (_i < _full && _i + 4 <= _n)
    {
        _w = buffer_peek(_src, _i, buffer_u32);
        buffer_write(_dst, buffer_u32, buffer_peek(_tab, ((_w & 255) << 5) | ((_w >> 11) & 30), buffer_u16) | (buffer_peek(_tab, ((_w & 3840) << 1) | ((_w >> 15) & 510), buffer_u16) << 16));
        _i += 3;
    }
    // the last whole group, when no fourth byte follows it
    while (_i < _full)
    {
        _g = (buffer_peek(_src, _i, buffer_u8) << 16) | (buffer_peek(_src, _i + 1, buffer_u8) << 8) | buffer_peek(_src, _i + 2, buffer_u8);
        buffer_write(_dst, buffer_u16, buffer_peek(_tab, (_g >> 12) << 1, buffer_u16));
        buffer_write(_dst, buffer_u16, buffer_peek(_tab, (_g & 4095) << 1, buffer_u16));
        _i += 3;
    }
    // padding: 15677 is two equals signs as a u16, 61 is one
    if (_n - _full == 1)
    {
        _g = buffer_peek(_src, _i, buffer_u8) << 16;
        buffer_write(_dst, buffer_u16, buffer_peek(_tab, (_g >> 12) << 1, buffer_u16));
        buffer_write(_dst, buffer_u16, 15677);
    }
    else if (_n - _full == 2)
    {
        _g = (buffer_peek(_src, _i, buffer_u8) << 16) | (buffer_peek(_src, _i + 1, buffer_u8) << 8);
        buffer_write(_dst, buffer_u16, buffer_peek(_tab, (_g >> 12) << 1, buffer_u16));
        buffer_write(_dst, buffer_u8, buffer_peek(_tab, (_g & 4095) << 1, buffer_u8));
        buffer_write(_dst, buffer_u8, 61);
    }
}
