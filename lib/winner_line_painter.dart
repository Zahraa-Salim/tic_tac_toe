import 'package:flutter/material.dart';

class WinningLinePainter extends CustomPainter {
  final List<List<int>> winningLine;
  final double progress; // Animation progress (0.0 to 1.0)

  WinningLinePainter(this.winningLine, {required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFFFFF) // Winning line color
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke;

    if (winningLine.isNotEmpty) {
      double cellSize = size.width / 3;

      // Calculate start and end points
      Offset start = Offset(
        winningLine.first[1] * cellSize + cellSize / 2,
        winningLine.first[0] * cellSize + cellSize / 2,
      );
      Offset end = Offset(
        winningLine.last[1] * cellSize + cellSize / 2,
        winningLine.last[0] * cellSize + cellSize / 2,
      );

      // Interpolate between start and end based on progress
      Offset animatedEnd = Offset.lerp(start, end, progress)!;

      canvas.drawLine(start, animatedEnd, paint);
    }
  }

  @override
  bool shouldRepaint(covariant WinningLinePainter oldDelegate) {
    return oldDelegate.winningLine != winningLine || oldDelegate.progress != progress;
  }
}
