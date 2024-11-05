import Toybox.Lang;
import Toybox.System;
import Toybox.Time;

(:debug) class Debug {
  
  public static function dumpDeviceSettings() as Void {
    var deviceSettings = System.getDeviceSettings();
    var text = "";
    text += "Device Settings:\n";
    text += deviceSettings has :activityTrackingOn               ? "Activity Tracking On              : " + deviceSettings.activityTrackingOn + "\n"               : "Activity Tracking On              : Not Supported\n";
    text += deviceSettings has :alarmCount                       ? "Alarm Count                       : " + deviceSettings.alarmCount + "\n"                       : "Alarm Count                       : Not Supported\n";
    text += deviceSettings has :connectionAvailable              ? "Connection Available              : " + deviceSettings.connectionAvailable + "\n"              : "Connection Available              : Not Supported\n";
    text += deviceSettings has :connectionInfo                   ? "Connection Info                   : " + deviceSettings.connectionInfo + "\n"                   : "Connection Info                   : Not Supported\n";
    text += deviceSettings has :distanceUnits                    ? "Distance Units                    : " + deviceSettings.distanceUnits + "\n"                    : "Distance Units                    : Not Supported\n";
    text += deviceSettings has :doNotDisturb                     ? "Do Not Disturb                    : " + deviceSettings.doNotDisturb + "\n"                     : "Do Not Disturb                    : Not Supported\n";
    text += deviceSettings has :elevationUnits                   ? "Elevation Units                   : " + deviceSettings.elevationUnits + "\n"                   : "Elevation Units                   : Not Supported\n";
    text += deviceSettings has :firmwareVersion                  ? "Firmware Version                  : " + deviceSettings.firmwareVersion + "\n"                  : "Firmware Version                  : Not Supported\n";
    text += deviceSettings has :firstDayOfWeek                   ? "First Day Of Week                 : " + deviceSettings.firstDayOfWeek + "\n"                   : "First Day Of Week                 : Not Supported\n";
    text += deviceSettings has :fontScale                        ? "Font Scale                        : " + deviceSettings.fontScale + "\n"                        : "Font Scale                        : Not Supported\n";
    text += deviceSettings has :heightUnits                      ? "Height Units                      : " + deviceSettings.heightUnits + "\n"                      : "Height Units                      : Not Supported\n";
    text += deviceSettings has :inputButtons                     ? "Input Buttons                     : " + deviceSettings.inputButtons + "\n"                     : "Input Buttons                     : Not Supported\n";
    text += deviceSettings has :is24Hour                         ? "Is 24 Hour                        : " + deviceSettings.is24Hour + "\n"                         : "Is 24 Hour                        : Not Supported\n";
    text += deviceSettings has :isEnhancedReadabilityModeEnabled ? "Enhanced Readability Mode Enabled : " + deviceSettings.isEnhancedReadabilityModeEnabled + "\n" : "Enhanced Readability Mode Enabled : Not Supported\n";
    text += deviceSettings has :isGlanceModeEnabled              ? "Glance Mode Enabled               : " + deviceSettings.isGlanceModeEnabled + "\n"              : "Glance Mode Enabled               : Not Supported\n";
    text += deviceSettings has :isNightModeEnabled               ? "Night Mode Enabled                : " + deviceSettings.isNightModeEnabled + "\n"               : "Night Mode Enabled                : Not Supported\n";
    text += deviceSettings has :isTouchScreen                    ? "Touch Screen                      : " + deviceSettings.isTouchScreen + "\n"                    : "Touch Screen                      : Not Supported\n";
    text += deviceSettings has :monkeyVersion                    ? "Monkey Version                    : " + deviceSettings.monkeyVersion + "\n"                    : "Monkey Version                    : Not Supported\n";
    text += deviceSettings has :notificationCount                ? "Notification Count                : " + deviceSettings.notificationCount + "\n"                : "Notification Count                : Not Supported\n";
    text += deviceSettings has :paceUnits                        ? "Pace Units                        : " + deviceSettings.paceUnits + "\n"                        : "Pace Units                        : Not Supported\n";
    text += deviceSettings has :partNumber                       ? "Part Number                       : " + deviceSettings.partNumber + "\n"                       : "Part Number                       : Not Supported\n";
    text += deviceSettings has :phoneConnected                   ? "Phone Connected                   : " + deviceSettings.phoneConnected + "\n"                   : "Phone Connected                   : Not Supported\n";
    text += deviceSettings has :requiresBurnInProtection         ? "Requires Burn In Protection       : " + deviceSettings.requiresBurnInProtection + "\n"         : "Requires Burn In Protection       : Not Supported\n";
    text += deviceSettings has :screenHeight                     ? "Screen Height                     : " + deviceSettings.screenHeight + "\n"                     : "Screen Height                     : Not Supported\n";
    text += deviceSettings has :screenShape                      ? "Screen Shape                      : " + deviceSettings.screenShape + "\n"                      : "Screen Shape                      : Not Supported\n";
    text += deviceSettings has :screenWidth                      ? "Screen Width                      : " + deviceSettings.screenWidth + "\n"                      : "Screen Width                      : Not Supported\n";
    text += deviceSettings has :systemLanguage                   ? "System Language                   : " + deviceSettings.systemLanguage + "\n"                   : "System Language                   : Not Supported\n";
    text += deviceSettings has :temperatureUnits                 ? "Temperature Units                 : " + deviceSettings.temperatureUnits + "\n"                 : "Temperature Units                 : Not Supported\n";
    text += deviceSettings has :tonesOn                          ? "Tones On                          : " + deviceSettings.tonesOn + "\n"                          : "Tones On                          : Not Supported\n";
    text += deviceSettings has :uniqueIdentifier                 ? "Unique Identifier                 : " + deviceSettings.uniqueIdentifier + "\n"                 : "Unique Identifier                 : Not Supported\n";
    text += deviceSettings has :vibrateOn                        ? "Vibrate On                        : " + deviceSettings.vibrateOn + "\n"                        : "Vibrate On                        : Not Supported\n";
    text += deviceSettings has :weightUnits                      ? "Weight Units                      : " + deviceSettings.weightUnits + "\n"                      : "Weight Units                      : Not Supported\n";
    System.println(text);
}

  public static function getTimestamp() as String {
    var dateTimeInfo = Time.Gregorian.info(Time.now(), Time.FORMAT_SHORT);
    var returnValue = Lang.format("$1$$2$$3$$4$$5$$6$", [
        dateTimeInfo.year.format("%04d"),
        dateTimeInfo.month.format("%02d"),
        dateTimeInfo.day.format("%02d"),
        dateTimeInfo.hour.format("%02d"),
        dateTimeInfo.min.format("%02d"),
        dateTimeInfo.sec.format("%02d")]
    );
    return returnValue;
  }

  public static function logMessage(message as String) as Void {
    System.println(getTimestamp() + " : " + message);
  }

  public static function logMessages(message as String, subMessages as Array<String> or Null) as Void {
    System.println(getTimestamp() + " : " + message);
    if (subMessages != null) {
        for (var i = 0; i < subMessages.size(); i++) {
            System.println("                 " + subMessages[i]);
        }
    }
  }
}
