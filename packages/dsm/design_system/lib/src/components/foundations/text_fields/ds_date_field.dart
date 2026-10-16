import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final class DSDateField extends StatefulWidget {
  /// Private Properties
  final GlobalKey<FormFieldState<String>>? _fieldKey;
  final String _placeholder;
  final DateTime _firstDate;
  final DateTime _lastDate;
  final String _format;
  final bool _validateOnFocusLost;
  final FocusNode? _focusNode;
  final VoidCallback _onTap;
  final Function(String?)? _onChanged;
  final Function(String?) _onSaved;
  final FormFieldValidator<String> _validator;

  DSDateField({
    super.key,
    GlobalKey<FormFieldState<String>>? fieldKey,
    required String placeholder,
    DateTime? firstDate,
    DateTime? lastDate,
    String format = 'MM/dd/yyyy',
    bool validateOnFocusLost = false,
    FocusNode? focusNode,
    required VoidCallback onTap,
    Function(String?)? onChanged,
    required Function(String?) onSaved,
    required FormFieldValidator<String> validator,
  }) : _fieldKey = fieldKey,
       _placeholder = placeholder,
       _firstDate = firstDate ?? DateTime(1900),
       _lastDate = lastDate ?? DateTime.now(),
       _format = format,
       _validateOnFocusLost = validateOnFocusLost,
       _focusNode = focusNode,
       _onTap = onTap,
       _onChanged = onChanged,
       _onSaved = onSaved,
       _validator = validator;

  @override
  State<DSDateField> createState() => _DSDateFieldState();
}

class _DSDateFieldState extends State<DSDateField> {
  late final TextEditingController _controller;
  late final DateFormat _formatter;

  DateTime? get _selectedDate {
    if (_controller.text.isEmpty) {
      return null;
    }

    try {
      return _formatter.parse(_controller.text);
    } catch (e) {
      // If parsing fails, return initial date
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _formatter = DateFormat(widget._format);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget._onTap();
        _pickDate(context);
      },
      child: DSTextField(
        fieldKey: widget._fieldKey,
        controller: _controller,
        enabled: false,
        placeholder: widget._placeholder,
        keyboardType: TextInputType.datetime,
        validateOnFocusLost: widget._validateOnFocusLost,
        focusNode: widget._focusNode,
        suffixIcon: _suffixIcon(context),
        validator: widget._validator,
        onChanged: widget._onChanged,
        onSaved: widget._onSaved,
      ),
    );
  }

  Widget _suffixIcon(BuildContext context) => DSSuffixIcon(
    icon: const Icon(Icons.calendar_month),
    onPressed: () => _pickDate(context),
  );

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: widget._firstDate,
      lastDate: widget._lastDate,
    );

    if (picked != null && picked != _selectedDate) {
      _controller.text = _formatter.format(picked);
    }
  }
}
