import 'dart:math';

import 'package:flutter/material.dart';

final class XTarget {
  const XTarget({
    required this.offset,
  });

  factory XTarget.startingValue() => const XTarget(offset: Offset(1, 1));

  factory XTarget.randomizeY(
    double currentTargetX, {
    required int minValue,
    required int maxValue,
  }) {
    return XTarget(
      offset: Offset(
          currentTargetX, (Random().nextInt(maxValue) + minValue).toDouble()),
    );
  }

  factory XTarget.randomizeX(
    double currentTargetY, {
    required int minValue,
    required int maxValue,
  }) {
    return XTarget(
      offset: Offset(
        (Random().nextInt(maxValue) + minValue).toDouble(),
        currentTargetY,
      ),
    );
  }

  factory XTarget.randomize({
    required int minValue,
    required int maxValue,
  }) {
    return XTarget(
      offset: Offset(
        (Random().nextInt(maxValue) + minValue).toDouble(),
        (Random().nextInt(maxValue) + minValue).toDouble(),
      ),
    );
  }
  final Offset offset;
}
