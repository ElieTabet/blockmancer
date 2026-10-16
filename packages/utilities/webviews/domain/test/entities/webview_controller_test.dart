import 'package:flutter_test/flutter_test.dart';
import 'package:webviews_domain/webviews_domain.dart';

class _TestCommand extends WebviewCommand {
  final String _js;

  const _TestCommand(this._js);

  @override
  String toJavascript() => _js;
}

void main() {
  group('Driving a webview from outside it', () {
    test(
      'Given a controller that was never attached '
      'When its attachment is checked '
      'Then it reports as not attached',
      () => expect(WebviewController().isAttached, isFalse),
    );

    test('Given a controller attached to an evaluator '
        'When its attachment is checked '
        'Then it reports as attached', () {
      final controller = WebviewController()
        ..attach((source) async => 'result');

      expect(controller.isAttached, isTrue);
    });

    test('Given a controller that was attached then detached '
        'When its attachment is checked '
        'Then it reports as not attached', () {
      final controller = WebviewController()
        ..attach((source) async => 'result')
        ..detach();

      expect(controller.isAttached, isFalse);
    });

    test('Given a controller attached to a JavaScript evaluator '
        'When a command is executed through it '
        'Then the JavaScript is evaluated and the result comes back', () async {
      final controller = WebviewController()
        ..attach((source) async => 'evaluated: $source');

      expect(
        await controller.execute(const _TestCommand('alert("hello")')),
        'evaluated: alert("hello")',
      );
    });

    test(
      'Given a controller that is not attached '
      'When a command is executed through it '
      'Then it fails loudly rather than silently dropping the command',
      () => expect(
        () => WebviewController().execute(const _TestCommand('test')),
        throwsA(
          isA<StateError>().having(
            (error) => error.message,
            'message',
            contains('not attached'),
          ),
        ),
      ),
    );
  });
}
