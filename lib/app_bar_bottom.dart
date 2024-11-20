import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vim_game/carret_position.dart';
import 'package:vim_game/providers/providers.dart';
import 'package:vim_game/score.dart';

class ScoreAndInstructions extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  const ScoreAndInstructions({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScoreAndInstructionsState();
}

class _ScoreAndInstructionsState extends ConsumerState<ScoreAndInstructions> {
  late Objective _objective;
  late GameObjective _gameObjective;

  Offset get carretPosition => ref.read(carretProvider).offset;

  Offset get targetPosition => ref.read(targetProvider).offset;

  ObjectiveType get gameObjective => ref.read(currentObjectiveProvider);

  Objective get objectiveByType => switch (gameObjective) {
        ObjectiveType.hitX => HitXObjective(
            targetPosition: targetPosition, carretPosition: carretPosition),
        ObjectiveType.hitWord => throw UnimplementedError(),
      };

  void _carretListener(
      CarretPosition? oldPosition, CarretPosition newPosition) {
    _objective = objectiveByType;
    _gameObjective.onCarretPositionChange(newPosition.offset, _objective);

    if (_objective.didHitObjective()) {
      _incrementScore();
      _updateObjective();
    }
  }

  void _incrementScore() => ref.read(scoreProvider.notifier).incrementScore();

  void _updateObjective() => switch (_objective) {
        HitXObjective() => ref.read(targetProvider.notifier).randomizeTargetY(),
        _ => throw UnimplementedError(),
      };

  @override
  void initState() {
    super.initState();
    _objective = HitXObjective(
        targetPosition: targetPosition, carretPosition: carretPosition);
    _gameObjective =
        GameObjective(objective: _objective, carretPosition: carretPosition);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(carretProvider, _carretListener);
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
