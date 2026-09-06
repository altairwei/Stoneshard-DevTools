function scr_console_getinstances()
{
    var _argumentsArray = argument[0]
    var _parentObjectString = _argumentsArray[0]
    // Vanilla calls __asset_get_index here (a GML caching wrapper over
    // asset_get_index); the old compiler cannot resolve that bare name, and
    // the wrapper's only job is caching - asset_get_index is equivalent.
    var _parentObject = asset_get_index(_parentObjectString)
    if (_parentObject >= 0)
    {
        var _instancesNumber = instance_number(_parentObject)
        scr_console_output_list(("Instances of " + _parentObjectString + ":"), white)
        if (_instancesNumber > 0)
        {
            for (var _i = 0; _i < _instancesNumber; _i++)
            {
                var _instance = instance_find(_parentObject, _i)
                var _objectIndexString = object_get_name(_instance.object_index)
                scr_console_output_list((_objectIndexString + " (" + "#" + string(_instance) + ", x: " + string(_instance.x) + ", y: " + string(_instance.y) + ")"), green)
            }
        }
        else
            scr_console_output_list("Instances not found", red)
    }
    else
        scr_console_output_list("Parent object not found", red)
}
