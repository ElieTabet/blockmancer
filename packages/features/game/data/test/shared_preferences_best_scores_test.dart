import 'package:flutter_test/flutter_test.dart';
import 'package:game_data/game_data.dart';
import 'package:game_domain/game_domain.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _today = GameMode.daily(day: 20261017);

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('nothing is best before a first run', () async {
    // Given / When
    final best = await const SharedPreferencesBestScores().best(_today);

    // Then
    expect(best, isNull);
  });

  test('a saved best is read back by the next launch', () async {
    // Given
    await const SharedPreferencesBestScores().save(_today, 2400);

    // When: what a relaunch reads, the store's cache gone
    final stored = await SharedPreferences.getInstance();
    final values = {for (final key in stored.getKeys()) key: stored.get(key)!};
    SharedPreferences.setMockInitialValues(values);
    final best = await const SharedPreferencesBestScores().best(_today);

    // Then
    expect(best, 2400);
  });

  test('each day and practice keep their own best', () async {
    // Given
    const scores = SharedPreferencesBestScores();
    await scores.save(_today, 2400);
    await scores.save(const GameMode.practice(), 3100);

    // When
    final tomorrow = await scores.best(const GameMode.daily(day: 20261018));

    // Then
    expect(tomorrow, isNull);
    expect(await scores.best(_today), 2400);
    expect(await scores.best(const GameMode.practice()), 3100);
  });

  test('clearing forgets every best and nothing else', () async {
    // Given
    const scores = SharedPreferencesBestScores();
    await scores.save(_today, 2400);
    await scores.save(const GameMode.daily(day: 20261018), 900);
    await scores.save(const GameMode.practice(), 3100);
    final stored = await SharedPreferences.getInstance();
    await stored.setString('run.saved', '{}');
    await stored.setBool('settings.sound', false);

    // When
    await scores.clearAll();

    // Then
    expect(await scores.best(_today), isNull);
    expect(await scores.best(const GameMode.daily(day: 20261018)), isNull);
    expect(await scores.best(const GameMode.practice()), isNull);
    expect(stored.getKeys(), {'run.saved', 'settings.sound'});
  });
}
