import 'package:design_system/src/components/foundations/buttons/ds_button.dart';
import 'package:flutter/material.dart';

final class DSSecondaryButton extends DSButton {
  // Private constructor - use factory constructors instead
  DSSecondaryButton._({
    required super.context,
    required super.enabled,
    required super.isLoading,
    required super.onPressed,
    required super.size,
    required super.title,
    super.key,
  }) : super.text(
         backgroundColor: Colors.transparent,
         textColor: Theme.of(context).colorScheme.onPrimary,
         borderColor: Theme.of(context).colorScheme.outline,
         borderWidth: 1.5,
       );

  DSSecondaryButton.small({
    required BuildContext context,
    required VoidCallback onPressed,
    required String title,
    bool enabled = true,
    bool isLoading = false,
    Key? key,
  }) : this._(
         key: key,
         title: title,
         isLoading: isLoading,
         enabled: enabled,
         onPressed: onPressed,
         context: context,
         size: DSButtonSize.small,
       );

  DSSecondaryButton.medium({
    required BuildContext context,
    required VoidCallback onPressed,
    required String title,
    bool enabled = true,
    bool isLoading = false,
    Key? key,
  }) : this._(
         key: key,
         title: title,
         isLoading: isLoading,
         enabled: enabled,
         onPressed: onPressed,
         context: context,
         size: DSButtonSize.medium,
       );

  DSSecondaryButton.large({
    required BuildContext context,
    required VoidCallback onPressed,
    required String title,
    bool enabled = true,
    bool isLoading = false,
    Key? key,
  }) : this._(
         key: key,
         title: title,
         isLoading: isLoading,
         enabled: enabled,
         onPressed: onPressed,
         context: context,
         size: DSButtonSize.large,
       );
}
