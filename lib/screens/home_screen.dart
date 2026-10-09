import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/app_colors.dart';
import '../core/glass.dart';
import '../cubit/best_score_cubit.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassBackground(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Glass(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text('⚽', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 8),
              const Text('HATRICK',
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 6)),
              const SizedBox(height: 6),
              Text('Get 3 right in a row. Score the bonus.',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.7))),
              const SizedBox(height: 24),
              const Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  _Tag('🕵️ Who Am I'),
                  _Tag('🧠 Football IQ'),
                  _Tag('🛡️ Guess the Club'),
                ],
              ),
              const SizedBox(height: 24),
              BlocBuilder<BestScoreCubit, int>(
                builder: (_, best) => Text('🏆 Best score: $best',
                    style: const TextStyle(
                        color: AppColors.gold, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
              GlassButton(
                label: 'KICK OFF',
                onTap: () => Navigator.push(context, QuizScreen.route()),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  const _Tag(this.text);

  @override
  Widget build(BuildContext context) => Glass(
        radius: 20,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Text(text, style: const TextStyle(fontSize: 13)),
      );
}
