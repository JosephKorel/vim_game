import 'package:flutter/material.dart';
import 'package:vim_game/key_event.dart';

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

  bool _canGoDown(double cursorDy) => cursorDy < _maxYOffset;

  int _updatedHorizontalSteps({
    required NavigationEvent event,
    required Offset cursorPosition,
  }) {
    int dx = cursorPosition.dx.toInt();
    if (event is GoLeftEvent) {
      final stepsToMoveLeft = _updateHorizontalCarretPositionWhenGoingLeft(
        event: event,
        cursorPosition: cursorPosition,
      );

      dx = dx -= stepsToMoveLeft;
      return dx;
    }
    final carretDx = cursorPosition.dx + event.stepsToMove;
    final overflowed = carretDx > _maxXOffset;

    if (overflowed) {
      dx = _maxXOffset;
      return dx;
    }

    return dx += event.stepsToMove;
  }

  int _updateHorizontalCarretPositionWhenGoingLeft({
    required NavigationEvent event,
    required Offset cursorPosition,
  }) {
    int currentStepsToMove = event.stepsToMove;
    if (cursorPosition.dx < event.stepsToMove) {
      currentStepsToMove = cursorPosition.dx.toInt();
    }

    return currentStepsToMove;
  }

  int _updateVerticalCarretPositionWhenGoingUp({
    required NavigationEvent event,
    required Offset cursorPosition,
  }) {
    int currentStepsToMove = event.stepsToMove;
    if (cursorPosition.dy < event.stepsToMove) {
      currentStepsToMove = cursorPosition.dy.toInt();
    }

    return currentStepsToMove;
  }

  int _updateVerticalCarretPosition({
    required NavigationEvent event,
    required Offset cursorPosition,
  }) {
    int dy = cursorPosition.dy.toInt();
    if (event is GoUpEvent) {
      final stepsToMoveUp = _updateVerticalCarretPositionWhenGoingUp(
        event: event,
        cursorPosition: cursorPosition,
      );
      return dy -= stepsToMoveUp;
    }

    final carretDy = cursorPosition.dy + event.stepsToMove;
    final overflowed = carretDy > _maxYOffset;
    if (overflowed) {
      dy = _maxYOffset;
      return dy;
    }
    return dy += event.stepsToMove;
  }

  int _updatedStepsToMove({
    required NavigationEvent event,
    required Offset cursorPosition,
  }) {
    if (event.horizontal) {
      return _updatedHorizontalSteps(
          event: event, cursorPosition: cursorPosition);
    }

    return _updateVerticalCarretPosition(
        event: event, cursorPosition: cursorPosition);
  }

  Offset validateAndUpdate({
    required NavigationEvent event,
    required Offset currentCursorPosition,
  }) {
    double dx = currentCursorPosition.dx;
    double dy = currentCursorPosition.dy;
    if (event.stepsToMove > 1) {
      final updatedSteps = _updatedStepsToMove(
          event: event, cursorPosition: currentCursorPosition);
      final updatedEvent = event.withUpdatedSteps(updatedSteps);
      if (updatedEvent.horizontal) {
        dx = updatedEvent.stepsToMove.toDouble();
      } else {
        dy = updatedEvent.stepsToMove.toDouble();
      }

      return Offset(dx, dy);
    }

    (switch (event) {
      GoRightEvent() => dx = _canGoRight(dx) ? ++dx : dx,
      GoLeftEvent() => dx = _canGoLeft(dx) ? --dx : dx,
      GoUpEvent() => dy = _canGoUp(dy) ? --dy : dy,
      GoDownEvent() => dy = _canGoDown(dy) ? ++dy : dy,
      _ => event,
    });

    return Offset(dx, dy);
  }
}
