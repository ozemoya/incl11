import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({
    super.key,
    required this.userName,
    required this.creatureType,
  });

  final String userName;
  final String creatureType;

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  final _confetti = ConfettiController(duration: const Duration(seconds: 3));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !MediaQuery.of(context).disableAnimations) {
        _confetti.play();
      }
    });
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(28),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        '03 / THE BALLROOM',
                        style: TextStyle(letterSpacing: 2, fontSize: 12),
                      ),
                      const SizedBox(height: 40),
                      const Icon(
                        Icons.celebration_outlined,
                        size: 90,
                        color: Color(0xFF69418B),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        'Welcome, ${widget.userName}!',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6D6F1),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'YOUR COMPANION',
                              style: TextStyle(fontSize: 11, letterSpacing: 2),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              widget.creatureType,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Creature registered: ${widget.creatureType}.',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'You are on the guest list. Enjoy the night.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 32),
                      FilledButton(
                        onPressed: () => Navigator.popUntil(
                          context,
                          (route) => route.isFirst,
                        ),
                        child: const Text('Back to the Foyer'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: IgnorePointer(
                child: ConfettiWidget(
                  confettiController: _confetti,
                  blastDirectionality: BlastDirectionality.explosive,
                  numberOfParticles: 18,
                  colors: const [
                    Color(0xFF69418B),
                    Color(0xFFFFB36B),
                    Color(0xFFE6D6F1),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
