import 'package:flutter/material.dart';

final class CarretValidator {
  final Size screenSize;
  final Size squareSize;
  const CarretValidator({required this.screenSize, required this.squareSize});

  bool canGoRight(double carretDx) =>
      carretDx * squareSize.width < screenSize.width;

  bool canGoLeft(double carretDx) => carretDx > 0;
}
