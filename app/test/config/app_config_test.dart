import 'package:blockmancer_app/config/app_config.dart';
import 'package:blockmancer_app/config/env.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Env', () {
    test('parses the known values', () {
      expect(Env.fromValue('dev'), Env.dev);
      expect(Env.fromValue('prod'), Env.prod);
    });

    test('rejects anything else rather than silently defaulting', () {
      expect(() => Env.fromValue('staging'), throwsArgumentError);
    });
  });

  group('AppConfig', () {
    // No --dart-define is passed under `flutter test`, so this is what every
    // test run and every plain `flutter run` actually gets.
    test('is a dev build with no dart-define', () {
      final config = AppConfig.fromEnvironment();

      expect(config.env, Env.dev);
      expect(config.isProduction, isFalse);
    });

    test('isProduction tracks the environment', () {
      expect(const AppConfig(env: Env.prod).isProduction, isTrue);
    });
  });
}
