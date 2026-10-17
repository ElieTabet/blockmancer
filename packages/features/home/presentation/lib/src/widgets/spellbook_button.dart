import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_presentation/src/notifiers/home_notifier.br.dart';
import 'package:l10n_application/l10n_application.dart';

final class SpellbookButton extends ConsumerWidget {
  const SpellbookButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => DSPressable(
    onTap: () => ref.read(homeProvider.notifier).openSpellbook(context),
    semanticLabel: context.t.home.spellbook.open,
    child: const SizedBox.square(
      dimension: kMinInteractiveDimension,
      child: Icon(
        Icons.auto_stories_rounded,
        color: DSColor.textMuted,
        size: 28,
      ),
    ),
  );
}
