import 'package:flutter/material.dart';
import 'package:vim_game/sentence_entity.dart';

enum SentenceObjectiveType {
  hitWord,
  hitLastCharacterOfWord,
  hitFirstCharacterOfWord,
}

base class SentenceObjective {
  const SentenceObjective({
    required this.sentence,
    required this.wordIndex,
  });

  List<Offset> get targetOffsets => [];

  SentenceObjective fromObjectiveType(SentenceObjectiveType type) =>
      switch (type) {
        SentenceObjectiveType.hitWord =>
          HitWordObjective(sentence: sentence, wordIndex: wordIndex),
        SentenceObjectiveType.hitLastCharacterOfWord =>
          HitEndOfWordObjective(sentence: sentence, wordIndex: wordIndex),
        SentenceObjectiveType.hitFirstCharacterOfWord =>
          HitStartOfWordObjective(sentence: sentence, wordIndex: wordIndex),
      };

  final SentenceEntity sentence;
  final int wordIndex;
}

final class HitWordObjective extends SentenceObjective {
  const HitWordObjective({
    required super.sentence,
    required super.wordIndex,
  });

  @override
  List<Offset> get targetOffsets => sentence.wordRangeOffset(wordIndex);
}

final class HitEndOfWordObjective extends SentenceObjective {
  const HitEndOfWordObjective({
    required super.sentence,
    required super.wordIndex,
  });

  @override
  List<Offset> get targetOffsets =>
      [sentence.findOffsetOfWordEnd(wordIndex: wordIndex)];
}

final class HitStartOfWordObjective extends SentenceObjective {
  const HitStartOfWordObjective({
    required super.sentence,
    required super.wordIndex,
  });

  @override
  List<Offset> get targetOffsets =>
      [sentence.findOffsetOfWordStart(wordIndex: wordIndex)];
}
