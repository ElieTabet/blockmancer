import 'dart:async';

import 'package:game_domain/game_domain.dart' as game;
import 'package:play_stats/play_stats.dart';
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
