import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vim_game/carret_position.dart';
import 'package:vim_game/mode.dart';

part 'providers.g.dart';

@riverpod
class CarretOffset extends _$CarretOffset {
  @override
  Offset build() {
    return const Offset(0, 0);
  }

  void updateCarretPosition(Offset offset) {
    state = offset;
  }
}

@riverpod
class Carret extends _$Carret {
  @override
  CarretPosition build() {
    return const CarretPosition(0, 0);
  }

  void updateCarretPosition(Offset offset) {
    state = state.moveTo(offset);
  }
}

@riverpod
class Theme extends _$Theme {
  @override
  ThemeMode build() {
    return ThemeMode.dark;
  }

  void updateTheme(ThemeMode themeMode) {
    state = themeMode;
  }
}

@riverpod
class MainColor extends _$MainColor {
  @override
  Color build() {
    return Colors.indigo;
  }

  void updateMainColor(Color color) {
    state = color;
  }
}

@riverpod
class KeyObserver extends _$KeyObserver {
  @override
  List<String> build() {
    return [];
  }

  void updateList(List<String> keys) {
    state = [...keys];
  }
}

@riverpod
class Mode extends _$Mode {
  @override
  VimMode build() {
    return VimMode.normal;
  }

  void updateMode(VimMode mode) {
    state = mode;
  }
}

@riverpod
class Score extends _$Score {
  @override
  int build() {
    return 0;
  }

  void incrementScore() {
    state++;
  }
}
