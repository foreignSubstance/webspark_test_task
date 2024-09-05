import 'package:flutter/material.dart';

enum CellType { regular, begin, transit, end, blocked }

class PathCell extends StatelessWidget {
  final List<int> coordinates;
  final CellType type;
  const PathCell({super.key, required this.coordinates, required this.type});

  @override
  Widget build(BuildContext context) {
    final Color color;
    switch (type) {
      case CellType.begin:
        color = const Color(0xFF64FFDA);
        break;
      case CellType.transit:
        color = const Color(0xFF4CAF50);
        break;
      case CellType.end:
        color = const Color(0xFF009688);
        break;
      case CellType.blocked:
        color = Colors.black;
        break;
      default:
        color = Colors.white;
    }
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: color,
      ),
      child: Center(
        child: Text(
          '(${coordinates[0]},${coordinates[1]})',
          style: TextStyle(
            color: type == CellType.blocked ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
