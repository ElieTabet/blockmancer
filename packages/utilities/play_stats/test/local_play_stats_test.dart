import 'dart:convert';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:play_stats/play_stats.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Always the same draw, so an install id is known in advance.
final class _FixedRandom implements Random {
  const _FixedRandom(this.value);

  final int value;

  @override
  bool nextBool() => false;

  @override
  double nextDouble() => 0;

  @override
  int nextInt(int max) => value % max;
}

void main() {
  late DateTime now;

  LocalPlayStats stats({Random random = const _FixedRandom(171)}) =>
      LocalPlayStats(now: () => now, random: random);

  Future<Map<String, dynamic>> exported(LocalPlayStats stats) async =>
      jsonDecode(await stats.exportJson()) as Map<String, dynamic>;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    now = DateTime(2026, 10, 16, 21);
  });

  test('Given two days of play, When the stats are exported, Then each day '
      'and the totals add up', () async {
    // Given: on the first day, a daily run lost in round 2, then a world run
    // that beat its boss after a revive and opened Gravity
    final log = stats();
    const daily = [
      AnalyticsEvent.runStart(mode: .daily, world: .rubble),
      AnalyticsEvent.jokerPick(id: .twin, offered: [.twin, .combo, .saver]),
      AnalyticsEvent.roundEnd(round: 1, score: 260, won: true),
      AnalyticsEvent.roundEnd(round: 2, score: 300, won: false),
      AnalyticsEvent.runEnd(starsEarned: 0, total: 560, won: false),
    ];
    const world = [
      AnalyticsEvent.runStart(mode: .world, world: .rubble),
      AnalyticsEvent.jokerPick(id: .combo, offered: [.combo, .twin, .tiny]),
      AnalyticsEvent.roundEnd(round: 1, score: 300, won: true),
      AnalyticsEvent.roundEnd(round: 2, score: 600, won: true),
      AnalyticsEvent.revive(source: .ad),
      AnalyticsEvent.roundEnd(round: 3, score: 950, won: true),
      AnalyticsEvent.roundEnd(round: 4, score: 1500, won: true),
      AnalyticsEvent.roundEnd(round: 5, score: 2100, won: true),
      AnalyticsEvent.runEnd(starsEarned: 2, total: 5450, won: true),
      AnalyticsEvent.worldUnlock(world: .gravity),
    ];
    [...daily, ...world].forEach(log.log);

    // and the next morning, a practice run lost in round 1
    now = DateTime(2026, 10, 17, 8);
    const practice = [
      AnalyticsEvent.runStart(mode: .practice, world: .rubble),
      AnalyticsEvent.roundEnd(round: 1, score: 120, won: false),
      AnalyticsEvent.runEnd(starsEarned: 0, total: 120, won: false),
    ];
    practice.forEach(log.log);

    // When
    final summary = await exported(log);

    // Then
    expect(summary['daysPlayed'], 2);
    expect(summary['exportedOn'], '2026-10-17');
    expect(summary['totals'], {
      'offers': {'twin': 2, 'combo': 2, 'saver': 1, 'tiny': 1},
      'picks': {'twin': 1, 'combo': 1},
      'revives': 1,
      'roundsReached': {'1': 3, '2': 2, '3': 1, '4': 1, '5': 1},
      'runs': 3,
      'runsWon': 1,
      'worldUnlocks': ['gravity'],
    });
    expect((summary['days'] as Map)['2026-10-16'], {
      'offers': {'twin': 2, 'combo': 2, 'saver': 1, 'tiny': 1},
      'picks': {'twin': 1, 'combo': 1},
      'revives': 1,
      'roundsReached': {'1': 2, '2': 2, '3': 1, '4': 1, '5': 1},
      'runs': 2,
      'runsWon': 1,
      'worldUnlocks': ['gravity'],
    });
    expect((summary['days'] as Map)['2026-10-17'], {
      'offers': <String, int>{},
      'picks': <String, int>{},
      'revives': 0,
      'roundsReached': {'1': 1},
      'runs': 1,
      'runsWon': 0,
      'worldUnlocks': <String>[],
    });
  });

  test('Given a device, When it exports twice, across relaunches, Then its '
      'random install id stays the same', () async {
    // Given
    final first = await exported(stats(random: const _FixedRandom(171)));

    // When: a later launch, which would draw another id
    final again = await exported(stats(random: const _FixedRandom(7)));

    // Then
    expect(first['installId'], 'abababababababababababababababab');
    expect(again['installId'], first['installId']);
  });

  test('Given nothing played yet, When the stats are exported, Then the '
      'summary is empty but complete', () async {
    // When
    final summary = await exported(stats());

    // Then
    expect(summary['schema'], 1);
    expect(summary['daysPlayed'], 0);
    expect(summary['days'], isEmpty);
    expect((summary['totals'] as Map)['runs'], 0);
  });

  test('Given a log that cannot be read, When an event is counted, Then the '
      'log starts afresh', () async {
    // Given
    SharedPreferences.setMockInitialValues({'playStats': 'not json'});
    final log = stats();

    // When
    log.log(const .runStart(mode: .daily, world: .rubble));
    final summary = await exported(log);

    // Then
    expect((summary['totals'] as Map)['runs'], 1);
  });

  test('Given an export under way, When an event is counted meanwhile, Then '
      'the next export has it', () async {
    // Given
    final log = stats();
    final first = log.exportJson();

    // When
    log.log(const .runStart(mode: .daily, world: .rubble));
    await first;
    final summary = await exported(log);

    // Then
    expect((summary['totals'] as Map)['runs'], 1);
  });

  test('Given a day an earlier build wrote without some counters, When the '
      'stats are exported, Then those read as 0 and the log is kept', () async {
    // Given: a day holding only its runs, under a known install id
    SharedPreferences.setMockInitialValues({
      'playStats': jsonEncode({
        'days': {
          '2026-10-15': {'runs': 2},
        },
        'installId': 'cafe',
        'version': 1,
      }),
    });

    // When
    final summary = await exported(stats());

    // Then
    expect(summary['installId'], 'cafe');
    expect((summary['days'] as Map)['2026-10-15'], {
      'offers': <String, int>{},
      'picks': <String, int>{},
      'revives': 0,
      'roundsReached': <String, int>{},
      'runs': 2,
      'runsWon': 0,
      'worldUnlocks': <String>[],
    });
  });

  test('Given stats counted, When they are discarded, Then nothing is kept on '
      'the device, the events logged before included', () async {
    // Given
    final played = stats()..log(const .revive(source: .owned));

    // When
    await played.discard();

    // Then
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('playStats'), isNull);
  });
}
