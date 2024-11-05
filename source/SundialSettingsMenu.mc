import Toybox.WatchUi;

class SundialSettingsMenu extends WatchUi.Menu2 {

  public function initialize() {
    Menu2.initialize({ :title => Rez.Strings.SettingsLabel });

    // Theme
    var currentThemeIndex = SundialSettings.getThemeIndex();
    var themeMenuItem = new MenuItem(
      Rez.Strings.ThemeLabel,
      SundialSettings.getAllThemes()[currentThemeIndex]["Name"],
      "Theme",
      {}
    );
    addItem(themeMenuItem);
  }
}
