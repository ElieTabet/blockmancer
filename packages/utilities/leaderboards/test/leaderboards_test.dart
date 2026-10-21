import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leaderboards/leaderboards.dart';

const _daily = (android: 'CgkI', ios: 'blockmancer.daily_run');

/// The platform as the leaderboards see it: whether the player is signed in,
/// whether they accept the sign-in when asked, and what was asked of it.
final class _FakeCalls implements GamesServicesCalls {
  _FakeCalls({this.accepts = false, this.signedIn = false});

  final bool accepts;
  final calls = <String>[];
  bool signedIn;

  @override
  Future<bool> isSignedIn() async => signedIn;

  @override
  Future<void> show(LeaderboardIds board, {required bool today}) async =>
      calls.add('show${today ? ' today' : ''}');

  @override
  Future<void> signIn() async {
    calls.add('ask to sign in');
    signedIn = accepts;
  }

  @override
  Future<void> submit(LeaderboardIds board, int score) async =>
      calls.add('submit $score');
}

void main() {
  tearDown(() => debugDefaultTargetPlatformOverride = null);

  group('On Android', () {
    setUp(() => debugDefaultTargetPlatformOverride = TargetPlatform.android);

    test('Given a player not signed in to Play Games, When the app starts, '
        'Then no sign-in screen is shown', () async {
      // Given
      final platform = _FakeCalls();

      // When
      await GamesServicesLeaderboards(calls: platform).restoreSignIn();

      // Then
      expect(platform.calls, isEmpty);
    });

    test('Given a player not signed in, When a run ends, Then the score is '
        'dropped without asking them to sign in', () async {
      // Given
      final platform = _FakeCalls(accepts: true);

      // When
      await GamesServicesLeaderboards(calls: platform).submit(_daily, 9000);

      // Then
      expect(platform.calls, isEmpty);
    });

    test('Given a player Play Games signed in by itself, When a run ends, '
        'Then the score is submitted', () async {
      // Given
      final platform = _FakeCalls(signedIn: true);

      // When
      await GamesServicesLeaderboards(calls: platform).submit(_daily, 9000);

      // Then
      expect(platform.calls, ['submit 9000']);
    });

    test('Given a player not signed in, When they tap Leaderboard and sign '
        "in, Then today's board opens", () async {
      // Given
      final platform = _FakeCalls(accepts: true);

      // When
      await GamesServicesLeaderboards(
        calls: platform,
      ).show(_daily, today: true);

      // Then
      expect(platform.calls, ['ask to sign in', 'show today']);
    });

    test('Given a player who refuses to sign in, When they tap Leaderboard, '
        'Then nothing opens', () async {
      // Given
      final platform = _FakeCalls();

      // When
      await GamesServicesLeaderboards(calls: platform).show(_daily);

      // Then
      expect(platform.calls, ['ask to sign in']);
    });

    test('Given a signed-in player, When they tap Leaderboard, Then the board '
        'opens without asking', () async {
      // Given
      final platform = _FakeCalls(signedIn: true);

      // When
      await GamesServicesLeaderboards(calls: platform).show(_daily);

      // Then
      expect(platform.calls, ['show']);
    });
  });

  test('Given an iPhone, When the app starts, Then Game Center is asked to '
      'sign the player in, as it must be for the boards to work', () async {
    // Given
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    final platform = _FakeCalls(accepts: true);

    // When
    await GamesServicesLeaderboards(calls: platform).restoreSignIn();

    // Then
    expect(platform.calls, ['ask to sign in']);
  });

  test('Given no leaderboards, When anything is asked, Then nothing '
      'happens', () async {
    await const NoLeaderboards().restoreSignIn();
    await const NoLeaderboards().submit(_daily, 9000);
    await const NoLeaderboards().show(_daily);
  });
}
