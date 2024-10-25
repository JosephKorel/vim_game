import 'package:flutter/material.dart';

base class CarretEvent {
  CarretEvent({this.jumpSteps = 1});

  int jumpSteps;

  bool get horizontal => true;
  bool get goingUp => false;
  bool get goingLeft => false;

  void updateJumpSteps(int jumpSteps) => this.jumpSteps = jumpSteps;

  Offset moveTo(Offset currentCarretPosition) => throw UnimplementedError();
}

final class GoRightCarrentEvent extends CarretEvent {
  GoRightCarrentEvent({super.jumpSteps});

  double _moveOneBlockRight(double dx) => dx + jumpSteps;

  @override
  Offset moveTo(Offset currentCarretPosition) {
    return Offset(
      _moveOneBlockRight(currentCarretPosition.dx),
      currentCarretPosition.dy,
    );
  }
}

final class GoLeftCarrentEvent extends CarretEvent {
  GoLeftCarrentEvent({super.jumpSteps});

  double _moveOneBlockLeft(double dx) => dx - jumpSteps;

  @override
  bool get goingLeft => true;

  @override
  Offset moveTo(Offset currentCarretPosition) {
    return Offset(
      _moveOneBlockLeft(currentCarretPosition.dx),
      currentCarretPosition.dy,
    );
  }
}

final class GoUpCarrentEvent extends CarretEvent {
  GoUpCarrentEvent({super.jumpSteps});

  double _moveOneBlockUp(double dy) => dy - jumpSteps;

  @override
  bool get horizontal => false;

  @override
  bool get goingUp => true;

  @override
  Offset moveTo(Offset currentCarretPosition) {
    return Offset(
      currentCarretPosition.dx,
      _moveOneBlockUp(currentCarretPosition.dy),
    );
  }
}

final class GoDownCarrentEvent extends CarretEvent {
  GoDownCarrentEvent({super.jumpSteps});

  double _moveOneBlockDown(double dy) => dy + jumpSteps;

  @override
  bool get horizontal => false;

  @override
  Offset moveTo(Offset currentCarretPosition) {
    return Offset(
      currentCarretPosition.dx,
      _moveOneBlockDown(currentCarretPosition.dy),
    );
  }
}
