function scr_console_save()
{
    var _argumentsArray = argument[0]
    var _saveType = scr_stringTransform(_argumentsArray[0]);
    var _saveTypeName = "N/A";
    var _saveTypeEvent = -4;
    
    switch (_saveType)
    {
        case "0":
        case "sleep":
            _saveTypeName = "Sleep";
            _saveTypeEvent = 5;
            break;
        
        case "1":
        case "auto":
            _saveTypeName = "Auto";
            _saveTypeEvent = 6;
            break;
        
        case "2":
        case "exit":
            _saveTypeName = "Exit";
            _saveTypeEvent = 7;
            break;
        
        default:
            scr_console_output_list("Save type not found. Should be 0 - sleep, 1 - auto, 2 - exit", red);
            break;
    }
    
    if (_saveTypeEvent != -4)
    {
        var _smoothChanger = scr_smoothRoomChange(-4, [4, _saveTypeEvent], -1, 0);
        
        if (_smoothChanger != -4)
        {
            scr_slotSaveTitleKeyPrepare();
            scr_slotSaveScreenshotPrepare();
            scr_console_output_list(_saveTypeName + " - saving...", green);
        }
        else
        {
            scr_console_output_list("Saving is in process already!", red);
        }
    }
}