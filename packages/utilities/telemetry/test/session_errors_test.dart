import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:telemetry/src/session_errors.dart';

void main() {
  test('Given an uncaught Flutter error, Then the session has seen one, and '
      'the handler before still ran', () {
    // Given
    final before = FlutterError.onError;
    final platformBefore = PlatformDispatcher.instance.onError;
    addTearDown(() {
      FlutterError.onError = before;
      PlatformDispatcher.instance.onError = platformBefore;
    });
    final reported = <FlutterErrorDetails>[];
    FlutterError.onError = reported.add;
    final errors = SessionErrors()..watch();

    // When
    FlutterError.onError!(FlutterErrorDetails(exception: StateError('broke')));

    // Then
    expect(errors.seen, isTrue);
    expect(reported, hasLength(1));
  });

  test('Given no error, Then the session has seen none', () {
    expect(SessionErrors().seen, isFalse);
  });
}
