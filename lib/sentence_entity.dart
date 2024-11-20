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

  List<Offset> wordRangeOffset(int wordIndex) {
    final startOffset = findOffsetOfWordStart(wordIndex: wordIndex);
    final endOffset = findOffsetOfWordEnd(wordIndex: wordIndex);
    final List<Offset> offsetList = [];
    for (int i = startOffset.dx.toInt(); i < endOffset.dx; i++) {
      offsetList.add(Offset(i.toDouble(), startOffset.dy));
    }
    return offsetList;
  }

  bool wordsInThisLine(double carretDyOffset) =>
      startingPoisition.dy == carretDyOffset;

  Offset endOfWordOffset() {
    return startingPoisition + Offset(text.length - 1, 0);
  }

  Offset get offsetOfLastWordStart =>
      findOffsetOfWordStart(wordIndex: _splitPattern.length - 1);

  Offset findOffsetOfWordStart({int wordIndex = 0}) {
    final distance = _numberOfCharactersUntilWord(wordIndex);
    final wordLength = _splitPattern[wordIndex].length;
    final dx = startingPoisition.dx + (distance - wordLength);
    return Offset(dx, startingPoisition.dy);
  }

  Offset findOffsetOfWordEnd({int wordIndex = 0}) {
    final distance = _numberOfCharactersUntilWord(wordIndex);
    final dx = startingPoisition.dx + (distance - 1);
    return Offset(dx, startingPoisition.dy);
  }

  /// Find the index of the word that the carret is above
  int? indexOfWordInOffset(
      {required Offset carretOffset, required bool goingLeft}) {
    final dx = carretOffset.dx;
    final dy = carretOffset.dy;

    if (_carretIsInEmptySpace(carretOffset)) {
      return _findIndexWhenCarretIsInEmptySpace(
        carretOffset: carretOffset,
        goingLeft: goingLeft,
      );
    }

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

  int _numberOfCharactersUntilWord(int wordIndex) =>
      _splitPattern.sublist(0, wordIndex + 1).join(' ').length;

  bool _carretIsInEmptySpace(Offset carretOffset) {
    if (startingPoisition.dx >= carretOffset.dx) {
      return false;
    }

    final dx = carretOffset.dx - startingPoisition.dx;
    final character = text[dx.toInt()];
    return character == ' ';
  }

  int _findIndexWhenCarretIsInEmptySpace({
    required Offset carretOffset,
    required bool goingLeft,
  }) {
    final adjacentIndexes = _findAdjacentWordIndexes(carretOffset.dx);
    return goingLeft ? adjacentIndexes.$1 : adjacentIndexes.$2;
  }

  (int leftWordIndex, int rightWordIndex) _findAdjacentWordIndexes(
      double carretDxOffset) {
    final startIndex = (carretDxOffset - startingPoisition.dx).toInt();
    var foundLeftWord = false;
    var foundRightWord = false;
    var leftWord = '';
    var rightWord = '';
    var indexToLeft = startIndex - 1;
    var indexToRight = startIndex + 1;

    while (!foundLeftWord) {
      final character = _getCharacterOrEmptySpace(indexToLeft);
      if (character == ' ') {
        foundLeftWord = true;
        break;
      }
      leftWord = character + leftWord;
      indexToLeft--;
    }

    while (!foundRightWord) {
      final character = _getCharacterOrEmptySpace(indexToRight);
      if (character == ' ') {
        foundRightWord = true;
        break;
      }

      rightWord = rightWord + character;
      indexToRight++;
    }

    final leftWordIndex = _splitPattern.indexOf(leftWord.trim());
    final rightWordIndex = _splitPattern.indexOf(rightWord.trim());

    return (leftWordIndex, rightWordIndex);
  }

  String _getCharacterOrEmptySpace(int iteratingIndex) {
    if (iteratingIndex < 0 || iteratingIndex > text.length) {
      return ' ';
    }

    return text[iteratingIndex];
  }
}
