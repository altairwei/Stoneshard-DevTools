// 200 response carrying a JSON-RPC result: socket, id as JSON text, result
// as JSON text.
function scr_devtools_mcp_reply()
{
    scr_devtools_mcp_send_text(argument[0], "200 OK", "Content-Type: application/json\r\n", "{\"jsonrpc\":\"2.0\",\"id\":" + argument[1] + ",\"result\":" + argument[2] + "}");
}
