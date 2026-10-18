import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:telemetry/src/package_name.dart';
import 'package:timber/timber.dart';

/// The game's events as Firebase Analytics events, snake_case names and
/// parameters, a bool as 0 or 1 (Analytics takes only text and numbers).
/// Collected only while telemetry's switch is on; never throws or waits.
final class FirebaseAnalyticsSink implements AnalyticsSink {
  final FirebaseAnalytics? _injected;

  FirebaseAnalyticsSink({FirebaseAnalytics? analytics}) : _injected = analytics;

  FirebaseAnalytics get _analytics => _injected ?? FirebaseAnalytics.instance;

  @override
  void log(AnalyticsEvent event) {
    final (name, parameters) = firebaseEventOf(event);

    unawaited(_send(name, parameters));
  }

  Future<void> _send(String name, Map<String, Object> parameters) async {
    try {
      await _analytics.logEvent(name: name, parameters: parameters);
    } catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage: 'Logging $name failed',
        exception: error,
        stackTrace: stackTrace,
      );
    }
  }
}

/// [event] as Firebase's name and parameters.
(String, Map<String, Object>) firebaseEventOf(AnalyticsEvent event) =>
    switch (event) {
      JokerPickEvent(:final id, :final offered) => (
        'joker_pick',
        {
          'id': id.name,
          'offered': offered.map((joker) => joker.name).join(','),
        },
      ),
      ReviveEvent() => ('revive', const {}),
      RoundEndEvent(:final round, :final score, :final won) => (
        'round_end',
        {'round': round, 'score': score, 'won': won ? 1 : 0},
      ),
      RunEndEvent(:final starsEarned, :final total, :final won) => (
        'run_end',
        {'stars_earned': starsEarned, 'total': total, 'won': won ? 1 : 0},
      ),
      RunStartEvent(:final mode, :final world) => (
        'run_start',
        {'mode': mode.name, 'world': world.name},
      ),
      WorldUnlockEvent(:final world) => ('world_unlock', {'world': world.name}),
    };

/// Every event to each of [sinks], in order: test builds count both on the
/// device and in Firebase.
final class CompositeAnalyticsSink implements AnalyticsSink {
  const CompositeAnalyticsSink(this._sinks);

  final List<AnalyticsSink> _sinks;

  @override
  void log(AnalyticsEvent event) {
    for (final sink in _sinks) {
      sink.log(event);
    }
  }
}
