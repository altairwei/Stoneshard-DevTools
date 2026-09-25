// Plain-text error response followed by closing the connection - for
// requests the parser cannot recover from: bad framing, oversized input.
function scr_devtools_mcp_fail()
{
    scr_devtools_mcp_send_text(argument[0], argument[1], "Content-Type: text/plain\r\nConnection: close\r\n", argument[1]);
    // a failed send has already dropped the client
    if (ds_map_exists(_mcp_clients, argument[0]))
        scr_devtools_mcp_drop(argument[0], true);
}
