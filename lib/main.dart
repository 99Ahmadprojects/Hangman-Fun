import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const HangmanApp());
}

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
    hangmanColor: Colors.black,
  );

  void _updateSettings(SettingsData newSettings) {
    setState(() => _settings = newSettings);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hangman Fun',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        scaffoldBackgroundColor: Colors.orange[50],
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: const TextStyle(fontSize: 18),
          ),
        ),
      ),
      // Use a Builder so the provided context is *below* MaterialApp (so Navigator exists).
      home: Builder(builder: (context) {
        return LandingPage(
          settings: _settings,
          onStartGame: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => GamePage(settings: _settings)),
            );
          },
          onOpenSettings: () {
            Navigator.of(context)
                .push<SettingsData>(
              MaterialPageRoute(builder: (_) => SettingsPage(settings: _settings)),
            )
                .then((result) {
              if (result != null) {
                _updateSettings(result);
              }
            });
          },
        );
      }),
    );
  }
}

/// Landing Page
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
    return Scaffold(
      appBar: AppBar(title: const Text('Hangman Fun',
                                        style: TextStyle(
                                          fontFamily: 'CooperBlack',
                                          fontWeight: FontWeight.w900,
                                          color: Colors.lightBlue,
                                          fontSize: 30,
                                        ),)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Save the HangMan',
              style: TextStyle(
                fontFamily: 'FontStyle',
                fontWeight: FontWeight.w500,
                color: Colors.lightBlue,
                fontSize: 35,
                height: 4,
              ),
            ),
            const SizedBox(height: 0),
            SizedBox(
              width: 200,
              height: 200,
              child: Image.asset(
                'assets/hangman.png',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(Icons.gamepad, size: 120),
              ),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              child: const Text('Start Game',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 25,
                  )),
              onPressed: onStartGame,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text('Settings',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 25,
                  )),
              onPressed: onOpenSettings,
            ),
            const SizedBox(height: 30),
            Text('Hints: ${settings.showHints ? "ON" : "OFF"} •• Guesses: ${settings.viewGuesses ? "Showing" : "Hidden"}'),
          ],
        ),
      ),
    );
  }
}

