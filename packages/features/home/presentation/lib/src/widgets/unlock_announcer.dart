import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_presentation/src/package_name.dart';
import 'package:home_presentation/src/providers_di.br.dart';
import 'package:home_presentation/src/widgets/joker_tile.dart';
import 'package:home_presentation/src/widgets/sheet_button.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:timber/timber.dart';

/// Announces the jokers unlocked outside a run, once: the first time the map
/// reads them, it marks them announced and shows them. Draws nothing itself.
final class UnlockAnnouncer extends ConsumerStatefulWidget {
  const UnlockAnnouncer({super.key});

  @override
  ConsumerState<UnlockAnnouncer> createState() => _UnlockAnnouncerState();
}

final class _UnlockAnnouncerState extends ConsumerState<UnlockAnnouncer> {
  var _announcing = false;

  @override
  void initState() {
    super.initState();
    ref.listenManual(
      progressionProvider.select(
        (progression) => progression.value?.unannouncedJokers,
      ),
      (_, jokers) {
        if (jokers == null || jokers.isEmpty || _announcing) return;

        _announcing = true;
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => _announce(jokers.toList()),
        );
      },
      fireImmediately: true,
    );
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();

  /// Marked before it shows, so a sheet left open by a killed app never
  /// comes back.
  Future<void> _announce(List<JokerId> jokers) async {
    final markAnnounced = ref.read(markJokersAnnouncedProvider);

    try {
      await markAnnounced();
    } on Object catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage: 'Marking the jokers announced failed',
        exception: error,
        stackTrace: stackTrace,
      );
    }

    if (mounted) await showJokersUnlockedSheet(context, jokers: jokers);

    _announcing = false;
  }
}

/// Shows [jokers] as newly unlocked, over Home.
Future<void> showJokersUnlockedSheet(
  BuildContext context, {
  required List<JokerId> jokers,
}) => showModalBottomSheet<void>(
  context: context,
  backgroundColor: DSColor.sheet,
  barrierColor: DSColor.scrim,
  isScrollControlled: true,
  useSafeArea: true,
  shape: const RoundedRectangleBorder(
    borderRadius: .vertical(top: Radius.circular(28)),
  ),
  builder: (context) => JokersUnlockedSheet(jokers: jokers),
);

/// The jokers the player holds the stars for, with the way back to the map.
final class JokersUnlockedSheet extends StatelessWidget {
  const JokersUnlockedSheet({required this.jokers, super.key});

  final List<JokerId> jokers;

  @override
  Widget build(BuildContext context) {
    final unlocks = context.t.game.unlocks;

    return SingleChildScrollView(
      padding: const .all(DSSpace.large),
      child: Column(
        crossAxisAlignment: .stretch,
        spacing: DSSpace.small,
        children: [
          Text(
            unlocks.label.toUpperCase(),
            style: const TextStyle(
              color: DSColor.info,
              fontSize: 12,
              fontWeight: .w700,
              letterSpacing: 1.6,
            ),
          ),
          Text(
            unlocks.newJokers,
            style: DSFont.display(
              const TextStyle(
                color: DSColor.accent,
                fontSize: 26,
                fontWeight: .w600,
              ),
            ),
          ),
          Text(
            unlocks.jokersNote,
            style: const TextStyle(color: DSColor.textMuted, fontSize: 13),
          ),
          for (final joker in jokers) JokerTile(joker: joker),
          SheetButton(
            label: unlocks.next,
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
