import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_presentation/src/providers_di.br.dart';
import 'package:home_presentation/src/widgets/sheet_button.dart';
import 'package:l10n_application/l10n_application.dart';

/// Shows the moment every world's boss has fallen, over Home.
Future<void> showWorldCompleteSheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: DSColor.sheet,
      barrierColor: DSColor.scrim,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: .vertical(top: Radius.circular(28)),
      ),
      builder: (context) => const WorldCompleteSheet(),
    );

/// Every boss beaten, and the stars held out of all there are.
final class WorldCompleteSheet extends ConsumerWidget {
  const WorldCompleteSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final worlds = ref.watch(worldsProvider.select((worlds) => worlds.length));
    final stars = ref.watch(
      progressionProvider.select(
        (progression) =>
            progression.value?.worlds.values.fold(
              0,
              (held, world) =>
                  held +
                  [
                    world.stars.bossBeaten,
                    world.stars.noRevive,
                    world.stars.scoreThreshold,
                  ].where((earned) => earned).length,
            ) ??
            0,
      ),
    );
    final complete = context.t.home.complete;

    return SingleChildScrollView(
      padding: const .all(DSSpace.large),
      child: Column(
        crossAxisAlignment: .stretch,
        spacing: DSSpace.small,
        children: [
          Text(
            complete.title,
            style: DSFont.display(
              const TextStyle(
                color: DSColor.accent,
                fontSize: 26,
                fontWeight: .w600,
              ),
            ),
          ),
          Text(
            complete.body(count: worlds),
            style: const TextStyle(color: DSColor.white, fontSize: 15),
          ),
          Row(
            mainAxisAlignment: .center,
            spacing: DSSpace.xsmall,
            children: [
              const Icon(Icons.star_rounded, color: DSColor.accent, size: 32),
              Text(
                complete.stars(max: worlds * 3, stars: stars),
                style: DSFont.display(
                  const TextStyle(
                    color: DSColor.white,
                    fontSize: 24,
                    fontWeight: .w600,
                  ),
                ),
              ),
            ],
          ),
          SheetButton(
            label: complete.ok,
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
