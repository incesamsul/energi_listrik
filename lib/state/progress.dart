import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Menyimpan progres pemain: level tertinggi yang terbuka dan status kuis.
/// Bertahan antar sesi lewat SharedPreferences.
class Progress extends ChangeNotifier {
  static const _kUnlocked = 'unlocked_level';
  static const _kQuizBest = 'quiz_best';

  int _unlockedLevel = 1; // level 1 selalu terbuka
  int _quizBest = -1; // skor benar terbaik, -1 = belum main

  int get unlockedLevel => _unlockedLevel;
  int get quizBest => _quizBest;
  bool get quizPlayed => _quizBest >= 0;

  // Kuis terbuka setelah semua level tuntas (unlockedLevel melewati total).
  bool quizUnlocked(int totalLevels) => _unlockedLevel > totalLevels;

  bool isUnlocked(int levelId) => levelId <= _unlockedLevel;

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    _unlockedLevel = p.getInt(_kUnlocked) ?? 1;
    _quizBest = p.getInt(_kQuizBest) ?? -1;
    notifyListeners();
  }

  /// Menandai [levelId] selesai; membuka level berikutnya. Menyelesaikan
  /// level terakhir membuat unlockedLevel = totalLevels + 1 (penanda kuis).
  Future<void> completeLevel(int levelId, int totalLevels) async {
    if (levelId >= _unlockedLevel && levelId <= totalLevels) {
      _unlockedLevel = levelId + 1;
      final p = await SharedPreferences.getInstance();
      await p.setInt(_kUnlocked, _unlockedLevel);
      notifyListeners();
    }
  }

  Future<void> saveQuiz(int correct) async {
    if (correct > _quizBest) {
      _quizBest = correct;
      final p = await SharedPreferences.getInstance();
      await p.setInt(_kQuizBest, _quizBest);
      notifyListeners();
    }
  }

  Future<void> reset() async {
    _unlockedLevel = 1;
    _quizBest = -1;
    final p = await SharedPreferences.getInstance();
    await p.remove(_kUnlocked);
    await p.remove(_kQuizBest);
    notifyListeners();
  }
}

/// Instance tunggal progres, dipakai lintas layar.
final appProgress = Progress();
