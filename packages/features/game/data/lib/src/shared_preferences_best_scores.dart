import 'package:game_domain/game_domain.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// One int per mode: a key per daily run's day, one for practice. Past days are
/// never pruned — a year of them is a few kilobytes.
final class SharedPreferencesBestScores implements BestScores {
  const SharedPreferencesBestScores();

  static const _prefix = 'best.';

  @override
  Future<int?> best(GameMode mode) async =>
      (await SharedPreferences.getInstance()).getInt(_keyOf(mode));

  @override
  Future<void> clearAll() async {
    final preferences = await SharedPreferences.getInstance();

    await Future.wait([
      for (final key in preferences.getKeys())
        if (key.startsWith(_prefix)) preferences.remove(key),
    ]);
  }

  @override
  Future<void> save(GameMode mode, int total) async {
    await (await SharedPreferences.getInstance()).setInt(_keyOf(mode), total);
  }

  static String _keyOf(GameMode mode) => switch (mode) {
    DailyMode(:final day) => '${_prefix}daily.$day',
    PracticeMode() => '${_prefix}practice',
  };
}
