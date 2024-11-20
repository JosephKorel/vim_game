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

  int? findOverlappingWordIndex() => sentence.indexOfWordInOffset(
        carretOffset: carretOffset,
        goingLeft: this is _NavigatingToBeginningOfPreviousWord,
      );

  bool carretIsAboveLastCharacter(int overlappingWordIndex) {
    final lastCharacterOffset =
        sentence.findOffsetOfWordEnd(wordIndex: overlappingWordIndex);
    return carretOffset == lastCharacterOffset;
  }

  bool carretIsAboveFirstCharacter(int overlappingWordIndex) {
    final firstCharacterOffset =
        sentence.findOffsetOfWordStart(wordIndex: overlappingWordIndex);
    return carretOffset == firstCharacterOffset;
  }

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

    final wordIndexToNavigate = carretIsAboveLastCharacter(overlappingWordIndex)
        ? overlappingWordIndex + 1
        : overlappingWordIndex;

    final endOfWordOffset =
        sentence.findOffsetOfWordEnd(wordIndex: wordIndexToNavigate);

    return endOfWordOffset;
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
    if (overlappingWordIndex == null) {
      return sentence.startingPoisition;
    }

    final wordIndexToNavigate = overlappingWordIndex + 1;

    final endOfWordOffset =
        sentence.findOffsetOfWordStart(wordIndex: wordIndexToNavigate);

    return endOfWordOffset;
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
    final carretIsAboveAnySentence = super.carretIsAboveAnySentence;
    if (carretIsAboveAnySentence) {
      return carretOffset;
    }

    final overlappingWordIndex = findOverlappingWordIndex();
    if (overlappingWordIndex == null) {
      return sentence.offsetOfLastWordStart;
    }

    final wordIndexToNavigate =
        carretIsAboveFirstCharacter(overlappingWordIndex)
            ? overlappingWordIndex - 1
            : overlappingWordIndex;

    final wordStartOffset =
        sentence.findOffsetOfWordStart(wordIndex: wordIndexToNavigate);

    return wordStartOffset;
  }
}
