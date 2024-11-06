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

  double get dxOfLastWord {
    final splitWords = text.split(' ');
    final lastWordLength = splitWords.last.length;
    return startingPoisition.dx + (text.length - lastWordLength);
  }

  bool wordsInThisLine(double carretDyOffset) =>
      startingPoisition.dy == carretDyOffset;

  Offset endOfWordOffset() {
    return startingPoisition + Offset(text.length - 1, 0);
  }

  Offset beginningOfWordOffset({int indexOfWordToNavigate = 0}) {
    final splitWords = text.split(' ');
    final charactersUntilWord =
        splitWords.sublist(0, indexOfWordToNavigate).join(' ').length;
    return startingPoisition + Offset(charactersUntilWord.toDouble(), 0);
  }

  int? indexOfWordInOffset({required double carretDxOffset}) {
    final splitWords = text.split(' ');
    int? indexOfWord;
    int dx = startingPoisition.dx.toInt();
    for (int i = 0; i < splitWords.length; i++) {
      final word = splitWords[i];
      dx += word.length;
      if (carretDxOffset.toInt() <= dx) {
        indexOfWord = i;
        break;
      }
    }
    return indexOfWord;
  }
}
