import 'package:game_presentation/src/notifiers/game_ui_state.br.dart';
import 'package:game_presentation/src/providers_di.br.dart';
import 'package:game_presentation/src/providers_internal.br.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_domain/shared_domain.dart';

part 'game_notifier.br.g.dart';

/// The run on screen. Every rule is [GameRules]': this only forwards the
/// player's actions and keeps what each one did.
@riverpod
class GameNotifier extends _$GameNotifier {
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

  /// Starts today's run again from its first pick.
  void retry() => state = _fresh();

  void revive() => _apply(_rules.revive(state.run));

  GameRules get _rules => ref.read(gameRulesProvider);

  void _apply(Transition transition) {
    final (run, events) = transition;

    state = state.copyWith(
      lastEvents: events,
      moveCount: state.moveCount + 1,
      run: run,
    );
  }

  GameUiState _fresh() => GameUiState(
    lastEvents: const [],
    moveCount: 0,
    run: _rules.startRun(
      config: _rules.defaultConfig,
      seed: ref.read(runSeedProvider),
    ),
  );
}
