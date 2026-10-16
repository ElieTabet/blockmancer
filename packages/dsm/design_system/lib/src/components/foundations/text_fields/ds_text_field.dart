import 'package:design_system/src/components/foundations/theme/ds_corner_radius.dart';
import 'package:flutter/material.dart';

class DSTextField extends StatelessWidget {
  /// Private Properties
  final GlobalKey<FormFieldState<String>> _fieldKey;
  final bool _enabled;
  final String _placeholder;
  final TextInputType? _keyboardType;
  final bool _autofocus;
  final bool _autocorrect;
  final bool _obscureText;
  final bool _enableSuggestions;
  final List<String> _autofillHints;
  final TextCapitalization _textCapitalization;
  final bool _enableIMEPersonalizedLearning;
  final bool _validateOnFocusLost;
  final FocusNode? _focusNode;
  final TextInputAction? _textInputAction;
  final Widget? _suffixIcon;
  final TextEditingController? _controller;
  final FormFieldValidator<String> _validator;
  final Function(String)? _onSubmitted;
  final Function(String?)? _onChanged;
  final VoidCallback? _onEditingComplete;
  final Function(String?) _onSaved;

  /// Constants
  final BorderRadius _borderRadius = BorderRadius.circular(
    DSCornerRadius.intermediate,
  );
  final double _focusedBorderWidth = 2.0;

  /// Constructor
  DSTextField({
    super.key,
    GlobalKey<FormFieldState<String>>? fieldKey,
    bool enabled = true,
    required String placeholder,
    required TextInputType? keyboardType,
    bool autofocus = false,
    bool autocorrect = false,
    bool obscureText = false,
    bool enableSuggestions = false,
    List<String>? autofillHints,
    TextCapitalization textCapitalization = TextCapitalization.none,
    bool enableIMEPersonalizedLearning = false,
    bool validateOnFocusLost = false,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
    Widget? suffixIcon,
    TextEditingController? controller,
    required FormFieldValidator<String> validator,
    Function(String)? onSubmitted,
    Function(String?)? onChanged,
    VoidCallback? onEditingComplete,
    required Function(String?) onSaved,
  }) : _fieldKey = fieldKey ?? GlobalKey<FormFieldState<String>>(),
       _validateOnFocusLost = validateOnFocusLost,
       _enabled = enabled,
       _placeholder = placeholder,
       _keyboardType = keyboardType,
       _autofocus = autofocus,
       _autocorrect = autocorrect,
       _obscureText = obscureText,
       _enableSuggestions = enableSuggestions,
       _autofillHints = autofillHints ?? const [],
       _textCapitalization = textCapitalization,
       _enableIMEPersonalizedLearning = enableIMEPersonalizedLearning,
       _focusNode = focusNode,
       _textInputAction = textInputAction,
       _suffixIcon = suffixIcon,
       _controller = controller,
       _validator = validator,
       _onSubmitted = onSubmitted,
       _onChanged = onChanged,
       _onEditingComplete = onEditingComplete,
       _onSaved = onSaved;

  /// Layout
  @override
  Widget build(BuildContext context) {
    return _buildContent(context: context);
  }

  /// Private Methods
  Widget _buildContent({required BuildContext context}) {
    return _buildMaterialTextField(context: context);
  }

  Widget _buildMaterialTextField({required BuildContext context}) {
    final textField = TextFormField(
      key: _fieldKey,
      enabled: _enabled,
      focusNode: _focusNode,
      decoration: _decoration(context: context),
      keyboardType:
          _keyboardType, // Use generic text to prevent autofill detection
      autocorrect: _autocorrect, // Force disable autocorrect
      obscureText: _obscureText,
      autofocus: _autofocus,
      enableSuggestions: _enableSuggestions, // Force disable suggestions
      autofillHints: _autofillHints, // Use one-time code to prevent autofill
      enableIMEPersonalizedLearning:
          _enableIMEPersonalizedLearning, // Force disable IME learning
      textCapitalization: _textCapitalization,
      textInputAction: _textInputAction,
      onFieldSubmitted: _onSubmitted,
      controller: _controller,
      validator: _validator,
      onChanged: _onChanged,
      onEditingComplete: _onEditingComplete,
      onSaved: _onSaved,
    );

    if (_validateOnFocusLost) {
      return Focus(
        onFocusChange: (hasFocus) {
          if (!hasFocus) {
            _fieldKey.currentState?.validate();
          }
        },
        child: textField,
      );
    } else {
      return textField;
    }
  }

  InputDecoration _decoration({required BuildContext context}) {
    final colorScheme = Theme.of(context).colorScheme;
    return InputDecoration(
      labelText: _placeholder,
      fillColor: colorScheme.inverseSurface.withValues(alpha: 0.06),
      filled: true,
      border: OutlineInputBorder(
        borderRadius: _borderRadius,
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: _borderRadius,
        borderSide: BorderSide(color: colorScheme.outline), // enabled color
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: _borderRadius,
        borderSide: BorderSide(
          // Not `primary`: a dark brand colour falls under the 3:1 a focus
          // indicator needs on the DS dark surface. Primary stays the colour
          // of the filled buttons.
          color: colorScheme.onSurface,
          width: _focusedBorderWidth,
        ), // focused
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: _borderRadius,
        borderSide: BorderSide(color: colorScheme.error), // error
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: _borderRadius,
        borderSide: BorderSide(
          color: colorScheme.error,
          width: _focusedBorderWidth,
        ), // focused error
      ),
      labelStyle: TextStyle(
        // Not `outline`: that is a hairline-border token, too low-contrast to
        // carry text (2.3:1 on the DS dark surface).
        color: colorScheme.onSurfaceVariant, // unfocused label
      ),
      floatingLabelStyle: TextStyle(
        color: colorScheme.onSurface, // focused (floating) label
      ),
      suffixIcon: _suffixIcon,
    );
  }
}
