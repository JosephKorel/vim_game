import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vim_game/carret_event.dart';
import 'package:vim_game/carret_validator.dart';
import 'package:vim_game/key_event.dart';
import 'package:vim_game/keyboard_handler.dart';
import 'package:vim_game/providers/providers.dart';

class KeyboardListenerView extends ConsumerStatefulWidget {
  const KeyboardListenerView({
    super.key,
    required this.child,
    required this.screenSize,
    required this.squareSize,
  });
  final Size screenSize;
  final Widget child;
  final Size squareSize;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _KeyboardListenerViewState();
}

class _KeyboardListenerViewState extends ConsumerState<KeyboardListenerView> {
  late final _carretValidator = CarretValidator(
      screenSize: widget.screenSize, squareSize: widget.squareSize);
  late final _cursorValidator = CursorEventValidator(
    screenSize: widget.screenSize,
    squareSize: widget.squareSize,
  );
  late final StreamSubscription<CarretEvent> _keyboardEventStreamController;
  late final StreamSubscription<CursorEvent> _cursorEventStreamController;
  final _focusNode = FocusNode();
  final _keyboardEventHandler = KeyboardEventHandler();

  void _moveCarret(CarretEvent event) {
    final carretPosition = ref.read(carretProvider);
    ref.read(carretProvider.notifier).updateCarretPosition(
          event.moveTo(carretPosition.offset),
        );
  }

  void _moveCursor(Offset offset) {
    ref.read(carretProvider.notifier).updateCarretPosition(offset);
  }

  void _updatedPressedKeys() {
    ref
        .read(keyObserverProvider.notifier)
        .updateList(_keyboardEventHandler.pressedKeys);
  }

  @override
  void initState() {
    super.initState();
    _cursorEventStreamController =
        _keyboardEventHandler.cursorEventStream.stream.listen((event) {
      if (event is! NavigationEvent) {
        return;
      }
      final carretPosition = ref.read(carretProvider);
      final offsetToMove = _cursorValidator.validateAndUpdate(
        event: event,
        currentCursorPosition: carretPosition.offset,
      );

      print('I should be moving to this offset: $offsetToMove');
      _moveCursor(offsetToMove);

      print('Cursor event: $event');
    });

    _keyboardEventStreamController =
        _keyboardEventHandler.carretEventStream.stream.listen((event) {
      // final carretPosition = ref.read(carretProvider);
      // final shouldMoveCarret = _carretValidator.shouldMove(
      //   event: event,
      //   carretPosition: carretPosition,
      // );
      // if (!shouldMoveCarret) {
      //   return;
      // }
      // _moveCarret(event);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _keyboardEventStreamController.cancel();
    _cursorEventStreamController.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(keyObserverProvider);
    return KeyboardListener(
      autofocus: true,
      focusNode: _focusNode,
      onKeyEvent: (event) {
        _keyboardEventHandler.onKeyDown(event);
        _updatedPressedKeys();
      },
      child: widget.child,
    );
  }
}
