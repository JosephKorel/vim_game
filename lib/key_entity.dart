import 'package:flutter/services.dart';
import 'package:vim_game/key_event.dart';
import 'package:vim_game/keyboard_handler.dart';

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
        _ => 1,
      };
}

base class KeyEntity {
  const KeyEntity();

  bool isSameKey(KeyEvent event) => event.logicalKey == _key;

  LogicalKeyboardKey get _key => throw UnimplementedError();

  CursorEvent perform(KeyEntity? previousKey) => const CursorEvent();
}

base class NavigationKey extends KeyEntity {
  const NavigationKey();

  int stepsToMove(KeyEntity? previousKey) {
    if (previousKey is NumberKey) {
      return previousKey.stepsToMove;
    }
    return 1;
  }
}

final class NumberKey extends KeyEntity {
  NumberKey();

  @override
  bool isSameKey(KeyEvent event) {
    final isNumberKey = numberKeys.contains(event.physicalKey);
    if (isNumberKey) {
      stepsToMove = event.physicalKey.value;
    }
    return isNumberKey;
  }

  int stepsToMove = 1;
}

final class LeftKey extends NavigationKey {
  const LeftKey();

  @override
  LogicalKeyboardKey get _key => LogicalKeyboardKey.keyH;

  @override
  CursorEvent perform(KeyEntity? previousKey) {
    final stepsToMove = super.stepsToMove(previousKey);
    return GoLeftEvent(stepsToMove);
  }
}

final class RightKey extends NavigationKey {
  const RightKey();

  @override
  LogicalKeyboardKey get _key => LogicalKeyboardKey.keyL;

  @override
  CursorEvent perform(KeyEntity? previousKey) {
    final stepsToMove = super.stepsToMove(previousKey);
    return GoRightEvent(stepsToMove);
  }
}

final class UpKey extends NavigationKey {
  const UpKey();

  @override
  LogicalKeyboardKey get _key => LogicalKeyboardKey.keyK;

  @override
  CursorEvent perform(KeyEntity? previousKey) {
    final stepsToMove = super.stepsToMove(previousKey);
    return GoUpEvent(stepsToMove);
  }
}

final class DownKey extends NavigationKey {
  const DownKey();

  @override
  LogicalKeyboardKey get _key => LogicalKeyboardKey.keyJ;

  @override
  CursorEvent perform(KeyEntity? previousKey) {
    final stepsToMove = super.stepsToMove(previousKey);
    return GoDownEvent(stepsToMove);
  }
}

final List<KeyEntity> entityKeys = [
  NumberKey(),
  const LeftKey(),
  const RightKey(),
  const UpKey(),
  const DownKey()
];
