function scr_console_actionslog()
{
    if (global.actionsLogVisible)
    {
        global.actionsLogVisible = false
        scr_console_output_list("ActionsLog is hidden", red)
    }
    else
    {
        global.actionsLogVisible = true
        scr_console_output_list("ActionsLog is visible", green)
    }
}
