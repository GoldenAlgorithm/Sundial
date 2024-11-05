import Toybox.WatchUi;

class SundialSettingsMenuDelegate extends WatchUi.Menu2InputDelegate {

  private var _sundialSettingsMenu as SundialSettingsMenu;

  function initialize(sundialSettingsMenu as SundialSettingsMenu) {
    Menu2InputDelegate.initialize();
    _sundialSettingsMenu = sundialSettingsMenu;
  }

  function onSelect(item as MenuItem) {
    var id = item.getId();
    switch (id) {
      case "Theme":
        var allThemes = SundialSettings.getAllThemes();
        var currentThemeIndex = SundialSettings.getThemeIndex();
        SundialSettings.setThemeIndex((currentThemeIndex + 1) % allThemes.size());
        item.setSubLabel(allThemes[SundialSettings.getThemeIndex()]["Name"]);
        _sundialSettingsMenu.updateItem(item, _sundialSettingsMenu.findItemById(item.getId()));
      default:
    }
  }

}
