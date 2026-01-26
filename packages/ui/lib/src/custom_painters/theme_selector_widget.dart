import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'theme_manager.dart';

class ThemeButton extends StatelessWidget {
  final ThemeManager themeManager;
  final bool showLabels;
  final VoidCallback? onThemeChanged;

  const ThemeButton({super.key, required this.themeManager, this.showLabels = true, this.onThemeChanged});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ThemeType>(
      icon: Icon(Icons.palette, color: themeManager.currentTheme.wallDark),
      tooltip: 'Select Theme',
      onSelected: (themeType) {
        themeManager.setTheme(themeType);
        onThemeChanged?.call();
      },
      itemBuilder: (BuildContext context) {
        return ThemeType.values.map((themeType) {
          final theme = AppTheme.getTheme(themeType);
          final isCurrent = themeManager.currentThemeType == themeType;
          return PopupMenuItem<ThemeType>(
            value: themeType,
            child: Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: theme.background,
                    border: Border.all(color: theme.wallDark, width: isCurrent ? 3 : 1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                if (showLabels) Text(AppTheme.getThemeName(themeType), style: TextStyle(fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal)),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}

class ThemeSelector extends StatefulWidget {
  final ThemeManager themeManager;

  const ThemeSelector({super.key, required this.themeManager});

  @override
  _ThemeSelectorState createState() => _ThemeSelectorState();
}

class _ThemeSelectorState extends State<ThemeSelector> {
  late AppTheme _currentTheme;

  @override
  void initState() {
    super.initState();
    _currentTheme = widget.themeManager.currentTheme;
    widget.themeManager.addListener(_handleThemeChanged);
  }

  @override
  void dispose() {
    widget.themeManager.removeListener(_handleThemeChanged);
    super.dispose();
  }

  void _handleThemeChanged(AppTheme newTheme) {
    setState(() {
      _currentTheme = newTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Theme',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _currentTheme.wallDark),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ThemeType.values.map((themeType) {
                final theme = AppTheme.getTheme(themeType);
                final isSelected = widget.themeManager.currentThemeType == themeType;
                return GestureDetector(
                  onTap: () {
                    widget.themeManager.setTheme(themeType);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? theme.wallDark.withOpacity(0.2) : Colors.transparent,
                      border: Border.all(color: isSelected ? theme.wallDark : theme.wallDark.withOpacity(0.3), width: isSelected ? 2 : 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: theme.background,
                            border: Border.all(color: theme.wallDark, width: 1),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          AppTheme.getThemeName(themeType),
                          style: TextStyle(color: theme.wallDark, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class QuickThemeToggleButton extends StatelessWidget {
  final ThemeManager themeManager;
  final VoidCallback? onThemeChanged;

  const QuickThemeToggleButton({super.key, required this.themeManager, this.onThemeChanged});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.color_lens, color: themeManager.currentTheme.wallDark),
      tooltip: 'Toggle Theme',
      onPressed: () {
        themeManager.toggleTheme();
        onThemeChanged?.call();
      },
    );
  }
}
