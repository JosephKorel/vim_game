import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vim_game/carret_position.dart';

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
