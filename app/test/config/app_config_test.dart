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
    // test run and every plain `flutter run` actually gets. It has to be a
    // usable URL: an empty base URL fails deep inside Dio instead.
    test('falls back to the local MAMP API with no dart-define', () {
      final config = AppConfig.fromEnvironment();

      expect(config.env, Env.dev);
      expect(config.apiBaseUrl, 'http://localhost:8888/api/mobile/v1');
      expect(config.isProduction, isFalse);
    });

    // Dart's HttpClient never reads the system proxy, so an unconfigured build
    // has nowhere to fall back to — null here means a direct connection, and
    // Proxyman sees nothing.
    test('no proxy is resolved with no dart-define', () {
      expect(AppConfig.fromEnvironment().httpProxy, isNull);
    });

    // Apple assigns the id only once the app is listed; until then the update
    // screens have no App Store page to send anyone to.
    test('no App Store id is resolved with no dart-define', () {
      expect(AppConfig.fromEnvironment().iosAppStoreId, isNull);
    });

    test('the proxy address is ignored until the build opts in', () {
      expect(
        AppConfig.resolveHttpProxy(
          allowed: false,
          explicitProxy: '127.0.0.1:9090',
        ),
        isNull,
      );
    });

    test('opting in without an address stays direct', () {
      expect(
        AppConfig.resolveHttpProxy(allowed: true, explicitProxy: ''),
        isNull,
      );
    });

    test('both defines together resolve the proxy', () {
      expect(
        AppConfig.resolveHttpProxy(
          allowed: true,
          explicitProxy: '10.0.2.2:9090',
        ),
        '10.0.2.2:9090',
      );
    });

    test('isProduction tracks the environment', () {
      expect(
        const AppConfig(
          apiBaseUrl: 'https://x.test',
          env: Env.prod,
        ).isProduction,
        isTrue,
      );
    });
  });
}
