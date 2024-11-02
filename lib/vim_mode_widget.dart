import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vim_game/providers/providers.dart';
import 'package:vim_game/theme/utils.dart';

class VimModeWidget extends ConsumerWidget {
  const VimModeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(modeProvider);
    return Text(
      mode.name.toUpperCase(),
      style: context.bodyMedium.copyWith(
        fontWeight: FontWeight.w600,
        color: context.onSurface.withOpacity(0.7),
      ),
    );
  }
}
