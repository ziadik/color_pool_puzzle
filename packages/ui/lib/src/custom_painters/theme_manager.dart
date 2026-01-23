import 'app_theme.dart';

typedef ThemeChangedCallback = void Function(AppTheme newTheme);

class ThemeManager {
  // Singleton instance
  static final ThemeManager _instance = ThemeManager._internal();
  factory ThemeManager() => _instance;
  ThemeManager._internal() {
    _currentTheme = AppTheme.light();
  }

  // Current theme
  AppTheme _currentTheme = AppTheme.light();

  // List of listeners (callbacks)
  final List<ThemeChangedCallback> _listeners = [];

  // Getters
  AppTheme get currentTheme => _currentTheme;
  ThemeType get currentThemeType => _currentTheme.type;
  List<AppTheme> get availableThemes => AppTheme.allThemes;

  // Set theme and notify all listeners
  void setTheme(ThemeType type) {
    _currentTheme = AppTheme.getTheme(type);
    _notifyListeners();
  }

  // Toggle to next theme
  void toggleTheme() {
    final themes = ThemeType.values;
    final currentIndex = themes.indexOf(_currentTheme.type);
    final nextIndex = (currentIndex + 1) % themes.length;
    setTheme(themes[nextIndex]);
  }

  // Add listener
  void addListener(ThemeChangedCallback callback) {
    _listeners.add(callback);
  }

  // Remove listener
  void removeListener(ThemeChangedCallback callback) {
    _listeners.remove(callback);
  }

  // Notify all listeners
  void _notifyListeners() {
    for (var listener in _listeners) {
      listener(_currentTheme);
    }
  }

  // Clear all listeners (useful for testing)
  void clearListeners() {
    _listeners.clear();
  }
}
