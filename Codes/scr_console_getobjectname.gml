function scr_console_getobjectname()
{
    var _argumentsArray = argument[0]
    if (_argumentsArray[0] == "" || array_length(_argumentsArray) > 1)
    {
        scr_console_output_list("invalid argument number", red)
        return;
    }
    var _id = round(scr_console_string_to_real_with_nan(_argumentsArray[0]))
    if (is_nan(_id) || _id < 0)
    {
        scr_console_output_list("id should be a number greater or equal to 0", red)
        return;
    }
    if (instance_exists(_id))
        scr_console_output_list(("Object with id " + string(_id) + " has name " + object_get_name(_id.object_index)), green)
    else
        scr_console_output_list(("Object with id " + string(_id) + " not found"), red)
}
