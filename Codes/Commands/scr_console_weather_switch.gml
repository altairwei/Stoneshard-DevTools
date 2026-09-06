function scr_console_weather_switch()
{
    var _argumentsArray = argument[0]
    if (_argumentsArray[0] == "" || array_length(_argumentsArray) > 1)
    {
        scr_console_output_list("invalid argument number", red)
        return;
    }
    switch _argumentsArray[0]
    {
        case "rain":
            if (!variable_global_exists("weatherDataMap"))
                scr_console_output_list("global.weatherDataMap doesn't exist", red)
            else if (!(ds_map_find_value(global.weatherDataMap, "active")))
            {
                scr_weatherEnable()
                scr_console_output_list("Enabled rain", green)
            }
            else
                scr_console_output_list("It's already raining", red)
            break
        case "clear":
            if (!variable_global_exists("weatherDataMap"))
                scr_console_output_list("global.weatherDataMap doesn't exist", red)
            else if (ds_map_find_value(global.weatherDataMap, "active"))
            {
                scr_weatherDisable()
                with (o_shader_start)
                    saturationRain = 0
                scr_console_output_list("Weather cleared", green)
            }
            else
                scr_console_output_list("Weather is already cleared", red)
            break
        case "info":
            if (!variable_global_exists("weatherInfo"))
                scr_console_output_list("global.weatherInfo doesn't exist", red)
            else if (global.weatherInfo)
            {
                global.weatherInfo = 0
                scr_console_output_list("Weather information is now OFF", green)
            }
            else
            {
                global.weatherInfo = 1
                scr_console_output_list("Weather information is now ON", green)
            }
            break
        default:
            scr_console_output_list(("Weather " + _argumentsArray[0] + " not found"), red)
            break
    }
}
