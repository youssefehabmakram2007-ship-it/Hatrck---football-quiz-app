import 'package:flutter/material.dart';
import '../core/glass.dart';
import '../cubit/quiz_state.dart';
import '../data/question.dart';

class QuestionCard extends StatelessWidget {
  final QuizState state;
  const QuestionCard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final q = state.question;
    return Glass(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        child: Column(children: [
          Text(q.type.label,
              style: const TextStyle(
                  letterSpacing: 3, fontSize: 12, color: Colors.white70)),
          const SizedBox(height: 12),
          if (q.type == QType.club) _Crest(colors: q.colors),
          Text(q.prompt,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          if (q.type != QType.general) ...[
            const SizedBox(height: 12),
            for (int i = 0; i < q.clues.length; i++) _clue(q, i),
          ],
        ]),
      ),
    );
  }

  Widget _clue(Question q, int i) {
    final visible =
        q.type == QType.club || i < state.cluesShown || state.isAnswered;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: Text(
          visible ? '• ${q.clues[i]}' : '• 🔒 ???',
          key: ValueKey(visible),
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white.withValues(alpha: visible ? 0.9 : 0.4)),
        ),
      ),
    );
  }
}

class _Crest extends StatelessWidget {
  final List<Color> colors;
  const _Crest({required this.colors});

  @override
  Widget build(BuildContext context) => Container(
        width: 80,
        height: 96,
        margin: const EdgeInsets.only(bottom: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [colors.first, colors.last], stops: const [0.5, 0.5]),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomLeft: Radius.circular(48),
            bottomRight: Radius.circular(48),
          ),
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: const Text('?',
            style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                shadows: [Shadow(blurRadius: 8)])),
      );
}
