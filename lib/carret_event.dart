import 'package:flutter/material.dart';

sealed class CarretEvent {
  const CarretEvent();

  Offset moveTo(Offset currentCarretPosition);
}

final class GoRightCarrentEvent extends CarretEvent {
  const GoRightCarrentEvent();

  double _moveOneBlockRight(double dx) => dx + 1;

  @override
  Offset moveTo(Offset currentCarretPosition) {
    return Offset(
      _moveOneBlockRight(currentCarretPosition.dx),
      currentCarretPosition.dy,
    );
  }
}

final class GoLeftCarrentEvent extends CarretEvent {
  const GoLeftCarrentEvent();

  double _moveOneBlockLeft(double dx) => dx - 1;

  @override
  Offset moveTo(Offset currentCarretPosition) {
    return Offset(
      _moveOneBlockLeft(currentCarretPosition.dx),
      currentCarretPosition.dy,
    );
  }
}
