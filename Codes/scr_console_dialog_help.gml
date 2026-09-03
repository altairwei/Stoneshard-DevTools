function scr_console_dialog_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [["dialog", green], ["Экспортирует данные глобального диалогового потока (global.__dialogue_flow_data) в JSON файл.", gray]];
    }
    if (_lang == 3)
    {
        return [["dialog", green], ["将全局对话流程数据（global.__dialogue_flow_data）导出为 JSON 文件。", gray]];
    }
    return [["dialog", green], ["Exports the global dialogue flow data (global.__dialogue_flow_data) to a JSON file.", gray]];
}
