import 'package:app_update_presentation/src/providers.br.dart';
import 'package:assets/assets.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n_application/l10n_application.dart';

/// A version too old to play: the reason, and the store one tap away. There
/// is no way past it, back included; the player updates or leaves.
final class UpdateRequiredWidget extends StatelessWidget {
  const UpdateRequiredWidget({super.key});

  static const _logoWidth = 160.0;

  @override
  Widget build(BuildContext context) {
    final required = context.t.update.required;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: DSColor.primary,
        body: SafeArea(
          child: Padding(
            padding: const .all(DSSpace.large),
            child: Column(
              mainAxisAlignment: .center,
              spacing: DSSpace.medium,
              children: [
                Assets.images.logo.image(width: _logoWidth),
                Text(
                  required.title,
                  textAlign: .center,
                  style: DSFont.display(
                    const TextStyle(
                      color: DSColor.white,
                      fontSize: 28,
                      fontWeight: .w700,
                    ),
                  ),
                ),
                Text(
                  required.body,
                  textAlign: .center,
                  style: const TextStyle(
                    color: DSColor.textMuted,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: DSSpace.small),
                const UpdateButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Opens the store, where the new version waits.
final class UpdateButton extends ConsumerWidget {
  const UpdateButton({super.key});

  static const _height = 54.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) => DSPressable(
    onTap: () => ref.read(openStoreListingProvider)(),
    child: Container(
      height: _height,
      width: double.infinity,
      alignment: .center,
      decoration: BoxDecoration(
        color: DSColor.accent,
        borderRadius: .circular(DSCornerRadius.large),
      ),
      child: Text(
        context.t.update.required.button,
        style: const TextStyle(
          color: DSColor.primary,
          fontSize: 18,
          fontWeight: .w700,
        ),
      ),
    ),
  );
}
