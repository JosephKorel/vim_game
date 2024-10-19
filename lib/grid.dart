import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vim_game/carret.dart';
import 'package:vim_game/line_counter.dart';
import 'package:vim_game/providers/providers.dart';

class EditorGrid extends StatelessWidget {
  const EditorGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Code Editor Layout'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;
            final squareSize = screenWidth / 80;

            return Row(
              children: [
                LineCounter(squareSize: squareSize, maxHeight: screenHeight),
                Expanded(
                  child: Stack(
                    children: [
                      CustomPaint(
                        size: Size(double.infinity, screenHeight),
                        painter: GridPainter(
                            squareSize: Size(squareSize, squareSize * 1.25)),
                      ),
                      PositionedCarret(
                        squareSize: Size(squareSize, squareSize * 1.25),
                      ),
                      GridOverlay(squareSize: squareSize),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final Size squareSize;

  GridPainter({required this.squareSize});

  double get _squareWidth => squareSize.width;
  double get _squareHeight => squareSize.height;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 0.5;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += _squareWidth) {
      final allowedHeight =
          ((size.height / _squareHeight)).floor() * _squareHeight;

      canvas.drawLine(Offset(x, 0), Offset(x, allowedHeight), paint);
    }
    // Draw horizontal lines
    for (double y = 0; y < size.height; y += _squareHeight) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Widget for interactivity overlay (tappable cells)
class GridOverlay extends ConsumerWidget {
  final double squareSize;

  const GridOverlay({super.key, required this.squareSize});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
        onTapDown: (details) {
          // Get tapped position
          final tapPos = details.localPosition;
          final x = (tapPos.dx / squareSize).floor();
          final y = (tapPos.dy / (squareSize * 1.25)).floor();
          ref.read(carretOffsetProvider.notifier).updateCarretPosition(
                Offset(x.toDouble(), y.toDouble()),
              );

          print('Tapped on cell: ($x, $y)');
          // You can add actions here like highlighting or opening an input
        },
        child: Container(
          color: Colors.transparent,
        ));
  }
}
