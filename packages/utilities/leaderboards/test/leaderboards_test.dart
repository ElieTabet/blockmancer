import 'package:flutter_test/flutter_test.dart';
import 'package:leaderboards/leaderboards.dart';

void main() {
  test('with no leaderboards, signing in fails quietly and scores go '
      'nowhere', () async {
    const board = (android: 'CgkI', ios: 'blockmancer.daily_run');

    expect(await const NoLeaderboards().signIn(), isFalse);
    await const NoLeaderboards().submit(board, 9000);
    await const NoLeaderboards().show(board);
  });
}
