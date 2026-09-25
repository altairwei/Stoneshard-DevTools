// tools/call result with a single text block: socket, id as JSON text, text,
// isError. Tool failures travel this way - inside a successful JSON-RPC
// result - so the agent gets to read the message.
function scr_devtools_mcp_tool_reply()
{
    var _err = "false";
    if (argument[3])
        _err = "true";
    scr_devtools_mcp_reply(argument[0], argument[1], "{\"content\":[{\"type\":\"text\",\"text\":" + scr_devtools_mcp_json_str(argument[2]) + "}],\"isError\":" + _err + "}");
}
