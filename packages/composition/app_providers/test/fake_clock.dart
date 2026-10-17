import 'package:game_domain/game_domain.dart';

/// A clock stopped at [instant].
final class FakeClock implements Clock {
  final DateTime instant;

  const FakeClock(this.instant);

  @override
  DateTime now() => instant;
}
