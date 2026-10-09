import 'package:flutter/material.dart';

enum QType { whoAmI, general, club }

extension QTypeX on QType {
  String get label => switch (this) {
        QType.whoAmI => '🕵️ WHO AM I',
        QType.general => '🧠 FOOTBALL IQ',
        QType.club => '🛡️ GUESS THE CLUB',
      };
}

class Question {
  final QType type;
  final String prompt;
  final List<String> options;
  final String answer;
  final List<String> clues; // whoAmI: vague -> obvious | club: all shown
  final List<Color> colors; // club kit colors

  const Question(
    this.type,
    this.prompt,
    this.options,
    this.answer, {
    this.clues = const [],
    this.colors = const [],
  });

  /// New copy with options in random order (const lists can't be shuffled).
  Question withShuffledOptions() => Question(
        type,
        prompt,
        [...options]..shuffle(),
        answer,
        clues: clues,
        colors: colors,
      );
}
