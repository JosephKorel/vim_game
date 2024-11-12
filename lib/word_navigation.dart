import 'package:flutter/material.dart';
import 'package:vim_game/key_event.dart';
import 'package:vim_game/sentence_entity.dart';

base class WordNavigation {
  const WordNavigation({
    required this.carretOffset,
    required this.sentence,
  });

  WordNavigation setHandlerBasedOnEvent(WordNavigationEvent event) =>
      switch (event) {
        AdvanceToEndOfNextWordEvent() => _NavigatingToEndOfNextWord(
            carretOffset: carretOffset,
            sentence: sentence,
          ),
        AdvanceToBeginningOfNextWordEvent() => _NavigatingToBeginningOfNextWord(
            carretOffset: carretOffset,
            sentence: sentence,
          ),
        AdvanceToBeginningOfPreviousWordEvent() =>
          _NavigatingToBeginningOfPreviousWord(
            carretOffset: carretOffset,
            sentence: sentence,
          ),
        _ => this,
      };

  Offset newOffset() => carretOffset;

  bool get carretIsAboveAnySentence =>
      carretOffset.dy < sentence.startingPoisition.dy;

  bool get carretIsBelowAnySentence =>
      !sentence.wordsInThisLine(carretOffset.dy) &&
      carretOffset.dy > sentence.startingPoisition.dy;

  int? findOverlappingWordIndex() =>
      sentence.indexOfWordInOffset(carretOffset: carretOffset);

  final Offset carretOffset;
  final SentenceEntity sentence;
}

final class _NavigatingToEndOfNextWord extends WordNavigation {
  const _NavigatingToEndOfNextWord({
    required super.carretOffset,
    required super.sentence,
  });

  @override
  Offset newOffset() => _findOffset();

  Offset _findOffset() {
    final carretIsBelowAnySentence = super.carretIsBelowAnySentence;
    if (carretIsBelowAnySentence) {
      return carretOffset;
    }

    final overlappingWordIndex = findOverlappingWordIndex();

    if (overlappingWordIndex == null) {
      final endOfWordOffset = sentence.findOffsetOfWordEnd(wordIndex: 0);

      return endOfWordOffset;
    }

    final wordIndexToNavigate =
        _carretIsAboveLastCharacter(overlappingWordIndex)
            ? overlappingWordIndex + 1
            : overlappingWordIndex;

    final endOfWordOffset =
        sentence.findOffsetOfWordEnd(wordIndex: wordIndexToNavigate);

    return Offset(endOfWordOffset.dx - 1, endOfWordOffset.dy);
  }

  bool _carretIsAboveLastCharacter(int overlappingWordIndex) {
    final lastCharacterOffset =
        sentence.findOffsetOfWordEnd(wordIndex: overlappingWordIndex);
    return carretOffset.dy == lastCharacterOffset.dy;
  }
}

final class _NavigatingToBeginningOfNextWord extends WordNavigation {
  const _NavigatingToBeginningOfNextWord({
    required super.carretOffset,
    required super.sentence,
  });

  @override
  Offset newOffset() => _findOffset();

  Offset _findOffset() {
    final carretIsBelowAnySentence = super.carretIsBelowAnySentence;
    if (carretIsBelowAnySentence) {
      return carretOffset;
    }

    final overlappingWordIndex = findOverlappingWordIndex();
    final endOfWordOffset = sentence.findOffsetOfWordStart(
        wordIndex: overlappingWordIndex == null ? 0 : overlappingWordIndex + 1);

    return Offset(endOfWordOffset.dx - 1, endOfWordOffset.dy);
  }
}

final class _NavigatingToBeginningOfPreviousWord extends WordNavigation {
  const _NavigatingToBeginningOfPreviousWord({
    required super.carretOffset,
    required super.sentence,
  });

  @override
  Offset newOffset() => _findOffset();

  Offset _findOffset() {
    double dy = carretOffset.dy;
    double dx = carretOffset.dx;

    final carretIsAboveAnySentence = super.carretIsAboveAnySentence;

    if (carretIsAboveAnySentence) {
      return Offset(dx, dy);
    }

    final carretIsBelowAnySentence = super.carretIsBelowAnySentence;
    if (carretIsBelowAnySentence) {
      _setDyToSentenceLineAndDxToBeginningOfLastWord(dy, dx);
      return Offset(dx, dy);
    }

    final overlappingIndex = findOverlappingWordIndex();
    final wordOffset =
        _findOffsetOfBeginningWordWithIndex(overlappingIndex ?? 0);
    return wordOffset;
  }

  void _setDyToSentenceLineAndDxToBeginningOfLastWord(
    double carretDy,
    double carretDx,
  ) {
    _setDyToBeInSentenceLine(carretDy, sentence.startingPoisition.dy);
    _setDxToBeginningOfLastWord(carretDx);
  }

  Offset _findOffsetOfBeginningWordWithIndex(
    int indexOfWordToNavigate,
  ) =>
      sentence.findOffsetOfWordStart(wordIndex: indexOfWordToNavigate);

  void _setDxToBeginningOfLastWord(double carretDx) =>
      carretDx = sentence.beginningOfLastWordDx;

  void _setDyToBeInSentenceLine(double carretDy, double sentenceDy) =>
      carretDy = sentenceDy;
}
