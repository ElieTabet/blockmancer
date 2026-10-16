import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockConnectivity extends Mock implements Connectivity {}

void main() {
  late StreamController<List<ConnectivityResult>> changes;
  late _MockConnectivity connectivity;
  late PlusConnectivityMonitor monitor;

  setUp(() {
    changes = StreamController<List<ConnectivityResult>>.broadcast();
    connectivity = _MockConnectivity();
    monitor = PlusConnectivityMonitor(connectivity: connectivity);

    when(
      () => connectivity.onConnectivityChanged,
    ).thenAnswer((_) => changes.stream);
  });

  tearDown(() => changes.close());

  test('given no network, when asked, then it is offline', () async {
    when(
      () => connectivity.checkConnectivity(),
    ).thenAnswer((_) async => [ConnectivityResult.none]);

    expect(await monitor.isOnline(), isFalse);
  });

  test('given any network at all, when asked, then it is online', () async {
    when(() => connectivity.checkConnectivity()).thenAnswer(
      (_) async => [ConnectivityResult.vpn, ConnectivityResult.mobile],
    );

    expect(await monitor.isOnline(), isTrue);
  });

  test('given the phone is offline, when the network comes and goes, then the '
      'changes start from the current answer', () async {
    when(
      () => connectivity.checkConnectivity(),
    ).thenAnswer((_) async => [ConnectivityResult.none]);

    final seen = <bool>[];
    final subscription = monitor.onlineChanges().listen(seen.add);

    await pumpEventQueue();
    changes
      ..add([ConnectivityResult.wifi])
      ..add([ConnectivityResult.none]);
    await pumpEventQueue();

    expect(seen, [false, true, false]);

    await subscription.cancel();
  });

  test('given the phone is online, when it hands over from Wi-Fi to cellular, '
      'then nothing is reported', () async {
    when(
      () => connectivity.checkConnectivity(),
    ).thenAnswer((_) async => [ConnectivityResult.wifi]);

    final seen = <bool>[];
    final subscription = monitor.onlineChanges().listen(seen.add);

    await pumpEventQueue();
    changes.add([ConnectivityResult.mobile]);
    await pumpEventQueue();

    expect(seen, [true]);

    await subscription.cancel();
  });
}
