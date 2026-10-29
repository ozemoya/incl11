import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import '../creature_art.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(
      fontFamily: 'Anton',
      fontSize: 48,
      color: Colors.black,
      letterSpacing: .5,
    );
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEDE5D8), Color(0xFFFFFFFF)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 26),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'THE CREATURE REGISTRY',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, letterSpacing: 2.5),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 78,
                      child: Center(
                        child: MediaQuery.of(context).disableAnimations
                            ? const Text('Nightfall', style: titleStyle)
                            : AnimatedTextKit(
                                animatedTexts: [
                                  TypewriterAnimatedText(
                                    'Nightfall',
                                    textStyle: titleStyle,
                                    speed: const Duration(milliseconds: 100),
                                  ),
                                ],
                                totalRepeatCount: 1,
                                displayFullTextOnTap: true,
                              ),
                      ),
                    ),
                    const CreatureCollage(height: 250),
                    const SizedBox(height: 20),
                    const Text(
                      'Good company.\nStrange creatures.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Anton',
                        fontSize: 25,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Find your familiar, sign the guest book,\nand join a night worth remembering.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 21,
                        color: Color(0xFF6A665F),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 32),
                    FilledButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => const SignupScreen(),
                        ),
                      ),
                      child: const Text('Enter the Registry'),
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'GHOSTS  /  BATS  /  BLACK CATS  /  SPIRITS  /  WITCHES',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 1,
                        color: Color(0xFF77716A),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
