import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import 'signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF37234E), Color(0xFF15101E)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'NIGHTFALL / CREATURE REGISTRY',
                      style: TextStyle(
                        color: Color(0xFFE6C8FF),
                        letterSpacing: 2,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 44),
                    const Icon(
                      Icons.nightlight_round,
                      size: 100,
                      color: Color(0xFFFFB36B),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      height: 150,
                      child: MediaQuery.of(context).disableAnimations
                          ? const Text(
                              'A place for every creature.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 42,
                                height: 1.1,
                                fontWeight: FontWeight.w800,
                              ),
                            )
                          : AnimatedTextKit(
                              animatedTexts: [
                                TypewriterAnimatedText(
                                  'A place for every creature.',
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 42,
                                    height: 1.1,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  speed: const Duration(milliseconds: 65),
                                ),
                              ],
                              totalRepeatCount: 1,
                              displayFullTextOnTap: true,
                            ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Ghosts, night owls, and new companions welcome. Add your name to the guest book.',
                      style: TextStyle(
                        color: Color(0xFFD4C8DE),
                        fontSize: 17,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 36),
                    FilledButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => const SignupScreen(),
                        ),
                      ),
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Enter the Registry'),
                    ),
                    const SizedBox(height: 48),
                    const Text(
                      '01  FOYER     /     02  GUEST BOOK     /     03  BALLROOM',
                      style: TextStyle(
                        color: Color(0xFFBCABC9),
                        fontSize: 10,
                        letterSpacing: 1,
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
