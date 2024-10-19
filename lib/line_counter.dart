import 'package:flutter/material.dart';

class LineCounter extends StatelessWidget {
  const LineCounter(
      {super.key, required this.squareSize, required this.maxHeight});
  final Size squareSize;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    final squareHeight = squareSize.height;
    final squareWidth = squareSize.width;
    return Column(
      children: [
        for (double i = squareHeight; i < maxHeight; i += squareHeight)
          SizedBox(
            width: squareWidth,
            height: squareHeight,
            child: Text('${(i / squareHeight).floor()}'),
          ),
      ],
    );
  }
}
