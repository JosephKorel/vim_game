import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vim_game/carret_position.dart';
import 'package:vim_game/providers/providers.dart';
import 'package:vim_game/score.dart';

mixin ObjectiveScoreProvider<T extends ConsumerStatefulWidget>
    on ConsumerState<T> {
  late GameObjective _gameObjective;

  Offset get carretPosition => ref.read(carretProvider).offset;

  Offset get targetPosition => ref.read(targetProvider).offset;

  GameStage get gameStage => ref.read(currentObjectiveProvider);

  Objective get objectiveByGameStage => switch (gameStage) {
        GameStage.hitX => HitXObjective(
            targetPosition: targetPosition, carretPosition: carretPosition),
        GameStage.hitWord => throw UnimplementedError(),
      };

  void onCarretPositionChange(_, CarretPosition newPosition) {
    _gameObjective.onCarretPositionChange(objectiveByGameStage);

    if (_gameObjective.objective.didHitObjective()) {
      _incrementScore();
      _updateObjective();
    }
  }

  void initializeGameObjective() {
    final objective = HitXObjective(
        targetPosition: targetPosition, carretPosition: carretPosition);
    _gameObjective = GameObjective(objective: objective);
  }

  void _incrementScore() => ref.read(scoreProvider.notifier).incrementScore();

  void _updateObjective() => switch (_gameObjective.objective) {
        HitXObjective() => ref.read(targetProvider.notifier).randomizeTargetY(),
        _ => throw UnimplementedError(),
      };
}
