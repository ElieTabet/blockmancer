import 'package:flutter/widgets.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:shared_domain/shared_domain.dart';

String worldName(BuildContext context, WorldId id) {
  final worlds = context.t.game.worlds;

  return switch (id) {
    .fog => worlds.fog,
    .gravity => worlds.gravity,
    .mirror => worlds.mirror,
    .rubble => worlds.rubble,
    .speed => worlds.speed,
  };
}
