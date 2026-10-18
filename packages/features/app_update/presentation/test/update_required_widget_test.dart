import 'package:app_update_domain/app_update_domain.dart' as app_update;
import 'package:app_update_presentation/app_update_presentation.dart';
import 'package:app_update_presentation/src/widgets/update_required_widget.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:l10n_application/l10n_application.dart';

final class _NoDismissals implements app_update.UpdateDismissals {
  @override
  Future<void> dismiss(String version) async {}

  @override
  Future<String?> dismissedVersion() async => null;
}

void main() {
  late List<String> opened;

  Future<void> pumpScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ...app_update.bindProviders(
            appVersion: (ref) async => '1.0.0',
            remoteValue: (ref) =>
                (_) => null,
            remoteValuesFetched: (ref) => Future.value(),
            storePlatform: (ref) => .ios,
            storeUrls: (ref) => (android: 'play', ios: 'appstore'),
            updateDismissals: (ref) => _NoDismissals(),
          ),
          ...bindProviders(
            openUrl: (ref) => (url) async {
              opened.add(url);

              return true;
            },
          ),
        ],
        child: TranslationProvider(
          child: MaterialApp(
            theme: DSTheme.instance.darkTheme,
            home: const UpdateRequiredWidget(),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  setUp(() => opened = []);

  testWidgets('Given a version too old to play, When Update is tapped, Then '
      "the platform's store page opens", (tester) async {
    // Given
    await pumpScreen(tester);
    expect(find.text('Update required'), findsOneWidget);

    // When
    await tester.tap(find.text('Update'));
    await tester.pump();

    // Then
    expect(opened, ['appstore']);
  });

  testWidgets('Given the update screen, When back is pressed, Then it stays', (
    tester,
  ) async {
    // Given
    await pumpScreen(tester);

    // When
    final popped = await tester.binding.handlePopRoute();
    await tester.pump();

    // Then
    expect(popped, isTrue);
    expect(find.text('Update required'), findsOneWidget);
  });
}
