import 'package:flutter/material.dart';
import 'package:ui/src/custom_painters/custom_painters.dart';

import 'all_painters_demo.dart';
import 'theme_preview_screen.dart';

// void main() {
//   runApp(const MyApp());
// }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeManager _themeManager = ThemeManager();
  late AppTheme _currentTheme;

  @override
  void initState() {
    super.initState();
    _currentTheme = _themeManager.currentTheme;
    _themeManager.addListener(_handleThemeChanged);
  }

  @override
  void dispose() {
    _themeManager.removeListener(_handleThemeChanged);
    super.dispose();
  }

  void _handleThemeChanged(AppTheme newTheme) {
    setState(() {
      _currentTheme = newTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'Custom Painters Gallery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: _currentTheme.background,
        appBarTheme: AppBarTheme(backgroundColor: _currentTheme.wallDark, foregroundColor: Colors.white),
        floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: _currentTheme.wallDark, foregroundColor: Colors.white),
      ),
      home: const HomeScreen(),
      routes: {'/all-painters': (context) => const AllPaintersDemo(), '/theme-preview': (context) => const ThemePreviewScreen()},
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Custom Painters Gallery')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Custom Painters Gallery', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text(
              'Explore all custom painters across different themes',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 300,
              child: Column(
                children: [
                  _buildNavigationCard(context, title: 'All Painters Demo', description: 'View all painters with theme switching', icon: Icons.brush, route: '/all-painters'),
                  const SizedBox(height: 20),
                  _buildNavigationCard(context, title: 'Theme Comparison', description: 'Compare one painter across all themes', icon: Icons.compare, route: '/theme-preview'),
                  const SizedBox(height: 20),
                  _buildNavigationCard(
                    context,
                    title: 'Theme Info',
                    description: 'View all available themes and colors',
                    icon: Icons.palette,
                    onTap: () {
                      _showThemeInfo(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationCard(BuildContext context, {required String title, required String description, required IconData icon, String? route, VoidCallback? onTap}) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap ?? () => Navigator.pushNamed(context, route!),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.blue),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(description, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, size: 30),
            ],
          ),
        ),
      ),
    );
  }

  void _showThemeInfo(BuildContext context) {
    final allThemes = AppTheme.allThemes;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Available Themes'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(mainAxisSize: MainAxisSize.min, children: [for (var theme in allThemes) _buildThemeInfoItem(theme)]),
          ),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
        );
      },
    );
  }

  Widget _buildThemeInfoItem(AppTheme theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.wallDark.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppTheme.getThemeName(theme.type),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.wallDark),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _ColorInfo(color: theme.background, label: 'Background', hex: '#${theme.background.value.toRadixString(16).substring(2)}'),
              const SizedBox(width: 12),
              _ColorInfo(color: theme.wallDark, label: 'Wall Dark', hex: '#${theme.wallDark.value.toRadixString(16).substring(2)}'),
              const SizedBox(width: 12),
              _ColorInfo(color: theme.gridLine, label: 'Grid Line', hex: '#${theme.gridLine.value.toRadixString(16).substring(2)}'),
            ],
          ),
        ],
      ),
    );
  }
}

class _ColorInfo extends StatelessWidget {
  final Color color;
  final String label;
  final String hex;

  const _ColorInfo({super.key, required this.color, required this.label, required this.hex});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10)),
        Text(hex, style: const TextStyle(fontSize: 8)),
      ],
    );
  }
}
