import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/app_colors.dart';
import '../core/glass.dart';
import '../cubit/best_score_cubit.dart';
import '../cubit/quiz_cubit.dart';
import '../cubit/quiz_state.dart';
import '../widgets/option_tile.dart';
import '../widgets/question_card.dart';
import '../widgets/quiz_hud.dart';
import 'results_screen.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  /// Creates a fresh QuizCubit every time a game starts.
  static Route<void> route() => MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => QuizCubit(),
          child: const QuizScreen(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BlocListener<QuizCubit, QuizState>(
      listenWhen: (p, c) =>
          p.status != c.status && c.status == QuizStatus.finished,
      listener: (context, s) {
        final isNew = context.read<BestScoreCubit>().submit(s.score);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => ResultsScreen(result: s, isNewBest: isNew)),
        );
      },
      child: GlassBackground(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<QuizCubit, QuizState>(
            builder: (context, s) {
              final cubit = context.read<QuizCubit>();
              final q = s.question;
              return Column(children: [
                QuizHud(state: s),
                const SizedBox(height: 12),
                _TimerBar(timeLeft: s.timeLeft, total: s.totalTime),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(children: [
                      QuestionCard(state: s),
                      if (s.hatTrickJustHappened)
                        const Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: Text('🎩 HAT-TRICK!  +100',
                              style: TextStyle(
                                  color: AppColors.gold,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900)),
                        ),
                      const SizedBox(height: 16),
                      for (final o in q.options)
                        if (!s.hidden.contains(o))
                          OptionTile(
                            text: o,
                            isAnswered: s.isAnswered,
                            isCorrect: o == q.answer,
                            isPicked: o == s.picked,
                            onTap: () => cubit.answer(o),
                          ),
                    ]),
                  ),
                ),
                GestureDetector(
                  onTap: cubit.useFiftyFifty,
                  child: Opacity(
                    opacity: s.lifelineAvailable ? 1 : 0.35,
                    child: const Glass(
                      radius: 16,
                      padding:
                          EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      child: Text('✂️ 50 / 50'),
                    ),
                  ),
                ),
              ]);
            },
          ),
        ),
      ),
    );
  }
}

class _TimerBar extends StatelessWidget {
  final int timeLeft, total;
  const _TimerBar({required this.timeLeft, required this.total});

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: TweenAnimationBuilder<double>(
          tween: Tween(end: timeLeft / total),
          duration: const Duration(milliseconds: 900),
          builder: (_, v, __) => LinearProgressIndicator(
            value: v,
            minHeight: 8,
            backgroundColor: Colors.white12,
            color: timeLeft <= 5 ? AppColors.red : AppColors.green,
          ),
        ),
      );
}
