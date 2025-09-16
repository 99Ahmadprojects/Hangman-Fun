// lib/main.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const HangmanApp());
}

/// Simple settings DTO
class SettingsData {
  bool showHints;
  bool viewGuesses;
  Color hangmanColor;

  SettingsData({
    required this.showHints,
    required this.viewGuesses,
    required this.hangmanColor,
  });
}

class HangmanApp extends StatefulWidget {
  const HangmanApp({super.key});

  @override
  State<HangmanApp> createState() => _HangmanAppState();
}

class _HangmanAppState extends State<HangmanApp> {
  SettingsData _settings = SettingsData(
    showHints: true,
    viewGuesses: true,
    hangmanColor: Colors.deepPurple,
  );

  void _updateSettings(SettingsData newSettings) {
    setState(() => _settings = newSettings);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hangman Fun',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        scaffoldBackgroundColor: Colors.orange[50],
        textTheme: TextTheme(
          bodyMedium: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
          headlineSmall: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      home: Builder(builder: (context) {
        return LandingPage(
          settings: _settings,
          onStartGame: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => GamePage(settings: _settings)));
          },
          onOpenSettings: () {
            Navigator.of(context)
                .push<SettingsData>(MaterialPageRoute(builder: (_) => SettingsPage(settings: _settings)))
                .then((result) {
              if (result != null) _updateSettings(result);
            });
          },
        );
      }),
    );
  }
}

/// Landing Page - now playful and animated
class LandingPage extends StatelessWidget {
  final VoidCallback onStartGame;
  final VoidCallback onOpenSettings;
  final SettingsData settings;

  const LandingPage({
    super.key,
    required this.onStartGame,
    required this.onOpenSettings,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    GoogleFonts.permanentMarker(
      fontSize: 36,
      color: Colors.white,
      shadows: [const Shadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 2))],
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade400, Colors.pink.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 40),
                AnimatedTextKit(
                  animatedTexts: [
                    ColorizeAnimatedText(
                      'Save the Hangman!',
                      textStyle: const TextStyle(
                        fontFamily: 'Marker', // must match your pubspec.yaml
                        fontWeight: FontWeight.w500,
                        fontSize: 35,
                        height: 1.2,
                      ),
                      colors: [
                        Colors.white,
                        //Colors.white,
                        Colors.blue,
                      ],
                    ),
                  ],
                  isRepeatingAnimation: true, // makes it loop
                  repeatForever: true,        // continuous animation
                ),
                const SizedBox(height: 10),
                Text('A silly number guessing Hangman', style: GoogleFonts.poppins(color: Colors.white70)),
                const SizedBox(height: 40),
                SizedBox(
                  width: 220,
                  height: 220,
                  child: Image.asset(
                    'assets/hangman.png',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.sentiment_very_satisfied, size: 120, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: onStartGame,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [Icon(Icons.play_arrow), SizedBox(width: 8), Text('Start Game')],
                  ),
                ),
                const SizedBox(height: 15),
                OutlinedButton.icon(
                  onPressed: onOpenSettings,
                  icon: const Icon(Icons.settings),
                  label: const Text('Settings'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white54),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Hints: ${settings.showHints ? "ON" : "OFF"} •• Guesses: ${settings.viewGuesses ? "Shown" : "Hidden"}',
                    style: GoogleFonts.poppins(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Settings page
class SettingsPage extends StatefulWidget {
  final SettingsData settings;
  const SettingsPage({super.key, required this.settings});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool showHints;
  late bool viewGuesses;
  late Color selectedColor;

  final List<Color> colorOptions = [Colors.deepPurple, Colors.red, Colors.blue, Colors.green, Colors.purple, Colors.orange];

  @override
  void initState() {
    showHints = widget.settings.showHints;
    viewGuesses = widget.settings.viewGuesses;
    selectedColor = widget.settings.hangmanColor;
    super.initState();
  }

  void _saveAndExit() {
    Navigator.pop(context, SettingsData(showHints: showHints, viewGuesses: viewGuesses, hangmanColor: selectedColor));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Game Settings', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 18),
          Row(children: [const Expanded(child: Text('Show Hints')), Switch(value: showHints, onChanged: (v) => setState(() => showHints = v))]),
          Row(children: [const Expanded(child: Text('View Guesses')), Switch(value: viewGuesses, onChanged: (v) => setState(() => viewGuesses = v))]),
          const SizedBox(height: 18),
          const Text('Hangman Color', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children: colorOptions.map((c) {
              final isSelected = c.value == selectedColor.value;
              return GestureDetector(
                onTap: () => setState(() => selectedColor = c),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: isSelected ? Border.all(width: 3, color: Colors.black) : null,
                  ),
                  child: CircleAvatar(radius: 20, backgroundColor: c),
                ),
              );
            }).toList(),
          ),
          const Spacer(),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(onPressed: _saveAndExit, child: const Text('Save'))
          ])
        ]),
      ),
    );
  }
}

