import 'package:flutter/material.dart';
import 'package:vim_game/carret_event.dart';
import 'package:vim_game/carret_position.dart';

final class CarretValidator {
  final Size screenSize;
  final Size squareSize;
  const CarretValidator({required this.screenSize, required this.squareSize});

  int get _maxYOffset =>
      ((screenSize.height - squareSize.height) / squareSize.height).floor();

  double _carretOccupiedWidth(double carretXOffset) =>
      carretXOffset * squareSize.width;

  double _carretOccupiedHeight(double carretYOffset) =>
      carretYOffset * squareSize.height;

  bool _canGoRight(double carretDx) =>
      carretDx * squareSize.width < screenSize.width;

  bool _canGoLeft(double carretDx) => carretDx > 0;

  bool _canGoUp(double carretDy) => carretDy > 0;

  bool _canGoDown(double carretDy) => carretDy <= _maxYOffset;

  void _updateHorizontalCarretPosition({
    required CarretEvent event,
    required CarretPosition carretPosition,
  }) {
    final carretOccupiedWidth =
        _carretOccupiedWidth(carretPosition.dx * event.jumpSteps);
    final needToUpdateJumpSteps = carretOccupiedWidth > screenSize.width;
    if (needToUpdateJumpSteps) {
      final jumpStep =
          ((carretOccupiedWidth - screenSize.width) * squareSize.width).floor();
      event.updateJumpSteps(jumpStep);
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

  void _updateJumpStepsToMaximumValue({
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
      _updateJumpStepsToMaximumValue(event: event, carretDy: carretDy);
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

final class CarretEventValidator {
  final Size screenSize;
  final Size squareSize;
  final CarretEvent event;
  final CarretPosition carretPosition;

  const CarretEventValidator({
    required this.screenSize,
    required this.squareSize,
    required this.event,
    required this.carretPosition,
  });

  double get _carretOccupiedWidth => carretPosition.dx * squareSize.width;
  double get _carretOccupiedHeight => carretPosition.dy * squareSize.height;

  double get _carretXDistance => _carretOccupiedWidth * event.jumpSteps;
  double get _carretYDistance => _carretOccupiedHeight * event.jumpSteps;

  bool get _carretXDistanceOverflowsScreen =>
      _carretXDistance > screenSize.width;
  bool get _carretYDistanceOverflowsScreen =>
      _carretYDistance > screenSize.height;
}
