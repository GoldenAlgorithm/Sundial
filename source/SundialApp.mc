import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class SundialApp extends Application.AppBase {

  function initialize() {
    AppBase.initialize();
  }

  function onStart(state as Dictionary?) as Void {
  }

  function onStop(state as Dictionary?) as Void {
  }

  function getInitialView() as [Views] or [Views, InputDelegates] {
    var view = new SundialWatchFace();
    var inputDelegate = new SundialWatchFaceDelegate(view);
    return [ view, inputDelegate ];
  }

}

function getApp() as SundialApp {
  return Application.getApp() as SundialApp;
}
