import 'package:flutter_test/flutter_test.dart';
import 'package:game_data/game_data.dart';
import 'package:game_domain/game_domain.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'profiles.dart';

const _today = GameMode.daily(day: 20261017);

SharedPreferencesBestScores _scores() =>
    SharedPreferencesBestScores(startingProgression: starting);

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('nothing is best before a first run', () async {
    // Given / When
    final best = await _scores().best(_today);

    // Then
    expect(best, isNull);
  });

  test('a saved best is read back by the next launch', () async {
    // Given
    await _scores().save(_today, 2400);

    // When
    await relaunch();
    final best = await _scores().best(_today);

    // Then
    expect(best, 2400);
  });

  test('each day and practice keep their own best', () async {
    // Given
    final scores = _scores();
    await scores.save(_today, 2400);
    await scores.save(const GameMode.practice(), 3100);

    // When
    final tomorrow = await scores.best(const GameMode.daily(day: 20261018));

    // Then
    expect(tomorrow, isNull);
    expect(await scores.best(_today), 2400);
    expect(await scores.best(const GameMode.practice()), 3100);
  });

  test('the days a daily run was played are read back by the next launch, '
      'and no other run counts', () async {
    // Given
    final scores = _scores();
    await scores.save(const GameMode.daily(day: 20261016), 1800);
    await scores.save(_today, 2400);
    await scores.save(const GameMode.practice(), 3100);

    // When
    await relaunch();
    final days = await _scores().dailyDays();

    // Then
    expect(days, {20261016, 20261017});
  });

  test('each world keeps its own best, apart from practice', () async {
    // Given
    final scores = _scores();
    await scores.save(const GameMode.world(world: .rubble), 5200);
    await scores.save(const GameMode.practice(), 3100);

    // When
    await relaunch();
    final relaunched = _scores();

    // Then
    expect(await relaunched.best(const GameMode.world(world: .rubble)), 5200);
    expect(
      await relaunched.best(const GameMode.world(world: .gravity)),
      isNull,
    );
    expect(await relaunched.best(const GameMode.practice()), 3100);
  });

  test('clearing forgets every best and nothing else', () async {
    // Given
    final scores = _scores();
    final progression = SharedPreferencesProgressionStore(
      startingProgression: starting,
    );
    final unlocked = starting.copyWith(tutorialDone: true);
    await scores.save(_today, 2400);
    await scores.save(const GameMode.daily(day: 20261018), 900);
    await scores.save(const GameMode.practice(), 3100);
    await scores.save(const GameMode.world(world: .rubble), 5200);
    await progression.save(unlocked);
    final stored = await SharedPreferences.getInstance();
    await stored.setString('run.saved', '{}');
    await stored.setBool('settings.sound', false);

    // When
    await scores.clearAll();

    // Then
    expect(await scores.best(_today), isNull);
    expect(await scores.best(const GameMode.daily(day: 20261018)), isNull);
    expect(await scores.best(const GameMode.practice()), isNull);
    expect(await scores.best(const GameMode.world(world: .rubble)), isNull);
    expect(await progression.load(), unlocked);
    expect(stored.getKeys(), {'profile', 'run.saved', 'settings.sound'});
  });
}
