import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_domain/src/entities/game/joker_id.dart';
import 'package:shared_domain/src/entities/game/joker_tuning.br.dart';
import 'package:shared_domain/src/entities/game/world_id.dart';

part 'joker_collection.br.freezed.dart';

/// Every joker, pair by pair, as the collection shows them: read from the
/// rules, so nothing in it depends on what the player has earned.
@freezed
abstract class JokerCollection with _$JokerCollection {
  const factory JokerCollection({
    /// The new player's pairs first, then each world's, then the stars'.
    required List<JokerPair> pairs,

    /// The tray the jokers play with, for describing Hat Trick.
    required int traySize,

    /// The numbers the jokers play with, for describing them.
    required JokerTuning tuning,
  }) = _JokerCollection;
}

/// Two partners, and how both are unlocked.
@freezed
abstract class JokerPair with _$JokerPair {
  const factory JokerPair({
    required JokerId first,
    required JokerId second,
    required JokerUnlock unlock,
  }) = _JokerPair;
}

/// What it takes to unlock a joker.
@freezed
sealed class JokerUnlock with _$JokerUnlock {
  /// Beating [world]'s boss for the first time.
  const factory JokerUnlock.boss({required WorldId world}) = BossUnlock;

  /// A new player has it.
  const factory JokerUnlock.starting() = StartingUnlock;

  /// Holding [count] stars across every world.
  const factory JokerUnlock.stars({required int count}) = StarsUnlock;
}
