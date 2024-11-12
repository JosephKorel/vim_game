import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

extension OffsetUtils on Offset {
  bool isInRange(Offset beginning, Offset end) {
    final dxIsInRange = dx >= beginning.dx && dx <= end.dx;
    final dyIsInRange = dy >= beginning.dy && dy <= end.dy;
    return dxIsInRange && dyIsInRange;
  }

  bool dxIsInRange(Offset beginning, Offset end) =>
      dx >= beginning.dx && dx <= end.dx;
}

final class SentenceEntity {
  const SentenceEntity({
    required this.text,
    required this.startingPoisition,
  });

  static const _startingOffset = Offset(2.0, 2.0);

  const SentenceEntity.initialValue()
      : text = 'A cool text with more than one word',
        startingPoisition = _startingOffset;

  final String text;
  final Offset startingPoisition;

  double get beginningOfLastWordDx {
    final splitWords = text.split(' ');
    final lastWordLength = splitWords.last.length;
    return startingPoisition.dx + (text.length - lastWordLength);
  }

  List<String> get _splitPattern => text.split(' ');

  bool wordsInThisLine(double carretDyOffset) =>
      startingPoisition.dy == carretDyOffset;

  Offset endOfWordOffset() {
    return startingPoisition + Offset(text.length - 1, 0);
  }

  Offset findOffsetOfWordStart({int wordIndex = 0}) {
    final charactersUntilWord =
        _splitPattern.sublist(0, wordIndex).join(' ').length;
    return startingPoisition + Offset(charactersUntilWord.toDouble(), 0);
  }

  Offset findOffsetOfWordEnd({int wordIndex = 0}) {
    if (wordIndex == 0) {
      return startingPoisition;
    }

    final distance = _splitPattern.sublist(0, wordIndex + 1).join(' ').length;
    final dxDistance = startingPoisition.dx + distance;

    return Offset(dxDistance, startingPoisition.dy);
  }

  /// Find the index of the word that the carret is above
  int? indexOfWordInOffset({required Offset carretOffset}) {
    final dx = carretOffset.dx;
    final dy = carretOffset.dy;

    if (dy != startingPoisition.dy) {
      return null;
    }

    for (int i = 0; i < _splitPattern.length; i++) {
      final startOffset = findOffsetOfWordStart(wordIndex: i);
      final endOffset = findOffsetOfWordEnd(wordIndex: i);
      final dxIsInRange = dx >= startOffset.dx && dx <= endOffset.dx;

      if (dxIsInRange) {
        return i;
      }
    }
    return null;
  }
}
