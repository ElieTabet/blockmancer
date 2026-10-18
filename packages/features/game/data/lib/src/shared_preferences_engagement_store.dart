import 'dart:convert';

import 'package:game_data/src/package_name.dart';
import 'package:game_domain/game_domain.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timber/timber.dart';

/// [EngagementStore] as one JSON string on the device. A field missing (one
/// a later build adds) reads as its default, so it grows without a
/// migration; a string that can't be read starts afresh.
final class SharedPreferencesEngagementStore implements EngagementStore {
  const SharedPreferencesEngagementStore();

  static const _key = 'engagement';

  @override
  Future<Engagement> load() async {
    final raw = (await SharedPreferences.getInstance()).getString(_key);

    if (raw == null) return const Engagement();

    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final lastInterstitialAt = json['lastInterstitialAt'] as String?;

      return Engagement(
        completedRuns: json['completedRuns'] as int? ?? 0,
        daysOpened: json['daysOpened'] as int? ?? 0,
        firstOpenedOn: json['firstOpenedOn'] as int?,
        lastInterstitialAt: lastInterstitialAt == null
            ? null
            : DateTime.parse(lastInterstitialAt),
        lastOpenedOn: json['lastOpenedOn'] as int?,
        runEndsSinceInterstitial: json['runEndsSinceInterstitial'] as int? ?? 0,
      );
    } on Object catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage:
            'The engagement could not be read (${error.runtimeType}); '
            'starting afresh',
        stackTrace: stackTrace,
      );

      return const Engagement();
    }
  }

  @override
  Future<void> save(Engagement engagement) async =>
      (await SharedPreferences.getInstance()).setString(
        _key,
        jsonEncode({
          'completedRuns': engagement.completedRuns,
          'daysOpened': engagement.daysOpened,
          'firstOpenedOn': engagement.firstOpenedOn,
          'lastInterstitialAt': engagement.lastInterstitialAt
              ?.toUtc()
              .toIso8601String(),
          'lastOpenedOn': engagement.lastOpenedOn,
          'runEndsSinceInterstitial': engagement.runEndsSinceInterstitial,
        }),
      );
}
