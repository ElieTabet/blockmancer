import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_domain/shared_domain.dart';

part 'input_lock_notifier.br.g.dart';

/// How long a clear's score breakdown takes to come in.
const scoreReveal = Duration(milliseconds: 600);

/// Whether the screen ignores touches: for [scoreReveal] after a move that
/// clears, so a finger already reaching for the next piece doesn't play it
/// before the breakdown has been seen.
@riverpod
class InputLockNotifier extends _$InputLockNotifier {
  Timer? _unlock;

  @override
  bool build() {
    ref
      ..onDispose(() => _unlock?.cancel())
      ..listen(
        gameProvider.select((state) => state.moveCount),
        (_, _) => _onMove(),
      );

    return false;
  }

  void _onMove() {
    final cleared = ref
        .read(gameProvider)
        .lastEvents
        .any((event) => event is LinesCleared);

    if (!cleared) return;

    _unlock?.cancel();
    state = true;
    _unlock = Timer(scoreReveal, () => state = false);
  }
}
