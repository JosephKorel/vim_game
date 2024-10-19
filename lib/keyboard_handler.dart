import 'dart:async';

import 'package:flutter/services.dart';
import 'package:vim_game/carret_event.dart';

final class KeyboardEventHandler {
  final carretEventStream = StreamController<CarretEvent>();

  final _validKeys = {LogicalKeyboardKey.keyH, LogicalKeyboardKey.keyL};

  void onKeyDown(KeyEvent event) {
    if (event is KeyUpEvent) {
      return;
    }

    if (!_shouldHandleKey(event)) {
      return;
    }
    print(
        'Should i handle the key: ${event.logicalKey}? ${_shouldHandleKey(event)}');
    switch (event.logicalKey) {
      case LogicalKeyboardKey.keyH:
        carretEventStream.add(const GoLeftCarrentEvent());
        break;
      case LogicalKeyboardKey.keyL:
        carretEventStream.add(const GoRightCarrentEvent());
        break;
      default:
        return;
    }
  }

  bool _shouldHandleKey(KeyEvent event) {
    return _validKeys.contains(event.logicalKey);
  }
}
