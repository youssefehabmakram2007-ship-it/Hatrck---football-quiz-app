import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// State is simply the best score (int). Persisted between launches.
class BestScoreCubit extends Cubit<int> {
  BestScoreCubit() : super(0) {
    _load();
  }

  static const _key = 'hatrick_best_score';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    emit(prefs.getInt(_key) ?? 0);
  }

  /// Returns true if [score] is a new record.
  bool submit(int score) {
    if (score <= state) return false;
    emit(score);
    SharedPreferences.getInstance().then((p) => p.setInt(_key, score));
    return true;
  }
}
