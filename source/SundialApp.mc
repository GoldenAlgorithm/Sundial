import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class SundialApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
        SundialAppSettings.update();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        var view = new SundialWatchFace();
        var inputDelegate = new SundialWatchFaceDelegate(view);
        return [ view, inputDelegate ];
    }

    function getSettingsView() as [ WatchUi.Views ] or [ WatchUi.Views, WatchUi.InputDelegates ] or Null {
        var view = new SundialSettingsView();
        var inputDelegate = new SundialSettingsViewDelegate();
        return [view, inputDelegate];
    }
    // New app settings have been received so trigger a UI update
    function onSettingsChanged() as Void {
        SundialAppSettings.update();
        WatchUi.requestUpdate();
    }

}

function getApp() as SundialApp {
    return Application.getApp() as SundialApp;
}