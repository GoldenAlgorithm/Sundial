import Toybox.WatchUi;

class SundialSettingsViewDelegate extends WatchUi.Menu2InputDelegate {
  function initialize() {
    Menu2InputDelegate.initialize();
  }

  function onSelect(item) {
    var id = item.getId();
    System.println("Selected item: " + id);
  }

}
