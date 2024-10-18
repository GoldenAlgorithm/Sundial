import Toybox.WatchUi;

class SundialSettingsMenu extends WatchUi.Menu2 {

  public function initialize() {
    Menu2.initialize({ :title => Rez.Strings.SettingsLabel });

    // Theme
    var currentThemeIndex = SundialAppSettings.getThemeIndex();
    var themeMenuItem = new MenuItem(
      Rez.Strings.ThemeLabel,
      SundialAppSettings.THEMES[currentThemeIndex]["Name"],
      "Theme",
      {}
    );
    addItem(themeMenuItem);
  }
}
