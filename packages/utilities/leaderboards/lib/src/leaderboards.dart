/// A leaderboard's id on each platform.
typedef LeaderboardIds = ({String android, String ios});

/// The platform's leaderboards (Game Center, Play Games), behind a contract
/// naming no vendor. Nothing here ever blocks play: a player who can't or
/// won't sign in simply has no leaderboard.
abstract interface class Leaderboards {
  /// Signs the player in, quietly where the platform can. Never throws.
  Future<bool> signIn();

  /// Submits [score] to [board], signing in first if needed; the platform
  /// keeps the best. Never throws.
  Future<void> submit(LeaderboardIds board, int score);

  /// Shows [board], signing in first if needed; [today] opens it on today's
  /// scores where the platform keeps time scopes (Play Games, whose day ends
  /// at midnight Pacific time). Game Center shows a recurring board's
  /// current day whatever it is asked. Never throws.
  Future<void> show(LeaderboardIds board, {bool today = false});
}

/// No leaderboards: tests, and a platform not set up yet.
final class NoLeaderboards implements Leaderboards {
  const NoLeaderboards();

  @override
  Future<bool> signIn() async => false;

  @override
  Future<void> show(LeaderboardIds board, {bool today = false}) async {}

  @override
  Future<void> submit(LeaderboardIds board, int score) async {}
}
