import 'package:flutter/material.dart';
import 'package:vim_game/carret_event.dart';
import 'package:vim_game/carret_position.dart';
import 'package:vim_game/key_event.dart';

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

final class CursorEventValidator {
  final Size screenSize;
  final Size squareSize;
  const CursorEventValidator({
    required this.screenSize,
    required this.squareSize,
  });

  int get _maxYOffset =>
      ((screenSize.height - squareSize.height) / squareSize.height).floor();

  int get _maxXOffset =>
      ((screenSize.width - squareSize.width) / squareSize.width).floor();

  bool _canGoRight(double cursorDx) => cursorDx < _maxXOffset;

  bool _canGoLeft(double cursorDx) => cursorDx > 0;

  bool _canGoUp(double cursorDy) => cursorDy > 0;

  bool _canGoDown(double cursorDy) => cursorDy <= _maxYOffset;

  int _updatedHorizontalSteps({
    required NavigationEvent event,
    required Offset carretPosition,
  }) {
    int currentStepsToMove = event.stepsToMove;
    if (event is GoLeftEvent) {
      currentStepsToMove = _updateHorizontalCarretPositionWhenGoingLeft(
        event: event,
        carretPosition: carretPosition,
      );
      return currentStepsToMove;
    }
    final carretDx = carretPosition.dx + event.stepsToMove;
    final overflowed = carretDx > _maxXOffset;

    if (overflowed) {
      currentStepsToMove = _goToMaximumHorizontalOffset(
          event: event, carretDx: carretPosition.dx);
    }

    return currentStepsToMove;
  }

  int _updateHorizontalCarretPositionWhenGoingLeft({
    required NavigationEvent event,
    required Offset carretPosition,
  }) {
    if (carretPosition.dx < event.stepsToMove) {
      return carretPosition.dx.toInt();
    }

    return event.stepsToMove;
  }

  int _updateVerticalCarretPositionWhenGoingUp({
    required NavigationEvent event,
    required Offset carretPosition,
  }) {
    int currentStepsToMove = event.stepsToMove;
    if (carretPosition.dy < event.stepsToMove) {
      currentStepsToMove = carretPosition.dy.toInt();
    }

    return currentStepsToMove;
  }

  int _goToMaximumHorizontalOffset({
    required NavigationEvent event,
    required double carretDx,
  }) {
    final remainingOffset = (carretDx - _maxXOffset).abs();
    return remainingOffset.toInt();
  }

  int _goToMaximumVerticalOffset({
    required NavigationEvent event,
    required double carretDy,
  }) {
    final remainingOffset = (carretDy - _maxYOffset).abs();
    return remainingOffset.toInt();
  }

  int _updateVerticalCarretPosition({
    required NavigationEvent event,
    required Offset carretPosition,
  }) {
    int currentStepsToMove = event.stepsToMove;
    if (event is GoUpEvent) {
      currentStepsToMove = _updateVerticalCarretPositionWhenGoingUp(
        event: event,
        carretPosition: carretPosition,
      );
      return currentStepsToMove;
    }

    final carretDy = carretPosition.dy + event.stepsToMove;
    final overflowed = carretDy > _maxYOffset;
    if (overflowed) {
      currentStepsToMove =
          _goToMaximumVerticalOffset(event: event, carretDy: carretPosition.dy);
    }
    return currentStepsToMove;
  }

  int _updatedStepsToMove({
    required NavigationEvent event,
    required Offset carretPosition,
  }) {
    if (event.horizontal) {
      return _updatedHorizontalSteps(
          event: event, carretPosition: carretPosition);
    }

    return _updateVerticalCarretPosition(
        event: event, carretPosition: carretPosition);
  }

  Offset validateAndUpdate({
    required NavigationEvent event,
    required Offset currentCursorPosition,
  }) {
    double dx = currentCursorPosition.dx;
    double dy = currentCursorPosition.dy;
    if (event.stepsToMove > 1) {
      final updatedSteps = _updatedStepsToMove(
          event: event, carretPosition: currentCursorPosition);
      final updatedEvent = event.withUpdatedSteps(updatedSteps);
      if (updatedEvent.horizontal) {
        dx = updatedEvent.stepsToMove.toDouble();
      } else {
        dy = updatedEvent.stepsToMove.toDouble();
      }

      return Offset(dx, dy);
    }
    print('Is my event go right event? ${event is GoRightEvent}');
    (switch (event) {
      GoRightEvent() => dx = _canGoRight(dx) ? ++dx : 0,
      GoLeftEvent() => dx = _canGoLeft(currentCursorPosition.dx) ? ++dx : 0,
      GoUpEvent() => dy = _canGoUp(currentCursorPosition.dy) ? ++dy : 0,
      GoDownEvent() => dy =
          _canGoDown(currentCursorPosition.dy + event.stepsToMove) ? ++dy : 0,
      _ => event,
    });

    print('Updated dx: $dx, dy: $dy');

    return Offset(dx, dy);
  }
}
