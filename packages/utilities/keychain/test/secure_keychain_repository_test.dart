import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:keychain/keychain.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late List<MethodCall> calls;

  setUp(() {
    calls = [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
          (call) async {
            calls.add(call);

            return call.method == 'read' ? null : null;
          },
        );
  });

  tearDown(
    () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
          null,
        ),
  );

  // The signature allows a null value, but FlutterSecureStorage.write isn't
  // guaranteed to accept one — so a null must route to delete instead.
  test('setValue(key, null) deletes rather than writing a null', () async {
    const repository = SecureKeychainRepository(FlutterSecureStorage());

    await repository.setValue('k', null);

    expect(calls.single.method, 'delete');
  });

  test('setValue(key, value) writes', () async {
    const repository = SecureKeychainRepository(FlutterSecureStorage());

    await repository.setValue('k', 'v');

    expect(calls.single.method, 'write');
  });

  test('getValue reads and deleteValue deletes', () async {
    const repository = SecureKeychainRepository(FlutterSecureStorage());

    await repository.getValue('k');
    await repository.deleteValue('k');

    expect(calls.map((c) => c.method), ['read', 'delete']);
  });
}
