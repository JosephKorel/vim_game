import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vim_game/objective_score_mixin.dart';
import 'package:vim_game/providers/providers.dart';

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
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _Instructions(),
        _Score(),
      ],
    );
  }
}

class _Instructions extends StatelessWidget {
  const _Instructions({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('Go to the X');
  }
}

class _Score extends ConsumerWidget {
  const _Score({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreCount = ref.watch(scoreProvider);
    return Text('Score: $scoreCount');
  }
}
