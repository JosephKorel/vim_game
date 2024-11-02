import 'dart:async';

import 'package:flutter/services.dart';
import 'package:vim_game/key_entity.dart';
import 'package:vim_game/key_event.dart';

final class KeyboardEventHandler {
  final cursorEventStream = StreamController<CursorEvent>();

  KeyEntity? _lastPressedKey;

  List<String> pressedKeys = [];

  void onKeyDown(KeyEvent event) {
    if (event is KeyUpEvent) {
      return;
    }

    final pressedKey =
        entityKeys.where((element) => element.isSameKey(event)).firstOrNull;

    cursorEventStream
        .add(pressedKey?.perform(_lastPressedKey) ?? const CursorEvent());

    _lastPressedKey = pressedKey;
  }
}
