import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vim_game/providers/providers.dart';
import 'package:vim_game/theme/utils.dart';

class XTargetWidget extends ConsumerWidget {
  const XTargetWidget({
    super.key,
    required this.squareSize,
    required this.gridSize,
  });

  final Size squareSize;
  final Size gridSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final target = ref.watch(targetProvider);

    final left = target.offset.dx * squareSize.width;
    final top = target.offset.dy * squareSize.height;

    return Positioned(
      left: left,
      top: top,
      child: SizedBox.fromSize(
        size: squareSize,
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
