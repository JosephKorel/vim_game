import 'dart:async';

import 'package:flutter/services.dart';
import 'package:vim_game/carret_event.dart';

final _numberKeys = {
  PhysicalKeyboardKey.digit1,
  PhysicalKeyboardKey.digit2,
  PhysicalKeyboardKey.digit3,
  PhysicalKeyboardKey.digit4,
  PhysicalKeyboardKey.digit5,
  PhysicalKeyboardKey.digit6,
  PhysicalKeyboardKey.digit7,
  PhysicalKeyboardKey.digit8,
  PhysicalKeyboardKey.digit9,
};

final _validKeys = {
  LogicalKeyboardKey.keyH,
  LogicalKeyboardKey.keyL,
  LogicalKeyboardKey.keyJ,
  LogicalKeyboardKey.keyK
};

extension on KeyEvent {
  bool get isNumberKey => _numberKeys.contains(physicalKey);

  bool get isValidKey => _validKeys.contains(logicalKey);
}

extension on PhysicalKeyboardKey {
  int get value => switch (this) {
        PhysicalKeyboardKey.digit1 => 1,
        PhysicalKeyboardKey.digit2 => 2,
        PhysicalKeyboardKey.digit3 => 3,
        PhysicalKeyboardKey.digit4 => 4,
        PhysicalKeyboardKey.digit5 => 5,
        PhysicalKeyboardKey.digit6 => 6,
        PhysicalKeyboardKey.digit7 => 7,
        PhysicalKeyboardKey.digit8 => 8,
        PhysicalKeyboardKey.digit9 => 9,
        _ => throw UnimplementedError(),
      };
}

final class KeyboardEventHandler {
  final carretEventStream = StreamController<CarretEvent>();

  int _jumpSteps = 1;

  void onKeyDown(KeyEvent event) {
    if (event.isNumberKey) {
      _handleNumberKeys(event);
      return;
    }

    if (!_shouldReadKey(event)) {
      return;
    }

    (switch (event.logicalKey) {
      LogicalKeyboardKey.keyH =>
        carretEventStream.add(GoLeftCarrentEvent(jumpSteps: _jumpSteps)),
      LogicalKeyboardKey.keyL =>
        carretEventStream.add(GoRightCarrentEvent(jumpSteps: _jumpSteps)),
      LogicalKeyboardKey.keyJ =>
        carretEventStream.add(GoDownCarrentEvent(jumpSteps: _jumpSteps)),
      LogicalKeyboardKey.keyK =>
        carretEventStream.add(GoUpCarrentEvent(jumpSteps: _jumpSteps)),
      _ => () {}
    });

    _jumpSteps = 1;
  }

  void _handleNumberKeys(KeyEvent event) {
    _jumpSteps = event.physicalKey.value;
  }

  bool _shouldReadKey(KeyEvent event) =>
      event is KeyDownEvent && event.isValidKey;
}
