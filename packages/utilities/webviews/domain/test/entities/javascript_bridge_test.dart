import 'package:flutter_test/flutter_test.dart';
import 'package:webviews_domain/webviews_domain.dart';

String _labelFromJson(Map<String, dynamic> json) => json['label'] as String;

Map<String, dynamic> _identityFromJson(Map<String, dynamic> json) => json;

final class _VoidBridgeInvocationTracker {
  bool onErrorInvoked = false;
  bool onParsedInvoked = false;
  bool parserInvoked = false;
}

JavascriptBridge<void> _voidBridge(_VoidBridgeInvocationTracker tracker) =>
    JavascriptBridge<void>(
      name: 'testName',
      onParsed: (_) => tracker.onParsedInvoked = true,
      parser: (_) => tracker.parserInvoked = true,
      onError: (_, _) => tracker.onErrorInvoked = true,
    );

/// Runs [message] through a bridge that expects a `label` field, returning what the
/// handler received — `null` when the payload could not be turned into one.
Future<String?> _labelFrom(String message) async {
  String? parsed = 'unchanged';

  await JavascriptBridge<String>(
    name: 'test',
    onParsed: (value) => parsed = value,
    parser: _labelFromJson,
    onError: (_, _) => parsed = null,
  ).onMessageReceived(message);

  return parsed;
}

void main() {
  group('Receiving a payload from the page', () {
    test(
      'Given a bridge with a short text label field '
      'When the page sends a one-line object literal '
      'Then the value is available to the app',
      () async => expect(await _labelFrom('{"label": "hello"}'), 'hello'),
    );

    test('Given a bridge receiving a deeply nested payload with arrays '
        'When the page sends it as valid JSON '
        'Then the nested objects and arrays survive intact', () async {
      Map<String, dynamic>? parsed;

      await JavascriptBridge<Map<String, dynamic>>(
        name: 'test',
        onParsed: (value) => parsed = value,
        parser: _identityFromJson,
        onError: (_, _) => parsed = null,
      ).onMessageReceived(
        '{"chapters":[{"parameters":{"formats":["EPUB","PDF"]}}],'
        '"publication":{"language":"fr","pageCount":"20"}}',
      );

      final publication = parsed!['publication']! as Map<String, dynamic>;
      expect(publication['language'], 'fr');

      final chapter =
          (parsed!['chapters']! as List).first as Map<String, dynamic>;
      final parameters = chapter['parameters']! as Map<String, dynamic>;
      expect(parameters['formats'], containsAll(['EPUB', 'PDF']));
    });

    test(
      'Given a bridge with a short text label field '
      'When the page sends only whitespace '
      'Then nothing is produced',
      () async => expect(await _labelFrom('   \n  \t '), isNull),
    );

    test(
      'Given a bridge with a short text label field '
      'When the page sends an empty string '
      'Then nothing is produced',
      () async => expect(await _labelFrom(''), isNull),
    );

    test(
      'Given a bridge with a short text label field '
      'When the payload is not valid for the expected shape '
      'Then nothing is produced',
      () async => expect(await _labelFrom('{label:}'), isNull),
    );

    test(
      'Given a page that hands over an unstringified object literal '
      'When the bare keys are not valid JSON '
      'Then they are quoted so the payload still reaches the app',
      () async => expect(await _labelFrom('{label: hello}'), 'hello'),
    );

    test('Given a bridge whose parser rejects every map '
        'When the JSON decodes to a map '
        'Then a parse error is reported', () async {
      Object? capturedError;

      await JavascriptBridge<String>(
        name: 'test',
        onParsed: (_) {},
        parser: (_) => throw StateError('reject'),
        onError: (error, _) => capturedError = error,
      ).onMessageReceived('{"label": "ok"}');

      expect(
        capturedError,
        isA<StateError>().having((error) => error.message, 'message', 'reject'),
      );
    });
  });

  group('Receiving a signal that carries no payload', () {
    test('Given a close-style bridge with no structured payload '
        'When the page sends the JSON null literal as text '
        'Then the handler runs without parsing an object map', () async {
      final tracker = _VoidBridgeInvocationTracker();

      await _voidBridge(tracker).onMessageReceived('null');

      expect(tracker.onParsedInvoked, isTrue);
      expect(tracker.onErrorInvoked, isFalse);
      expect(tracker.parserInvoked, isFalse);
    });

    test(
      'Given a close-style bridge with no structured payload '
      'When the page sends the null literal padded with whitespace '
      'Then the handler still runs and the payload is not treated as an error',
      () async {
        final tracker = _VoidBridgeInvocationTracker();

        await _voidBridge(tracker).onMessageReceived('  null\n');

        expect(tracker.onParsedInvoked, isTrue);
        expect(tracker.onErrorInvoked, isFalse);
        expect(tracker.parserInvoked, isFalse);
      },
    );
  });

  group('Answering the page asynchronously', () {
    test('Given a bridge that answers the page asynchronously '
        'When the page asks a question the device can satisfy '
        'Then the answer is returned to the page', () async {
      final result = await JavascriptBridge<String>.async(
        name: 'eligibility',
        parser: _labelFromJson,
        onParsed: (value) async => value == 'yes',
      ).onMessageReceived('{"label": "yes"}');

      expect(result, isTrue);
    });

    test('Given a bridge that fails safely when the payload cannot be read '
        'When the page sends an undecodable payload '
        'Then the safe default is returned to the page', () async {
      final result = await JavascriptBridge<String>.async(
        name: 'eligibility',
        parser: _labelFromJson,
        onParsed: (_) async => true,
        onError: (_, _) => false,
      ).onMessageReceived('{label:}');

      expect(result, isFalse);
    });

    test(
      'Given a bridge that fails safely when the handler rejects the request '
      'When the parser rejects the payload '
      'Then the safe default is returned to the page',
      () async {
        final result = await JavascriptBridge<String>.async(
          name: 'eligibility',
          parser: (_) => throw StateError('reject'),
          onParsed: (_) async => true,
          onError: (_, _) => false,
        ).onMessageReceived('{"label": "ok"}');

        expect(result, isFalse);
      },
    );
  });
}
