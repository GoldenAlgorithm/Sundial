import Toybox.WatchUi;

class SundialSettingsView extends WatchUi.Menu2 {

  public function initialize() {
    Menu2.initialize({ :title => "Settings" });
    addItem(new MenuItem("Label", "Sublabel", "Id", {}));
  }
}
