import Toybox.Application;

class SundialAppSettings{
    static var backgroundColor = 0x000000;
    static var foregroundColor = 0xFFFFFF;

    static function update(){
        backgroundColor = Application.Properties.getValue("BackgroundColor");
        foregroundColor = Application.Properties.getValue("ForegroundColor");
    }
}