import 'package:flutter/material.dart';
import 'package:ui/src/custom_painters/custom_painters.dart';

class _PainterInfo {
  final String name;
  final CustomPainter painter;

  _PainterInfo(this.name, this.painter);
}

class ThemePreviewScreen extends StatefulWidget {
  const ThemePreviewScreen({super.key});

  @override
  State<ThemePreviewScreen> createState() => _ThemePreviewScreenState();
}

class _ThemePreviewScreenState extends State<ThemePreviewScreen> {
  double _painterSize = 100.0;
  int _selectedPainterIndex = 0;
  final List<_PainterInfo> _painters = [];

  @override
  void initState() {
    super.initState();
    _initializePainters();
  }

  void _initializePainters() {
    // Initialize with light theme (will be overridden for each theme)
    _painters.addAll([
      _PainterInfo('Top Wall', TopWallCP()),
      _PainterInfo('Left Wall', LeftWallCP()),
      _PainterInfo('Down Wall', DownWallCP()),
      _PainterInfo('Block', BlockCP()),
      _PainterInfo('Top Left Out Angle', TopLeftOutAngleCP()),
      _PainterInfo('Top Left In Angle', TopLeftInAngleCP()),
      _PainterInfo('Down Left In Angle', DownLeftInAngleCP()),
      _PainterInfo('Down Right Out Angle', DownRightOutAngleCP()),
      _PainterInfo('Left Bridge', LeftBridgeCP()),
      _PainterInfo('Left Bridge (No Shadow)', LeftBridgeWOTShadowCP()),
      _PainterInfo('Left Bridge Shadow', LeftBridgesShadow()),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final allThemes = AppTheme.allThemes;
    final selectedPainter = _painters[_selectedPainterIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Theme Comparison: ${selectedPainter.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.zoom_out),
            onPressed: () {
              setState(() {
                _painterSize = (_painterSize - 10).clamp(50.0, 200.0);
              });
            },
            tooltip: 'Zoom Out',
          ),
          IconButton(
            icon: const Icon(Icons.zoom_in),
            onPressed: () {
              setState(() {
                _painterSize = (_painterSize + 10).clamp(50.0, 200.0);
              });
            },
            tooltip: 'Zoom In',
          ),
        ],
      ),
      body: Column(
        children: [
          // Painter selector
          _buildPainterSelector(),

          // Theme comparison grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 800
                    ? 5
                    : MediaQuery.of(context).size.width > 600
                    ? 3
                    : 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.8,
              ),
              itemCount: allThemes.length,
              itemBuilder: (context, index) {
                return _buildThemeCard(allThemes[index], selectedPainter);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPainterSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select Painter:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _painters.length,
              itemBuilder: (context, index) {
                final painter = _painters[index];
                final isSelected = index == _selectedPainterIndex;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(painter.name, style: TextStyle(color: isSelected ? Colors.white : Colors.black87)),
                    selected: isSelected,
                    selectedColor: Colors.blue,
                    backgroundColor: Colors.grey[300],
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedPainterIndex = index;
                        });
                      }
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Size: '),
              Expanded(
                child: Slider(
                  value: _painterSize,
                  min: 50.0,
                  max: 200.0,
                  divisions: 15,
                  label: _painterSize.toInt().toString(),
                  onChanged: (value) {
                    setState(() {
                      _painterSize = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThemeCard(AppTheme theme, _PainterInfo painterInfo) {
    // Create a new instance of the painter with the specific theme
    final painter = _createPainterWithTheme(painterInfo, theme);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.wallDark.withOpacity(0.5), width: 2),
      ),
      child: Column(
        children: [
          // Theme name
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              color: theme.background,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              border: Border(bottom: BorderSide(color: theme.wallDark.withOpacity(0.3), width: 1)),
            ),
            child: Center(
              child: Text(
                AppTheme.getThemeName(theme.type),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: theme.wallDark),
              ),
            ),
          ),

          // Painter preview
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              color: theme.background.withOpacity(0.2),
              child: Stack(
                children: [
                  // Grid background
                  Positioned.fill(
                    child: CustomPaint(painter: GridPainter(gridWidth: 4, gridHeight: 4, cellSize: 12, theme: theme)),
                  ),

                  // Main painter
                  Center(
                    child: SizedBox(
                      width: _painterSize,
                      height: _painterSize,
                      child: CustomPaint(painter: painter),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Color palette
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            decoration: BoxDecoration(
              color: theme.background.withOpacity(0.1),
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ColorDot(color: theme.background, tooltip: 'Background'),
                _ColorDot(color: theme.wallDark, tooltip: 'Wall Dark'),
                _ColorDot(color: theme.gridLine, tooltip: 'Grid Line'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  CustomPainter _createPainterWithTheme(_PainterInfo painterInfo, AppTheme theme) {
    // This function creates a new instance of the painter with the specified theme
    switch (painterInfo.name) {
      case 'Top Wall':
        return TopWallCP(theme: theme);
      case 'Left Wall':
        return LeftWallCP(theme: theme);
      case 'Down Wall':
        return DownWallCP(theme: theme);
      case 'Block':
        return BlockCP(theme: theme);
      case 'Top Left Out Angle':
        return TopLeftOutAngleCP(theme: theme);
      case 'Top Left In Angle':
        return TopLeftInAngleCP(theme: theme);
      case 'Down Left In Angle':
        return DownLeftInAngleCP(theme: theme);
      case 'Down Right Out Angle':
        return DownRightOutAngleCP(theme: theme);
      case 'Left Bridge':
        return LeftBridgeCP(theme: theme);
      case 'Left Bridge (No Shadow)':
        return LeftBridgeWOTShadowCP(theme: theme);
      case 'Left Bridge Shadow':
        return LeftBridgesShadow(theme: theme);
      default:
        return TopWallCP(theme: theme);
    }
  }
}

class _ColorDot extends StatelessWidget {
  final Color color;
  final String tooltip;

  const _ColorDot({super.key, required this.color, required this.tooltip});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.black12),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
