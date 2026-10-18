import 'package:app_update_domain/app_update_domain.dart';
import 'package:flutter_test/flutter_test.dart';

UpdateNeed _need(String appVersion, {String? latest, String? minimum}) =>
    updateNeedOf(
      appVersion: appVersion,
      platform: .ios,
      valueOf: (key) => switch (key) {
        'min_version_ios' => minimum,
        'latest_version_ios' => latest,
        _ => null,
      },
    );

void main() {
  group('the minimum version', () {
    test('Given the app at the minimum, Then it plays on', () {
      expect(_need('1.2.0', minimum: '1.2.0'), const UpdateNeed.none());
    });

    test('Given the app older than the minimum, Then it must update', () {
      expect(_need('1.1.9', minimum: '1.2.0'), const UpdateNeed.required());
    });

    test('Given the app newer than the minimum, Then it plays on', () {
      expect(_need('1.3.0', minimum: '1.2.0'), const UpdateNeed.none());
    });

    test('Given a malformed minimum, Then nobody is locked out', () {
      expect(_need('1.0.0', minimum: '1.2'), const UpdateNeed.none());
      expect(_need('1.0.0', minimum: 'soon'), const UpdateNeed.none());
    });

    test("Given the defaults' 0.0.0, Then nothing is asked", () {
      expect(
        _need('1.0.0', latest: '0.0.0', minimum: '0.0.0'),
        const UpdateNeed.none(),
      );
    });
  });

  group('the latest version', () {
    test('Given the app at the latest, Then nothing is offered', () {
      expect(_need('1.2.0', latest: '1.2.0'), const UpdateNeed.none());
    });

    test('Given the app older than the latest, Then the latest is offered', () {
      expect(
        _need('1.1.0', latest: '1.2.0'),
        const UpdateNeed.optional(latest: '1.2.0'),
      );
    });

    test('Given the app newer than the latest, Then nothing is offered', () {
      expect(_need('1.3.0', latest: '1.2.0'), const UpdateNeed.none());
    });

    test('Given a malformed latest, Then nothing is offered', () {
      expect(_need('1.0.0', latest: 'v2'), const UpdateNeed.none());
    });

    test('Given the app below both, Then the minimum wins', () {
      expect(
        _need('1.0.0', latest: '1.5.0', minimum: '1.2.0'),
        const UpdateNeed.required(),
      );
    });
  });

  test("Given the app's own version malformed, Then nothing is asked", () {
    expect(_need('unknown', minimum: '1.0.0'), const UpdateNeed.none());
  });
}
