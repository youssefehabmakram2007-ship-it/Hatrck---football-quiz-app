import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/glass.dart';
import '../cubit/quiz_state.dart';
import 'quiz_screen.dart';

class ResultsScreen extends StatelessWidget {
  final QuizState result;
  final bool isNewBest;
  const ResultsScreen(
      {super.key, required this.result, required this.isNewBest});

  String get rank {
    final p = result.correct / result.questions.length;
    if (p >= 0.9) return '🏆 World Class';
    if (p >= 0.7) return '🥇 First Team';
    if (p >= 0.4) return '🥈 Substitute';
    return '🥉 Bench Warmer';
  }

  @override
  Widget build(BuildContext context) {
    return GlassBackground(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Glass(
            padding: const EdgeInsets.all(32),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(rank,
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.w900)),
              const SizedBox(height: 16),
              TweenAnimationBuilder<int>(
                tween: IntTween(begin: 0, end: result.score),
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeOut,
                builder: (_, v, __) => Text('$v',
                    style: const TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.w900,
                        color: AppColors.gold)),
              ),
              const Text('POINTS', style: TextStyle(letterSpacing: 4)),
              const SizedBox(height: 20),
              Text('✅ Correct: ${result.correct} / ${result.questions.length}'),
              const SizedBox(height: 4),
              Text('🔥 Best streak: ${result.bestStreak}'),
              const SizedBox(height: 4),
              Text('🎩 Hat-tricks: ${result.hatTricks}'),
              if (isNewBest)
                const Padding(
                  padding: EdgeInsets.only(top: 14),
                  child: Text('🎉 New best score!',
                      style: TextStyle(
                          color: AppColors.gold, fontWeight: FontWeight.bold)),
                ),
              const SizedBox(height: 24),
              GlassButton(
                label: 'PLAY AGAIN',
                onTap: () =>
                    Navigator.pushReplacement(context, QuizScreen.route()),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
                child: const Text('Home'),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
