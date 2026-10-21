/// A leaderboard's id on each platform.
typedef LeaderboardIds = ({String android, String ios});

/// The platform's leaderboards (Game Center, Play Games), behind a contract
/// naming no vendor. Nothing here ever blocks play: a player who can't or
/// won't sign in simply has no leaderboard, and is only ever asked from the
/// board itself.
abstract interface class Leaderboards {
  /// At launch: picks the player's sign-in up without putting a screen in
  /// their way where the platform allows. Never throws.
  Future<void> restoreSignIn();

  /// Submits [score] to [board] when the player is signed in, and drops it
  /// otherwise: a score never asks the player to sign in. The platform keeps
  /// the best. Never throws.
  Future<void> submit(LeaderboardIds board, int score);

  /// Shows [board], asking the player to sign in first if they aren't; [today]
  /// opens it on today's scores where the platform keeps time scopes (Play
  /// Games, whose day ends at midnight Pacific time). Game Center shows a
  /// recurring board's current day whatever it is asked. Never throws.
  Future<void> show(LeaderboardIds board, {bool today = false});
}

/// No leaderboards: tests, and a platform not set up yet.
final class NoLeaderboards implements Leaderboards {
  const NoLeaderboards();

  @override
  Future<void> restoreSignIn() async {}

  @override
  Future<void> show(LeaderboardIds board, {bool today = false}) async {}

  @override
  Future<void> submit(LeaderboardIds board, int score) async {}
}
