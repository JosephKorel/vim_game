import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vim_game/providers/providers.dart';
import 'package:vim_game/target.dart';
import 'package:vim_game/theme/utils.dart';

class Target extends ConsumerStatefulWidget {
  const Target({super.key, required this.squareSize, required this.gridSize});

  final Size squareSize;
  final Size gridSize;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TargetState();
}

class _TargetState extends ConsumerState<Target> {
  GameTarget _target = GameTarget.startingValue();

  bool _carretOffsetMatchesTarget(Offset carretOffset) =>
      carretOffset == _target.offset;

  void _updateTargetPosition() {
    setState(() {
      _target =
          GameTarget.randomizeY(_target.offset.dx, minValue: 1, maxValue: 10);
    });
  }

  void _onCarretPositionChange(Offset carretOffset) {
    if (_carretOffsetMatchesTarget(carretOffset)) {
      _updateTargetPosition();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(carretProvider, (previous, next) {
      _onCarretPositionChange(next.offset);
    });

    final left = _target.offset.dx * widget.squareSize.width;
    final top = _target.offset.dy * widget.squareSize.height;

    return Positioned(
      left: left,
      top: top,
      child: SizedBox.fromSize(
        size: widget.squareSize,
        child: Center(
          child: Text(
            'X',
            style: context.bodyLarge
                .copyWith(color: context.primary, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
