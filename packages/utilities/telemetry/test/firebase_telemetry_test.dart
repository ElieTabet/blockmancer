import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:telemetry/telemetry.dart';

class _MockAnalytics extends Mock implements FirebaseAnalytics {}

class _MockCrashlytics extends Mock implements FirebaseCrashlytics {}

void main() {
  late _MockAnalytics analytics;
  late _MockCrashlytics crashlytics;
  late FirebaseTelemetry telemetry;

  setUpAll(() => registerFallbackValue(StackTrace.empty));

  setUp(() {
    analytics = _MockAnalytics();
    crashlytics = _MockCrashlytics();
    telemetry = FirebaseTelemetry(
      analytics: analytics,
      crashlytics: crashlytics,
    );

    when(
      () => analytics.setAnalyticsCollectionEnabled(any()),
    ).thenAnswer((_) async {});
    when(
      () => crashlytics.setCrashlyticsCollectionEnabled(any()),
    ).thenAnswer((_) async {});
    when(() => crashlytics.deleteUnsentReports()).thenAnswer((_) async {});
  });

  test(
    'Given a yes, When enabled, Then both collect and nothing is deleted',
    () async {
      await telemetry.setCollectionEnabled(true);

      verify(() => analytics.setAnalyticsCollectionEnabled(true)).called(1);
      verify(() => crashlytics.setCrashlyticsCollectionEnabled(true)).called(1);
      verifyNever(() => crashlytics.deleteUnsentReports());
    },
  );

  test(
    'Given a no, When disabled, Then both stop and cached crashes go',
    () async {
      await telemetry.setCollectionEnabled(false);

      verify(() => analytics.setAnalyticsCollectionEnabled(false)).called(1);
      verify(
        () => crashlytics.setCrashlyticsCollectionEnabled(false),
      ).called(1);
      verify(() => crashlytics.deleteUnsentReports()).called(1);
    },
  );

  test('Given the SDK fails, When switched, Then it does not throw', () async {
    when(
      () => analytics.setAnalyticsCollectionEnabled(any()),
    ).thenThrow(Exception('no Firebase'));

    await expectLater(telemetry.setCollectionEnabled(true), completes);
  });

  test(
    'Given a recovered failure, When recorded, Then Crashlytics gets it as non-fatal',
    () async {
      final error = StateError('boom');
      when(
        () => crashlytics.recordError(error, .empty, reason: 'push'),
      ).thenAnswer((_) async {});

      await telemetry.recordNonFatal(error, .empty, reason: 'push');

      verify(
        () => crashlytics.recordError(error, .empty, reason: 'push'),
      ).called(1);
    },
  );

  test('Given the SDK fails, When recording, Then it does not throw', () async {
    when(
      () => crashlytics.recordError(
        any<Object>(),
        any(),
        reason: any(named: 'reason'),
      ),
    ).thenThrow(Exception('no Firebase'));

    await expectLater(
      telemetry.recordNonFatal(StateError('boom'), .empty, reason: 'push'),
      completes,
    );
  });
}
