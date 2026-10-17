import 'dart:async';

import 'package:game_domain/game_domain.dart';
import 'package:game_presentation/src/notifiers/game_ui_state.br.dart';
import 'package:game_presentation/src/package_name.dart';
import 'package:game_presentation/src/providers_di.br.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:timber/timber.dart';

part 'game_notifier.br.g.dart';

/// The run on screen. Every rule is [GameRules]': this only forwards the
/// player's actions and keeps what each one did.
@riverpod
class GameNotifier extends _$GameNotifier {
  var _reviving = false;

  @override
  GameUiState build() {
    ref.watch(gameRulesProvider);

    return _fresh();
  }

  void endRun() => _apply(_rules.endRun(state.run));

  void pickJoker(JokerId id) => _apply(_rules.pickJoker(state.run, id: id));

  /// Ignores a drop that doesn't fit; the drag shadow has already said so.
  void place({required Cell anchor, required int trayIndex}) {
    if (!_rules.canPlace(state.run, anchor: anchor, trayIndex: trayIndex)) {
      return;
    }

    _apply(_rules.place(state.run, anchor: anchor, trayIndex: trayIndex));
  }

  /// Starts the same mode's run again from its first pick.
  void retry() => state = _fresh();

  /// Revives once the reward it costs has been earned. A second tap while the
  /// reward is showing is ignored.
  Future<void> revive() async {
    if (_reviving || !_rules.canRevive(state.run)) return;

    _reviving = true;
    final rewardedAction = ref.read(rewardedActionProvider);

    try {
      final granted = await rewardedAction();

      // The run may have been ended while the reward showed.
      if (!ref.mounted || !granted || !_rules.canRevive(state.run)) return;

      _apply(_rules.revive(state.run));
    } on Object catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage: 'The revive reward failed; the round stays lost',
        exception: error,
        stackTrace: stackTrace,
      );
    } finally {
      _reviving = false;
    }
  }

  GameRules get _rules => ref.read(gameRulesProvider);

  void _apply(Transition transition) {
    final (run, events) = transition;
    final ended = !_isOver(state.run) && _isOver(run);

    state = state.copyWith(
      lastEvents: events,
      moveCount: state.moveCount + 1,
      run: run,
    );

    if (ended) unawaited(_recordEnd(run));
  }

  bool _isOver(RunState run) => run.phase is WonPhase || run.phase is OverPhase;

  Future<void> _recordEnd(RunState run) async {
    final recordRunEnd = ref.read(recordRunEndProvider);

    try {
      final record = await recordRunEnd(state.mode, run.runTotal);

      // Not if the player has already started again.
      if (!ref.mounted || !identical(state.run, run)) return;

      state = state.copyWith(record: record);
    } on Object catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage: 'Recording the run end failed; no best is shown',
        exception: error,
        stackTrace: stackTrace,
      );
    }
  }

  GameUiState _fresh() {
    final (:mode, :seed) = ref.read(todaysDailyRunProvider);

    return GameUiState(
      lastEvents: const [],
      mode: mode,
      moveCount: 0,
      run: _rules.startRun(config: _rules.defaultConfig, seed: seed),
    );
  }
}
