import 'package:flutter/material.dart';
import 'package:vim_game/sentence_objective.dart';

/// Phases of the game
enum GameStage {
  hitX,
  hitWord,
}

interface class Objective {
  bool didHitObjective() => false;
}

class GameObjective {
  GameObjective({required this.objective});

  Objective objective;

  void onCarretPositionChange(Objective objective) {
    this.objective = objective;
  }
}

final class HitXObjective implements Objective {
  const HitXObjective({
    required this.targetPosition,
    required this.carretPosition,
  });

  final Offset targetPosition;
  final Offset carretPosition;
  @override
  bool didHitObjective() => carretPosition == targetPosition;
}

final class HitWordObjective implements Objective {
  const HitWordObjective({
    required this.sentenceObjective,
    required this.carretPosition,
  });

  final SentenceObjective sentenceObjective;
  final Offset carretPosition;

  @override
  bool didHitObjective() =>
      sentenceObjective.targetOffsets.contains(carretPosition);
}
