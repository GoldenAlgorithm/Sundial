import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class SundialApp extends Application.AppBase {

  function initialize() {
    AppBase.initialize();
  }

  function getInitialView() as [Views] or [Views, InputDelegates] {
    var view = new SundialWatchFace();
    var inputDelegate = new SundialWatchFaceDelegate(view);
    return [ view, inputDelegate ];
  }

  function getSettingsView() as [ WatchUi.Views ] or [ WatchUi.Views, WatchUi.InputDelegates ] or Null {
        var view = new SundialSettingsMenu();
        var inputDelegate = new SundialSettingsMenuDelegate(view);
        return [view, inputDelegate];
    }
    
    function onSettingsChanged() as Void {
        WatchUi.requestUpdate();
    }
}

function getApp() as SundialApp {
  return Application.getApp() as SundialApp;
}
