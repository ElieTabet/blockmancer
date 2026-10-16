import 'package:flutter/material.dart';
import 'package:design_system/src/components/foundations/buttons/ds_button.dart';

/// Factory class for creating primary button variants
final class DSPrimaryButton extends DSButton {
  // Private constructor - use factory constructors instead
  DSPrimaryButton._({
    super.key,
    required super.context,
    required super.title,
    required super.isLoading,
    required super.enabled,
    required super.onPressed,
    required super.size,
  }) : super.text(
         backgroundColor: Theme.of(context).colorScheme.primary,
         textColor: Theme.of(context).colorScheme.onPrimary,
       );

  DSPrimaryButton.small({
    Key? key,
    required String title,
    bool isLoading = false,
    bool enabled = true,
    required BuildContext context,
    required VoidCallback onPressed,
  }) : this._(
         key: key,
         title: title,
         isLoading: isLoading,
         enabled: enabled,
         onPressed: onPressed,
         context: context,
         size: DSButtonSize.small,
       );

  DSPrimaryButton.medium({
    Key? key,
    required String title,
    bool isLoading = false,
    bool enabled = true,
    required BuildContext context,
    required VoidCallback onPressed,
  }) : this._(
         key: key,
         title: title,
         isLoading: isLoading,
         enabled: enabled,
         onPressed: onPressed,
         context: context,
         size: DSButtonSize.medium,
       );

  DSPrimaryButton.large({
    Key? key,
    required String title,
    bool isLoading = false,
    bool enabled = true,
    required BuildContext context,
    required VoidCallback onPressed,
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
