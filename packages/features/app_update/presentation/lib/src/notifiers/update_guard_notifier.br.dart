import 'dart:async';

import 'package:app_update_domain/app_update_domain.dart';
import 'package:app_update_presentation/src/providers_di.br.dart' as di;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_guard_notifier.br.g.dart';

/// Puts the update screen up the moment this version stops playing, wherever
/// the player is, once the game has finished with its last move.
///
/// `keepAlive`, and listened to from boot for the app's life (a read would
/// leave it paused): the minimum can be raised at any moment the app is open.
/// The splash decides at launch; the screen has no way out, so it is put up
/// once.
@Riverpod(keepAlive: true)
class UpdateGuardNotifier extends _$UpdateGuardNotifier {
  var _blocking = false;

  @override
  void build() => ref.listen(
    updateRequiredProvider,
    (_, required) => unawaited(_onCheck(required)),
    fireImmediately: true,
  );

  Future<void> _onCheck(AsyncValue<bool> required) async {
    if (_blocking || required.value != true) return;

    _blocking = true;
    await ref.read(di.whenGameSettledProvider)();

    if (!ref.mounted) return;

    ref.read(di.appUpdateRoutingProvider).onUpdateRequired();
  }
}
