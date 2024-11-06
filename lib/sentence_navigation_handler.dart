import 'package:flutter/material.dart';
import 'package:vim_game/sentence_entity.dart';

final class SentenceNavigationHandler {
  const SentenceNavigationHandler();

  void goToBeginningOfPreviousWord({
    required Offset carretOffset,
    required SentenceEntity sentence,
  }) {
    final offsetOfLastWord = _findOffsetOfLastWord(
      carretOffset: carretOffset,
      sentence: sentence,
    );

    throw UnimplementedError();
  }

  int? _findOverlappingWordIndex(
          double carretDxOffset, SentenceEntity sentence) =>
      sentence.indexOfWordInOffset(carretDxOffset: carretDxOffset);

  Offset _findOffsetOfLastWord({
    required Offset carretOffset,
    required SentenceEntity sentence,
  }) {
    double dy = carretOffset.dy;
    double dx = _findDxOfLastWord(sentence);

    final carretIsAboveAnySentence = _carretIsAboveAnySentence(dy, sentence);

    if (carretIsAboveAnySentence) {
      return Offset(dx, dy);
    }

    final carretIsBelowAnySentence = _carretIsBelowAnySentence(dy, sentence);
    if (carretIsBelowAnySentence) {
      _setDyToSentenceLineAndDxToBeginningOfLastWord(dy, dx, sentence);
      return Offset(dx, dy);
    }

    final overlappingIndex = _findOverlappingWordIndex(dx, sentence);
    final wordOffset =
        _findOffsetOfBeginningWordWithIndex(overlappingIndex ?? 0, sentence);
    return wordOffset;
  }

  void _setDyToSentenceLineAndDxToBeginningOfLastWord(
    double carretDy,
    double carretDx,
    SentenceEntity sentence,
  ) {
    _setDyToBeInSentenceLine(carretDy, sentence.startingPoisition.dy);
    _setDxToBeginningOfLastWord(carretDx, sentence);
  }

  Offset _findOffsetOfBeginningWordWithIndex(
    int indexOfWordToNavigate,
    SentenceEntity sentence,
  ) =>
      sentence.beginningOfWordOffset(
          indexOfWordToNavigate: indexOfWordToNavigate);

  bool _carretIsAboveAnySentence(double carretDy, SentenceEntity sentence) =>
      carretDy < sentence.startingPoisition.dy;

  bool _carretIsBelowAnySentence(double carretDy, SentenceEntity sentence) =>
      !sentence.wordsInThisLine(carretDy) &&
      carretDy > sentence.startingPoisition.dy;

  void _setDxToBeginningOfLastWord(double carretDx, SentenceEntity sentence) =>
      carretDx = sentence.dxOfLastWord;

  double _findDxOfLastWord(SentenceEntity sentence) => sentence.dxOfLastWord;

  void _setDyToBeInSentenceLine(double carretDy, double sentenceDy) =>
      carretDy = sentenceDy;
}
