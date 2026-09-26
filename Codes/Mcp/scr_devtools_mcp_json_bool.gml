// JSON literal for a truth value: true or false.
function scr_devtools_mcp_json_bool()
{
    if (argument[0])
        return "true";
    return "false";
}
