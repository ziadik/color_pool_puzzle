import 'package:flutter/material.dart';
import 'package:ui/src/custom_painters/custom_painters.dart';

class AllPaintersDemo extends StatefulWidget {
  const AllPaintersDemo({Key? key}) : super(key: key);

  @override
  State<AllPaintersDemo> createState() => _AllPaintersDemoState();
}

class _AllPaintersDemoState extends State<AllPaintersDemo> {
  final ThemeManager _themeManager = ThemeManager();
  late AppTheme _currentTheme;
  int _selectedThemeIndex = 0;
  double _painterSize = 150.0;
  bool _showGrid = true;
  bool _showLabels = true;

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

  void _selectTheme(ThemeType themeType) {
    _themeManager.setTheme(themeType);
    _selectedThemeIndex = ThemeType.values.indexOf(themeType);
  }

  void _selectThemeByIndex(int index) {
    final themeType = ThemeType.values[index];
    _selectTheme(themeType);
  }

  @override
  Widget build(BuildContext context) {
    final allThemes = AppTheme.allThemes;
    final themeNames = ThemeType.values.map((type) => AppTheme.getThemeName(type)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Custom Painters Demo'),
        actions: [
          ThemeButton(themeManager: _themeManager, onThemeChanged: () => setState(() {})),
          IconButton(
            icon: Icon(_showGrid ? Icons.grid_off : Icons.grid_on, color: _currentTheme.wallDark),
            onPressed: () {
              setState(() {
                _showGrid = !_showGrid;
              });
            },
            tooltip: 'Toggle Grid',
          ),
          IconButton(
            icon: Icon(_showLabels ? Icons.label_off : Icons.label, color: _currentTheme.wallDark),
            onPressed: () {
              setState(() {
                _showLabels = !_showLabels;
              });
            },
            tooltip: 'Toggle Labels',
          ),
        ],
      ),
      body: Column(
        children: [
          // Theme selection
          _buildThemeSelector(allThemes),

          // Controls
          _buildControls(),

          // All painters grid
          Expanded(child: _buildPaintersGrid()),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            heroTag: 'fab1',
            onPressed: () {
              setState(() {
                _painterSize = (_painterSize - 20).clamp(80.0, 300.0);
              });
            },
            child: const Icon(Icons.remove),
            tooltip: 'Decrease Size',
          ),
          const SizedBox(height: 8),
          FloatingActionButton.small(
            heroTag: 'fab2',
            onPressed: () {
              setState(() {
                _painterSize = (_painterSize + 20).clamp(80.0, 300.0);
              });
            },
            child: const Icon(Icons.add),
            tooltip: 'Increase Size',
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'fab3',
            onPressed: () {
              _themeManager.toggleTheme();
            },
            child: const Icon(Icons.color_lens),
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSelector(List<AppTheme> allThemes) {
    final themeNames = ThemeType.values.map((type) => AppTheme.getThemeName(type)).toList();
    return Container(
      padding: const EdgeInsets.all(12.0),
      color: _currentTheme.background.withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Theme: ${AppTheme.getThemeName(_currentTheme.type)}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _currentTheme.wallDark),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(allThemes.length, (index) {
                final theme = allThemes[index];
                final isSelected = index == _selectedThemeIndex;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(themeNames[index], style: TextStyle(color: isSelected ? Colors.white : theme.wallDark)),
                    selected: isSelected,
                    selectedColor: theme.wallDark,
                    backgroundColor: theme.background.withOpacity(0.5),
                    onSelected: (selected) {
                      if (selected) {
                        _selectThemeByIndex(index);
                      }
                    },
                    avatar: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: theme.background,
                        border: Border.all(color: theme.wallDark, width: 1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Card(
      margin: const EdgeInsets.all(12.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Painter Size: ${_painterSize.toInt()}px',
                  style: TextStyle(color: _currentTheme.wallDark, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Current: ${AppTheme.getThemeName(_currentTheme.type)}',
                  style: TextStyle(color: _currentTheme.wallDark, fontStyle: FontStyle.italic),
                ),
              ],
            ),
            Slider(
              value: _painterSize,
              min: 80.0,
              max: 300.0,
              divisions: 11,
              label: _painterSize.toInt().toString(),
              onChanged: (value) {
                setState(() {
                  _painterSize = value;
                });
              },
              activeColor: _currentTheme.wallDark,
              inactiveColor: _currentTheme.wallDark.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaintersGrid() {
    final painters = [
      _PainterInfo('Top Wall', TopWallCP(theme: _currentTheme)),
      _PainterInfo('Left Wall', LeftWallCP(theme: _currentTheme)),
      _PainterInfo('Down Wall', DownWallCP(theme: _currentTheme)),
      _PainterInfo('Block', BlockCP(theme: _currentTheme)),
      _PainterInfo('Top Left Out Angle', TopLeftOutAngleCP(theme: _currentTheme)),
      _PainterInfo('Top Left In Angle', TopLeftInAngleCP(theme: _currentTheme)),
      _PainterInfo('Down Left In Angle', DownLeftInAngleCP(theme: _currentTheme)),
      _PainterInfo('Down Right Out Angle', DownRightOutAngleCP(theme: _currentTheme)),
      _PainterInfo('Left Bridge', LeftBridgeCP(theme: _currentTheme)),
      _PainterInfo('Left Bridge (No Shadow)', LeftBridgeWOTShadowCP(theme: _currentTheme)),
      _PainterInfo('Left Bridge Shadow', LeftBridgesShadow(theme: _currentTheme)),
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2, crossAxisSpacing: 16.0, mainAxisSpacing: 16.0, childAspectRatio: 1.2),
      itemCount: painters.length,
      itemBuilder: (context, index) {
        return _buildPainterCard(painters[index]);
      },
    );
  }

  Widget _buildPainterCard(_PainterInfo painterInfo) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: _currentTheme.wallDark.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          // Label
          if (_showLabels)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                color: _currentTheme.background.withOpacity(0.2),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              ),
              child: Center(
                child: Text(
                  painterInfo.name,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _currentTheme.wallDark),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ),
            ),

          // Painter preview
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  // Grid background
                  if (_showGrid)
                    Positioned.fill(
                      child: CustomPaint(painter: GridPainter(gridWidth: 5, gridHeight: 5, cellSize: 15, theme: _currentTheme)),
                    ),

                  // Main painter
                  Center(
                    child: SizedBox(
                      width: _painterSize,
                      height: _painterSize,
                      child: CustomPaint(painter: painterInfo.painter),
                    ),
                  ),

                  // Theme indicator
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _currentTheme.background,
                        border: Border.all(color: _currentTheme.wallDark, width: 1.5),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Theme color indicators
          Container(
            height: 4,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
              gradient: LinearGradient(colors: [_currentTheme.background, _currentTheme.wallDark, _currentTheme.gridLine], begin: Alignment.centerLeft, end: Alignment.centerRight),
            ),
          ),
        ],
      ),
    );
  }
}

class _PainterInfo {
  final String name;
  final CustomPainter painter;

  _PainterInfo(this.name, this.painter);
}
