import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vim_game/providers/providers.dart';

const _avaiableColors = [
  Colors.indigo,
  Colors.pink,
  Colors.purpleAccent,
  Colors.teal,
  Colors.cyanAccent
];

class ColorSelect extends ConsumerWidget {
  const ColorSelect({super.key});

  void _onTap(WidgetRef ref, Color color) {
    ref.read(mainColorProvider.notifier).updateMainColor(color);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        for (final color in _avaiableColors)
          Container(
            color: color,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: InkWell(onTap: () => _onTap(ref, color)),
          )
      ],
    );
  }
}
