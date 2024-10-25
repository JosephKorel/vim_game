import 'package:flutter/material.dart';
import 'package:vim_game/carret_event.dart';
import 'package:vim_game/carret_position.dart';

final class CarretValidator {
  final Size screenSize;
  final Size squareSize;
  const CarretValidator({required this.screenSize, required this.squareSize});

  int get _maxYOffset =>
      ((screenSize.height - squareSize.height) / squareSize.height).floor();

  int get _maxXOffset =>
      ((screenSize.width - squareSize.width) / squareSize.width).floor();

  bool _canGoRight(double carretDx) => carretDx < _maxXOffset;

  bool _canGoLeft(double carretDx) => carretDx > 0;

  bool _canGoUp(double carretDy) => carretDy > 0;

  bool _canGoDown(double carretDy) => carretDy <= _maxYOffset;

  void _updateHorizontalCarretPosition({
    required CarretEvent event,
    required CarretPosition carretPosition,
  }) {
    if (event.goingLeft) {
      _updateHorizontalCarretPositionWhenGoingLeft(
        event: event,
        carretPosition: carretPosition,
      );
      return;
    }
    final carretDx = carretPosition.dx + event.jumpSteps;
    final overflowed = carretDx > _maxXOffset;

    if (overflowed) {
      _goToMaximumHorizontalOffset(event: event, carretDx: carretPosition.dx);
    }
  }

  void _updateHorizontalCarretPositionWhenGoingLeft({
    required CarretEvent event,
    required CarretPosition carretPosition,
  }) {
    if (carretPosition.dx < event.jumpSteps) {
      event.updateJumpSteps(carretPosition.dx.toInt());
    }
  }

  void _updateVerticalCarretPositionWhenGoingUp({
    required CarretEvent event,
    required CarretPosition carretPosition,
  }) {
    if (carretPosition.dy < event.jumpSteps) {
      event.updateJumpSteps(carretPosition.dy.toInt());
    }
  }

  void _goToMaximumHorizontalOffset({
    required CarretEvent event,
    required double carretDx,
  }) {
    final remainingOffset = (carretDx - _maxXOffset).abs();
    event.updateJumpSteps(remainingOffset.toInt());
  }

  void _goToMaximumVerticalOffset({
    required CarretEvent event,
    required double carretDy,
  }) {
    final remainingOffset = (carretDy - _maxYOffset).abs();
    event.updateJumpSteps(remainingOffset.toInt());
  }

  void _updateVerticalCarretPosition({
    required CarretEvent event,
    required CarretPosition carretPosition,
  }) {
    if (event.goingUp) {
      _updateVerticalCarretPositionWhenGoingUp(
        event: event,
        carretPosition: carretPosition,
      );
      return;
    }

    final carretDy = carretPosition.dy + event.jumpSteps;
    final overflowed = carretDy > _maxYOffset;
    if (overflowed) {
      _goToMaximumVerticalOffset(event: event, carretDy: carretPosition.dy);
    }
  }

  void _updateCarretJumpSteps({
    required CarretEvent event,
    required CarretPosition carretPosition,
  }) {
    if (event.horizontal) {
      _updateHorizontalCarretPosition(
          event: event, carretPosition: carretPosition);
      return;
    }

    _updateVerticalCarretPosition(event: event, carretPosition: carretPosition);
  }

  bool shouldMove({
    required CarretEvent event,
    required CarretPosition carretPosition,
  }) {
    if (event.jumpSteps > 1) {
      _updateCarretJumpSteps(event: event, carretPosition: carretPosition);
      return true;
    }
    return (switch (event) {
      GoRightCarrentEvent() => _canGoRight(carretPosition.dx),
      GoLeftCarrentEvent() => _canGoLeft(carretPosition.dx),
      GoUpCarrentEvent() => _canGoUp(carretPosition.dy),
      GoDownCarrentEvent() => _canGoDown(carretPosition.dy + event.jumpSteps),
      _ => false,
    });
  }
}
