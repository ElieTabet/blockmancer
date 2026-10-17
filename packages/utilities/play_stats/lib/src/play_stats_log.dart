import 'package:flutter/foundation.dart' show immutable;
import 'package:shared_domain/shared_domain.dart';

/// One day's numbers.
@immutable
final class DayStats {
  const DayStats({
    this.offers = const {},
    this.picks = const {},
    this.revives = 0,
    this.roundsReached = const {},
    this.runs = 0,
    this.runsWon = 0,
    this.worldUnlocks = const [],
  });

  /// A counter a later build added reads as 0 in a day an earlier one
  /// wrote, so a log never has to be thrown away for growing.
  factory DayStats.fromJson(Map<String, dynamic> json) => DayStats(
    offers: _counts(json['offers']),
    picks: _counts(json['picks']),
    revives: json['revives'] as int? ?? 0,
    roundsReached: _counts(json['roundsReached']),
    runs: json['runs'] as int? ?? 0,
    runsWon: json['runsWon'] as int? ?? 0,
    worldUnlocks: [
      ...json['worldUnlocks'] as List<dynamic>? ?? const [],
    ].cast<String>(),
  );

  /// Times each joker was among the offers, by name.
  final Map<String, int> offers;

  /// Times each joker was taken, by name.
  final Map<String, int> picks;
  final int revives;

  /// Runs that reached each round, by its number from 1: each round ends
  /// once, won or given up, however many revives it took.
  final Map<String, int> roundsReached;

  /// Runs started: a run counts from its starting pick.
  final int runs;
  final int runsWon;
  final List<String> worldUnlocks;

  DayStats operator +(DayStats other) => DayStats(
    offers: _sum(offers, other.offers),
    picks: _sum(picks, other.picks),
    revives: revives + other.revives,
    roundsReached: _sum(roundsReached, other.roundsReached),
    runs: runs + other.runs,
    runsWon: runsWon + other.runsWon,
    worldUnlocks: [...worldUnlocks, ...other.worldUnlocks],
  );

  DayStats withEvent(AnalyticsEvent event) => switch (event) {
    JokerPickEvent(:final id, :final offered) =>
      this +
          DayStats(
            offers: {for (final joker in offered) joker.name: 1},
            picks: {id.name: 1},
          ),
    ReviveEvent() => this + const DayStats(revives: 1),
    RoundEndEvent(:final round) =>
      this + DayStats(roundsReached: {'$round': 1}),
    RunEndEvent(:final won) => this + DayStats(runsWon: won ? 1 : 0),
    RunStartEvent() => this + const DayStats(runs: 1),
    WorldUnlockEvent(:final world) =>
      this + DayStats(worldUnlocks: [world.name]),
  };

  Map<String, Object> toJson() => {
    'offers': offers,
    'picks': picks,
    'revives': revives,
    'roundsReached': roundsReached,
    'runs': runs,
    'runsWon': runsWon,
    'worldUnlocks': worldUnlocks,
  };

  static Map<String, int> _counts(Object? json) => {
    for (final MapEntry(:key, :value)
        in (json as Map<String, dynamic>? ?? const {}).entries)
      key: value as int,
  };

  static Map<String, int> _sum(Map<String, int> a, Map<String, int> b) => {
    ...a,
    for (final MapEntry(:key, :value) in b.entries) key: (a[key] ?? 0) + value,
  };
}

/// Everything counted on this device, day by day, under a random install id
/// that says which device a summary came from and nothing about who uses it.
@immutable
final class PlayStatsLog {
  const PlayStatsLog({required this.installId, this.days = const {}});

  /// Reads a log any version up to [version] wrote; a later one is
  /// unreadable.
  factory PlayStatsLog.fromJson(Map<String, dynamic> json) {
    final written = json['version'];

    if (written is! int || written > version) {
      throw FormatException('Play stats version $written');
    }

    return PlayStatsLog._fromJson(json);
  }

  factory PlayStatsLog._fromJson(Map<String, dynamic> json) => PlayStatsLog(
    days: {
      for (final MapEntry(:key, :value)
          in (json['days'] as Map<String, dynamic>).entries)
        key: DayStats.fromJson(value as Map<String, dynamic>),
    },
    installId: json['installId'] as String,
  );

  /// Keyed by the device's local day, `yyyy-mm-dd`.
  final Map<String, DayStats> days;
  final String installId;

  /// The stored log's schema. A new counter needs no bump: older days read
  /// it as 0.
  static const version = 1;

  /// The summary a tester sends: every day, their totals, and on how many
  /// days a run was started.
  Map<String, Object> summary({required String exportedOn}) {
    final totals = days.values.fold(const DayStats(), (sum, day) => sum + day);

    return {
      'days': {
        for (final MapEntry(:key, :value) in days.entries) key: value.toJson(),
      },
      'daysPlayed': days.values.where((day) => day.runs > 0).length,
      'exportedOn': exportedOn,
      'installId': installId,
      'schema': 1,
      'totals': totals.toJson(),
    };
  }

  Map<String, Object> toJson() => {
    'days': {
      for (final MapEntry(:key, :value) in days.entries) key: value.toJson(),
    },
    'installId': installId,
    'version': version,
  };

  PlayStatsLog withEvent(AnalyticsEvent event, {required String day}) =>
      PlayStatsLog(
        days: {...days, day: (days[day] ?? const DayStats()).withEvent(event)},
        installId: installId,
      );
}
