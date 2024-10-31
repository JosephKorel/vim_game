import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vim_game/providers/providers.dart';

class ThemeSwitch extends ConsumerWidget {
  const ThemeSwitch({super.key});

  void _onChanged(WidgetRef ref, bool darkMode) {
    ref
        .read(themeProvider.notifier)
        .updateTheme(darkMode ? ThemeMode.dark : ThemeMode.light);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    return Switch(
        value: themeMode == ThemeMode.dark,
        onChanged: (value) => _onChanged(ref, value));
  }
}
