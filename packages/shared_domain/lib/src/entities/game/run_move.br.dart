import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_domain/src/entities/game/cell.br.dart';
import 'package:shared_domain/src/entities/game/joker_id.dart';

part 'run_move.br.freezed.dart';

/// One action of the player. A run is its seed and its moves: replaying them
/// rebuilds it exactly, which is what lets a server check a score later.
@freezed
sealed class RunMove with _$RunMove {
  /// Ends the run after a lost round.
  const factory RunMove.end() = EndMove;

  const factory RunMove.pick({required JokerId id}) = PickMove;

  const factory RunMove.place({required Cell anchor, required int trayIndex}) =
      PlaceMove;

  const factory RunMove.revive() = ReviveMove;
}
