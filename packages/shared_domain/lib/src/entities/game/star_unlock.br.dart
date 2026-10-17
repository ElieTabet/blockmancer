import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_domain/src/entities/game/joker_id.dart';

part 'star_unlock.br.freezed.dart';

/// Jokers unlocked once the player holds [stars] stars across every world.
@freezed
abstract class StarUnlock with _$StarUnlock {
  const factory StarUnlock({
    required List<JokerId> jokers,
    required int stars,
  }) = _StarUnlock;
}
