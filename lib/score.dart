import 'package:flutter/material.dart';
import 'package:vim_game/sentence_objective.dart';

enum ObjectiveType {
  hitX,
  hitWord,
}

interface class Objective {
  bool didHitObjective() => false;
}

base class GameObjective {
  GameObjective({required this.carretPosition, required this.objective});

  Objective objective;
  Offset carretPosition;

  void onCarretPositionChange(Offset carretPosition, Objective objective) {
    this.carretPosition = carretPosition;
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
