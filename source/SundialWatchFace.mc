import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class SundialWatchFace extends WatchUi.WatchFace {
    
    // Constructor
    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        //setLayout(Rez.Layouts.WatchFaceLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        clearScreen(dc);
        switch (System.getDisplayMode()) {
            case System.DISPLAY_MODE_OFF:
                return;
            case System.DISPLAY_MODE_LOW_POWER:
                drawLowPowerWatchFace(dc);
                break;
            case System.DISPLAY_MODE_HIGH_POWER:
                drawHighPowerWatchFace(dc);
        }

        // Call the parent onUpdate function to redraw the layout
        //View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    //The device is exiting low power mode.
    //Timers and animations may be started here in preparation for once-per-second updates.
    function onExitSleep() as Void {
        requestUpdate();
    }

    //The device is entering low power mode.
    //Terminate any active timers and prepare for once-per-minute updates.
    function onEnterSleep() as Void {
        requestUpdate();
    }


    function drawHighPowerWatchFace(dc as Dc) as Void {
        // Draw the watch face
        dc.setColor(SundialAppSettings.foregroundColor, SundialAppSettings.backgroundColor);
        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_SYSTEM_SMALL, "HIGH", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    function drawLowPowerWatchFace(dc as Dc) as Void {
        // Draw the watch face
        dc.setColor(SundialAppSettings.foregroundColor, SundialAppSettings.backgroundColor);
        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_SYSTEM_SMALL, "LOW", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    //Clear the screen
    function clearScreen(dc as Dc) as Void {
        dc.setColor(SundialAppSettings.foregroundColor, SundialAppSettings.backgroundColor);
        dc.clear();
    }
    // If the user presses the screen, request an update
    function handlePress(clickEvent as ClickEvent) as Void {
        requestUpdate();
    }
}
