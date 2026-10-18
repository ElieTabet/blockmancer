import 'package:game_domain/src/contracts/clock.dart';
import 'package:game_domain/src/contracts/engagement_store.dart';
import 'package:game_domain/src/entities/engagement.br.dart';

/// Every change to the device's [Engagement], one after another, so a run's
/// end counted during a launch's write isn't lost to it.
class EngagementBehavior {
  EngagementBehavior({required Clock clock, required EngagementStore store})
    : _clock = clock,
      _store = store;

  final Clock _clock;
  Future<void> _last = Future.value();
  final EngagementStore _store;

  /// The engagement once every change asked for so far has been kept.
  Future<Engagement> read() => _after((engagement) => (engagement, engagement));

  /// Counts this launch's local day; true when it is the device's first
  /// launch, the session in which nothing may interrupt the player.
  Future<bool> recordLaunch() async {
    final today = _localDay(_clock.now());

    return _after((engagement) {
      final first = engagement.firstOpenedOn == null;

      return (
        engagement.lastOpenedOn == today
            ? engagement
            : engagement.copyWith(
                daysOpened: engagement.daysOpened + 1,
                firstOpenedOn: engagement.firstOpenedOn ?? today,
                lastOpenedOn: today,
              ),
        first,
      );
    });
  }

  /// A run played to its end.
  Future<void> countRunEnd() => _after(
    (engagement) => (
      engagement.copyWith(
        completedRuns: engagement.completedRuns + 1,
        runEndsSinceInterstitial: engagement.runEndsSinceInterstitial + 1,
      ),
      null,
    ),
  );

  /// An interstitial shown [at], which restarts the count of run ends.
  Future<void> recordInterstitial(DateTime at) => _after(
    (engagement) => (
      engagement.copyWith(lastInterstitialAt: at, runEndsSinceInterstitial: 0),
      null,
    ),
  );

  Future<T> _after<T>((Engagement, T) Function(Engagement) change) {
    final result = _last.then((_) async {
      final before = await _store.load();
      final (after, answer) = change(before);

      if (after != before) await _store.save(after);

      return answer;
    });

    _last = result.then((_) {}, onError: (Object _) {});

    return result;
  }

  static int _localDay(DateTime now) {
    final local = now.toLocal();

    return local.year * 10000 + local.month * 100 + local.day;
  }
}
