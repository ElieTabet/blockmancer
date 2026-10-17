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

    /// What the finished run earned on the map; null until the run has ended
    /// and it is kept, and for good in a run that earns nothing there.
    ProgressionChange? progress,

    /// Whether the run has just ended and what it earned is still being kept:
    /// its end waits, so a celebration is never beaten to the screen by the
    /// run's end, nor discarded by a quick Play again.
    @Default(false) bool progressPending,

    /// The finished run against its mode's best; null until the run has ended
    /// and the best has been read, and for good if it couldn't be.
    RunEndRecord? record,

    /// Whether the player has been shown what the run unlocked.
    @Default(false) bool unlocksSeen,
  }) = _GameUiState;
}
