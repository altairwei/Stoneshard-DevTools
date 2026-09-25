function scr_console_mcp_help()
{
    var _lang = global.language;
    if (_lang == 1)
    {
        return [["mcp [status | start [port] | stop]", green], ["Встроенный MCP-сервер: ИИ-агент может выполнять команды консоли и делать скриншоты по HTTP.", gray], ["Запускается вместе с консолью при начале или загрузке игры, на порту 8765; только локальные подключения.", gray], ["Опции:", white], ["status: показать адрес и открытые подключения - по умолчанию.", gray], ["start [port]: перезапустить сервер, при необходимости на другом порту.", gray], ["stop: остановить сервер до 'mcp start' или следующего запуска игры.", gray], ["Адрес: http://127.0.0.1:<port>/mcp - транспорт Streamable HTTP.", gray], ["Claude Code: claude mcp add --transport http stoneshard http://127.0.0.1:8765/mcp", gray], ["Инструменты: console_execute, console_read, screenshot.", gray]];
    }
    if (_lang == 3)
    {
        return [["mcp [status | start [port] | stop]", green], ["内置 MCP 服务器：让 AI 智能体通过 HTTP 执行控制台命令并截图。", gray], ["随控制台在开始或读取游戏时启动，端口 8765；只接受本机连接。", gray], ["选项：", white], ["status: 显示地址和当前连接数 - 默认。", gray], ["start [port]: 重启服务器，可换到另一个端口。", gray], ["stop: 停止服务器，直到 'mcp start' 或下次启动游戏。", gray], ["地址：http://127.0.0.1:<port>/mcp - Streamable HTTP 传输。", gray], ["Claude Code: claude mcp add --transport http stoneshard http://127.0.0.1:8765/mcp", gray], ["工具：console_execute、console_read、screenshot。", gray]];
    }
    return [["mcp [status | start [port] | stop]", green], ["Built-in MCP server that lets an AI agent run console commands and take screenshots over HTTP.", gray], ["Starts with the console when a game is started or loaded, on port 8765; local connections only.", gray], ["Options:", white], ["status: show the endpoint and open connections - the default.", gray], ["start [port]: restart the server, optionally on another port.", gray], ["stop: stop the server until 'mcp start' or the next game launch.", gray], ["Endpoint: http://127.0.0.1:<port>/mcp - Streamable HTTP transport.", gray], ["Claude Code: claude mcp add --transport http stoneshard http://127.0.0.1:8765/mcp", gray], ["Tools: console_execute, console_read, screenshot.", gray]];
}
