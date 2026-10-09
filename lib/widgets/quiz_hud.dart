import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/glass.dart';
import '../cubit/quiz_state.dart';

class QuizHud extends StatelessWidget {
  final QuizState state;
  const QuizHud({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Glass(
      radius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('❤️' * state.lives + '🖤' * (3 - state.lives)),
        Text('Q ${state.index + 1}/${state.questions.length}'),
        Text('🔥 ${state.streak}'),
        Text('⭐ ${state.score}',
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: AppColors.gold)),
      ]),
    );
  }
}
