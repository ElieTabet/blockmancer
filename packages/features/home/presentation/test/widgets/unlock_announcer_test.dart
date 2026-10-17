import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_presentation/src/providers_di.br.dart';
import 'package:home_presentation/src/widgets/home_widget.dart';
import 'package:home_presentation/src/widgets/unlock_announcer.dart';
import 'package:shared_domain/shared_domain.dart';

import '../pump_home.dart';

void main() {
  /// A player whose save was brought up to date with Full House and On the
  /// Brink unlocked, until the map marks them announced.
  ({Progression Function() progression, int Function() marks}) unannounced() {
    var announced = false;
    var marks = 0;
    final progression = freshProgression().copyWith(
      unannouncedJokers: const {.fullhouse, .brink},
      unlockedJokers: const {.fullhouse, .brink},
    );

    return (
      progression: () => announced
          ? progression.copyWith(unannouncedJokers: const {})
          : progression,
      marks: () {
        announced = true;

        return ++marks;
      },
    );
  }

  testWidgets('Given jokers unlocked by bringing a save up to date, When the '
      'map opens, Then it announces them and marks them announced', (
    tester,
  ) async {
    // Given
    var marks = 0;
    final player = unannounced();

    // When
    await pumpHome(
      tester,
      markJokersAnnounced: () async => marks = player.marks(),
      progression: () async => player.progression(),
    );
    await tester.pumpAndSettle();

    // Then
    expect(find.byType(JokersUnlockedSheet), findsOneWidget);
    expect(find.text('New jokers'), findsOneWidget);
    expect(find.text('Full House'), findsOneWidget);
    expect(find.text('On the Brink'), findsOneWidget);
    expect(marks, 1);
  });

  testWidgets('Given the announcement closed, When the map is read again, '
      'Then it is not announced a second time', (tester) async {
    // Given
    var marks = 0;
    final player = unannounced();
    await pumpHome(
      tester,
      markJokersAnnounced: () async => marks = player.marks(),
      progression: () async => player.progression(),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // When
    ProviderScope.containerOf(
      tester.element(find.byType(HomeWidget)),
    ).invalidate(progressionProvider);
    await tester.pumpAndSettle();

    // Then
    expect(find.byType(JokersUnlockedSheet), findsNothing);
    expect(marks, 1);
  });

  testWidgets('Given nothing waiting to be announced, When the map opens, '
      'Then no sheet shows', (tester) async {
    // Given
    var marks = 0;

    // When
    await pumpHome(tester, markJokersAnnounced: () async => marks++);
    await tester.pumpAndSettle();

    // Then
    expect(find.byType(JokersUnlockedSheet), findsNothing);
    expect(marks, 0);
  });
}
