import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vim_game/carret_validator.dart';
import 'package:vim_game/key_event.dart';
import 'package:vim_game/key_recorder.dart';
import 'package:vim_game/keyboard_handler.dart';
import 'package:vim_game/keyboard_listener_mixin.dart';
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

class _KeyboardListenerViewState extends ConsumerState<KeyboardListenerView>
    with KeyboardEventListener {
  late final _cursorValidator = CursorEventValidator(
    screenSize: widget.screenSize,
    squareSize: widget.squareSize,
  );

  late final StreamSubscription<CursorEvent> _cursorEventStreamController;
  final _focusNode = FocusNode();
  final _keyboardEventHandler = KeyboardEventHandler();
  final _keyWatcher = KeyWatcher();

  void _updatedPressedKeys(List<String> pressedKeys) {
    ref.read(keyObserverProvider.notifier).updateList(pressedKeys);
  }

  void _watchKey(KeyEvent event) {
    final pressedKeys = (_keyWatcher..onKeyDown(event)).pressedKeys;
    _updatedPressedKeys(pressedKeys);
  }

  @override
  CursorEventValidator get cursorValidator => _cursorValidator;

  @override
  void initState() {
    super.initState();
    _cursorEventStreamController =
        _keyboardEventHandler.cursorEventStream.stream.listen((event) {
      onCursorEvent(event);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
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
        _watchKey(event);
        _keyboardEventHandler.onKeyDown(event);
      },
      child: widget.child,
    );
  }
}