/// GamePage — fully interactive
class GamePage extends StatefulWidget {
  final SettingsData settings;
  const GamePage({super.key, required this.settings});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final int maxAttempts = 6;
  late int _target;
  int _attempts = 0;
  bool _won = false;
  bool _lost = false;
  List<int> _guesses = [];
  String _hint = '';
  late ConfettiController _confettiController;

  // animation helpers for playful micro-interactions
  late AnimationController _headBumpController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
    _headBumpController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _headBumpController.addStatusListener((s) {
      if (s == AnimationStatus.completed) _headBumpController.reverse();
    });
    _startNewGame();
  }

  void _startNewGame() {
    setState(() {
      _target = Random().nextInt(20); // 0..19
      _attempts = 0;
      _won = false;
      _lost = false;
      _guesses = [];
      _hint = 'Make a guess! Tap a number or type it.';
      _controller.clear();
    });
  }

  // funny hint generator
  String _cheekyHint(int guess) {
    final diff = (guess - _target).abs();
    if (guess == _target) return 'BOOM! Perfect!';
    if (diff == 1) return "So close! You're on 🔥";
    if (diff <= 3) return "You're pretty warm 🔥";
    if (diff <= 6) return "Mildly warm 🙂";
    return "Brrr... cold 🥶 Try another!";
  }

  void _handleGuess(int guess) {
    if (_won || _lost) return;
    if (guess < 0 || guess > 19) return;
    if (_guesses.contains(guess)) {
      // small head bump animation for repeat guess
      _headBumpController.forward(from: 0);
      setState(() => _hint = 'You already guessed $guess — try another!');
      return;
    }
    setState(() {
      _guesses.add(guess);
      _attempts++;
      _hint = widget.settings.showHints ? _cheekyHint(guess) : '';
    });

    // play micro-animation
    _headBumpController.forward(from: 0);

    if (guess == _target) {
      setState(() {
        _won = true;
      });
      _confettiController.play();
      Future.delayed(const Duration(milliseconds: 350), () {
        _showEndDialog('You won! 🥳', 'Correct number: $_target\nYou saved the hangman!🎉');
      });
      return;
    }

    if (_attempts >= maxAttempts) {
      setState(() {
        _lost = true;
      });
      Future.delayed(const Duration(milliseconds: 350), () {
        _showEndDialog('You lost 😢', 'The number was $_target\nBetter luck next time!');
      });
      return;
    }
  }

  Future<void> _showEndDialog(String title, String content) async {
    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
    _startNewGame();
  }

  // build playful hangman - parts appear based on attempts
  Widget _buildHangman(Color color) {
    final partsVisible = _attempts.clamp(0, maxAttempts);
    // small animation via TweenAnimationBuilder for each part
    Widget animatedPart({required Widget child, required bool visible, int delay = 0}) {
      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.7, end: visible ? 1.0 : 0.7),
        duration: Duration(milliseconds: 350),
        curve: Curves.elasticOut,
        builder: (context, scale, _) => Opacity(opacity: visible ? 1 : 0.0, child: Transform.scale(scale: scale, child: child)),
      );
    }

    final head = animatedPart(
      visible: partsVisible > 0,
      child: AnimatedBuilder(
        animation: _headBumpController,
        builder: (c, child) {
          final bump = 1 + (_headBumpController.value * 0.06);
          return Transform.scale(scale: bump, child: child);
        },
        child: CircleAvatar(
          radius: 28,
          backgroundColor: color,
          child: Text(
            _won ? '😎' : _lost ? '😵' : '🙂',
            style: const TextStyle(fontSize: 26),
          ),
        ),
      ),
    );

    final body = animatedPart(
      visible: partsVisible > 1,
      child: Container(width: 6, height: 64, color: color),
    );

    final leftArm = animatedPart(visible: partsVisible > 2, child: Transform.rotate(angle: -pi / 6, child: Container(width: 48, height: 6, color: color)));
    final rightArm = animatedPart(visible: partsVisible > 3, child: Transform.rotate(angle: pi / 6, child: Container(width: 48, height: 6, color: color)));
    final leftLeg = animatedPart(visible: partsVisible > 4, child: Transform.rotate(angle: pi / 6, child: Container(width: 6, height: 48, color: color)));
    final rightLeg = animatedPart(visible: partsVisible > 5, child: Transform.rotate(angle: -pi / 6, child: Container(width: 6, height: 48, color: color)));

    return SizedBox(
      height: 220,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // simple gallow
          Positioned(top: 0, left: 36, child: Container(width: 8, height: 220, color: Colors.brown[700])),
          Positioned(top: 0, left: 36, child: Container(width: 120, height: 12, color: Colors.brown[700])),
          Positioned(top: 12, left: 34 + 114, child: Container(width: 8, height: 28, color: Colors.brown[700])),
          // hangman body parts near the beam
          Positioned(top: 40, left: 25 + 114 - 14, child: head),
          Positioned(top: 40 + 56, left: 37 + 114 - 2, child: body),
          Positioned(top: 40 + 80, left: 36 + 114 - 45, child: leftArm),
          Positioned(top: 40 + 80, left: 36 + 114 + 1, child: rightArm),
          Positioned(top: 40 + 115, left: 36 + 114 - 14, child: leftLeg),
          Positioned(top: 40 + 115, left: 36 + 114 + 12, child: rightLeg),
          // confetti overlay
          Positioned.fill(child: IgnorePointer(child: ConfettiWidget(confettiController: _confettiController, blastDirectionality: BlastDirectionality.explosive, shouldLoop: false))),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    _headBumpController.dispose();
    super.dispose();
  }

  Widget _buildKeypad() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 5,
      mainAxisSpacing: 10,
      crossAxisSpacing: 8,
      childAspectRatio: 1.2,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(10, (i) {
        final disabled = _guesses.contains(i) || _won || _lost;
        return ElevatedButton(
          onPressed: disabled ? null : () => _handleGuess(i),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.all(6),
            backgroundColor: disabled ? Colors.grey.shade300 : Colors.white,
            foregroundColor: disabled ? Colors.grey : Colors.black87,
            elevation: 4,
            shadowColor: Colors.black12,
          ),
          child: Text(
            '$i',
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hangmanColor = widget.settings.hangmanColor;
    return Scaffold(
      appBar: AppBar(title: const Text('Hangman Game 🎯')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(left: 16, right: 16, top: 18, bottom: MediaQuery.of(context).viewInsets.bottom + 16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            _buildHangman(hangmanColor),
            const SizedBox(height: 8),
            // hearts (attempts left)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(maxAttempts, (i) {
// before used attempts are filled; reverse to show remaining
                final showFilled = i < (maxAttempts - _attempts);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(Icons.favorite, color: showFilled ? Colors.redAccent : Colors.grey.shade400, size: 22),
                );
              }),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Type a guess (0 - 19)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                suffixIcon: IconButton(icon: const Icon(Icons.send), onPressed: () {
                  final value = int.tryParse(_controller.text.trim());
                  if (value != null) {
                    _handleGuess(value);
                    _controller.clear();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter 0 - 19')));
                  }
                }),
              ),
              onSubmitted: (_) {
                final value = int.tryParse(_controller.text.trim());
                if (value != null) {
                  _handleGuess(value);
                  _controller.clear();
                }
              },
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: ElevatedButton(onPressed: () => _handleGuess(-1), child: const Text('Hint (Try keys)'))),
              const SizedBox(width: 12),
              ElevatedButton(onPressed: _startNewGame, child: const Text('Restart')),
            ]),
            const SizedBox(height: 15),
            // keypad
            _buildKeypad(),
            const SizedBox(height: 15),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              child: widget.settings.showHints
                  ? Text(_hint, key: ValueKey(_hint), style: const TextStyle(fontSize: 18), textAlign: TextAlign.center)
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 15),
            widget.settings.viewGuesses
                ? Text('Guesses: ${_guesses.join(" • ")}', textAlign: TextAlign.center)
                : const Center(child: Text('Guesses are hidden')),
            const SizedBox(height: 10),
            Text('Attempts: $_attempts of $maxAttempts', textAlign: TextAlign.center),
            const SizedBox(height: 22),
          ]),
        ),
      ),
    );
  }
}
