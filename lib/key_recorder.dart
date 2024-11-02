import 'package:flutter/services.dart';

final class KeyWatcher {
  final pressedKeys = List<String>.empty(growable: true);

  void onKeyDown(KeyEvent event) {
    if (event is KeyUpEvent) {
      return;
    }
    _savePressedKey(event);
  }

  void _savePressedKey(KeyEvent event) {
    if (pressedKeys.length > 4) {
      pressedKeys.removeLast();
    }

    pressedKeys.insert(0, event.logicalKey.keyLabel.toUpperCase());
  }
}
