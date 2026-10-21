import 'package:flutter/foundation.dart';
import 'package:games_services/games_services.dart' as games;
import 'package:leaderboards/src/leaderboards.dart';
import 'package:leaderboards/src/package_name.dart';
import 'package:timber/timber.dart';

/// [Leaderboards] over `games_services`: Game Center on iOS, Play Games on
/// Android; the plugin picks the platform's id.
///
/// Only the board's own button asks the player to sign in. On Android, asking
/// opens Google's account screens, full screen, even on a phone with no
/// account; Play Games signs a player in by itself where it can, so launch and
/// scores only read whether it did.
final class GamesServicesLeaderboards implements Leaderboards {
  const GamesServicesLeaderboards({
    GamesServicesCalls calls = const GamesServicesCalls(),
  }) : _calls = calls;

  final GamesServicesCalls _calls;

  /// Game Center signs a player in only once the app asks at launch, and
  /// shows its own sheet at most once; Play Games needs nothing.
  @override
  Future<void> restoreSignIn() async {
    if (defaultTargetPlatform != .iOS) return;

    try {
      await _calls.signIn();
    } catch (error, stackTrace) {
      _log('Signing in to Game Center failed', error, stackTrace);
    }
  }

  @override
  Future<void> show(LeaderboardIds board, {bool today = false}) async {
    try {
      if (!await _calls.isSignedIn()) {
        await _calls.signIn();

        if (!await _calls.isSignedIn()) return;
      }

      await _calls.show(board, today: today);
    } catch (error, stackTrace) {
      _log('Showing the leaderboard failed', error, stackTrace);
    }
  }

  @override
  Future<void> submit(LeaderboardIds board, int score) async {
    try {
      if (!await _calls.isSignedIn()) return;

      await _calls.submit(board, score);
    } catch (error, stackTrace) {
      _log('Submitting a score failed', error, stackTrace);
    }
  }

  static void _log(String message, Object error, StackTrace stackTrace) =>
      Timber.e(
        tag: packageName,
        logMessage: message,
        exception: error,
        stackTrace: stackTrace,
      );
}

/// The games_services calls the leaderboards make, apart so a test never
/// reaches a platform channel.
class GamesServicesCalls {
  const GamesServicesCalls();

  /// Asks no one: on Android, Play Games' `isAuthenticated`.
  Future<bool> isSignedIn() => games.GameAuth.isSignedIn;

  Future<void> show(LeaderboardIds board, {required bool today}) =>
      games.Leaderboards.showLeaderboards(
        androidLeaderboardID: board.android,
        iOSLeaderboardID: board.ios,
        timeScope: today ? .today : .allTime,
      );

  /// Shows the platform's sign-in when the player isn't signed in.
  Future<void> signIn() => games.GameAuth.signIn();

  Future<void> submit(LeaderboardIds board, int score) =>
      games.Leaderboards.submitScore(
        score: games.Score(
          androidLeaderboardID: board.android,
          iOSLeaderboardID: board.ios,
          value: score,
        ),
      );
}
