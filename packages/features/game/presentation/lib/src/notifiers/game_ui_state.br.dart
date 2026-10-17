import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:game_domain/game_domain.dart';
import 'package:shared_domain/shared_domain.dart';

part 'game_ui_state.br.freezed.dart';

@freezed
abstract class GameUiState with _$GameUiState {
  const factory GameUiState({
    /// What the last action did, for the feedback that follows it.
    required List<GameEvent> lastEvents,

    /// Counts actions, so the same events twice still read as a new move.
    /// What the run counts for: which best it is measured against.
    required GameMode mode,
    required int moveCount,
    required RunState run,

    /// The guided first run: never saved, and never measured against a best.
    @Default(false) bool isTutorial,

    /// The finished run against its mode's best; null until the run has ended
    /// and the best has been read, and for good if it couldn't be.
    RunEndRecord? record,
  }) = _GameUiState;
}
