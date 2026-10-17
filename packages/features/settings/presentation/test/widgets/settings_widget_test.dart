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
    'Given a release build, When Settings opens, Then the Version row shows the version and the build',
    (tester) async {
      // Given / When
      await pumpSettings(tester);

      // Then
      expect(find.text('Version'), findsOneWidget);
      expect(find.text('1.0.0 (2)'), findsOneWidget);
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
