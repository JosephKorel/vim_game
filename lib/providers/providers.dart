import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
