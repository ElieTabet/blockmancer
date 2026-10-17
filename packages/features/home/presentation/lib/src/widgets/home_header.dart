import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_presentation/src/notifiers/home_notifier.br.dart';
import 'package:home_presentation/src/widgets/best_line.dart';
import 'package:home_presentation/src/widgets/settings_button.dart';
import 'package:home_presentation/src/widgets/spellbook_button.dart';
import 'package:l10n_application/l10n_application.dart';

/// The game's name, with practice, the Spellbook and Settings a tap away.
final class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) => Row(
    spacing: DSSpace.xsmall,
    children: [
      Expanded(
        // Shrunk rather than cut when a long practice best crowds it.
        child: FittedBox(
          fit: .scaleDown,
          alignment: .centerLeft,
          child: Text(
            context.t.home.title,
            style: DSFont.display(
              const TextStyle(
                color: DSColor.white,
                fontSize: 30,
                fontWeight: .w700,
              ),
            ),
          ),
        ),
      ),
      const PracticeButton(),
      const SpellbookButton(),
      const SettingsButton(),
    ],
  );
}

/// Practice, a run off the map, with its best on this device.
final class PracticeButton extends ConsumerWidget {
  const PracticeButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => DSPressable(
    onTap: () => ref.read(homeProvider.notifier).openPractice(context),
    child: Container(
      padding: const .symmetric(
        horizontal: DSSpace.small,
        vertical: DSSpace.xxsmall,
      ),
      decoration: const ShapeDecoration(
        color: DSColor.card,
        shape: StadiumBorder(
          side: BorderSide(color: DSColor.cardBorder, width: 2),
        ),
      ),
      child: Column(
        crossAxisAlignment: .start,
        mainAxisSize: .min,
        children: [
          Text(
            context.t.home.practice.title,
            style: const TextStyle(
              color: DSColor.white,
              fontSize: 14,
              fontWeight: .w700,
            ),
          ),
          const BestLine(mode: .practice),
        ],
      ),
    ),
  );
}
