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

  Widget _companion(
    IconData icon,
    Color color,
    String label, {
    bool selected = false,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: selected ? 102 : 74,
            height: selected ? 102 : 74,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 6),
            ),
            child: Icon(icon, size: selected ? 54 : 36, color: Colors.black),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Anton', fontSize: selected ? 18 : 14),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final icon = switch (widget.creatureType) {
      'Black Cat' => Icons.pets,
      'Witch' => Icons.auto_awesome,
      'Pumpkin Spirit' => Icons.emoji_nature,
      'Bat' => Icons.nightlight_round,
      _ => Icons.sentiment_satisfied_alt,
    };
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
                        'The guest list',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: 'Anton', fontSize: 23),
                      ),
                      const SizedBox(height: 36),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _companion(
                            Icons.sentiment_satisfied_alt,
                            const Color(0xFFED4C39),
                            'GHOST',
                          ),
                          _companion(
                            icon,
                            const Color(0xFFE9D9B8),
                            widget.creatureType,
                            selected: true,
                          ),
                          _companion(
                            Icons.nightlight_round,
                            const Color(0xFF43816A),
                            'BAT',
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Welcome, ${widget.userName}!',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Anton',
                          fontSize: 30,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Creature registered: ${widget.creatureType}.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 21,
                          color: Color(0xFF6A665F),
                        ),
                      ),
                      const SizedBox(height: 30),
                      _record(
                        Icons.person_outline,
                        'Guest',
                        widget.userName,
                        const Color(0xFFED4C39),
                      ),
                      _record(
                        Icons.pets_outlined,
                        'Companion',
                        widget.creatureType,
                        const Color(0xFF8A68BB),
                      ),
                      _record(
                        Icons.check_circle_outline,
                        'Registration',
                        'Complete',
                        const Color(0xFFE9B72F),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'You are on the list. Enjoy the night.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFF6A665F),
                        ),
                      ),
                      const SizedBox(height: 24),
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
                    Color(0xFFED4C39),
                    Color(0xFFFFCA42),
                    Color(0xFF8A68BB),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _record(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 17),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE1DBD1))),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color,
            foregroundColor: Colors.black,
            child: Icon(icon),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontFamily: 'Anton', fontSize: 18),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
