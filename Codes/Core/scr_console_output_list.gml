function scr_console_output_list()
{
    // positional arguments come in through argument[0]/argument[1] - the old
    // compiler does not support named parameters in declarations.
    // DevTools console output pipeline: appends to the o_devconsole
    // instance's ds_lists. Every caller sits on the command chain
    // (Step -> scr_devconsole_execute -> scr_devconsole_command ->
    // command script -> here) or in a console event, where self is always
    // the o_devconsole instance.
    ds_list_add(output_list, string(argument[0]));
    ds_list_add(color_list, argument[1]);

    // MCP console_execute captures the lines a command prints
    if (variable_global_exists("_mcp_capturing"))
    {
        if (global._mcp_capturing)
        {
            ds_list_add(global._mcp_capture, string(argument[0]));
            ds_list_add(global._mcp_capture_col, argument[1]);
        }
    }

    // keep the DevTools log pipeline
    if (variable_global_exists("_msl_log"))
        scr_msl_log(string(argument[0]));
}
