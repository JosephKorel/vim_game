import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vim_game/carret.dart';
import 'package:vim_game/color_select.dart';
import 'package:vim_game/keyboard_listener.dart';
import 'package:vim_game/line_counter.dart';
import 'package:vim_game/pressed_keys.dart';
import 'package:vim_game/providers/providers.dart';
import 'package:vim_game/target_widget.dart';
import 'package:vim_game/theme/utils.dart';
import 'package:vim_game/theme_switch.dart';

class EditorGrid extends StatelessWidget {
  const EditorGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yet Another Vim Game'),
        actions: const [
          ColorSelect(),
          SizedBox(
            width: 8,
          ),
          ThemeSwitch(),
          SizedBox(
            width: 16,
          ),
        ],
        titleTextStyle: context.titleLarge.copyWith(
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.underline,
          decorationColor: context.primary,
          decorationThickness: 2,
        ),
        foregroundColor: context.onSurface,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(builder: (context, constraints) {
                final screenWidth = constraints.maxWidth;
                final screenHeight = constraints.maxHeight;
                final squareWidth = screenWidth / 80;
                final squareHeight = squareWidth * 1.25;
                final squareSize = Size(squareWidth, squareHeight);
                return Row(
                  children: [
                    LineCounter(
                        squareSize: squareSize, maxHeight: screenHeight),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: LayoutBuilder(builder: (context, constraints) {
                        return KeyboardListenerView(
                          screenSize:
                              Size(constraints.maxWidth, constraints.maxHeight),
                          squareSize: squareSize,
                          child: Stack(
                            children: [
                              CustomPaint(
                                size: Size(constraints.maxWidth,
                                    constraints.maxHeight),
                                painter: GridPainter(
                                  squareSize: squareSize,
                                ),
                              ),
                              PositionedCarret(
                                squareSize: squareSize,
                              ),
                              GridOverlay(squareSize: squareWidth),
                              Target(
                                squareSize: squareSize,
                                gridSize: Size(
                                  constraints.maxWidth,
                                  constraints.maxHeight,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                );
              }),
            ),
            const PressedKeys(),
          ],
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
      final height = ((size.height / _squareHeight)).floor() * _squareHeight;

      canvas.drawLine(Offset(x, 0), Offset(x, height), paint);
    }
    // Draw horizontal lines
    for (double y = 0; y < size.height; y += _squareHeight) {
      final width = (size.width / _squareWidth).floor() * _squareWidth;
      canvas.drawLine(Offset(0, y), Offset(width, y), paint);
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
