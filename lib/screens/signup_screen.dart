import 'package:flutter/material.dart';

import 'success_screen.dart';
import '../creature_art.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  static const _tips = <String>[
    'Use a long, unique password for each account. A password manager can help you remember it.',
    'Avoid names and birthdays in passwords. Choose a phrase that is hard for someone else to guess.',
    'Turn on two-factor authentication when it is available.',
  ];

  String _tip = 'Get a quick password tip before you sign up.';
  int _tipIndex = 0;
  bool _isLoading = false;
  bool _tipFailed = false;

  bool _obscurePassword = true;
  bool _submitting = false;
  bool _triedSubmit = false;
  String? _selectedCreatureType;
  DateTime? _birthDate;
  final _dateController = TextEditingController();

  Future<void> _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(2008),
      firstDate: DateTime(1920),
      lastDate: DateUtils.dateOnly(DateTime.now()),
    );
    if (!mounted || picked == null) return;
    setState(() {
      _birthDate = picked;
      _dateController.text = '${picked.month}/${picked.day}/${picked.year}';
    });
  }

  Future<void> _submit() async {
    if (_submitting) return;
    setState(() => _triedSubmit = true);
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final userName = _nameController.text.trim();
    final creatureType = _selectedCreatureType!;
    setState(() => _submitting = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
        builder: (_) =>
            SuccessScreen(userName: userName, creatureType: creatureType),
      ),
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _getTip({bool simulateError = false}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _tipFailed = false;
    });

    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;

    setState(() {
      _isLoading = false;
      if (simulateError) {
        _tipFailed = true;
        _tip = 'The demo tip could not load. Your form is unaffected.';
      } else {
        _tip = _tips[_tipIndex % _tips.length];
        _tipIndex++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The guest book'),
        backgroundColor: const Color(0xFFF5F0E8),
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Form(
              key: _formKey,
              autovalidateMode: _triedSubmit
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: const Color(0xFFED4C39),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Chip(
                          label: Text(
                            'GUEST BOOK',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          backgroundColor: Colors.black,
                          side: BorderSide.none,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Find your familiar.',
                          style: TextStyle(
                            fontFamily: 'Anton',
                            fontSize: 32,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Five creatures. One unforgettable night.',
                          style: TextStyle(fontSize: 19, color: Colors.white),
                        ),
                        CreatureCollage(height: 120),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Your details',
                    style: TextStyle(fontFamily: 'Anton', fontSize: 25),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        tooltip: _obscurePassword
                            ? 'Show password'
                            : 'Hide password',
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    key: const Key('creature'),
                    initialValue: _selectedCreatureType,
                    decoration: const InputDecoration(
                      labelText: 'Creature type',
                      prefixIcon: Icon(Icons.pets),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    items:
                        const [
                              'Ghost',
                              'Bat',
                              'Black Cat',
                              'Pumpkin Spirit',
                              'Witch',
                            ]
                            .map(
                              (type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ),
                            )
                            .toList(),
                    onChanged: _submitting
                        ? null
                        : (type) =>
                              setState(() => _selectedCreatureType = type),
                    validator: (type) =>
                        type == null ? 'Choose your creature type' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Birth Date',
                      prefixIcon: Icon(Icons.cake),
                      suffixIcon: Icon(Icons.calendar_month),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (_) =>
                        _birthDate == null ? 'Pick your birth date' : null,
                    onTap: _submitting ? null : _pickBirthDate,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _submitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),
                    ),
                    child: _submitting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            'Register Creature',
                            style: TextStyle(fontFamily: 'Anton', fontSize: 18),
                          ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    color: const Color(0xFFEAE2D5),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Password tip',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (_isLoading)
                            const Row(
                              children: [
                                SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text('Choosing a preset tip...'),
                              ],
                            )
                          else
                            Text(_tip),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            children: [
                              OutlinedButton(
                                onPressed: _isLoading ? null : _getTip,
                                child: const Text('Get a signup tip'),
                              ),
                              TextButton(
                                onPressed: _isLoading
                                    ? null
                                    : () => _getTip(simulateError: true),
                                child: const Text('Test error'),
                              ),
                              if (_tipFailed)
                                TextButton(
                                  onPressed: () => _getTip(),
                                  child: const Text('Retry tip'),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
