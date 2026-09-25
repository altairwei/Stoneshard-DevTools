// Handles one JSON-RPC message from a POST body and sends the HTTP reply.
// argument[0] socket, argument[1] body text.
function scr_devtools_mcp_rpc()
{
    var _sock = argument[0];
    var _root = json_decode(argument[1]);
    var _method = 0;
    var _idj = "null";
    var _params = -1;
    var _pv = "2025-11-25";
    var _v = 0;
    if (!ds_exists(_root, ds_type_map))
    {
        scr_devtools_mcp_reply_error(_sock, "400 Bad Request", "null", -32700, "Parse error");
        return;
    }
    // json_decode wraps whatever is not an object as the only key "default":
    // a top-level array - a batch - as a list, anything else as a plain value,
    // which is also what some unparseable text decodes to
    if (ds_map_exists(_root, "default") && ds_map_size(_root) == 1)
    {
        if (ds_map_is_list(_root, "default"))
            scr_devtools_mcp_reply_error(_sock, "400 Bad Request", "null", -32600, "Invalid Request: send one JSON-RPC object per POST - batches are not supported");
        else
            scr_devtools_mcp_reply_error(_sock, "400 Bad Request", "null", -32700, "Parse error: the body must be one JSON-RPC request object");
        ds_map_destroy(_root);
        return;
    }
    _method = ds_map_find_value(_root, "method");
    if (!is_string(_method))
    {
        // a response to a server request is acknowledged - this server
        // never sends requests, so there is nothing to match it with
        if (ds_map_exists(_root, "result") || ds_map_exists(_root, "error"))
            scr_devtools_mcp_send_text(_sock, "202 Accepted", "", "");
        else
            scr_devtools_mcp_reply_error(_sock, "400 Bad Request", scr_devtools_mcp_json_id(ds_map_find_value(_root, "id")), -32600, "Invalid Request");
        ds_map_destroy(_root);
        return;
    }
    if (!ds_map_exists(_root, "id"))
    {
        // a notification: accepted, no JSON-RPC reply
        ds_map_destroy(_root);
        scr_devtools_mcp_send_text(_sock, "202 Accepted", "", "");
        return;
    }
    _idj = scr_devtools_mcp_json_id(ds_map_find_value(_root, "id"));
    if (ds_map_exists(_root, "params"))
    {
        if (ds_map_is_map(_root, "params"))
            _params = ds_map_find_value(_root, "params");
    }
    if (_method == "initialize")
    {
        if (_params != -1)
        {
            _v = ds_map_find_value(_params, "protocolVersion");
            if (is_string(_v))
            {
                if (_v == "2024-11-05" || _v == "2025-03-26" || _v == "2025-06-18" || _v == "2025-11-25")
                    _pv = _v;
            }
        }
        scr_devtools_mcp_reply(_sock, _idj, "{\"protocolVersion\":\"" + _pv + "\",\"capabilities\":{\"tools\":{\"listChanged\":false}},\"serverInfo\":{\"name\":\"stoneshard-devtools\",\"title\":\"Stoneshard DevTools\",\"version\":\"1.2.0\"},\"instructions\":" + scr_devtools_mcp_json_str("Drives the Stoneshard DevTools console in the running game. console_execute runs one console command - the same as typing it into the F2 console - and returns what it printed; start with 'help' to list commands and 'help <command>' for usage. console_read shows recent console history. screenshot captures the game window.") + "}");
    }
    else if (_method == "ping")
        scr_devtools_mcp_reply(_sock, _idj, "{}");
    else if (_method == "tools/list")
        scr_devtools_mcp_reply(_sock, _idj, scr_devtools_mcp_tools_list());
    else if (_method == "tools/call")
        scr_devtools_mcp_tools_call(_sock, _idj, _params);
    else
        scr_devtools_mcp_reply_error(_sock, "200 OK", _idj, -32601, "Method not found: " + _method);
    ds_map_destroy(_root);
}
