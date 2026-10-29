import 'package:flutter/material.dart';

import 'screens/welcome_screen.dart';

void main() => runApp(const HauntedMansionApp());

class HauntedMansionApp extends StatelessWidget {
  const HauntedMansionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nightfall Creature Registry',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF69418B)),
        scaffoldBackgroundColor: const Color(0xFFF8F2E9),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFFFB36B),
            foregroundColor: const Color(0xFF24132D),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          ),
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}
