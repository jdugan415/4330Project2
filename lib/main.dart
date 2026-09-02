import 'package:flutter/material.dart';

import 'screens/game_screen.dart';
import 'theme/app_theme.dart';

void main() => runApp(const RockPaperScissorsApp());

class RockPaperScissorsApp extends StatelessWidget {
  const RockPaperScissorsApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Rock Paper Scissors',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    darkTheme: AppTheme.dark,
    themeMode: ThemeMode.system,
    home: const GameScreen(),
  );
}
