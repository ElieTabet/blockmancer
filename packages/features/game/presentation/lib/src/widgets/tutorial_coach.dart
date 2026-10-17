import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_presentation/src/notifiers/playback_notifier.br.dart';
import 'package:game_presentation/src/notifiers/tutorial_notifier.br.dart';
import 'package:l10n_application/l10n_application.dart';

/// The tutorial's line for the step the player is on, with the way out. Sits
/// over the top of the screen, clear of the tray, the board's lower rows the
/// hints point at, and the sheets, which rise from the bottom.
final class TutorialCoach extends ConsumerWidget {
  const TutorialCoach({super.key});

  static const _fade = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = ref.watch(tutorialProvider);
    final tutorial = context.t.game.tutorial;

    return AnimatedSwitcher(
      duration: _fade,
      child: switch (step) {
        null => const SizedBox.shrink(),
        .clear => _CoachCard(key: ValueKey(step), line: tutorial.clear),
        .drag => _CoachCard(key: ValueKey(step), line: tutorial.drag),
        .pick => _CoachCard(key: ValueKey(step), line: tutorial.pick),
        // A touch anywhere lets the held score land, the card included.
        .score => GestureDetector(
          key: ValueKey(step),
          behavior: .opaque,
          onTap: () => ref.read(playbackProvider.notifier).skip(),
          child: _CoachCard(hint: tutorial.scoreHint, line: tutorial.score),
        ),
      },
    );
  }
}

final class _CoachCard extends StatelessWidget {
  const _CoachCard({required this.line, this.hint, super.key});

  final String? hint;
  final String line;

  @override
  Widget build(BuildContext context) {
    final hint = this.hint;

    return Container(
      padding: const .fromLTRB(
        DSSpace.medium,
        DSSpace.small,
        DSSpace.small,
        DSSpace.small,
      ),
      decoration: ShapeDecoration(
        color: DSColor.sheet,
        shape: RoundedRectangleBorder(
          borderRadius: .circular(DSCornerRadius.large),
          side: const BorderSide(color: DSColor.accent, width: 2),
        ),
      ),
      child: Row(
        spacing: DSSpace.small,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              spacing: DSSpace.xxxsmall,
              children: [
                Text(
                  line,
                  style: DSFont.display(
                    const TextStyle(
                      color: DSColor.white,
                      fontSize: 17,
                      fontWeight: .w600,
                    ),
                  ),
                ),
                if (hint != null)
                  Text(
                    hint,
                    style: const TextStyle(
                      color: DSColor.textMuted,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          const _SkipButton(),
        ],
      ),
    );
  }
}

final class _SkipButton extends ConsumerWidget {
  const _SkipButton();

  static const _height = 36.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) => DSPressable(
    onTap: () => ref.read(tutorialProvider.notifier).skip(),
    child: Container(
      height: _height,
      padding: const .symmetric(horizontal: DSSpace.small),
      alignment: .center,
      decoration: BoxDecoration(
        color: DSColor.card,
        borderRadius: .circular(DSCornerRadius.intermediate),
      ),
      child: Text(
        context.t.game.tutorial.skip,
        style: const TextStyle(color: DSColor.accent, fontWeight: .w700),
      ),
    ),
  );
}
