import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final class DSTimeField extends StatefulWidget {
  /// Private Properties
  final GlobalKey<FormFieldState<String>>? _fieldKey;
  final String _placeholder;
  final String _format;
  final bool _validateOnFocusLost;
  final FocusNode? _focusNode;
  final VoidCallback _onTap;
  final Function(String?)? _onChanged;
  final Function(String?) _onSaved;
  final FormFieldValidator<String> _validator;

  /// Constructor
  const DSTimeField({
    super.key,
    GlobalKey<FormFieldState<String>>? fieldKey,
    required String placeholder,
    String? format,
    bool validateOnFocusLost = false,
    FocusNode? focusNode,
    required VoidCallback onTap,
    Function(String?)? onChanged,
    required Function(String?) onSaved,
    required FormFieldValidator<String> validator,
  }) : _fieldKey = fieldKey,
       _placeholder = placeholder,
       _format = format ?? 'h:mm a',
       _validateOnFocusLost = validateOnFocusLost,
       _focusNode = focusNode,
       _onTap = onTap,
       _onChanged = onChanged,
       _onSaved = onSaved,
       _validator = validator;

  @override
  State<DSTimeField> createState() => _DSTimeFieldState();
}

class _DSTimeFieldState extends State<DSTimeField> {
  /// Private Properties
  late final TextEditingController _controller;
  late final DateFormat _formatter;
  TimeOfDay? get _selectedTime {
    if (_controller.text.isEmpty) {
      return null;
    }

    try {
      return _parseTime(_controller.text);
    } catch (e) {
      // If parsing fails, return initial time
      return null;
    }
  }

  /// Lifecycle
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
        _pickTime(context);
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
    icon: const Icon(Icons.access_time),
    onPressed: () => _pickTime(context),
  );

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.input,
    );

    if (picked != null && picked != _selectedTime) {
      _controller.text = _formatTime(picked);
    }
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return _formatter.format(dt);
  }

  TimeOfDay _parseTime(String timeString) {
    final dt = _formatter.parse(timeString);
    return TimeOfDay(hour: dt.hour, minute: dt.minute);
  }
}
