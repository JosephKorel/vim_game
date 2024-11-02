import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vim_game/providers/providers.dart';
import 'package:vim_game/theme/utils.dart';

class ScoreWidget extends ConsumerWidget {
  const ScoreWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final score = ref.watch(scoreProvider);
    return Row(
      children: [
        Text(
          'Score: ',
          style: context.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
        Text(
          '$score',
          style: context.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: context.primary,
          ),
        ),
      ],
    );
  }
}
