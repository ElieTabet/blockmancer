import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:game_presentation/src/notifiers/beat.br.dart';
import 'package:shared_domain/shared_domain.dart';

part 'playback_state.br.freezed.dart';

@freezed
abstract class PlaybackState with _$PlaybackState {
  const factory PlaybackState({
    /// The beat playing; null once the move has played out.
    Beat? beat,

    /// Whether a touch skips to the end yet.
    @Default(false) bool canSkip,

    /// The run before the move, which the run total and the streak show until
    /// the move's points land; null shows the run's own.
    RunState? heldRun,

    /// The round score shown until the move's points land in it; null shows
    /// the run's own.
    int? heldScore,

    /// Counts the beats played, so the same beat twice running still starts
    /// its animation again.
    @Default(0) int step,
  }) = _PlaybackState;

  const PlaybackState._();

  bool get isPlaying => beat != null;
}
