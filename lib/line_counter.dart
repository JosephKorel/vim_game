import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vim_game/providers/providers.dart';
import 'package:vim_game/theme/utils.dart';

class LineCounter extends ConsumerWidget {
  const LineCounter({
    super.key,
    required this.squareSize,
    required this.maxHeight,
  });

  final Size squareSize;
  final double maxHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final carretPosition = ref.watch(carretProvider);
    final squareHeight = squareSize.height;
    final numberOfRows = (maxHeight / squareHeight).floor();
    return SizedBox(
      height: maxHeight,
      width: squareSize.width,
      child: ListView.builder(
        itemCount: numberOfRows,
        itemBuilder: (context, index) => SizedBox.fromSize(
          size: squareSize,
          child: _RowTile(
            index: index,
            carretY: carretPosition.dy.floor(),
          ),
        ),
      ),
    );
  }
}

class _RowTile extends StatelessWidget {
  const _RowTile({super.key, required this.index, required this.carretY});

  final int index;
  final int carretY;

  @override
  Widget build(BuildContext context) {
    final carretYAndIndexDifference = (carretY - index).abs();
    final text = carretYAndIndexDifference < 10
        ? '$carretYAndIndexDifference'
        : '$index';
    final activeRowTextStyle = context.bodyMedium.copyWith(
      color: context.primary,
      fontWeight: FontWeight.w600,
    );
    final inactiveRowTextStyle =
        context.bodyMedium.copyWith(color: context.onSurface.withOpacity(0.7));

    return Center(
      child: Text(
        text,
        style: carretYAndIndexDifference < 10
            ? activeRowTextStyle
            : inactiveRowTextStyle,
      ),
    );
  }
}
