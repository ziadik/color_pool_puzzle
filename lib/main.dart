import 'package:flutter/material.dart';

import 'app/di/depends.dart';
import 'app/di/di_container.dart';
import 'app/theme/app_theme.dart';
import 'app/utils/app_zone.dart';
import 'app/utils/error_util.dart';
import 'app/widget/app_error.dart';
import 'features/init_app/data/initialization.dart';
import 'features/leaderboard/presentation/leaderboard_screen.dart';
import 'features/main_menu/main_menu_screen.dart';
import 'features/user/presentation/user_screen.dart';
import 'features/game/game_screen.dart';
import 'l10n/gen/app_localizations.dart';

part 'app/game_router.dart';

void main() => appZone(() async {
  // Splash screen
  final initializationProgress = ValueNotifier<({int progress, String message})>((progress: 0, message: ''));
  /* runApp(SplashScreen(progress: initializationProgress)); */
  $initializeApp(
    onProgress: (progress, message) => initializationProgress.value = (progress: progress, message: message),
    onSuccess: (depends) => runApp(_MyApp(depends: depends)),
    onError: (error, stackTrace) {
      runApp(AppError(error: error, stackTrace: stackTrace));
      ErrorUtil.logError(error, stackTrace).ignore();
    },
  ).ignore();
  // // Инициализируем Flutter binding
  // WidgetsFlutterBinding.ensureInitialized();

  // // Создаем экземпляр класса Depends
  // final Depends depends = Depends();
  // try {
  //   // Инициализируем зависимости
  //   await depends.init();
  //   // В случае успешной инициализации зависимостей
  //   // запускаем приложение
  //   // Передаем зависимости в контейнер зависимостей
  //   runApp(_MyApp(depends: depends));
  // } on Object catch (error, stackTrace) {
  //   // В случае ошибки при инициализации зависимостей
  //   // запускаем приложение с экраном ошибки
  //   runApp(AppError(error: error, stackTrace: stackTrace));
  // }
});

class _MyApp extends StatefulWidget {
  const _MyApp({required this.depends});

  /// Передаем зависимости в приложение
  /// и используем их в контейнере зависимостей
  final Depends depends;

  @override
  State<_MyApp> createState() => MyAppState();
}

class MyAppState extends State<_MyApp> {
  Locale _locale = const Locale('ru');
  ThemeMode _themeMode = ThemeMode.system;
  ThemeData _theme = AppTheme.light;
  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  /// Получение текущего режима темы
  ThemeMode get themeMode => _themeMode;

  /// Установить тему
  set themeMode(ThemeMode value) {
    if (_themeMode != value) {
      _themeMode = value;
      _theme = _themeMode == ThemeMode.light ? AppTheme.light : AppTheme.dark;
    }
  }

  /// Метод для переключения темы приложения.
  ///
  /// Переключает между светлой и темной темой.
  /// Если текущая тема светлая, переключает на темную и наоборот.
  void changeTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _theme = _themeMode == ThemeMode.light ? AppTheme.light : AppTheme.dark;
  }

  Future<void> _loadLocale() async {
    final storage = widget.depends.storageService;
    final localeCode = storage.getString('locale') ?? 'ru';
    setState(() {
      _locale = Locale(localeCode);
    });
  }

  void setLocale(Locale locale) {
    setState(() {
      changeTheme();
      _locale = locale;
    });
    _saveLocale(locale.languageCode);
  }

  Future<void> _saveLocale(String localeCode) async {
    final storage = widget.depends.storageService;
    await storage.setString('locale', localeCode);
  }

  @override
  Widget build(BuildContext context) {
    return DiContainer(
      depends: widget.depends,

      child: MaterialApp(
        theme: _theme,
        debugShowCheckedModeBanner: false,
        locale: _locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        initialRoute: GameRouter.initialRoute,
        routes: GameRouter._appRoutes,
      ),
    );
  }
}
