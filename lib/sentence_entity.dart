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

  double get beginningOfLastWordDx {
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

  Offset endOfWordWithIndex(int index) {
    final splitWords = text.split(' ');
    double dx = startingPoisition.dx;
    for (int i = 0; i <= index; i++) {
      dx += splitWords[i].length;
    }
    return Offset(dx - 1, startingPoisition.dy);
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
