import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_presentation/src/providers_internal.br.dart';
import 'package:shared_domain/shared_domain.dart';

/// Each joker's glyph, drawn in its kind's colour until its art is bundled:
/// one map, so art replaces a glyph by dropping `assets/jokers/<id>.png` in
/// the assets package, with no change here.
const jokerGlyphs = <JokerId, IconData>{
  .anchor: Icons.anchor_rounded,
  .avalanche: Icons.landslide_rounded,
  .bigbox: Icons.inventory_2_rounded,
  .brink: Icons.warning_amber_rounded,
  .collector: Icons.collections_bookmark_rounded,
  .column: Icons.view_column_rounded,
  .combo: Icons.bolt_rounded,
  .ember: Icons.local_fire_department_rounded,
  .finisher: Icons.sports_score_rounded,
  .fullhouse: Icons.home_rounded,
  .hattrick: Icons.looks_3_rounded,
  .heavy: Icons.fitness_center_rounded,
  .lantern: Icons.lightbulb_rounded,
  .momentum: Icons.trending_up_rounded,
  .patience: Icons.hourglass_bottom_rounded,
  .pockets: Icons.shopping_bag_rounded,
  .precision: Icons.gps_fixed_rounded,
  .prism: Icons.change_history_rounded,
  .quarry: Icons.terrain_rounded,
  .saver: Icons.savings_rounded,
  .sprinter: Icons.directions_run_rounded,
  .stonemason: Icons.foundation_rounded,
  .sweep: Icons.cleaning_services_rounded,
  .symmetry: Icons.flip_rounded,
  .tiny: Icons.handyman_rounded,
  .twin: Icons.drag_handle_rounded,
};

/// The design system's frame for [kind].
DSJokerFrame jokerFrameOf(JokerKind kind) => switch (kind) {
  .additiveMult => .additiveMult,
  .boardEffect => .boardEffect,
  .chips => .chips,
  .drawWeight => .drawWeight,
  .flatBonus => .flatBonus,
  .multiplicativeMult => .multiplicativeMult,
};

/// [joker]'s emblem, [size] across: its art when bundled, its glyph
/// otherwise. Decoration: the card says what it is.
final class JokerEmblem extends ConsumerWidget {
  const JokerEmblem({required this.joker, required this.size, super.key});

  final JokerId joker;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasArt = ref.watch(
      jokerArtProvider.select((art) => art.value?.contains(joker) ?? false),
    );

    if (hasArt) {
      return Image.asset(jokerArtPath(joker), height: size, width: size);
    }

    final frame = jokerFrameOf(ref.watch(jokerKindProvider(joker)));

    return Icon(jokerGlyphs[joker], color: frame.edge, size: size);
  }
}
