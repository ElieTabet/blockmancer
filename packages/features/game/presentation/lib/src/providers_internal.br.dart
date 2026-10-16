import 'package:game_presentation/src/providers_di.br.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers_internal.br.g.dart';

/// Today's daily seed. The rules have no clock, so the date is read here — and
/// overridden in tests.
@riverpod
int runSeed(Ref ref) {
  final today = DateTime.now().toUtc();

  return ref
      .watch(gameRulesProvider)
      .dailySeed(day: today.day, month: today.month, year: today.year);
}
