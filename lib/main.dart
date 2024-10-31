import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vim_game/grid.dart';
import 'package:vim_game/providers/providers.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainColor = ref.watch(mainColorProvider);
    final themeMode = ref.watch(themeProvider);
    return MaterialApp(
      title: 'Yet Another Vim Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
        useMaterial3: true,
      ),
      themeMode: themeMode,
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: mainColor, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const EditorGrid(),
    );
  }
}
