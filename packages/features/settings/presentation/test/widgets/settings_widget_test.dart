import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:settings_domain/settings_domain.dart';

import '../fake_feedback.dart';
import '../fake_settings_store.dart';
import '../pump_settings.dart';

bool _switchOf(WidgetTester tester, String title) => tester
    .widget<Switch>(
      find.descendant(
        of: find.ancestor(of: find.text(title), matching: find.byType(Row)),
        matching: find.byType(Switch),
      ),
    )
    .value;

void main() {
  testWidgets('each switch shows what the player chose', (tester) async {
    // Given / When
    await pumpSettings(
      tester,
      store: FakeSettingsStore(
        const AppSettings(haptics: false, reduceMotion: true),
      ),
    );

    // Then
    expect(_switchOf(tester, 'Sound'), isTrue);
    expect(_switchOf(tester, 'Haptics'), isFalse);
    expect(_switchOf(tester, 'Reduce motion'), isTrue);
    expect(find.text('Calmer animations, no screen shake'), findsOneWidget);
  });

  for (final (title, read) in [
    ('Sound', (AppSettings settings) => settings.sound),
    ('Haptics', (AppSettings settings) => settings.haptics),
    ('Reduce motion', (AppSettings settings) => settings.reduceMotion),
    ('Daily reminder', (AppSettings settings) => settings.dailyReminder),
  ]) {
    testWidgets('tapping $title flips it, and it is kept', (tester) async {
      // Given
      final store = FakeSettingsStore();
      await pumpSettings(tester, store: store);
      final before = _switchOf(tester, title);

      // When
      await tester.tap(find.text(title));
      await tester.pumpAndSettle();

      // Then
      expect(_switchOf(tester, title), !before);
      expect(read(store.saved!), !before);
    });
  }

  testWidgets('a screen reader reads each switch with its name', (
    tester,
  ) async {
    // Given
    final semantics = tester.ensureSemantics();

    // When
    await pumpSettings(tester);

    // Then
    expect(
      tester.getSemantics(find.byType(Switch).first),
      isSemantics(label: 'Sound', isToggled: true),
    );
    semantics.dispose();
  });

  testWidgets('the switch itself flips its setting once', (tester) async {
    // Given
    final store = FakeSettingsStore();
    await pumpSettings(tester, store: store);

    // When
    await tester.tap(find.byType(Switch).first);
    await tester.pumpAndSettle();

    // Then
    expect(store.saved?.sound, isFalse);
  });

  testWidgets('choosing French shows the app in French, and it is kept', (
    tester,
  ) async {
    // Given
    final store = FakeSettingsStore();
    await pumpSettings(tester, store: store);

    // When
    await tester.tap(find.text('Français'));
    await tester.pumpAndSettle();

    // Then
    expect(store.saved?.language, AppLanguage.fr);
    expect(LocaleSettings.currentLocale, AppLocale.fr);
    expect(find.text('Réglages'), findsOneWidget);
  });

  testWidgets('choosing System follows the phone again', (tester) async {
    // Given: French chosen, on a phone in English
    final store = FakeSettingsStore(const AppSettings(language: .fr));
    LocaleSettings.setLocaleSync(.fr);
    await pumpSettings(tester, store: store);

    // When
    await tester.tap(find.text('Système'));
    await tester.pumpAndSettle();

    // Then
    expect(store.saved?.language, AppLanguage.system);
    expect(find.text('Settings'), findsOneWidget);
  });

  group('resetting progress', () {
    testWidgets('asks first', (tester) async {
      // Given
      final cleared = <String>[];
      await pumpSettings(tester, clearedProgress: cleared);

      // When
      await tester.ensureVisible(find.text('Reset progress'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Reset progress'));
      await tester.pumpAndSettle();

      // Then
      expect(find.text('Reset progress?'), findsOneWidget);
      expect(cleared, isEmpty);
    });

    testWidgets('cancelled, clears nothing', (tester) async {
      // Given
      final cleared = <String>[];
      final store = FakeSettingsStore(const AppSettings(tutorialSeen: true));
      await pumpSettings(tester, clearedProgress: cleared, store: store);
      await tester.ensureVisible(find.text('Reset progress'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Reset progress'));
      await tester.pumpAndSettle();

      // When
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Then
      expect(find.text('Reset progress?'), findsNothing);
      expect(cleared, isEmpty);
      expect(store.saved?.tutorialSeen, isTrue);
    });

    testWidgets('confirmed, clears the progress and the tutorial', (
      tester,
    ) async {
      // Given
      final cleared = <String>[];
      final store = FakeSettingsStore(const AppSettings(tutorialSeen: true));
      await pumpSettings(tester, clearedProgress: cleared, store: store);
      await tester.ensureVisible(find.text('Reset progress'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Reset progress'));
      await tester.pumpAndSettle();

      // When
      await tester.tap(find.text('Reset'));
      await tester.pumpAndSettle();

      // Then
      expect(find.text('Reset progress?'), findsNothing);
      expect(cleared, ['cleared']);
      expect(store.saved?.tutorialSeen, isFalse);
    });
  });

  testWidgets('Replay tutorial opens the tutorial', (tester) async {
    // Given
    final routing = await pumpSettings(tester);

    // When
    await tester.tap(find.text('Replay tutorial'));
    await tester.pump();

    // Then
    expect(routing.calls, ['replay tutorial']);
  });

  testWidgets(
    'Given a release build, When Settings opens, Then the Version row shows the version, without the build',
    (tester) async {
      // Given / When
      await pumpSettings(tester);

      // Then
      expect(find.text('Version'), findsOneWidget);
      expect(find.text('1.0.0'), findsOneWidget);
      expect(find.textContaining('(2)'), findsNothing);
    },
  );

  group('sending feedback', () {
    testWidgets(
      'Given a mail app, When Send feedback is tapped, Then a draft to support opens',
      (tester) async {
        // Given
        final mailApp = FakeMailApp();
        await pumpSettings(tester, mailApp: mailApp);

        // When
        await tester.ensureVisible(find.text('Send feedback'));
        await tester.tap(find.text('Send feedback'));
        await tester.pumpAndSettle();

        // Then
        expect(mailApp.drafts.single.path, 'support@elietabet.com');
        expect(find.text('No mail app'), findsNothing);
      },
    );

    testWidgets(
      'Given no mail app, When Send feedback is tapped, Then the address is shown to write to',
      (tester) async {
        // Given
        await pumpSettings(tester, mailApp: FakeMailApp(installed: false));

        // When
        await tester.ensureVisible(find.text('Send feedback'));
        await tester.tap(find.text('Send feedback'));
        await tester.pumpAndSettle();

        // Then
        expect(find.text('No mail app'), findsOneWidget);
        expect(
          find.text(
            "We couldn't open a mail app. Write to us at support@elietabet.com.",
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Given a mail app that fails to open, When Send feedback is tapped, Then the address is shown to write to',
      (tester) async {
        // Given
        await pumpSettings(tester, mailApp: FakeMailApp(broken: true));

        // When
        await tester.ensureVisible(find.text('Send feedback'));
        await tester.tap(find.text('Send feedback'));
        await tester.pumpAndSettle();

        // Then
        expect(tester.takeException(), isNull);
        expect(find.text('No mail app'), findsOneWidget);
      },
    );
  });

  group('sharing test stats', () {
    testWidgets(
      'Given a share sheet, When Share test stats is tapped, Then it opens '
      'with the stats, pointing from the row',
      (tester) async {
        // Given
        final shareSheet = FakeShareSheet();
        await pumpSettings(tester, shareSheet: shareSheet);
        await tester.ensureVisible(find.text('Share test stats'));
        await tester.pumpAndSettle();

        // When
        await tester.tap(find.text('Share test stats'));
        await tester.pumpAndSettle();

        // Then
        final shared = shareSheet.shared.single;
        expect(shared.text, contains('"installId": "ab12"'));
        expect(shared.text, contains('"version": "1.0.0"'));
        expect(shared.origin, isNotNull);
        expect(
          shared.origin!.contains(
            tester.getCenter(find.text('Share test stats')),
          ),
          isTrue,
        );
        expect(find.text("Couldn't share"), findsNothing);
      },
    );

    testWidgets(
      "Given a share sheet that doesn't open, When Share test stats is tapped, "
      'Then the player is told',
      (tester) async {
        // Given
        await pumpSettings(tester, shareSheet: FakeShareSheet(opens: false));
        await tester.ensureVisible(find.text('Share test stats'));
        await tester.pumpAndSettle();

        // When
        await tester.tap(find.text('Share test stats'));
        await tester.pumpAndSettle();

        // Then
        expect(find.text("Couldn't share"), findsOneWidget);
      },
    );
  });

  testWidgets(
    'Given Settings, When Rate Blockmancer is tapped, Then the store page '
    'opens',
    (tester) async {
      // Given
      final links = <String>[];
      await pumpSettings(tester, links: links);
      await tester.ensureVisible(find.text('Rate Blockmancer'));
      await tester.pumpAndSettle();

      // When
      await tester.tap(find.text('Rate Blockmancer'));
      await tester.pumpAndSettle();

      // Then
      expect(links, ['store page']);
    },
  );

  group('purchases', () {
    testWidgets(
      'Given the store, When Remove ads is tapped, Then its sheet opens, the '
      'price shown on the row',
      (tester) async {
        // Given
        final purchases = <String>[];
        await pumpSettings(tester, purchases: purchases);
        await tester.ensureVisible(find.text('Remove ads'));
        await tester.pumpAndSettle();

        // When
        await tester.tap(find.text('Remove ads'));
        await tester.pumpAndSettle();

        // Then
        expect(
          find.text(r'No more ads between runs, for good · $3.99'),
          findsOneWidget,
        );
        expect(purchases, ['buy']);
      },
    );

    testWidgets(
      "Given a store that can't be reached, When Remove ads is tapped, Then "
      'the player is told',
      (tester) async {
        // Given
        await pumpSettings(tester, removeAdsPrice: null, storeOpens: false);
        await tester.ensureVisible(find.text('Remove ads'));
        await tester.pumpAndSettle();

        // When
        await tester.tap(find.text('Remove ads'));
        await tester.pumpAndSettle();

        // Then
        expect(find.text('Store unavailable'), findsOneWidget);
      },
    );

    testWidgets(
      'Given Remove ads owned, When Settings opens, Then it thanks the player '
      'and offers nothing to buy',
      (tester) async {
        // Given / When
        await pumpSettings(tester, ownsRemoveAds: true);

        // Then
        expect(find.text('Ads removed. Thank you!'), findsOneWidget);
        expect(find.text('Remove ads'), findsNothing);
      },
    );

    testWidgets(
      'Given a purchase made before, When Restore purchases is tapped, Then '
      'it is restored and the player told',
      (tester) async {
        // Given
        await pumpSettings(tester, restoreFinds: true);
        await tester.ensureVisible(find.text('Restore purchases'));
        await tester.pumpAndSettle();

        // When
        await tester.tap(find.text('Restore purchases'));
        await tester.pumpAndSettle();

        // Then
        expect(find.text('Purchases restored'), findsOneWidget);
      },
    );

    testWidgets(
      'Given nothing bought, When Restore purchases is tapped, Then the player '
      'is told there was nothing to restore',
      (tester) async {
        // Given
        await pumpSettings(tester);
        await tester.ensureVisible(find.text('Restore purchases'));
        await tester.pumpAndSettle();

        // When
        await tester.tap(find.text('Restore purchases'));
        await tester.pumpAndSettle();

        // Then
        expect(find.text('Nothing to restore'), findsOneWidget);
      },
    );
  });

  group('privacy', () {
    testWidgets(
      'Given a player outside the EEA, When Settings opens, Then there are no '
      'privacy choices to change',
      (tester) async {
        // Given / When
        await pumpSettings(tester);

        // Then
        expect(find.text('Privacy choices'), findsNothing);
        expect(find.text('Privacy policy'), findsOneWidget);
      },
    );

    testWidgets(
      'Given a player in the EEA, When Privacy choices is tapped, Then the '
      'consent form opens again',
      (tester) async {
        // Given
        final links = <String>[];
        await pumpSettings(
          tester,
          consent: (canRequestAds: false, privacyOptionsRequired: true),
          links: links,
        );
        await tester.ensureVisible(find.text('Privacy choices'));
        await tester.pumpAndSettle();

        // When
        await tester.tap(find.text('Privacy choices'));
        await tester.pumpAndSettle();

        // Then
        expect(links, ['privacy options']);
      },
    );

    testWidgets(
      'Given Settings, When the privacy policy and support are tapped, Then '
      "each opens on the studio's site",
      (tester) async {
        // Given
        final links = <String>[];
        await pumpSettings(tester, links: links);

        // When
        for (final row in ['Privacy policy', 'Support']) {
          await tester.ensureVisible(find.text(row));
          await tester.pumpAndSettle();
          await tester.tap(find.text(row));
          await tester.pumpAndSettle();
        }

        // Then
        expect(links, [
          'https://studio.elietabet.com/privacy',
          'https://studio.elietabet.com/support',
        ]);
      },
    );
  });

  group('test tools', () {
    testWidgets(
      "Given a release build, When Settings opens, Then neither tester's row "
      'is there',
      (tester) async {
        // Given / When
        await pumpSettings(tester, testBuild: false);

        // Then
        expect(find.text('Share test stats'), findsNothing);
        expect(find.text('Test crash'), findsNothing);
      },
    );

    testWidgets(
      'Given a test build, When Test crash is tapped, Then the app crashes on '
      'purpose',
      (tester) async {
        // Given
        final crashes = <String>[];
        await pumpSettings(tester, crashes: crashes);
        await tester.ensureVisible(find.text('Test crash'));
        await tester.pumpAndSettle();

        // When
        await tester.tap(find.text('Test crash'));

        // Then
        expect(crashes, ['crash']);
      },
    );
  });

  testWidgets('the close button closes Settings', (tester) async {
    // Given
    final routing = await pumpSettings(tester);

    // When
    await tester.tap(find.bySemanticsLabel('Close'));
    await tester.pump();

    // Then
    expect(routing.calls, ['close']);
  });
}
