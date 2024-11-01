import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vim_game/providers/providers.dart';

class PressedKeys extends ConsumerWidget {
  const PressedKeys({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pressedKeys = ref.watch(keyObserverProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        for (final key in pressedKeys)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(key),
          )
      ],
    );
  }
}
