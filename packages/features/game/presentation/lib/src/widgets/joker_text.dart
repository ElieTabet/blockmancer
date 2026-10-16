import 'package:flutter/widgets.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:shared_domain/shared_domain.dart';

/// A joker's localised name and description.
({String description, String name}) jokerText(
  BuildContext context,
  JokerId id,
) {
  final jokers = context.t.game.jokers;

  return switch (id) {
    .bigbox => (
      description: jokers.bigbox.description,
      name: jokers.bigbox.name,
    ),
    .collector => (
      description: jokers.collector.description,
      name: jokers.collector.name,
    ),
    .column => (
      description: jokers.column.description,
      name: jokers.column.name,
    ),
    .combo => (description: jokers.combo.description, name: jokers.combo.name),
    .heavy => (description: jokers.heavy.description, name: jokers.heavy.name),
    .patience => (
      description: jokers.patience.description,
      name: jokers.patience.name,
    ),
    .pockets => (
      description: jokers.pockets.description,
      name: jokers.pockets.name,
    ),
    .precision => (
      description: jokers.precision.description,
      name: jokers.precision.name,
    ),
    .quarry => (
      description: jokers.quarry.description,
      name: jokers.quarry.name,
    ),
    .saver => (description: jokers.saver.description, name: jokers.saver.name),
    .stonemason => (
      description: jokers.stonemason.description,
      name: jokers.stonemason.name,
    ),
    .sweep => (description: jokers.sweep.description, name: jokers.sweep.name),
    .tiny => (description: jokers.tiny.description, name: jokers.tiny.name),
    .twin => (description: jokers.twin.description, name: jokers.twin.name),
  };
}

String jokerNames(BuildContext context, Iterable<JokerId> ids) =>
    ids.map((id) => jokerText(context, id).name).join(', ');
