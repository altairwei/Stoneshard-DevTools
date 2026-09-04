function scr_console_getassetid()
{
    var _argumentsArray = argument[0]
    var _name = _argumentsArray[0]
    // Vanilla resolves through the __asset_get_index caching wrapper; plain
    // asset_get_index returns the same ids and is compile-safe (see the
    // scr_console_getinstances patch).
    var _id = asset_get_index(_name)
    if (_id >= 0)
        scr_console_output_list(string(_id), green)
    else
        scr_console_output_list("Invalid name", red)
}
