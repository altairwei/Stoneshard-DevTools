// scr_devtools_mcp_send with a string body: socket, status, header lines,
// body text. An empty body sends Content-Length: 0 - the 202 replies.
function scr_devtools_mcp_send_text()
{
    var _b = buffer_create(256, buffer_grow, 1);
    var _r = 0;
    buffer_write(_b, buffer_text, argument[3]);
    _r = scr_devtools_mcp_send(argument[0], argument[1], argument[2], _b, buffer_tell(_b));
    buffer_delete(_b);
    return _r;
}
