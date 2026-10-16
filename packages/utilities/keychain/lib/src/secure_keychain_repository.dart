import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:keychain/src/keychain_repository.dart';

/// Keychain (iOS) / Keystore (Android) backed storage.
///
/// Storage failures are deliberately **not** swallowed here. Swallowing this
/// low would make writes fail silently too, and a silently-failed token write
/// after a successful login is a worse bug than a visible one. Each caller
/// decides what "storage failed" means for its own operation — reads are
/// typically tolerant, writes are not.
final class SecureKeychainRepository implements KeychainRepository {
  final FlutterSecureStorage _storage;

  const SecureKeychainRepository(this._storage);

  @override
  Future<void> deleteValue(String key) => _storage.delete(key: key);

  @override
  Future<String?> getValue(String key) => _storage.read(key: key);

  // Writing a null would leave the platform channel to interpret it; delete is
  // the unambiguous way to express "no value".
  @override
  Future<void> setValue(String key, String? value) => value == null
      ? _storage.delete(key: key)
      : _storage.write(key: key, value: value);
}
