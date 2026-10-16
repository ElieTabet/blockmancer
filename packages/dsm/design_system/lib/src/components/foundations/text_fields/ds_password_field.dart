import 'package:design_system/src/components/foundations/icons/ds_suffix_icon.dart';
import 'package:design_system/src/components/foundations/text_fields/ds_text_field.dart';
import 'package:flutter/material.dart';

final class DSPasswordField extends StatefulWidget {
  /// Private Properties
  final GlobalKey<FormFieldState<String>>? _fieldKey;
  final bool _enabled;
  final String _placeholder;
  final List<String> _autofillHints;
  final bool _validateOnFocusLost;
  final FocusNode? _focusNode;
  final TextInputAction? _textInputAction;
  final FormFieldValidator<String> _validator;
  final Function(String)? _onSubmitted;
  final Function(String?)? _onChanged;
  final VoidCallback? _onEditingComplete;
  final Function(String?) _onSaved;

  /// Constructor
  const DSPasswordField({
    super.key,
    GlobalKey<FormFieldState<String>>? fieldKey,
    bool enabled = true,
    required String placeholder,
    List<String> autofillHints = const [AutofillHints.oneTimeCode],
    bool validateOnFocusLost = false,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
    required FormFieldValidator<String> validator,
    Function(String)? onSubmitted,
    Function(String?)? onChanged,
    VoidCallback? onEditingComplete,
    required Function(String?) onSaved,
  }) : _fieldKey = fieldKey,
       _enabled = enabled,
       _placeholder = placeholder,
       _autofillHints = autofillHints,
       _validateOnFocusLost = validateOnFocusLost,
       _focusNode = focusNode,
       _textInputAction = textInputAction,
       _validator = validator,
       _onSubmitted = onSubmitted,
       _onChanged = onChanged,
       _onEditingComplete = onEditingComplete,
       _onSaved = onSaved;

  /// Lifecycle
  @override
  State<DSPasswordField> createState() => _DSPasswordFieldState();
}

class _DSPasswordFieldState extends State<DSPasswordField> {
  /// Private Properties
  late bool _isObscureText;

  /// Lifecycle
  @override
  void initState() {
    super.initState();
    _isObscureText = true;
  }

  /// Layout
  @override
  Widget build(BuildContext context) {
    return DSTextField(
      fieldKey: widget._fieldKey,
      enabled: widget._enabled,
      placeholder: widget._placeholder,
      keyboardType: TextInputType.visiblePassword,
      obscureText: _isObscureText,
      enableSuggestions: false,
      autocorrect: false,
      autofillHints: widget._autofillHints,
      textCapitalization: TextCapitalization.none,
      enableIMEPersonalizedLearning: false,
      validateOnFocusLost: widget._validateOnFocusLost,
      focusNode: widget._focusNode,
      textInputAction: widget._textInputAction,
      suffixIcon: _suffixIcon,
      validator: widget._validator,
      onSubmitted: widget._onSubmitted,
      onChanged: widget._onChanged,
      onEditingComplete: widget._onEditingComplete,
      onSaved: widget._onSaved,
    );
  }

  Widget get _suffixIcon => DSSuffixIcon(
    icon: _isObscureText
        ? const Icon(Icons.visibility)
        : const Icon(Icons.visibility_off),
    onPressed: () {
      setState(() {
        _isObscureText = !_isObscureText;
      });
    },
  );
}
