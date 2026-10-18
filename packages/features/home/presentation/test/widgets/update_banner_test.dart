import 'package:flutter_test/flutter_test.dart';

import '../pump_home.dart';

void main() {
  testWidgets('Given no newer version, When the map opens, Then no update '
      'banner shows', (tester) async {
    // Given / When
    await pumpHome(tester);

    // Then
    expect(find.text('A new version is out'), findsNothing);
  });

  testWidgets('Given a newer version, When its banner is tapped, Then the '
      'store opens', (tester) async {
    // Given
    final offer = UpdateOffer('1.1.0');
    await pumpHome(tester, updateOffer: offer);

    // When
    await tester.tap(find.text('A new version is out'));
    await tester.pump();

    // Then
    expect(offer.calls, ['store']);
  });

  testWidgets('Given a newer version, When Not now is tapped, Then its banner '
      'is closed for that version', (tester) async {
    // Given
    final offer = UpdateOffer('1.1.0');
    await pumpHome(tester, updateOffer: offer);

    // When
    await tester.tap(find.text('Not now'));
    await tester.pump();

    // Then
    expect(offer.calls, ['dismiss']);
  });
}
