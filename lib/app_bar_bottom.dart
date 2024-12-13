import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vim_game/objective_score_mixin.dart';
import 'package:vim_game/providers/providers.dart';
import 'package:vim_game/theme/utils.dart';

class ScoreAndInstructions extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  const ScoreAndInstructions({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScoreAndInstructionsState();
}

class _ScoreAndInstructionsState extends ConsumerState<ScoreAndInstructions>
    with ObjectiveScoreProvider {
  @override
  void initState() {
    super.initState();
    initializeGameObjective();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(carretProvider, onCarretPositionChange);
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _Instructions(),
          _Score(),
        ],
      ),
    );
  }
}

class _Instructions extends StatelessWidget {
  const _Instructions();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Goal:',
          style: context.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: context.primary,
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: context.primary,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Go to the X',
              style: context.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
                color: context.onPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Score extends ConsumerWidget {
  const _Score();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreCount = ref.watch(scoreProvider);
    return Row(
      children: [
        Text(
          'Score: ',
          style: context.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: context.primary,
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: context.primary,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '$scoreCount',
              style: context.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: context.onPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
