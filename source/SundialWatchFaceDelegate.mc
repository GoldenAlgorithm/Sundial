import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class SundialWatchFaceDelegate extends WatchUi.WatchFaceDelegate {

    private var _sundialWatchFace as SundialWatchFace;

    public function initialize(sundialWatchFace as SundialWatchFace) {
        WatchFaceDelegate.initialize();
        _sundialWatchFace = sundialWatchFace;
    }

    public function onPowerBudgetExceeded(watchFacePowerInfo as WatchFacePowerInfo) as Void {
    }

    public function onPress(clickEvent as ClickEvent) as Lang.Boolean {
        _sundialWatchFace.handlePress(clickEvent);
        return false;
    }
}
