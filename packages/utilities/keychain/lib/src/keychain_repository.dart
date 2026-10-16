/// Secure on-device key/value storage. Deliberately generic: no token, auth or
/// JWT knowledge lives here, so anything needing a durable secret (a device
/// identifier, a stored token) can use the same store without one forcing a
/// dependency on the other's shape.
abstract interface class KeychainRepository {
  Future<void> deleteValue(String key);

  Future<String?> getValue(String key);

  Future<void> setValue(String key, String? value);
}
