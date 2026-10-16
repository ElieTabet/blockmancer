import 'package:shared_domain/shared_domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_ui_state.br.freezed.dart';

@freezed
abstract class GameUiState with _$GameUiState {
  const factory GameUiState({
    /// What the last action did, for the feedback that follows it.
    required List<GameEvent> lastEvents,

    /// Counts actions, so the same events twice still read as a new move.
    required int moveCount,
    required RunState run,
  }) = _GameUiState;
}
