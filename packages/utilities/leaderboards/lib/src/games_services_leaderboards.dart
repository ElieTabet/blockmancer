import 'package:games_services/games_services.dart' as games;
import 'package:leaderboards/src/leaderboards.dart';
import 'package:leaderboards/src/package_name.dart';
import 'package:timber/timber.dart';

/// [Leaderboards] over `games_services`: Game Center on iOS, Play Games on
/// Android; the plugin picks the platform's id.
final class GamesServicesLeaderboards implements Leaderboards {
  const GamesServicesLeaderboards();

  @override
  Future<bool> signIn() async {
    try {
      if (await games.GameAuth.isSignedIn) return true;

      await games.GameAuth.signIn();

      return await games.GameAuth.isSignedIn;
    } catch (error, stackTrace) {
      _log('Signing in to the leaderboards failed', error, stackTrace);

      return false;
    }
  }

  @override
  Future<void> show(LeaderboardIds board, {bool today = false}) async {
    try {
      if (!await signIn()) return;

      await games.Leaderboards.showLeaderboards(
        androidLeaderboardID: board.android,
        iOSLeaderboardID: board.ios,
        timeScope: today ? .today : .allTime,
      );
    } catch (error, stackTrace) {
      _log('Showing the leaderboard failed', error, stackTrace);
    }
  }

  @override
  Future<void> submit(LeaderboardIds board, int score) async {
    try {
      if (!await signIn()) return;

      await games.Leaderboards.submitScore(
        score: games.Score(
          androidLeaderboardID: board.android,
          iOSLeaderboardID: board.ios,
          value: score,
        ),
      );
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
