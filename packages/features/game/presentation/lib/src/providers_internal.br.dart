import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers_internal.br.g.dart';

/// Whether the tray piece at [index] fits anywhere — cached, so the board scan
/// runs once per change of the board or the tray, not in a widget's selector.
@riverpod
bool trayFits(Ref ref, int index) {
  ref.watch(
    gameProvider.select(
      (state) => (state.run.board, state.run.phase, state.run.tray[index]),
    ),
  );

  return ref
      .watch(gameRulesProvider)
      .fitsSomewhere(ref.read(gameProvider).run, trayIndex: index);
}
