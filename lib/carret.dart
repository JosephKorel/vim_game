import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vim_game/mode.dart';
import 'package:vim_game/providers/providers.dart';

class Carret extends StatefulWidget {
  const Carret({super.key, required this.squareSize, required this.vimMode});

  final VimMode vimMode;
  final Size squareSize;

  @override
  State<Carret> createState() => _CarretState();
}

class _CarretState extends State<Carret> {
  late final Timer _timer;
  bool _active = false;

  static const timerDuration = Duration(milliseconds: 300);
  void _tickCarret() {
    _timer = Timer.periodic(timerDuration, (_) {
      setState(() {
        _active = !_active;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _tickCarret();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = widget.vimMode == VimMode.insert
        ? 2.toDouble()
        : widget.squareSize.width;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 100),
      opacity: _active ? 1 : 0,
      child: Container(
        width: width,
        height: widget.squareSize.height,
        color: Colors.indigo,
      ),
    );
  }
}

class CursorDisplay extends ConsumerWidget {
  const CursorDisplay({super.key, required this.squareSize});

  final Size squareSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offset = ref.watch(carretProvider);
    final vimMode = ref.watch(modeProvider);
    return Positioned(
      left: offset.dx * squareSize.width,
      top: offset.dy * (squareSize.height),
      child: Carret(
        squareSize: squareSize,
        vimMode: vimMode,
      ),
    );
  }
}
