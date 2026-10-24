import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:splash_presentation/splash_presentation.dart';
import 'package:splash_presentation/src/widgets/splash_effects.dart';
import 'package:splash_presentation/src/widgets/splash_logo.dart';
import 'package:splash_presentation/src/widgets/splash_particles.dart';
import 'package:splash_presentation/src/widgets/splash_timeline.dart';
import 'package:splash_presentation/src/widgets/splash_widget.dart';

final class _RecordingRouting implements SplashRouting {
  final handOffs = <String>[];

  @override
  void onFirstLaunch(BuildContext context) => handOffs.add('tutorial');

  @override
  void onInitialized(BuildContext context) => handOffs.add('home');

  @override
  void onUpdateRequired(BuildContext context) => handOffs.add('update');
}

/// The splash of a player who has seen the tutorial, its update check
/// answering at once (no update needed) unless [updateRequired] says
/// otherwise, motion on unless turned down in the app ([reduceMotion]) or on
/// the phone ([systemReduceMotion]).
Future<_RecordingRouting> _pumpSplash(
  WidgetTester tester, {
  bool reduceMotion = false,
  bool systemReduceMotion = false,
  Future<bool> Function()? updateRequired,
}) async {
  final routing = _RecordingRouting();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        ...bindProviders(
          reduceMotionSetting: (ref) async => reduceMotion,
          tutorialSeen: (ref) async => true,
          updateRequired: (ref) =>
              updateRequired?.call() ?? Future.value(false),
        ),
        ...bindRoutingProviders(splashRouting: (ref) => routing),
      ],
      child: MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(disableAnimations: systemReduceMotion),
          child: child!,
        ),
        home: const SplashWidget(),
      ),
    ),
  );

  return routing;
}

/// Frame by frame, as a phone draws them, [total] in [step]s.
Future<void> _play(
  WidgetTester tester,
  Duration total, {
  Duration step = const Duration(milliseconds: 50),
}) async {
  for (var played = Duration.zero; played < total; played += step) {
    await tester.pump(step);
  }
}

/// The logo's transform, when it has one: under reduce motion it has none.
Matrix4? _logoTransform(WidgetTester tester) {
  final transforms = find.descendant(
    of: find.byType(SplashLogo),
    matching: find.byType(Transform),
  );

  return transforms.evaluate().isEmpty
      ? null
      : tester.widget<Transform>(transforms.first).transform;
}

/// Whether any of the effects reduce motion drops is on screen.
bool _effectsShown() => [SplashRays, SplashRings, SplashParticles].any(
  (effect) => find
      .descendant(of: find.byType(effect), matching: find.byType(CustomPaint))
      .evaluate()
      .isNotEmpty,
);

bool _flashShown() => find
    .descendant(of: find.byType(SplashFlash), matching: find.byType(ColoredBox))
    .evaluate()
    .isNotEmpty;

void main() {
  testWidgets('Given the phone showing its own launch screen, When the app '
      'draws its first frame, Then the logo is alone, at the size the phone '
      'drew it', (tester) async {
    // When
    final routing = await _pumpSplash(tester);

    // Then
    expect(
      tester
          .getSize(
            find.descendant(
              of: find.byType(SplashLogo),
              matching: find.byType(Image),
            ),
          )
          .width,
      SplashTimeline.logo,
    );
    expect(find.text('B'), findsNothing);
    expect(_effectsShown(), isFalse);
    expect(_flashShown(), isFalse);

    await _play(tester, const Duration(seconds: 2));
    expect(routing.handOffs, ['home']);
  });

  testWidgets('Given motion on, When the app starts, Then the logo squashes, '
      'pops past its size, and the effects and the wordmark come in', (
    tester,
  ) async {
    // Given
    await _pumpSplash(tester);
    await tester.pump();

    // When / Then: squashed onto its base at 300 ms
    await _play(tester, const Duration(milliseconds: 300));
    expect(_logoTransform(tester)!.storage[5], lessThan(0.95));

    // Popped past its size at 450 ms, the effects under way by 600 ms
    await _play(tester, const Duration(milliseconds: 150));
    expect(_logoTransform(tester)!.getMaxScaleOnAxis(), greaterThan(1.1));

    await _play(tester, const Duration(milliseconds: 150));
    expect(_effectsShown(), isTrue);

    // Every letter of the wordmark in by the end of the entrance
    await _play(tester, const Duration(milliseconds: 650));
    for (final letter in 'BLOCKMANCER'.split('').toSet()) {
      expect(find.text(letter), findsWidgets);
    }

    await _play(tester, const Duration(seconds: 1));
  });

  for (final (place, inApp, onPhone) in [
    ('in the app', true, false),
    ('on the phone', false, true),
  ]) {
    testWidgets('Given motion turned down $place, When the app starts and '
        'leaves, Then the logo never scales, no effect plays, and the logo '
        'and wordmark fade out into the next screen', (tester) async {
      // Given / When
      final routing = await _pumpSplash(
        tester,
        reduceMotion: inApp,
        systemReduceMotion: onPhone,
      );

      // Then: at every moment, through the whole sequence and its exit
      for (var at = 0; at < 1800; at += 50) {
        await tester.pump(const Duration(milliseconds: 50));
        expect(_logoTransform(tester), isNull, reason: '${at}ms');
        expect(_effectsShown(), isFalse, reason: '${at}ms');
        expect(_flashShown(), isFalse, reason: '${at}ms');
      }

      expect(find.text('B'), findsOneWidget);
      expect(routing.handOffs, ['home']);
    });
  }

  testWidgets('Given the answers already in, When the app starts, Then the '
      'next screen fades in 1.48 s after the first frame, not later', (
    tester,
  ) async {
    // Given / When
    final routing = await _pumpSplash(tester);

    // Then
    await tester.pump(const Duration(milliseconds: 1479));
    expect(routing.handOffs, isEmpty);

    await tester.pump(const Duration(milliseconds: 1));
    expect(routing.handOffs, ['home']);
  });

  testWidgets('Given a slow update check, When the app starts, Then the '
      'settled logo and wordmark hold, the rays still turning, and the next '
      'screen fades in the moment the check answers', (tester) async {
    // Given
    final routing = await _pumpSplash(
      tester,
      updateRequired: () =>
          Future.delayed(const Duration(seconds: 2), () => false),
    );
    await tester.pump();

    // When: past the entrance, the check still running
    await _play(tester, const Duration(milliseconds: 1700));
    final rays = find.descendant(
      of: find.byType(SplashRays),
      matching: find.byType(Transform),
    );
    final turned = tester.widget<Transform>(rays).transform.storage[1];
    await tester.pump(const Duration(milliseconds: 100));

    // Then: still on the splash, settled, the rays turning
    expect(routing.handOffs, isEmpty);
    expect(_logoTransform(tester)!.getMaxScaleOnAxis(), 1.0);
    expect(find.text('R'), findsOneWidget);
    expect(tester.widget<Transform>(rays).transform.storage[1], isNot(turned));

    // And it leaves when the check answers, at 2 s, not later
    await tester.pump(const Duration(milliseconds: 190));
    expect(routing.handOffs, isEmpty);

    await tester.pump(const Duration(milliseconds: 20));
    expect(routing.handOffs, ['home']);
  });

  testWidgets('Given a version too old to play, When the app starts, Then '
      'it goes to the update screen, not Home', (tester) async {
    // Given / When
    final routing = await _pumpSplash(tester, updateRequired: () async => true);
    await _play(tester, const Duration(milliseconds: 1500));

    // Then
    expect(routing.handOffs, ['update']);
  });
}
