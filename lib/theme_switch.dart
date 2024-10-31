import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vim_game/providers/providers.dart';

class ThemeSwitch extends ConsumerWidget {
  const ThemeSwitch({super.key});

  void _onChanged(WidgetRef ref, ThemeMode themeMode) {
    ref.read(themeProvider.notifier).updateTheme(themeMode);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    return IconButton(
      onPressed: () => _onChanged(
          ref, themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark),
      icon: themeMode == ThemeMode.dark
          ? const Icon(Icons.light_mode)
          : const Icon(Icons.dark_mode),
    );
  }
}
