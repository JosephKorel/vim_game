import 'package:flutter/material.dart';

final class SentenceEntity {
  const SentenceEntity({
    required this.text,
    required this.startingPoisition,
  });

  static const _startingOffset = Offset(2.0, 2.0);

  const SentenceEntity.initialValue()
      : text = 'Text',
        startingPoisition = _startingOffset;

  final String text;
  final Offset startingPoisition;

  Offset endOfWordOffset() {
    return startingPoisition + Offset(text.length - 1, 0);
  }
}
