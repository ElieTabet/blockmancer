import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_presentation/src/providers_internal.br.dart';
import 'package:home_presentation/src/widgets/joker_text.dart';
import 'package:home_presentation/src/widgets/spellbook_card.dart';
import 'package:home_presentation/src/widgets/unlock_text.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:shared_domain/shared_domain.dart';

/// Opens [joker] in full over the Spellbook.
Future<void> showJokerSheet(BuildContext context, {required JokerId joker}) =>
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: DSColor.sheet,
      barrierColor: DSColor.scrim,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: .vertical(top: Radius.circular(28)),
      ),
      builder: (context) => JokerSheet(joker: joker),
    );

/// One joker: what it does, its partner and its stats once unlocked; how to
/// unlock it until then.
final class JokerSheet extends ConsumerWidget {
  const JokerSheet({required this.joker, super.key});

  final JokerId joker;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unlocked = ref.watch(jokerOwnedProvider(joker));

    return SingleChildScrollView(
      padding: const .all(DSSpace.large),
      child: unlocked
          ? UnlockedJokerDetails(joker: joker)
          : LockedJokerDetails(joker: joker),
    );
  }
}

final class UnlockedJokerDetails extends ConsumerWidget {
  const UnlockedJokerDetails({required this.joker, super.key});

  final JokerId joker;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tuning = ref.watch(jokerTuningProvider);
    final partner = ref.watch(jokerPartnerProvider(joker));

    return Column(
      crossAxisAlignment: .stretch,
      spacing: DSSpace.small,
      children: [
        Text(
          jokerName(context, joker),
          style: DSFont.display(
            const TextStyle(
              color: DSColor.joker,
              fontSize: 26,
              fontWeight: .w600,
            ),
          ),
        ),
        Text(
          jokerDescription(context, joker, tuning),
          style: const TextStyle(color: DSColor.white, fontSize: 16),
        ),
        Text(
          context.t.home.spellbook.partner(name: jokerName(context, partner)),
          style: const TextStyle(
            color: DSColor.accent,
            fontSize: 14,
            fontWeight: .w600,
          ),
        ),
        const SizedBox(height: DSSpace.xsmall),
        JokerStatLines(joker: joker),
      ],
    );
  }
}

final class LockedJokerDetails extends ConsumerWidget {
  const LockedJokerDetails({required this.joker, super.key});

  final JokerId joker;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unlock = ref.watch(jokerUnlockProvider(joker));

    return Column(
      spacing: DSSpace.small,
      children: [
        const JokerSilhouette(size: 96),
        Text(
          context.t.home.spellbook.locked,
          style: DSFont.display(
            const TextStyle(
              color: DSColor.textMuted,
              fontSize: 26,
              fontWeight: .w600,
            ),
          ),
        ),
        Text(
          unlockText(context, unlock),
          textAlign: .center,
          style: const TextStyle(
            color: DSColor.white,
            fontSize: 16,
            fontWeight: .w600,
          ),
        ),
      ],
    );
  }
}
