import 'package:external_links/external_links.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

/// Stands in for the operating system, which a test has no way to ask.
final class _FakeLauncher extends UrlLauncherPlatform {
  bool answer = true;
  final launched = <String>[];
  Object? throws;

  @override
  LinkDelegate? get linkDelegate => null;

  @override
  Future<bool> canLaunch(String url) async => true;

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    launched.add(url);

    final throws = this.throws;

    if (throws != null) throw throws;

    return answer;
  }
}

void main() {
  late _FakeLauncher launcher;

  setUp(() {
    launcher = _FakeLauncher();
    UrlLauncherPlatform.instance = launcher;
  });

  group('opening a link from an announcement', () {
    test('hands an http address to the device', () async {
      expect(await openExternalUrl('https://acme.example/news/12'), isTrue);
      expect(launcher.launched, ['https://acme.example/news/12']);
    });

    // A body is authored in a CMS, so a scheme the app never meant to honour
    // must do nothing rather than hand the device an unreviewed intent.
    test('refuses a scheme that is not http or https', () async {
      expect(await openExternalUrl('tel:+15145551234'), isFalse);
      expect(await openExternalUrl('mailto:someone@example.org'), isFalse);
      expect(await openExternalUrl('acme://open/12'), isFalse);
      expect(launcher.launched, isEmpty);
    });

    test('refuses an address that will not parse', () async {
      expect(await openExternalUrl('::not a url::'), isFalse);
      expect(launcher.launched, isEmpty);
    });

    test('answers false when the device declines to open it', () async {
      launcher.answer = false;

      expect(await openExternalUrl('https://acme.example'), isFalse);
    });
  });

  group('opening a mail draft', () {
    test('hands the address to the device', () async {
      expect(await composeEmail(Uri.parse('mailto:hello@example.org')), isTrue);
      expect(launcher.launched, ['mailto:hello@example.org']);
    });

    // The mail slot exists so the announcement guard can stay strict; it must
    // not become a way around it.
    test('refuses anything that is not a mailto', () async {
      expect(await composeEmail(Uri.parse('https://acme.example')), isFalse);
      expect(launcher.launched, isEmpty);
    });

    test('answers false when no mail app is configured', () async {
      launcher.answer = false;

      expect(
        await composeEmail(Uri.parse('mailto:hello@example.org')),
        isFalse,
      );
    });
  });

  // The boundary is the operating system, and it refuses for reasons the app
  // cannot enumerate. An escaping throw lands in the renderer's await as an
  // unhandled async error, where a tap that failed looks like one never wired.
  group('a launch the operating system will not perform', () {
    test('is an answer, not a throw, for either launcher', () async {
      launcher.throws = PlatformException(code: 'channel-error');

      expect(await openExternalUrl('https://acme.example'), isFalse);
      expect(
        await composeEmail(Uri.parse('mailto:hello@example.org')),
        isFalse,
      );
    });

    // Not a subtype of PlatformException: naming only that one let the failure
    // a native build one plugin behind the Dart code produces escape unlogged.
    test('is an answer when the plugin is absent from the binary', () async {
      launcher.throws = MissingPluginException('no implementation found');

      expect(await openExternalUrl('https://acme.example'), isFalse);
      expect(
        await composeEmail(Uri.parse('mailto:hello@example.org')),
        isFalse,
      );
    });
  });

  group('sharing text', () {
    test(
      'hands the text, the subject and the origin to the share sheet',
      () async {
        // Given
        final shared = <ShareParams>[];

        // When
        final opened = await shareText(
          '{"installId":"a1"}',
          origin: const Rect.fromLTWH(10, 20, 30, 40),
          share: (params) async {
            shared.add(params);

            return const ShareResult('', .dismissed);
          },
          subject: 'Test stats',
        );

        // Then
        expect(opened, isTrue);
        expect(shared.single.text, '{"installId":"a1"}');
        expect(shared.single.subject, 'Test stats');
        expect(
          shared.single.sharePositionOrigin,
          const Rect.fromLTWH(10, 20, 30, 40),
        );
      },
    );

    for (final (name, error) in [
      ('refuses', PlatformException(code: 'unavailable')),
      ('is missing from the build', MissingPluginException()),
    ]) {
      test('answers false when the share sheet $name', () async {
        // When
        final opened = await shareText('{}', share: (_) async => throw error);

        // Then
        expect(opened, isFalse);
      });
    }
  });
}
