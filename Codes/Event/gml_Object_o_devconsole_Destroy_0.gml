global.consoleEnabled = false;
ds_list_destroy(previous_command);
ds_list_destroy(output_list);
ds_list_destroy(color_list);
ds_list_destroy(autocomplete_list);
ds_map_destroy(commandsMap);
ds_map_destroy(helpMap);
