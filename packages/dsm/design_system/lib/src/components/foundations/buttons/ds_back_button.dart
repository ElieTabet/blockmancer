import 'package:design_system/src/components/foundations/buttons/ds_icon_button.dart';
import 'package:flutter/material.dart';

/// An app bar's `leading`, standing in for Material's [BackButton] so going
/// back presses like every other button: [DSIconButton]'s fade on iOS rather
/// than an ink splash.
final class DSBackButton extends StatelessWidget {
  const DSBackButton({super.key});

  @override
  Widget build(BuildContext context) => DSIconButton(
    icon: Icons.adaptive.arrow_back,
    onPressed: () => Navigator.maybePop(context),
    semanticsLabel: MaterialLocalizations.of(context).backButtonTooltip,
  );
}
