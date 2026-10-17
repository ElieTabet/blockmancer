import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:game_data/game_data.dart';
import 'package:game_data/src/dtos/profile_dto.br.dart';
import 'package:game_domain/game_domain.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'profiles.dart';

/// Rubble done with every star, Gravity open with one, its jokers earned, and
/// a few runs counted for two jokers.
final _progressed = starting.copyWith(
  jokerStats: const {
    .stonemason: JokerStats(bestRunTotal: 7200, runsWon: 1, timesPicked: 3),
    .twin: JokerStats(bestRunTotal: 4100, runsWon: 0, timesPicked: 5),
  },
  tutorialDone: true,
  unlockedJokers: {...starting.unlockedJokers, .stonemason, .quarry},
  worlds: {
    ...starting.worlds,
    .rubble: const WorldProgress(
      bossBeaten: true,
      stars: WorldStars(bossBeaten: true, noRevive: true, scoreThreshold: true),
      unlocked: true,
    ),
    .gravity: const WorldProgress(
      bossBeaten: false,
      stars: WorldStars(
        bossBeaten: false,
        noRevive: false,
        scoreThreshold: true,
      ),
      unlocked: true,
    ),
  },
);

SharedPreferencesProgressionStore _store() =>
    SharedPreferencesProgressionStore(startingProgression: starting);

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('Given a progression, When it goes through JSON, Then it comes back the '
      'same', () {
    // When
    final json = jsonEncode(ProgressionDto.fromDomain(_progressed).toJson());
    final decoded = ProgressionDto.fromJson(
      jsonDecode(json) as Map<String, dynamic>,
    ).toDomain();

    // Then
    expect(decoded, _progressed);
  });

  test('Given a saved progression, When the next launch loads it, Then it is '
      'the one saved', () async {
    // Given
    await _store().save(_progressed);

    // When
    await relaunch();
    final loaded = await _store().load();

    // Then
    expect(loaded, _progressed);
  });

  test('Given bests and a progression written together, When both are read, '
      'Then neither write undid the other', () async {
    // Given
    final scores = SharedPreferencesBestScores(startingProgression: starting);

    // When
    await Future.wait([
      scores.save(const GameMode.practice(), 3100),
      _store().save(_progressed),
    ]);
    await relaunch();

    // Then
    expect(await _store().load(), _progressed);
    expect(
      await SharedPreferencesBestScores(
        startingProgression: starting,
      ).best(const GameMode.practice()),
      3100,
    );
  });
}
