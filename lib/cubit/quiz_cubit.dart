import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/question.dart';
import 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  QuizCubit() : super(QuizState.initial()) {
    _startTimer();
  }

  Timer? _ticker;
  Timer? _nextDelay;

  void _startTimer() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (state.status != QuizStatus.playing) return;
    final t = state.timeLeft - 1;
    if (t <= 0) {
      emit(state.copyWith(timeLeft: 0));
      answer(null); // time's up counts as wrong
    } else {
      emit(state.copyWith(timeLeft: t));
    }
  }

  void answer(String? choice) {
    if (state.status != QuizStatus.playing) return;
    _ticker?.cancel();

    final isRight = choice == state.question.answer;
    var s = state;

    if (isRight) {
      final streak = s.streak + 1;
      var pts = 50 + s.timeLeft * 5;
      // Earlier guess in Who-am-I = bigger bonus.
      if (s.question.type == QType.whoAmI) {
        pts += (s.question.clues.length - s.cluesShown) * 25;
      }
      final isHatTrick = streak % 3 == 0;
      if (isHatTrick) pts += 100;
      HapticFeedback.lightImpact();
      s = s.copyWith(
        correct: s.correct + 1,
        streak: streak,
        bestStreak: streak > s.bestStreak ? streak : s.bestStreak,
        score: s.score + pts,
        hatTricks: s.hatTricks + (isHatTrick ? 1 : 0),
        hatTrickJustHappened: isHatTrick,
      );
    } else {
      HapticFeedback.heavyImpact();
      s = s.copyWith(
        streak: 0,
        lives: s.lives - 1,
        hatTrickJustHappened: false,
      );
    }

    emit(s.copyWith(
      status: QuizStatus.answered,
      picked: choice,
      clearPicked: choice == null,
    ));
    _nextDelay = Timer(const Duration(milliseconds: 1400), _next);
  }

  void _next() {
    if (state.lives <= 0 || state.isLast) {
      emit(state.copyWith(status: QuizStatus.finished));
      return;
    }
    final nextIndex = state.index + 1;
    final t = QuizState.timeFor(state.questions[nextIndex]);
    emit(state.copyWith(
      index: nextIndex,
      status: QuizStatus.playing,
      timeLeft: t,
      totalTime: t,
      hidden: {},
      hatTrickJustHappened: false,
      clearPicked: true,
    ));
    _startTimer();
  }

  /// 50/50: removes two wrong options. One use per game.
  void useFiftyFifty() {
    if (!state.lifelineAvailable || state.isAnswered) return;
    final wrong = state.question.options
        .where((o) => o != state.question.answer)
        .toList()
      ..shuffle();
    emit(state.copyWith(
      lifelineAvailable: false,
      hidden: wrong.take(2).toSet(),
    ));
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    _nextDelay?.cancel();
    return super.close();
  }
}
