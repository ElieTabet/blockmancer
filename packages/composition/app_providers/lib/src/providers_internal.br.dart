import 'dart:async';

import 'package:game_domain/game_domain.dart' as game;
import 'package:play_stats/play_stats.dart';
import 'package:remote_config/remote_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sounds/sounds.dart';

part 'providers_internal.br.g.dart';

// app_providers — layer-internal providers: the instances composition builds
// once and hands out.

/// One for the app's life: its sounds are loaded once, at launch.
@Riverpod(keepAlive: true)
GameSounds gameSounds(Ref ref) {
  final sounds = GameSounds();
  ref.onDispose(() => unawaited(sounds.dispose()));

  return sounds;
}

/// One for the app's life, so its writes stay in order. Its days are the
/// game's clock's.
@Riverpod(keepAlive: true)
LocalPlayStats playStats(Ref ref) =>
    LocalPlayStats(now: ref.watch(game.clockProvider).now);

/// One for the app's life. A test build fetches every few minutes, so a value
/// published in the console reaches a tester's next run; a release build twice
/// a day, as Remote Config's quotas expect.
@Riverpod(keepAlive: true)
RemoteValues remoteValues(Ref ref) => FirebaseRemoteValues(
  minimumFetchInterval: ref.watch(testToolsProvider)
      ? const Duration(minutes: 5)
      : const Duration(hours: 12),
);

/// The launch's fetch, started at boot and kept: the update check waits for
/// it, briefly, before deciding.
@Riverpod(keepAlive: true)
Future<void> remoteValuesFetched(Ref ref) =>
    ref.watch(remoteValuesProvider).fetchAndActivate();

/// Whether this is a test build: `TEST_TOOLS`, the app's to say.
@Riverpod(keepAlive: true)
bool testTools(Ref ref) => throw UnimplementedError(
  'testToolsProvider is overridden by featureBindingOverrides',
);
