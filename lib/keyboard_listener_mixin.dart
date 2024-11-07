import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vim_game/carret_validator.dart';
import 'package:vim_game/key_event.dart';
import 'package:vim_game/providers/providers.dart';
import 'package:vim_game/word_navigation.dart';

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

  void _handleWordNavigationEvent(WordNavigationEvent event) {
    final handler = _buildNavigationHandler().setHandlerBasedOnEvent(event);
    final offset = handler.newOffset();
    _moveCursor(offset);
  }

  void onCursorEvent(CursorEvent event) {
    (switch (event) {
      SwitchVimModeEvent() => _switchVimMode(event),
      NavigationEvent() => _handleNavigationEvent(event),
      WordNavigationEvent() => _handleWordNavigationEvent(event),
      _ => () {}
    });
  }

  void _moveCursor(Offset offset) {
    ref.read(carretProvider.notifier).updateCarretPosition(offset);
  }

  WordNavigation _buildNavigationHandler() {
    final carretOffset = ref.read(carretProvider);
    final sentence = ref.read(sentenceProvider);
    return WordNavigation(
        carretOffset: carretOffset.offset, sentence: sentence);
  }
}
