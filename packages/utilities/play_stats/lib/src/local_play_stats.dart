import 'dart:convert';
import 'dart:math';

import 'package:play_stats/src/package_name.dart';
import 'package:play_stats/src/play_stats_log.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timber/timber.dart';

/// The game's [AnalyticsSink] for the testers: every event counted into the
/// device's day, kept as one JSON string, and summed up by [exportJson].
///
/// [log] returns at once; the writes run one after another, in the order the
/// events came, so none undoes another. A log that can't be read starts
/// afresh, under a new install id.
final class LocalPlayStats implements AnalyticsSink {
  LocalPlayStats({required DateTime Function() now, Random? random})
    : _now = now,
      _random = random ?? .secure();

  static const _key = 'playStats';
  final DateTime Function() _now;
  final Random _random;
  Future<void> _writes = .value();

  @override
  void log(AnalyticsEvent event) {
    final day = _dayOf(_now());

    _writes = _writes.then((_) async {
      try {
        final log = await _read();
        await _write(log.withEvent(event, day: day));
      } on Object catch (error, stackTrace) {
        Timber.e(
          tag: packageName,
          logMessage: 'Counting an event failed',
          exception: error,
          stackTrace: stackTrace,
        );
      }
    });
  }

  /// Forgets everything counted on this device, in its turn among the writes:
  /// a release build keeps no testers' stats. Never throws.
  Future<void> discard() {
    final discarded = _writes.then((_) async {
      try {
        await (await SharedPreferences.getInstance()).remove(_key);
      } on Object catch (error, stackTrace) {
        Timber.e(
          tag: packageName,
          logMessage: 'Discarding the play stats failed',
          exception: error,
          stackTrace: stackTrace,
        );
      }
    });

    _writes = discarded;

    return discarded;
  }

  /// The summary to share, once every event logged so far is counted. It
  /// takes its turn among the writes, so an event logged meanwhile is counted
  /// after it rather than lost to its write.
  Future<String> exportJson() {
    final export = _writes.then((_) async {
      final log = await _read();

      // Kept, so the install id stays the same from one export to the next.
      await _write(log);

      return jsonEncode(log.summary(exportedOn: _dayOf(_now())));
    });

    _writes = export.then((_) {}, onError: (Object _) {});

    return export;
  }

  Future<PlayStatsLog> _read() async {
    final raw = (await SharedPreferences.getInstance()).getString(_key);

    if (raw == null) return PlayStatsLog(installId: _newInstallId());

    try {
      return PlayStatsLog.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on Object catch (error, stackTrace) {
      // The type alone: a parse error quotes the stored text, install id and
      // all.
      Timber.e(
        tag: packageName,
        logMessage:
            'The play stats could not be read (${error.runtimeType}); '
            'starting afresh',
        stackTrace: stackTrace,
      );

      return PlayStatsLog(installId: _newInstallId());
    }
  }

  Future<void> _write(PlayStatsLog log) async {
    await (await SharedPreferences.getInstance()).setString(
      _key,
      jsonEncode(log.toJson()),
    );
  }

  /// 128 random bits, as hex.
  String _newInstallId() => [
    for (var byte = 0; byte < 16; byte++)
      _random.nextInt(256).toRadixString(16).padLeft(2, '0'),
  ].join();

  static String _dayOf(DateTime time) =>
      '${time.year.toString().padLeft(4, '0')}-'
      '${time.month.toString().padLeft(2, '0')}-'
      '${time.day.toString().padLeft(2, '0')}';
}
