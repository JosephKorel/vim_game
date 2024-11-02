import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vim_game/carret_validator.dart';
import 'package:vim_game/key_event.dart';
import 'package:vim_game/providers/providers.dart';

mixin KeyboardEventListener<T extends ConsumerStatefulWidget>
    on ConsumerState<T> {
  CursorEventValidator get cursorValidator;

  void _switchVimMode(SwitchVimModeEvent event) {
    ref.read(modeProvider.notifier).switchMode(event.vimMode);
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
      SwitchVimModeEvent() => _switchVimMode(event),
      NavigationEvent() => _handleNavigationEvent(event),
      _ => () {}
    });
  }

  void _moveCursor(Offset offset) {
    ref.read(carretProvider.notifier).updateCarretPosition(offset);
  }
}
