import 'dart:async';
import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/glass.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..forward();

  late final Animation<double> _scale =
      CurvedAnimation(parent: _c, curve: Curves.elasticOut);
  late final Animation<double> _fade =
      CurvedAnimation(parent: _c, curve: const Interval(0, 0.6));

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 2800), _goHome);
  }

  void _goHome() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, __, ___) => const HomeScreen(),
        transitionsBuilder: (_, a, __, child) =>
            FadeTransition(opacity: a, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlassBackground(
      child: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Glass(
              radius: 40,
              padding:
                  const EdgeInsets.symmetric(horizontal: 44, vertical: 40),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                RotationTransition(
                  turns: Tween(begin: 0.0, end: 1.0).animate(_c),
                  child: const Text('⚽', style: TextStyle(fontSize: 76)),
                ),
                const SizedBox(height: 12),
                const Text('HATRICK',
                    style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 8)),
                const SizedBox(height: 6),
                Text('THE FOOTBALL QUIZ',
                    style: TextStyle(
                        fontSize: 12,
                        letterSpacing: 4,
                        color: Colors.white.withValues(alpha: 0.7))),
                const SizedBox(height: 28),
                const SizedBox(
                  width: 120,
                  child: LinearProgressIndicator(
                    minHeight: 4,
                    color: AppColors.green,
                    backgroundColor: Colors.white12,
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
