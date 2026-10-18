import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_presentation/src/providers_internal.br.dart';
import 'package:home_presentation/src/widgets/joker_tile.dart';
import 'package:home_presentation/src/widgets/points_text.dart';
import 'package:home_presentation/src/widgets/sheet_button.dart';
import 'package:home_presentation/src/widgets/world_name.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:shared_domain/shared_domain.dart';

/// Opens [world]'s sheet over Home; true once the player chose to play it.
Future<bool> showWorldSheet(
  BuildContext context, {
  required WorldId world,
}) async {
  final play = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: DSColor.sheet,
    barrierColor: DSColor.scrim,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: .vertical(top: Radius.circular(28)),
    ),
    builder: (context) => WorldSheet(world: world),
  );

  return play ?? false;
}

/// One world in full: where it stands, its boss, its three stars and what
/// beating it unlocks, and the way in when it is open. A world that isn't in
/// the game yet shows only its name.
final class WorldSheet extends ConsumerWidget {
  const WorldSheet({required this.world, super.key});

  final WorldId world;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playable = ref.watch(
      worldSummaryProvider(world).select((summary) => summary.playable),
    );
    final sheet = context.t.home.sheet;
    final rule = _bossRule(context, world);

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const .all(DSSpace.large),
        child: Column(
          crossAxisAlignment: .stretch,
          mainAxisSize: .min,
          spacing: DSSpace.small,
          children: [
            Column(
              crossAxisAlignment: .start,
              spacing: DSSpace.xxsmall,
              children: [
                _StatusLabel(world: world),
                Text(
                  worldName(context, world),
                  style: DSFont.display(
                    const TextStyle(
                      color: DSColor.accent,
                      fontSize: 26,
                      fontWeight: .w600,
                    ),
                  ),
                ),
              ],
            ),
            if (playable) ...[
              if (rule != null)
                Text(
                  rule,
                  style: const TextStyle(color: DSColor.white, fontSize: 15),
                ),
              _BossTarget(world: world),
              _Heading(sheet.stars),
              for (final star in _Star.values)
                _StarObjective(star: star, world: world),
              _Heading(sheet.unlocks),
              _Unlocks(world: world),
            ],
            _SheetAction(world: world),
          ],
        ),
      ),
    );
  }

  String? _bossRule(BuildContext context, WorldId world) {
    final rules = context.t.home.sheet.bossRule;

    return switch (world) {
      .fog => rules.fog,
      .gravity => rules.gravity,
      .rubble => rules.rubble,
      .tide => rules.tide,
      .mirror => null,
    };
  }
}

enum _Star { bossBeaten, noRevive, scoreThreshold }

final class _BossTarget extends ConsumerWidget {
  const _BossTarget({required this.world});

  final WorldId world;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final target = ref.watch(
      worldSummaryProvider(world).select((summary) => summary.bossTarget),
    );

    return Text(
      context.t.home.sheet.bossTarget(points: pointsText(context, target)),
      style: const TextStyle(
        color: DSColor.accent,
        fontSize: 15,
        fontWeight: .w700,
      ),
    );
  }
}

final class _Heading extends StatelessWidget {
  const _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const .only(top: DSSpace.xsmall),
    child: Text(
      text.toUpperCase(),
      style: const TextStyle(
        color: DSColor.info,
        fontSize: 12,
        fontWeight: .w700,
        letterSpacing: 1.6,
      ),
    ),
  );
}

/// The play button while the world is open: Replay once its boss is beaten
/// and a star is still missing. A locked world says what opens it instead.
final class _SheetAction extends ConsumerWidget {
  const _SheetAction({required this.world});

  final WorldId world;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (status, stars) = ref.watch(
      worldNodeProvider(world).select((node) => (node.status, node.stars)),
    );
    final sheet = context.t.home.sheet;
    final starMissing =
        !(stars.bossBeaten && stars.noRevive && stars.scoreThreshold);

    return switch (status) {
      .current => SheetButton(
        label: sheet.start,
        onTap: () => Navigator.of(context).pop(true),
      ),
      .done => SheetButton(
        label: starMissing ? sheet.replay : sheet.start,
        onTap: () => Navigator.of(context).pop(true),
      ),
      .locked => Padding(
        padding: const .only(top: DSSpace.xsmall),
        child: Text(
          sheet.lockedHint,
          textAlign: .center,
          style: const TextStyle(
            color: DSColor.textMuted,
            fontSize: 14,
            fontWeight: .w600,
          ),
        ),
      ),
      .comingSoon => const SizedBox.shrink(),
    };
  }
}

final class _StarObjective extends ConsumerWidget {
  const _StarObjective({required this.star, required this.world});

  final _Star star;
  final WorldId world;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final earned = ref.watch(
      worldNodeProvider(world).select(
        (node) => switch (star) {
          .bossBeaten => node.stars.bossBeaten,
          .noRevive => node.stars.noRevive,
          .scoreThreshold => node.stars.scoreThreshold,
        },
      ),
    );
    final stars = context.t.game.end.stars;
    final color = earned ? DSColor.white : DSColor.textMuted;

    return Row(
      spacing: DSSpace.xsmall,
      children: [
        Icon(
          earned ? Icons.star_rounded : Icons.star_outline_rounded,
          color: earned ? DSColor.accent : DSColor.textMuted,
          size: 22,
          semanticLabel: earned ? stars.earned : stars.missing,
        ),
        Expanded(
          child: switch (star) {
            .bossBeaten => _ObjectiveText(stars.bossBeaten, color: color),
            .noRevive => _ObjectiveText(stars.noRevive, color: color),
            .scoreThreshold => _ThresholdText(color: color, world: world),
          },
        ),
      ],
    );
  }
}

final class _ObjectiveText extends StatelessWidget {
  const _ObjectiveText(this.text, {required this.color});

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(color: color, fontSize: 14, fontWeight: .w600),
  );
}

final class _ThresholdText extends ConsumerWidget {
  const _ThresholdText({required this.color, required this.world});

  final Color color;
  final WorldId world;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final threshold = ref.watch(
      worldSummaryProvider(world).select((summary) => summary.starThreshold),
    );

    return _ObjectiveText(
      context.t.home.sheet.threshold(points: pointsText(context, threshold)),
      color: color,
    );
  }
}

final class _StatusLabel extends ConsumerWidget {
  const _StatusLabel({required this.world});

  final WorldId world;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(
      worldNodeProvider(world).select((node) => node.status),
    );
    final home = context.t.home;
    final (label, color) = switch (status) {
      .comingSoon => (home.map.comingSoon, DSColor.textMuted),
      .current => (home.sheet.current, DSColor.accent),
      .done => (home.sheet.done, DSColor.positive),
      .locked => (home.map.locked, DSColor.textMuted),
    };

    return Text(
      label.toUpperCase(),
      style: TextStyle(
        color: color,
        fontSize: 12,
        fontWeight: .w700,
        letterSpacing: 1.6,
      ),
    );
  }
}

/// A joker beating the world's boss unlocks, in the look of the game's joker
/// cards, marked once runs may offer it.
final class _Unlocks extends ConsumerWidget {
  const _Unlocks({required this.world});

  final WorldId world;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // The rules' unlocks, which never change while the app runs.
    final unlocks = ref.watch(
      worldSummaryProvider(world).select((summary) => summary.unlocks),
    );

    return Column(
      crossAxisAlignment: .stretch,
      spacing: DSSpace.xsmall,
      children: [for (final joker in unlocks) JokerTile(joker: joker)],
    );
  }
}
