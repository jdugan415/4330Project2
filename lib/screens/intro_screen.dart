import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'game_screen.dart';

/// A short title sequence, shown once when the app opens.
class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _intro;

  @override
  void initState() {
    super.initState();
    _intro =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 3200),
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed && mounted) {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder<void>(
                transitionDuration: MediaQuery.disableAnimationsOf(context)
                    ? Duration.zero
                    : const Duration(milliseconds: 550),
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const GameScreen(),
                transitionsBuilder: (
                  context,
                  animation,
                  secondaryAnimation,
                  child,
                ) => FadeTransition(opacity: animation, child: child),
              ),
            );
          }
        });
    _intro.forward();
  }

  @override
  void dispose() {
    _intro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return Scaffold(
      backgroundColor: const Color(0xFF14102B),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.35),
            radius: 1.1,
            colors: [Color(0xFF493579), Color(0xFF14102B)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'THREE MOVES. ONE WINNER.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFC9B8F4),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ExcludeSemantics(
                      child: AnimatedBuilder(
                        animation: _intro,
                        builder: (context, child) => _MoveArtwork(
                          drift: reduceMotion
                              ? 0
                              : math.sin(_intro.value * math.pi * 2) * 5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Semantics(
                      header: true,
                      label: 'Rock Paper Scissors The Game',
                      excludeSemantics: true,
                      child: const Column(
                        children: [
                          Text(
                            'ROCK PAPER\nSCISSORS',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 38,
                              height: 1.04,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -1.5,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'THE GAME',
                            style: TextStyle(
                              color: Color(0xFFFFD280),
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'by Jack Dugan and Andrew Kilpatric',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFD9CFEF),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 36),
                    SizedBox(
                      width: 160,
                      child: AnimatedBuilder(
                        animation: _intro,
                        builder: (context, child) => LinearProgressIndicator(
                          value: _intro.value,
                          minHeight: 4,
                          borderRadius: BorderRadius.circular(8),
                          backgroundColor: const Color(0xFF403455),
                          color: const Color(0xFFBBA0FF),
                          semanticsLabel: 'Opening game',
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Get ready to make your move',
                      style: TextStyle(color: Color(0xFFBFB0D8), fontSize: 12),
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

class _MoveArtwork extends StatelessWidget {
  const _MoveArtwork({required this.drift});
  final double drift;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 230,
    child: FittedBox(
      fit: BoxFit.contain,
      child: SizedBox(
        width: 320,
        height: 230,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 210,
              height: 210,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF8064B0)),
              ),
            ),
            Transform.rotate(
              angle: -0.4,
              child: Container(
                width: 300,
                height: 125,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: const Color(0xFF69508F)),
                ),
              ),
            ),
            const Positioned(
              left: 22,
              top: 30,
              child: Icon(
                Icons.auto_awesome,
                color: Color(0xFFFFD280),
                size: 22,
              ),
            ),
            const Positioned(
              right: 28,
              bottom: 20,
              child: Icon(
                Icons.auto_awesome,
                color: Color(0xFFC0A0FF),
                size: 28,
              ),
            ),
            Positioned(
              left: 10,
              top: 95 + drift,
              child: _tile(
                Icons.hexagon_rounded,
                const Color(0xFFBBA0FF),
                -0.23,
                'ROCK',
              ),
            ),
            Positioned(
              right: 10,
              top: 96 - drift,
              child: _tile(
                Icons.content_cut_rounded,
                const Color(0xFFFF9C88),
                0.23,
                'SCISSORS',
              ),
            ),
            Positioned(
              top: 15 + drift,
              child: _tile(
                Icons.description_rounded,
                const Color(0xFFFFD280),
                -0.06,
                'PAPER',
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _tile(IconData icon, Color color, double angle, String label) =>
      Transform.rotate(
        angle: angle,
        child: Container(
          width: 105,
          height: 120,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.5),
              width: 2,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x66090019),
                blurRadius: 20,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 55, color: const Color(0xFF302043)),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF302043),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      );
}
