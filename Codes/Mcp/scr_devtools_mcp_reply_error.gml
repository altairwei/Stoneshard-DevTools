// JSON-RPC error response: socket, HTTP status line, id as JSON text, error
// code, message text.
function scr_devtools_mcp_reply_error()
{
    scr_devtools_mcp_send_text(argument[0], argument[1], "Content-Type: application/json\r\n", "{\"jsonrpc\":\"2.0\",\"id\":" + argument[2] + ",\"error\":{\"code\":" + string(argument[3]) + ",\"message\":" + scr_devtools_mcp_json_str(argument[4]) + "}}");
}
