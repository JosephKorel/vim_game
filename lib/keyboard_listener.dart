import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vim_game/carret_event.dart';
import 'package:vim_game/carret_validator.dart';
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
  late final StreamSubscription<CarretEvent> _keyboardEventStreamController;
  final _focusNode = FocusNode();
  final _keyboardEventHandler = KeyboardEventHandler();
  @override
  void initState() {
    super.initState();
    _keyboardEventStreamController =
        _keyboardEventHandler.carretEventStream.stream.listen((event) {
      final carretPosition = ref.read(carretProvider);
      switch (event) {
        case const GoRightCarrentEvent():
          final canGoRight = _carretValidator.canGoRight(carretPosition.dx);
          if (canGoRight) {
            ref.read(carretProvider.notifier).updateCarretPosition(
                  event.moveTo(carretPosition.offset),
                );
          }
          break;
        case const GoLeftCarrentEvent():
          final canGoLeft = _carretValidator.canGoLeft(carretPosition.dx);
          if (canGoLeft) {
            ref.read(carretProvider.notifier).updateCarretPosition(
                  event.moveTo(carretPosition.offset),
                );
          }
          break;
        default:
          return;
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _keyboardEventStreamController.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      autofocus: true,
      focusNode: _focusNode,
      onKeyEvent: _keyboardEventHandler.onKeyDown,
      child: widget.child,
    );
  }
}
