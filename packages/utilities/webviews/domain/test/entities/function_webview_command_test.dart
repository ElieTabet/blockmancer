import 'package:flutter_test/flutter_test.dart';
import 'package:webviews_domain/webviews_domain.dart';

void main() {
  group('Calling a function on the page', () {
    test('Given a command with several string arguments '
        'When it is converted to JavaScript '
        'Then it is a call with comma-separated quoted arguments', () {
      final command = FunctionWebviewCommand(
        functionName: 'doSomething',
        arguments: ['arg1', 'arg2', 'arg3'],
      );

      expect(command.toJavascript(), "doSomething('arg1','arg2','arg3')");
    });

    test('Given a command with no arguments '
        'When it is converted to JavaScript '
        'Then it is a call with an empty argument list', () {
      final command = FunctionWebviewCommand(
        functionName: 'init',
        arguments: [],
      );

      expect(command.toJavascript(), 'init()');
    });
  });
}
