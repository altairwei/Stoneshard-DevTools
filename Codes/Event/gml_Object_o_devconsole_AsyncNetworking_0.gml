// Async Networking event: MCP server socket traffic - connect, disconnect,
// data. async_load is read here at event level, like the proven o_webchannel
// handler of the Multiplayer mod, and handed to the script.
scr_devtools_mcp_network(async_load);
