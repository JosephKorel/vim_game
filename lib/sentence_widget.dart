import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vim_game/providers/providers.dart';

class SentenceWidget extends ConsumerWidget {
  const SentenceWidget({
    super.key,
    required this.squareSize,
  });

  final Size squareSize;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sentence = ref.watch(sentenceProvider);
    final dx = sentence.startingPoisition.dx * squareSize.width;
    final dy = sentence.startingPoisition.dy * squareSize.height;
    return Positioned(
      left: dx,
      top: dy,
      child: Row(
        children: [
          for (var i = 0; i < sentence.text.length; i++)
            SizedBox.fromSize(
              size: squareSize,
              child: Center(
                child: Text(sentence.text[i]),
              ),
            )
        ],
      ),
    );
  }
}
