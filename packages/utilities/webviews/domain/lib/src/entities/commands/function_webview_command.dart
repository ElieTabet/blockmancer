import 'package:webviews_domain/src/entities/commands/string_to_javascript_argument_converter.dart';
import 'package:webviews_domain/src/entities/webview_command.dart';

class FunctionWebviewCommand extends WebviewCommand {
  final String functionName;
  final StringToJavascriptArgumentConverter converter;
  final List<Object?> _arguments;

  FunctionWebviewCommand({
    required this.functionName,
    required List<Object?> arguments,
    this.converter = const StringToJavascriptArgumentConverter(),
  }) : _arguments = arguments;

  @override
  String toJavascript() =>
      '$functionName(${_arguments.map(converter.call).join(',')})';
}
