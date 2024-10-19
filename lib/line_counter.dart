import 'package:flutter/material.dart';

class LineCounter extends StatelessWidget {
  const LineCounter(
      {super.key, required this.squareSize, required this.maxHeight});
  final double squareSize;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    final squareHeight = squareSize * 1.25;
    return Column(
      children: [
        for (double i = squareHeight; i < maxHeight; i += squareHeight)
          SizedBox(
            width: squareSize,
            height: squareSize * 1.25,
            child: Text('${(i / squareSize).floor()}'),
          ),
      ],
    );
  }
}
