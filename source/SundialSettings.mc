import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;

public class SundialSettings {
    private static var screenWidth as Float?;
    private static var screenHeight as Float?;

    private static const THEMES as Array<Dictionary<String, String or Number>> = [
        {
            "Name" => Rez.Strings.ThemeDark,
            "HighPowerBackgroundColor" => Graphics.COLOR_BLACK,
            "HighPowerForegroundColor" => Graphics.COLOR_WHITE,
            "HighPowerMarksColor" => Graphics.COLOR_LT_GRAY,
            "HighPowerTextColor" => Graphics.COLOR_LT_GRAY,
            "HighPowerComplicationColor" => Graphics.COLOR_LT_GRAY,
            "HighPowerHandsLightColor" => Graphics.COLOR_LT_GRAY,
            "HighPowerHandsDarkColor" => Graphics.COLOR_DK_GRAY,
            "HighPowerSecondHandColor" => Graphics.COLOR_LT_GRAY,
            "LowPowerBackgroundColor" => Graphics.COLOR_BLACK,
            "LowPowerMarksColor" => Graphics.COLOR_DK_GRAY,
            "LowPowerHandsColor" => Graphics.COLOR_DK_GRAY,
            "AccentColor" => Graphics.COLOR_ORANGE
        },
        {
            "Name" => Rez.Strings.ThemeLight,
            "HighPowerBackgroundColor" => Graphics.COLOR_WHITE,
            "HighPowerForegroundColor" => Graphics.COLOR_BLACK,
            "HighPowerMarksColor" => Graphics.COLOR_DK_GRAY,
            "HighPowerTextColor" => Graphics.COLOR_DK_GRAY,
            "HighPowerComplicationColor" => Graphics.COLOR_DK_GRAY,
            "HighPowerHandsLightColor" => Graphics.COLOR_LT_GRAY,
            "HighPowerHandsDarkColor" => Graphics.COLOR_DK_GRAY,
            "HighPowerSecondHandColor" => Graphics.COLOR_DK_GRAY,
            "LowPowerBackgroundColor" => Graphics.COLOR_BLACK,
            "LowPowerMarksColor" => Graphics.COLOR_DK_GRAY,
            "LowPowerHandsColor" => Graphics.COLOR_DK_GRAY,
            "AccentColor" => Graphics.COLOR_ORANGE
        }
    ];

    private static const PROPERTYID_THEME as String = "ThemeIndex";
    public static function getThemeIndex() as Number {
        return Application.Properties.getValue("ThemeIndex");
    }
    public static function setThemeIndex(themeIndex as Number) {
        Application.Properties.setValue(PROPERTYID_THEME, themeIndex);
    }
    public static function getAllThemes() as Array<Dictionary<String, String or Number>> {
        return THEMES; //TODO: Add error handling
    }

    public static function getCurrentTheme() as Dictionary<String, String or Number> {
        return THEMES[getThemeIndex()];
    }

    // Device Settings
    public static function getScreenWidth() as Float {
        return screenWidth == null ? System.getDeviceSettings().screenWidth.toFloat() : screenWidth;
    }

    public static function getScreenHeight() as Float {
        return screenHeight == null ? System.getDeviceSettings().screenHeight.toFloat() : screenHeight;
    }

    public static function isInAirplaneMode() as Boolean {
        return !System.getDeviceSettings().connectionAvailable;
    }

    public static function getBluetoothState() as String {
        switch(System.getDeviceSettings().connectionInfo[:bluetooth]) {
            case null:
                return "Not Supported";
            case System.CONNECTION_STATE_NOT_INITIALIZED:
                return "Not setup / Inactive";
            case System.CONNECTION_STATE_NOT_CONNECTED:
                return "Not in range";
            case System.CONNECTION_STATE_CONNECTED:
                return "Connected";
            default:
                return "ERROR";
        }
    }

    public static function getWifiState() as String {
        switch(System.getDeviceSettings().connectionInfo[:wifi]) {
            case null:
                return "Not Supported";
            case System.CONNECTION_STATE_NOT_INITIALIZED:
                return "Not setup / Inactive";
            case System.CONNECTION_STATE_NOT_CONNECTED:
                return "Not in range";
            case System.CONNECTION_STATE_CONNECTED:
                return "Connected";
            default:
                return "ERROR";
        }
    }

    public static function getLteState() as String {
        switch(System.getDeviceSettings().connectionInfo[:lte]) {
            case null:
                return "Not Supported";
            case System.CONNECTION_STATE_NOT_INITIALIZED:
                return "Not setup / Inactive";
            case System.CONNECTION_STATE_NOT_CONNECTED:
                return "Not in range";
            case System.CONNECTION_STATE_CONNECTED:
                return "Connected";
            default:
                return "ERROR";
        }
    }
}
