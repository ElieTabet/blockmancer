import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:splash_presentation/src/notifiers/splash_state_notifier.br.dart';
import 'package:splash_presentation/src/providers_di.br.dart' as di;
import 'package:splash_presentation/src/routing/splash_routing.dart';

class _RecordingRouting implements SplashRouting {
  int missingCount = 0;
  int validCount = 0;

  @override
  void onSessionMissing(BuildContext context) => missingCount++;

  @override
  void onSessionValid(BuildContext context) => validCount++;
}

void main() {
  // Splash knows only "is there a usable session" — it never touches tokens,
  // storage or the network, so the two slots are the entire seam it needs.
  late bool? appStatusAllows;
  late List<String> launchWork;
  late int prepareCount;
  late bool prepareThrows;
  late bool refreshThrows;

  setUp(() {
    appStatusAllows = true;
    launchWork = [];
    prepareCount = 0;
    prepareThrows = false;
    refreshThrows = false;
  });

  ProviderContainer containerWith({
    required bool isAuthenticated,
    required _RecordingRouting routing,
    bool sessionAppearsDuringPrepare = false,
  }) {
    var sessionExists = isAuthenticated;
    final container = ProviderContainer(
      overrides: [
        di.splashRoutingProvider.overrideWithValue(routing),
        di.isAuthenticatedProvider.overrideWith((ref) async => sessionExists),
        // Null stands for a check that throws.
        di.checkAppStatusProvider.overrideWithValue(() async {
          if (appStatusAllows case final allows?) return allows;

          throw Exception('checking blew up');
        }),
        di.prepareDeviceProvider.overrideWithValue(() async {
          prepareCount++;
          launchWork.add('device');

          if (prepareThrows) throw Exception('preparing blew up');

          // Stands in for the launch handshake writing a fresh pair: when the
          // access token has lapsed, the device work is what puts a usable one
          // back. Whether splash sees it depends entirely on ordering.
          //
          // The suspension is the whole point — the real handshake is a network
          // call, so the write lands after an await. Setting the flag
          // synchronously would complete this future before isAuthenticated was
          // even called, and the test would pass against the very ordering it
          // exists to reject.
          if (sessionAppearsDuringPrepare) {
            await Future<void>.delayed(Duration.zero);
            sessionExists = true;
          }
        }),
        di.refreshSettingsProvider.overrideWithValue(() async {
          launchWork.add('settings');

          if (refreshThrows) throw Exception('refreshing blew up');
        }),
      ],
    );
    addTearDown(container.dispose);

    return container;
  }

  /// Pumps a host widget and returns its context — `onReady` needs a real,
  /// mounted one to hand to the routing interface.
  Future<BuildContext> pumpHost(
    ProviderContainer container,
    WidgetTester tester,
  ) async {
    late BuildContext ctx;

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              ctx = context;

              return const SizedBox();
            },
          ),
        ),
      ),
    );

    return ctx;
  }

  Future<void> run(
    WidgetTester tester, {
    required bool isAuthenticated,
    required _RecordingRouting routing,
    bool sessionAppearsDuringPrepare = false,
  }) async {
    final container = containerWith(
      routing: routing,
      isAuthenticated: isAuthenticated,
      sessionAppearsDuringPrepare: sessionAppearsDuringPrepare,
    );
    final ctx = await pumpHost(container, tester);

    final future = container.read(splashStateProvider.notifier).onReady(ctx);
    await tester.pump(const Duration(seconds: 2));
    await future;
  }

  testWidgets('a valid session skips the login screen', (tester) async {
    final routing = _RecordingRouting();

    await run(tester, routing: routing, isAuthenticated: true);

    expect(routing.validCount, 1);
    expect(routing.missingCount, 0);
  });

  testWidgets('a missing session routes to login', (tester) async {
    final routing = _RecordingRouting();

    await run(tester, routing: routing, isAuthenticated: false);

    expect(routing.missingCount, 1);
    expect(routing.validCount, 0);
  });

  // What the device work is, and what a failure means, are the device feature's
  // business now. Splash only has to keep triggering it and keep handing off
  // regardless of how it goes.
  testWidgets('triggers the once-per-launch device work', (tester) async {
    await run(tester, routing: _RecordingRouting(), isAuthenticated: true);

    expect(prepareCount, 1);
  });

  testWidgets('a throwing device step neither blocks nor breaks the hand-off', (
    tester,
  ) async {
    prepareThrows = true;
    final routing = _RecordingRouting();

    await run(tester, routing: routing, isAuthenticated: true);

    expect(routing.validCount, 1);
  });

  // The settings route wants a token, and registering is what mints one.
  testWidgets('fetches the settings once the device work is done', (
    tester,
  ) async {
    await run(tester, routing: _RecordingRouting(), isAuthenticated: true);

    expect(launchWork, ['device', 'settings']);
  });

  testWidgets(
    'a throwing settings fetch neither blocks nor breaks the hand-off',
    (tester) async {
      refreshThrows = true;
      final routing = _RecordingRouting();

      await run(tester, routing: routing, isAuthenticated: false);

      expect(routing.missingCount, 1);
    },
  );

  testWidgets('the hand-off waits for the branded delay', (tester) async {
    final routing = _RecordingRouting();
    final container = containerWith(routing: routing, isAuthenticated: true);
    final ctx = await pumpHost(container, tester);

    final future = container.read(splashStateProvider.notifier).onReady(ctx);
    await tester.pump();

    // Startup work resolves immediately; the splash must still be showing.
    expect(routing.validCount, 0);

    await tester.pump(const Duration(seconds: 2));
    await future;

    expect(routing.validCount, 1);
  });

  // What the ordering test used to guard, restated as the property that now
  // holds. The launch handshake writes only when nothing was stored, and what
  // it writes is a GUEST pair — so whether splash resolves the authentication
  // answer before or after the device work, a guest is not authenticated either
  // way. `sessionAppearsDuringPrepare` flips the underlying flag mid-prepare;
  // the hand-off must not change because of it.
  testWidgets('a session appearing during the device work is still a guest', (
    tester,
  ) async {
    final routing = _RecordingRouting();

    await run(
      tester,
      routing: routing,
      isAuthenticated: false,
      sessionAppearsDuringPrepare: true,
    );

    expect(routing.missingCount, 1);
    expect(routing.validCount, 0);
  });

  // The launch check speaks first: a build that may not launch has its screen
  // put up by whoever said so, and splash must neither register the device nor
  // route over it.
  testWidgets('a blocked launch neither prepares the device nor routes', (
    tester,
  ) async {
    appStatusAllows = false;
    final routing = _RecordingRouting();

    await run(tester, routing: routing, isAuthenticated: true);

    expect(launchWork, isEmpty);
    expect(routing.validCount + routing.missingCount, 0);
  });

  testWidgets('a launch check that throws still launches', (tester) async {
    appStatusAllows = null;
    final routing = _RecordingRouting();

    await run(tester, routing: routing, isAuthenticated: true);

    expect(prepareCount, 1);
    expect(routing.validCount, 1);
  });
}
