import '../data/question.dart';
import '../data/questions_data.dart';

enum QuizStatus { playing, answered, finished }

class QuizState {
  static const rounds = 10;

  final List<Question> questions;
  final QuizStatus status;
  final int index;
  final int score;
  final int lives;
  final int streak;
  final int bestStreak;
  final int hatTricks;
  final int correct;
  final int timeLeft;
  final int totalTime;
  final bool lifelineAvailable;
  final bool hatTrickJustHappened;
  final String? picked;
  final Set<String> hidden;

  const QuizState({
    required this.questions,
    this.status = QuizStatus.playing,
    this.index = 0,
    this.score = 0,
    this.lives = 3,
    this.streak = 0,
    this.bestStreak = 0,
    this.hatTricks = 0,
    this.correct = 0,
    this.timeLeft = 15,
    this.totalTime = 15,
    this.lifelineAvailable = true,
    this.hatTrickJustHappened = false,
    this.picked,
    this.hidden = const {},
  });

  factory QuizState.initial() {
    final qs = QuestionsData.randomSet(rounds);
    final t = timeFor(qs.first);
    return QuizState(questions: qs, timeLeft: t, totalTime: t);
  }

  static int timeFor(Question q) => q.type == QType.whoAmI ? 20 : 15;

  Question get question => questions[index];
  bool get isAnswered => status != QuizStatus.playing;
  bool get isLast => index + 1 >= questions.length;

  /// Who-am-I: one new clue every 5 seconds.
  int get cluesShown {
    final elapsed = totalTime - timeLeft;
    return (1 + elapsed ~/ 5).clamp(1, question.clues.length);
  }

  QuizState copyWith({
    QuizStatus? status,
    int? index,
    int? score,
    int? lives,
    int? streak,
    int? bestStreak,
    int? hatTricks,
    int? correct,
    int? timeLeft,
    int? totalTime,
    bool? lifelineAvailable,
    bool? hatTrickJustHappened,
    String? picked,
    bool clearPicked = false,
    Set<String>? hidden,
  }) =>
      QuizState(
        questions: questions,
        status: status ?? this.status,
        index: index ?? this.index,
        score: score ?? this.score,
        lives: lives ?? this.lives,
        streak: streak ?? this.streak,
        bestStreak: bestStreak ?? this.bestStreak,
        hatTricks: hatTricks ?? this.hatTricks,
        correct: correct ?? this.correct,
        timeLeft: timeLeft ?? this.timeLeft,
        totalTime: totalTime ?? this.totalTime,
        lifelineAvailable: lifelineAvailable ?? this.lifelineAvailable,
        hatTrickJustHappened: hatTrickJustHappened ?? this.hatTrickJustHappened,
        picked: clearPicked ? null : (picked ?? this.picked),
        hidden: hidden ?? this.hidden,
      );
}
