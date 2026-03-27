import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controllers/settings_manager.dart';
import 'controllers/level_manager.dart';
import 'views/game_screen.dart';
import 'utils/app_colors.dart';
import 'utils/localization.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final app = await initialApp();
  runApp(app);
}

Future<Widget> initialApp() async {
  // Принудительно устанавливаем портретную ориентацию
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  try {
    // Инициализация менеджеров
    final prefs = await SharedPreferences.getInstance();
    final settingsManager = SettingsManager(prefs);

    // Загрузка сохраненных настроек
    await settingsManager.loadSettings();
    final levelManager = LevelManager();
    levelManager.syncWithSettings(settingsManager); // Добавить этот вызов

    print('✅ Settings loaded');
    print('  Max opened level: ${settingsManager.maxOpenedLevel}');
    print('  Records count: ${settingsManager.records.length}');

    return AppMain(
      child: MyApp(),
      settingsManager: settingsManager,
      levelManager: levelManager,
    );
  } catch (e) {
    print('Error initializing app: $e');
    // Fallback - запускаем с настройками по умолчанию
    return AppMain(child: MyApp(), settingsManager: SettingsManager(SharedPreferences.getInstance() as SharedPreferences), levelManager: LevelManager());
  }
}

class AppMain extends StatelessWidget {
  final Widget child;
  final SettingsManager settingsManager;
  final LevelManager levelManager;
  const AppMain({super.key, required this.child, required this.settingsManager, required this.levelManager});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => settingsManager),
        ChangeNotifierProvider(create: (_) => levelManager),
      ],
      child: child,
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Используем Consumer только если SettingsManager доступен
    // Иначе используем MaterialApp с настройками по умолчанию
    try {
      return Consumer<SettingsManager>(
        builder: (context, settings, _) {
          return MaterialApp(
            title: 'Ball Puzzle',
            debugShowCheckedModeBanner: false,
            locale: settings.currentLocale,
            theme: _buildLightTheme(),
            darkTheme: _buildDarkTheme(),
            themeMode: settings.currentTheme,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: Localization.supportedLocales,
            home: const GameScreen(),
          );
        },
      );
    } catch (e) {
      // Fallback если провайдер недоступен
      return MaterialApp(
        title: 'Ball Puzzle',
        debugShowCheckedModeBanner: false,
        theme: _buildLightTheme(),
        darkTheme: _buildDarkTheme(),
        themeMode: ThemeMode.system,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: Localization.supportedLocales,
        home: const GameScreen(),
      );
    }
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primaryColor,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryColor,
        secondary: AppColors.secondaryColor,
        surface: AppColors.backgroundColor,
        error: AppColors.errorColor,
      ),
      fontFamily: 'SFPro',
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.blue, // цвет текста для светлой темы
          disabledForegroundColor: Colors.grey,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.backgroundColor,
      dialogTheme: const DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryColorDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryColorDark,
        secondary: AppColors.secondaryColor,
        surface: AppColors.backgroundColorDark,
        error: AppColors.errorColor,
        onSurface: Colors.white, // цвет текста на поверхности для темной темы
        onPrimary: Colors.white,
      ),
      fontFamily: 'SFPro',
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.lightBlueAccent, // цвет текста для темной темы
          disabledForegroundColor: Colors.grey,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
        titleLarge: TextStyle(color: Colors.white),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.primaryColorDark,
        foregroundColor: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.backgroundColorDark,
      dialogTheme: const DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }
}