/// Settings Page
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

  final List<Color> colorOptions = [
    Colors.black,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.orange,
  ];

  @override
  void initState() {
    super.initState();
    showHints = widget.settings.showHints;
    viewGuesses = widget.settings.viewGuesses;
    selectedColor = widget.settings.hangmanColor;
  }

  void _saveAndExit() {
    final newSettings = SettingsData(
      showHints: showHints,
      viewGuesses: viewGuesses,
      hangmanColor: selectedColor,
    );
    Navigator.pop(context, newSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Game Settings', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              children: [
                const Expanded(child: Text('Show Hints: ', style: TextStyle(fontSize: 18))),
                Switch(value: showHints, onChanged: (val) => setState(() => showHints = val)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Expanded(child: Text('View Guesses: ', style: TextStyle(fontSize: 18))),
                Switch(value: viewGuesses, onChanged: (val) => setState(() => viewGuesses = val)),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Hangman Color', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(onPressed: _saveAndExit, child: const Text('Save')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Game Page
class GamePage extends StatefulWidget {
  final SettingsData settings;

  const GamePage({super.key, required this.settings});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final TextEditingController _controller = TextEditingController();
  final int maxAttempts = 6;

  late int _target;
  int _attempts = 0;
  bool _won = false;
  bool _lost = false;

  String _hint = '';
  List<int> _guesses = [];

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    setState(() {
      _target = Random().nextInt(20); // 0-19
      _attempts = 0;
      _won = false;
      _lost = false;
      _guesses.clear();
      _hint = '';
      _controller.clear();
    });
  }

  void _onGuess() {
    if (_won || _lost) return;

    final guess = int.tryParse(_controller.text.trim());
    if (guess == null || guess < 0 || guess > 19) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a number between 0 and 19')),
      );
      return;
    }

    _controller.clear();

    if (_guesses.contains(guess)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You already guessed that number')),
      );
      return;
    }

    setState(() {
      _guesses.add(guess);
      _attempts++;
    });

    if (guess == _target) {
      setState(() {
        _won = true;
        _hint = 'You guessed it!';
      });
      _showDialog('You won! 🥇', 'Correct number: $_target  😎');
      return;
    }

    if (_attempts >= maxAttempts) {
      setState(() => _lost = true);
      _showDialog('You lost 😔', 'The number was $_target  (🤪)');
      return;
    }

    setState(() {
      _hint = guess > _target ? 'Try smaller number' : 'Try bigger number';
    });
  }

  Future<void> _showDialog(String title, String content) async {
    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    // restart when dialog dismissed
    _startNewGame();
  }

  Widget _buildHangman(Color color) {
    final partsVisible = _attempts.clamp(0, maxAttempts);

    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      const h = 200.0;

      final double postWidth = (w * 0.02).clamp(12, 12).toDouble();
      final double gallowLeft = (w * 0.08).toDouble();
      final double beamLength = (w * 0.52).clamp(120, w - 40).toDouble();
      final double ropeX = gallowLeft + beamLength;

      final double headRadius = (w * 0.06).clamp(12, 28).toDouble();
      const double headTop = 30.0;
      final double bodyHeight = (h * 0.22).clamp(30, 80).toDouble();
      final double armLength = (w * 0.12).clamp(20, 60).toDouble();
      final double legLength = (h * 0.15).clamp(20, 60).toDouble();

      return SizedBox(
        height: h,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // Gallow post
            Positioned(
              left: gallowLeft,
              top: 0,
              bottom: 0,
              child: Container(width: postWidth, color: Colors.brown),
            ),
            // Beam
            Positioned(
              left: gallowLeft,
              top: 0,
              child: Container(width: beamLength, height: 16, color: Colors.brown),
            ),
            // Short vertical at beam end
            Positioned(
              left: ropeX - (postWidth / 2),
              top: 8,
              child: Container(width: postWidth / 2, height: 28, color: Colors.brown),
            ),
            // Head
            if (partsVisible > 0)
              Positioned(
                top: headTop,
                left: ropeX - headRadius - 3,
                child: CircleAvatar(radius: headRadius, backgroundColor: color),
              ),
            // Body
            if (partsVisible > 1)
              Positioned(
                top: headTop + headRadius * 2,
                left: ropeX - 2,
                child: Container(width: 4, height: bodyHeight, color: color),
              ),
            // Left arm
            if (partsVisible > 2)
              Positioned(
                top: headTop + headRadius * 2 + (bodyHeight * 0.5),
                left: ropeX - armLength + 2,
                child: Transform.rotate(
                  angle: -pi / 8,
                  alignment: Alignment.centerLeft,
                  child: Container(width: armLength, height: 4, color: color),
                ),
              ),
            // Right arm
            if (partsVisible > 3)
              Positioned(
                top: headTop + headRadius * 2 + (bodyHeight * 0.15),
                left: ropeX + 1,
                child: Transform.rotate(
                  angle: pi / 8,
                  alignment: Alignment.centerLeft,
                  child: Container(width: armLength, height: 4, color: color),
                ),
              ),
            // Left leg
            if (partsVisible > 4)
              Positioned(
                top: headTop + headRadius * 2 + bodyHeight,
                left: ropeX - 3,
                child: Transform.rotate(
                  angle: pi / 6,
                  alignment: Alignment.topLeft,
                  child: Container(width: 4, height: legLength, color: color),
                ),
              ),
            // Right leg
            if (partsVisible > 5)
              Positioned(
                top: headTop + headRadius * 2 + (bodyHeight + 1),
                left: ropeX + 0,
                child: Transform.rotate(
                  angle: -pi / 6,
                  alignment: Alignment.topLeft,
                  child: Container(width: 4, height: legLength, color: color),
                ),
              ),
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hangman Game')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 40,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHangman(widget.settings.hangmanColor),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Enter your Guess 🤔 (0 - 19)',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) => _onGuess(),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: ElevatedButton(onPressed: _onGuess, child: const Text('Guess'))),
                  const SizedBox(width: 12),
                  ElevatedButton(onPressed: _startNewGame, child: const Text('Restart')),
                ],
              ),
              const SizedBox(height: 30),
              if (widget.settings.showHints) Text(_hint, style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 10),
              if (widget.settings.viewGuesses)
                Text('Guesses: ${_guesses.join(" - ")}', overflow: TextOverflow.visible)
              else
                const Text('Guesses are hidden'),
              const SizedBox(height: 10),
              Text('Attempts: $_attempts Out of $maxAttempts'),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
