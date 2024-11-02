import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vim_game/carret_validator.dart';
import 'package:vim_game/key_event.dart';
import 'package:vim_game/providers/providers.dart';

mixin KeyboardEventListener<T extends ConsumerStatefulWidget>
    on ConsumerState<T> {
  CursorEventValidator get cursorValidator;

  void _switchVimMode() {
    ref.read(modeProvider.notifier).switchMode();
  }

  void _handleNavigationEvent(NavigationEvent event) {
    final cursorPosition = ref.read(carretProvider);
    final offsetToMove = cursorValidator.validateAndUpdate(
      event: event,
      currentCursorPosition: cursorPosition.offset,
    );

    _moveCursor(offsetToMove);
  }

  void onCursorEvent(CursorEvent event) {
    (switch (event) {
      SwitchVimModeEvent() => _switchVimMode(),
      NavigationEvent() => _handleNavigationEvent(event),
      _ => () {}
    });

    // if (event is SwitchVimModeEvent) {
    //   _switchVimMode();
    // }
  }

  void _moveCursor(Offset offset) {
    ref.read(carretProvider.notifier).updateCarretPosition(offset);
  }
}
