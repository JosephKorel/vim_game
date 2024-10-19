import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vim_game/providers/providers.dart';

class Carret extends StatefulWidget {
  const Carret({super.key, required this.squareSize});

  final Size squareSize;

  @override
  State<Carret> createState() => _CarretState();
}

class _CarretState extends State<Carret> {
  bool _active = false;

  static const timerDuration = Duration(milliseconds: 400);
  void _tickCarret() {
    Timer.periodic(timerDuration, (_) {
      setState(() {
        _active = !_active;
      });
    });
  }

  @override
  void initState() {
    _tickCarret();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 100),
      opacity: _active ? 1 : 0,
      child: Container(
        width: widget.squareSize.width,
        height: widget.squareSize.height,
        color: Colors.indigo,
      ),
    );
  }
}

class PositionedCarret extends ConsumerWidget {
  const PositionedCarret({super.key, required this.squareSize});

  final Size squareSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offset = ref.watch(carretOffsetProvider);
    return Stack(
      children: [
        Positioned(
          left: offset.dx * squareSize.width,
          top: offset.dy * (squareSize.height),
          child: Carret(squareSize: squareSize),
        ),
      ],
    );
  }
}
