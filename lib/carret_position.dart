import 'package:flutter/material.dart';

final class CarretPosition {
  final double dx;
  final double dy;
  const CarretPosition(this.dx, this.dy);

  Offset get offset => Offset(dx, dy);

  double get yOffset => dy + 1.toDouble();

  double get xOffset => dx + 1.toDouble();

  bool get isAtTheStartOfRow => dx == 0;

  bool get isAtTheStartOfColumn => dy == 0;

  CarretPosition moveTo(Offset offset) {
    return CarretPosition(offset.dx, offset.dy);
  }
}
