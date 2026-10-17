import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_presentation/src/widgets/mode_card.dart';
import 'package:l10n_application/l10n_application.dart';

/// The first tab: what to play.
final class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) => AnnotatedRegion(
    value: SystemUiOverlayStyle.light,
    child: Scaffold(
      backgroundColor: DSColor.primary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const .all(DSSpace.large),
            child: Column(
              crossAxisAlignment: .stretch,
              spacing: DSSpace.small,
              children: [
                Text(
                  context.t.home.title,
                  textAlign: .center,
                  style: DSFont.display(
                    const TextStyle(
                      color: DSColor.white,
                      fontSize: 40,
                      fontWeight: .w700,
                    ),
                  ),
                ),
                Text(
                  context.t.home.tagline,
                  textAlign: .center,
                  style: const TextStyle(
                    color: DSColor.textMuted,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: DSSpace.medium),
                const Column(
                  crossAxisAlignment: .stretch,
                  children: [
                    ContinueCard(),
                    ModeCard(mode: .daily),
                    SizedBox(height: DSSpace.small),
                    ModeCard(mode: .practice),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
