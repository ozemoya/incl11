import 'package:flutter/material.dart';

import 'screens/welcome_screen.dart';

void main() => runApp(const HauntedMansionApp());

class HauntedMansionApp extends StatelessWidget {
  const HauntedMansionApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(seedColor: const Color(0xFFED4C39))
        .copyWith(
          primary: Colors.black,
          onPrimary: Colors.white,
          secondary: const Color(0xFFED4C39),
          surface: const Color(0xFFF5F0E8),
        );
    return MaterialApp(
      title: 'Nightfall Creature Registry',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: scheme,
        fontFamily: 'BarlowCondensed',
        scaffoldBackgroundColor: const Color(0xFFF5F0E8),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 18),
          bodyLarge: TextStyle(fontSize: 19),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5F0E8),
          foregroundColor: Colors.black,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: TextStyle(
            fontFamily: 'Anton',
            fontSize: 22,
            color: Colors.black,
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 54),
            textStyle: const TextStyle(
              fontFamily: 'Anton',
              fontSize: 17,
              letterSpacing: .6,
            ),
          ),
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}
