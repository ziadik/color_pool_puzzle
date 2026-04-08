import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/localization.dart';

class LevelLabel extends StatelessWidget {
  final int levelNumber;

  const LevelLabel({
    super.key,
    required this.levelNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 48,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD9C8FB), Color(0xFFD9C8FB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            offset: const Offset(2, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Center(
        child: Text(
          '${Localization.getString('level')} $levelNumber',
          style: const TextStyle(
            color: Color(0xFF6549AE),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
