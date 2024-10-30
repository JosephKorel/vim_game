import 'dart:math';

import 'package:flutter/material.dart';

final class GameTarget {
  const GameTarget({
    required this.offset,
  });

  factory GameTarget.startingValue() => const GameTarget(offset: Offset(1, 1));

  factory GameTarget.randomizeY(
    double currentTargetX, {
    required int minValue,
    required int maxValue,
  }) {
    return GameTarget(
      offset: Offset(
          currentTargetX, (Random().nextInt(maxValue) + minValue).toDouble()),
    );
  }

  factory GameTarget.randomizeX(
    double currentTargetY, {
    required int minValue,
    required int maxValue,
  }) {
    return GameTarget(
      offset: Offset(
        (Random().nextInt(maxValue) + minValue).toDouble(),
        currentTargetY,
      ),
    );
  }

  factory GameTarget.randomize({
    required int minValue,
    required int maxValue,
  }) {
    return GameTarget(
      offset: Offset(
        (Random().nextInt(maxValue) + minValue).toDouble(),
        (Random().nextInt(maxValue) + minValue).toDouble(),
      ),
    );
  }
  final Offset offset;
}
